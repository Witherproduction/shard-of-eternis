show_debug_message("### oGlobalManager.create - INITIALISATION GLOBALE");

// Singleton Check
if (instance_number(object_index) > 1) {
    show_debug_message("### oGlobalManager: Doublon détruit");
    instance_destroy();
    exit;
}

// Assurer la persistance de l'objet
persistent = true;

// Assurer que la base de données est présente (Singleton persistant)
if (!instance_exists(oDataBase)) {
    instance_create_depth(0, 0, 0, oDataBase);
    show_debug_message("### oGlobalManager - oDataBase créée");
}

// Initialiser le générateur pseudo-aléatoire une seule fois par session
if (!variable_global_exists("rng_initialized") || !global.rng_initialized) {
    randomize();
    global.rng_initialized = true;
    show_debug_message("### RNG initialisé avec randomize() pour cette session");
}

// Initialisation de la progression
if (!variable_global_exists("options_loaded") || !global.options_loaded) {
    progression_init();
    
    // Volume
    ini_open("options.ini");
    var _ini_vol = ini_read_real("audio", "volume_percent", 100);
    ini_close();
    global.volume_percent = clamp(_ini_vol, 0, 100);
    audio_master_gain(global.volume_percent / 100);

    // Plein écran
    ini_open("options.ini");
    var _fs_default = window_get_fullscreen() ? 1 : 0;
    var _ini_fs = ini_read_real("display", "fullscreen", _fs_default);
    ini_close();
    var _fs_enabled = (_ini_fs >= 0.5);
    window_set_fullscreen(_fs_enabled);

    // Résolution (appliquée uniquement en mode fenêtré)
    ini_open("options.ini");
    var _current_w = window_get_width();
    var _current_h = window_get_height();
    var _default_res = string(_current_w) + "x" + string(_current_h);
    var _res_str = ini_read_string("display", "resolution", _default_res);
    ini_close();

    if (!_fs_enabled) {
        var _xpos = string_pos("x", _res_str);
        if (_xpos > 0) {
            var _new_w = real(string_copy(_res_str, 1, _xpos - 1));
            var _new_h = real(string_copy(_res_str, _xpos + 1, string_length(_res_str) - _xpos));
            window_set_size(_new_w, _new_h);
            window_center();
        }
    }

    global.options_loaded = true;
    show_debug_message("### Options chargées et progression initialisée");
}

// Autres variables globales
if (!variable_global_exists("previous_room_before_duel")) {
    global.previous_room_before_duel = rMode;
}

// Mode Admin
if (!variable_global_exists("admin_mode")) {
    global.admin_mode = false;
}
