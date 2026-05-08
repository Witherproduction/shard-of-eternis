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
    if (script_exists(asset_get_index("progression_reset"))) {
        progression_reset();
        show_debug_message("### PROGRESSION RESET DEMANDÉ PAR L'UTILISATEUR");
        show_message("Progression réinitialisée avec succès !");
        room_restart();
    } else {
        show_debug_message("### progression_reset introuvable");
        show_message("Script progression_reset introuvable.");
    }
}

if (variable_global_exists("admin_mode") && global.admin_mode) {
    if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("D"))) {
        directory_create("datafiles");
        var ok = false;
        if (script_exists(asset_get_index("regenerate_database_from_objects"))) {
            ok = regenerate_database_from_objects();
        } else {
            show_debug_message("### DEV: regenerate_database_from_objects introuvable (script non présent dans le projet GameMaker).");
            show_message("Script dev introuvable: ajoute sDevTools dans le projet.");
        }
        var db = instance_find(oDataBase, 0);
        var cnt = 0;
        if (db != noone && instance_exists(db) && variable_struct_exists(db, "cardDatabase")) {
            cnt = variable_struct_names_count(db.cardDatabase);
        }
        if (instance_exists(oCardViewer)) {
            with (oCardViewer) {
                if (is_callable(displayFilteredCards)) displayFilteredCards();
                if (is_callable(rebuildDropdown)) rebuildDropdown();
                if (is_callable(displayFilteredCards)) displayFilteredCards();
            }
        }
        var scanned = variable_global_exists("dev_last_regen_scan") ? global.dev_last_regen_scan : -1;
        var found = variable_global_exists("dev_last_regen_count") ? global.dev_last_regen_count : -1;
        var wrote = variable_global_exists("dev_last_regen_written") ? global.dev_last_regen_written : false;
        show_debug_message("### DEV: DB regen ok=" + string(ok) + " scanned=" + string(scanned) + " found=" + string(found) + " wrote=" + string(wrote) + " db_cards=" + string(cnt));
        show_message("DB regen ok=" + string(ok) + " found=" + string(found) + " db=" + string(cnt));
    }
    
    if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("B"))) {
        if (!variable_global_exists("dev_regen_db_on_boot")) global.dev_regen_db_on_boot = false;
        global.dev_regen_db_on_boot = !global.dev_regen_db_on_boot;
        show_debug_message("### DEV: dev_regen_db_on_boot=" + string(global.dev_regen_db_on_boot));
        show_message("Auto régénération DB au démarrage: " + string(global.dev_regen_db_on_boot));
    }
}

// === FORCAGE DES RÉGLAGES VIDÉO (DÉMARRAGE) ===
// Ajout Or (Debug): F2 -> +1000 pièces d'or
if (keyboard_check_pressed(vk_f2)) {
    var before = get_gold();
    var after = add_gold(1000);
    show_debug_message("### GOLD GRANT: " + string(before) + " -> " + string(after));
}

// Reset Collection: F3
if (keyboard_check_pressed(vk_f3)) {
    reset_collection_cards();
    if (instance_exists(oCardViewer)) {
        with (oCardViewer) {
            if (!is_undefined(displayFilteredCards)) displayFilteredCards();
        }
    }
    show_debug_message("### COLLECTION RESET");
}

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
