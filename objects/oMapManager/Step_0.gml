/// @description Map Logic & Editor Controls

// Trouver le ContinentManager s'il n'est pas déjà trouvé
if (continent_manager == noone) {
    continent_manager = instance_find(oContinentManager, 0);
}

// --- LOGIQUE DE ZOOM ET TRANSITION ---
if (continent_manager != noone) {
    if (map_zoom_state == "ZOOMING_IN") {
        // 1. Zoomer le continent
        var current_scale = continent_manager.image_xscale;
        var new_scale = lerp(current_scale, zoom_level_target, zoom_speed);
        
        continent_manager.image_xscale = new_scale;
        continent_manager.image_yscale = new_scale;
        
        // 2. Fondu Sortant du Continent (Fade Out)
        // On réduit l'alpha du continent au fur et à mesure qu'on zoom
        continent_manager.image_alpha = lerp(continent_manager.image_alpha, 0, fade_speed);
        
        // 3. Fondu Entrant de la Région (Fade In)
        if (location_sprite != -1) {
            location_alpha = lerp(location_alpha, 1, fade_speed);
        }
        
        // Condition de fin de transition
        if (abs(continent_manager.image_xscale - zoom_level_target) < 0.01 && location_alpha > 0.95) {
            map_zoom_state = "SHOW_LOCATION";
            continent_manager.image_alpha = 0; // S'assurer qu'il est invisible
            location_alpha = 1;
        }
    }
    else if (map_zoom_state == "ZOOMING_OUT") {
        // Retour à la normale
        var current_scale = continent_manager.image_xscale;
        var new_scale = lerp(current_scale, zoom_level_initial, zoom_speed);
        
        continent_manager.image_xscale = new_scale;
        continent_manager.image_yscale = new_scale;
        
        continent_manager.image_alpha = lerp(continent_manager.image_alpha, 1, fade_speed);
        location_alpha = lerp(location_alpha, 0, fade_speed);
        
        if (abs(continent_manager.image_xscale - zoom_level_initial) < 0.01 && location_alpha < 0.05) {
            map_zoom_state = "IDLE";
            continent_manager.image_alpha = 1;
            location_alpha = 0;
            continent_manager.image_xscale = zoom_level_initial;
            continent_manager.image_yscale = zoom_level_initial;
        }
    }
}

// --- CONTROLES EDITEUR (Bas de fichier) ---

// Activer/Désactiver le mode Admin avec F1
if (keyboard_check_pressed(vk_f1)) {
    global.admin_mode = !variable_global_exists("admin_mode") ? true : !global.admin_mode;
    editor_active = global.admin_mode;
}

if (!variable_global_exists("admin_mode") || !global.admin_mode) exit;

// --- MODE TRACÉ DE POLYGONE (Touche P) ---
if (keyboard_check_pressed(ord("P"))) {
    poly_mode = !poly_mode;
    if (poly_mode) {
        show_debug_message("MODE TRACÉ ACTIVÉ");
        // Optionnel: Reset des points si on veut recommencer
        if (keyboard_check(vk_shift)) current_poly_points = [];
    } else {
        show_debug_message("MODE TRACÉ DÉSACTIVÉ");
    }
}

// Gestion du tracé
if (poly_mode && mouse_check_button_pressed(mb_left)) {
    // Calculer la position relative au centre de l'écran (ou du sprite affiché)
    // On suppose que le sprite est centré à room_width/2, room_height/2
    var cx = room_width / 2;
    var cy = room_height / 2;
    
    // Si MapManager suit le continent
    if (instance_exists(oContinentManager)) {
        cx = oContinentManager.x;
        cy = oContinentManager.y;
    }
    
    var rel_x = mouse_x - cx;
    var rel_y = mouse_y - cy;
    
    array_push(current_poly_points, {x: rel_x, y: rel_y});
}

// Annuler le dernier point (Z)
if (poly_mode && keyboard_check_pressed(ord("Z"))) {
    if (array_length(current_poly_points) > 0) {
        array_pop(current_poly_points);
    }
}

// Copier les points (C)
if (poly_mode && keyboard_check_pressed(ord("C"))) {
    var str_points = "points = [\n";
    for (var i = 0; i < array_length(current_poly_points); i++) {
        var pt = current_poly_points[i];
        str_points += "    {x:" + string(round(pt.x)) + ", y:" + string(round(pt.y)) + "}";
        if (i < array_length(current_poly_points) - 1) str_points += ",";
        str_points += "\n";
    }
    str_points += "];";
    
    clipboard_set_text(str_points);
    clipboard_str = "Points copiés (" + string(array_length(current_poly_points)) + ")";
    show_debug_message(str_points);
}

// Si mode polygone actif, on bloque les autres contrôles d'édition
if (poly_mode) exit;


// Trouver le ContinentManager s'il n'est pas déjà trouvé
if (continent_manager == noone) {
    continent_manager = instance_find(oContinentManager, 0);
}

if (continent_manager != noone) {
    var regions = continent_manager.regions;
    var nb_regions = array_length(regions);
    
    if (nb_regions == 0) exit;
    
    // Sélection de la région (TAB)
    if (keyboard_check_pressed(vk_tab)) {
        selected_region_index++;
        if (selected_region_index >= nb_regions) selected_region_index = 0;
    }
    
    // Récupérer la région active
    var reg = regions[selected_region_index];
    selected_region_name = reg.name;
    
    // Vitesse de modification
    var spd = 1;
    if (keyboard_check(vk_shift)) spd = 5;
    if (keyboard_check(vk_control)) spd = 0.1; // Précision
    
    // Déplacement (Flèches)
    if (keyboard_check(vk_left))  reg.x -= spd;
    if (keyboard_check(vk_right)) reg.x += spd;
    if (keyboard_check(vk_up))    reg.y -= spd;
    if (keyboard_check(vk_down))  reg.y += spd;
    
    // Redimensionnement UNIFORME (Pavé Numérique ou IJKL)
    // Plus (+) / Moins (-) ou I/K : Scale Uniforme
    var scale_spd = 0.005; // Plus fin par défaut pour le scaling uniforme
    if (keyboard_check(vk_shift)) scale_spd = 0.02;
    
    var scale_delta = 0;
    
    // Zoom In (Plus grand)
    if (keyboard_check(ord("I")) || keyboard_check(vk_numpad8) || keyboard_check(vk_add)) {
        scale_delta += scale_spd;
    }
    
    // Zoom Out (Plus petit)
    if (keyboard_check(ord("K")) || keyboard_check(vk_numpad2) || keyboard_check(vk_subtract)) {
        scale_delta -= scale_spd;
    }
    
    if (scale_delta != 0) {
        reg.scale_x += scale_delta;
        reg.scale_y += scale_delta;
        
        // Empêcher le scale négatif ou nul
        if (reg.scale_x < 0.01) reg.scale_x = 0.01;
        if (reg.scale_y < 0.01) reg.scale_y = 0.01;
    }
    
    // Sauvegarder dans le presse-papier (Espace ou S)
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("S"))) {
        // Formatter comme le code GML attendu dans oContinentManager
        var code_snippet = "";
        code_snippet += "    x: " + string(reg.x) + ",\n";
        code_snippet += "    y: " + string(reg.y) + ",\n";
        code_snippet += "    scale_x: " + string(reg.scale_x) + ",\n";
        code_snippet += "    scale_y: " + string(reg.scale_y) + ",";
        
        clipboard_str = "x: " + string(reg.x) + ", y: " + string(reg.y) + ", scale: " + string(reg.scale_x);
        clipboard_set_text(code_snippet);
        show_debug_message("CODE COPIÉ:\n" + code_snippet);
    }
}
