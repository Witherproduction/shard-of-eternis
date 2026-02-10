// === GESTION DU MODE ADMIN ===
// Combinaison : CTRL + ALT + P
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("P"))) {
    if (variable_global_exists("admin_mode")) {
        global.admin_mode = !global.admin_mode;
        show_debug_message("### MODE ADMIN " + (global.admin_mode ? "ACTIVÉ" : "DÉSACTIVÉ"));
    } else {
        // Sécurité si progression_init n'a pas été appelé (ne devrait pas arriver avec oGlobalManager)
        global.admin_mode = true;
        show_debug_message("### MODE ADMIN ACTIVÉ (Force Init)");
    }
    
    // Mettre à jour l'affichage des mains immédiatement (pour voir/cacher la main adverse)
    if (instance_exists(oHand)) {
        with (oHand) {
            if (variable_instance_exists(id, "updateDisplay")) updateDisplay();
        }
    }
}

// Reset Progression (Debug) : CTRL + ALT + R
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("R"))) {
    progression_reset();
    show_debug_message("### PROGRESSION RESET DEMANDÉ PAR L'UTILISATEUR");
    show_message("Progression réinitialisée avec succès !");
    room_restart();
}

// === FORCAGE DES RÉGLAGES VIDÉO (DÉMARRAGE) ===
// Force les réglages pendant les 60 premières frames pour contrer le comportement par défaut de l'OS/Runner
if (variable_instance_exists(id, "force_settings_frames") && force_settings_frames > 0) {
    force_settings_frames--;
    
    // On force l'application uniquement toutes les 10 frames ou à la fin, pour ne pas spammer trop le driver graphique
    if (force_settings_frames % 10 == 0 || force_settings_frames == 1) {
        show_debug_message("### [oGlobalManager] FORCING SETTINGS (Remaining frames: " + string(force_settings_frames) + ")");
        
        var _mode = target_display_mode;
        var _res = target_res_str;
        
        if (_mode == 2) { // Sans bordure
            var _mw = display_get_width();
            var _mh = display_get_height();
            
            // Forcer les propriétés critiques
            if (window_get_fullscreen()) window_set_fullscreen(false);
            window_set_showborder(false);
            window_set_rectangle(0, 0, _mw, _mh);
            window_set_size(_mw, _mh);
            window_set_position(0, 0);
            
            if (surface_exists(application_surface)) {
                if (surface_get_width(application_surface) != _mw || surface_get_height(application_surface) != _mh) {
                    surface_resize(application_surface, _mw, _mh);
                }
            }
        }
        else if (_mode == 1) { // Plein écran
             if (!window_get_fullscreen()) window_set_fullscreen(true);
        }
        else { // Fenêtré
             if (window_get_fullscreen()) window_set_fullscreen(false);
             // On ne force pas window_center() ici en boucle car ça empêcherait l'utilisateur de bouger la fenêtre
        }
    }
}
