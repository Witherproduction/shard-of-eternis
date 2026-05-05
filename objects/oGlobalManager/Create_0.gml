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

if (!instance_exists(oNetworkManager)) {
    instance_create_depth(0, 0, 0, oNetworkManager);
    show_debug_message("### oGlobalManager - oNetworkManager créée");
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

    // Définir la taille de l'interface utilisateur (GUI) pour garantir une échelle constante
    display_set_gui_size(1920, 1080);

    // Mode d'affichage (0=Fenêtré, 1=Plein écran, 2=Sans bordure)
    ini_open("options.ini");
    var _fs_default = window_get_fullscreen() ? 1 : 0;
    var _display_mode = ini_read_real("display", "fullscreen", _fs_default);
    // Résolution
    var _current_w = window_get_width();
    var _current_h = window_get_height();
    var _default_res = string(_current_w) + "x" + string(_current_h);
    var _res_str = ini_read_string("display", "resolution", _default_res);
    ini_close();

    show_debug_message("### [oGlobalManager] LOADED SETTINGS: Mode=" + string(_display_mode) + ", Res=" + _res_str);

    // Fonction locale pour appliquer les paramètres
    var _apply_graphics = method({_mode: _display_mode, _res: _res_str}, function() {
        show_debug_message("### [oGlobalManager] APPLYING GRAPHICS SETTINGS (Direct)...");
        var _d_mode = clamp(_mode, 0, 2);
        
        // Log de diagnostic
        var _monitor_w = display_get_width();
        var _monitor_h = display_get_height();
        show_debug_message("### Monitor Size: " + string(_monitor_w) + "x" + string(_monitor_h));

        if (_d_mode == 1) {
            // === PLEIN ÉCRAN ===
            if (!window_get_fullscreen()) {
                window_set_fullscreen(true);
            }
            window_set_showborder(true);
        } 
        else if (_d_mode == 2) {
            // === SANS BORDURE (BORDERLESS) ===
            if (window_get_fullscreen()) {
                window_set_fullscreen(false);
            }
            window_set_showborder(false);
            window_set_rectangle(0, 0, _monitor_w, _monitor_h);
            
            if (surface_exists(application_surface)) {
                surface_resize(application_surface, _monitor_w, _monitor_h);
            }
        } 
        else {
            // === FENÊTRÉ CLASSIQUE ===
            if (window_get_fullscreen()) {
                window_set_fullscreen(false);
            }
            window_set_showborder(true);
            
            var _target_w = 1280;
            var _target_h = 720;
            
            var _xpos = string_pos("x", _res);
            if (_xpos > 0) {
                _target_w = real(string_copy(_res, 1, _xpos - 1));
                _target_h = real(string_copy(_res, _xpos + 1, string_length(_res) - _xpos));
            }
            
            window_set_size(_target_w, _target_h);
            
            if (surface_exists(application_surface)) {
                surface_resize(application_surface, _target_w, _target_h);
            }
        }
    });
    
    // Application initiale immédiate
    _apply_graphics();

    // Configuration pour le forçage dans le Step
    force_settings_frames = 60; // Forcer pendant 1 seconde (60 frames)
    target_display_mode = _display_mode;
    target_res_str = _res_str;

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
if (!variable_global_exists("dev_regen_db_on_boot")) {
    global.dev_regen_db_on_boot = false;
}
if (!variable_global_exists("dev_force_db_cache_clear")) {
    global.dev_force_db_cache_clear = false;
}

// === CONFIGURATION LAYOUT CARTE ===
// Coordonnées de base (Scale 1.0, coin haut-gauche 0,0)
if (!variable_global_exists("card_layout")) {
    global.card_layout = {
        name: { x1: 19, y1: 18, x2: 387, y2: 59 },
        mana: { x1: 391, y1: 17, x2: 438, y2: 61 },
        genre: { x1: 21, y1: 394, x2: 227, y2: 418 },
        archetype: { x1: 222, y1: 395, x2: 426, y2: 419 },
        description: { x1: 23, y1: 437, x2: 421, y2: 572 },
        atk: { x1: 394, y1: 580, x2: 436, y2: 630 },
        hp: { x1: 8, y1: 580, x2: 70, y2: 623 }
    };
    
    // Si des fichiers de sauvegarde de layout existent, on pourrait les charger ici
}

if (!variable_global_exists("get_runtime_font")) {
    global.__rtf_title_name = "Georgia";
    global.__rtf_title_bold = true;
    global.__rtf_text_name = "Georgia";
    global.__rtf_text_bold = false;
    global.__rtf_title_sizes = [];
    global.__rtf_title_fonts = [];
    global.__rtf_text_sizes = [];
    global.__rtf_text_fonts = [];
    
    global.get_runtime_font = function(kind, size) {
        size = clamp(round(size), 6, 64);
        
        var sizes = (kind == "title") ? global.__rtf_title_sizes : global.__rtf_text_sizes;
        var fonts = (kind == "title") ? global.__rtf_title_fonts : global.__rtf_text_fonts;
        
        var n = array_length(sizes);
        for (var i = 0; i < n; i++) {
            if (sizes[i] == size) return fonts[i];
        }
        
        var fn = (kind == "title") ? global.__rtf_title_name : global.__rtf_text_name;
        var bold = (kind == "title") ? global.__rtf_title_bold : global.__rtf_text_bold;
        var f = font_add(fn, size, bold, false, 32, 255);

        if (f == -1) {
            if (os_type == os_windows) {
                var ttf = "C:\\Windows\\Fonts\\georgia.ttf";
                if (fn == "Georgia" && bold) ttf = "C:\\Windows\\Fonts\\georgiab.ttf";
                if (file_exists(ttf)) {
                    f = font_add(ttf, size, bold, false, 32, 255);
                }
            }
        }
        
        if (f != -1) {
            array_push(sizes, size);
            array_push(fonts, f);
            return f;
        }
        
        if (font_exists(fontText)) return fontText;
        if (font_exists(fontTitle)) return fontTitle;
        if (font_exists(fontUI)) return fontUI;
        return -1;
    };
}

global.show_green_frames = false;
global.debug_selected_field = "";
