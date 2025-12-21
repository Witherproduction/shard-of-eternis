randomize();
show_debug_message("GlobalMusicManager: Created");

// Listes de lecture
lobby_music_list = ["SonAcceuil1", "SonAcceuil2"];
duel_music_list = ["SonDuel1", "SonDuel2"];

// État actuel
current_context = "none"; // "lobby", "duel", "none"
current_track_index = -1;
current_sound_inst = -1;

// Pour détecter si on était en pause et qu'on doit reprendre
is_paused_for_room = false;
