// Déterminer le contexte cible selon la room actuelle
var target_context = "lobby"; // Par défaut

if (room == rDuel) {
    target_context = "duel";
} else if (room == rScenario) {
    target_context = "none";
}

// Debug (F1)
if (keyboard_check_pressed(vk_f1)) {
    show_debug_message("GlobalMusicManager Status:");
    show_debug_message("Room: " + room_get_name(room));
    show_debug_message("Current Context: " + current_context);
    show_debug_message("Target Context: " + target_context);
    if (current_sound_inst != -1) {
        show_debug_message("Is Playing: " + string(audio_is_playing(current_sound_inst)));
        show_debug_message("Gain: " + string(audio_sound_get_gain(current_sound_inst)));
    }
}



// Gestion du changement de contexte
if (current_context != target_context) {
    show_debug_message("GlobalMusicManager: Context switch from " + current_context + " to " + target_context);
    
    // Arrêter le son en cours
    if (current_sound_inst != -1) {
        if (audio_is_playing(current_sound_inst)) {
            audio_stop_sound(current_sound_inst);
        }
        current_sound_inst = -1;
    }
    
    // Mettre à jour le contexte et réinitialiser l'index pour un démarrage aléatoire
    current_context = target_context;
    current_track_index = -1; 
}

// Si le contexte est "none", on ne fait rien de plus
if (current_context == "none") {
    exit;
}

// Gestion de la lecture pour le contexte actif
if (current_sound_inst == -1 || !audio_is_playing(current_sound_inst)) {
    
    // Sélectionner la bonne liste
    var active_list = [];
    if (current_context == "lobby") {
        active_list = lobby_music_list;
    } else if (current_context == "duel") {
        active_list = duel_music_list;
    }
    
    if (array_length(active_list) > 0) {
        // Choix de la piste
        if (current_track_index == -1) {
            // Premier lancement : aléatoire
            current_track_index = irandom(array_length(active_list) - 1);
            show_debug_message("GlobalMusicManager (" + current_context + "): Initial random index: " + string(current_track_index));
        } else {
            // Suivant (boucle)
            current_track_index = (current_track_index + 1) % array_length(active_list);
            show_debug_message("GlobalMusicManager (" + current_context + "): Looping to next index: " + string(current_track_index));
        }
        
        var asset_name = active_list[current_track_index];
        var asset = asset_get_index(asset_name);
        
        show_debug_message("GlobalMusicManager: Trying to play " + asset_name);
        
        if (asset != -1) {
            current_sound_inst = audio_play_sound(asset, 100, false);
            audio_sound_gain(current_sound_inst, 1, 0);
        } else {
            show_debug_message("GlobalMusicManager: ERROR - Asset not found: " + asset_name);
            current_sound_inst = -1;
        }
    }
}