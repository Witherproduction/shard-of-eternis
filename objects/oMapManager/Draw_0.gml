/// @description Draw Region / Location
if (location_sprite != -1 && location_alpha > 0) {
    // Dessiner le sprite de la région (Plein écran ou centré)
    // On suppose que le sprite doit être centré sur l'écran ou à la position du continent
    // Si c'est un background plein écran comme sForetDesVoleur (probablement)
    
    // Pour l'instant, on dessine centré sur l'objet (qui est généralement au centre de la room)
    // Si l'objet MapManager est en 0,0, il faut utiliser room_width/2, room_height/2
    
    var draw_x = room_width / 2;
    var draw_y = room_height / 2;
    
    // Si MapManager suit le continent, on peut utiliser x, y
    if (instance_exists(oContinentManager)) {
        draw_x = oContinentManager.x;
        draw_y = oContinentManager.y;
    }
    
    draw_sprite_ext(location_sprite, 0, draw_x, draw_y, 1, 1, 0, c_white, location_alpha);
    
    // Dessiner le masque par-dessus s'il existe (seulement si le mode tracé est INACTIF)
    var show_mask = true;
    if (variable_instance_exists(id, "poly_mode") && poly_mode) show_mask = false;
    
    if (location_mask != -1 && show_mask) {
        // --- GESTION DU POCHOIR VIA SURFACE ---
        if (!surface_exists(mask_surface)) {
            // Créer une surface de la taille du masque
            var sw = sprite_get_width(location_mask);
            var sh = sprite_get_height(location_mask);
            // Sécurité taille min
            if (sw < 1) sw = 1;
            if (sh < 1) sh = 1;
            mask_surface = surface_create(sw, sh);
        }
        
        // Dessiner sur la surface
        surface_set_target(mask_surface);
        draw_clear_alpha(c_black, 0); // Vider
        
        // 1. Dessiner le masque complet (l'obscurité)
        // On dessine le sprite à l'origine de la surface (ou centré selon l'offset)
        var xoff = sprite_get_xoffset(location_mask);
        var yoff = sprite_get_yoffset(location_mask);
        draw_sprite(location_mask, 0, xoff, yoff);
        
        // 2. Soustraire les zones révélées (Pochoirs)
        gpu_set_blendmode(bm_subtract);
        draw_set_color(c_white);
        
        for (var i = 0; i < array_length(location_reveal_zones); i++) {
            var zone = location_reveal_zones[i];
            
            // Vérifier la condition
            var revealed = false;
            try {
                if (zone.condition_check()) revealed = true;
            } catch(e) {}
            
            if (revealed) {
                // Dessiner le polygone
                // Les points sont relatifs au centre (x,y) de l'objet/sprite
                // Donc sur la surface, on doit ajouter xoff, yoff
                if (array_length(zone.points) > 2) {
                    draw_primitive_begin(pr_trianglefan);
                    // Centre approximatif pour trianglefan (optionnel, ou premier point)
                    // draw_vertex(xoff + zone.points[0].x, yoff + zone.points[0].y); 
                    for (var p = 0; p < array_length(zone.points); p++) {
                        var pt = zone.points[p];
                        draw_vertex(xoff + pt.x, yoff + pt.y);
                    }
                    draw_primitive_end();
                }
            }
        }
        
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
        
        // 3. Dessiner la surface finale sur l'écran
        var surf_x = draw_x - xoff;
        var surf_y = draw_y - yoff;
        draw_surface_ext(mask_surface, surf_x, surf_y, 1, 1, 0, c_white, location_alpha);
    }
    
    // --- DEBUG TRACÉ POLYGONE ---
    if (variable_instance_exists(id, "poly_mode") && poly_mode && array_length(current_poly_points) > 0) {
        draw_set_color(c_red);
        var cx = draw_x;
        var cy = draw_y;
        
        for (var i = 0; i < array_length(current_poly_points); i++) {
            var pt = current_poly_points[i];
            var px = cx + pt.x;
            var py = cy + pt.y;
            
            draw_circle(px, py, 4, false);
            
            if (i > 0) {
                var prev = current_poly_points[i-1];
                draw_line_width(cx + prev.x, cy + prev.y, px, py, 2);
            }
        }
        
        // Fermer la boucle visuellement
        if (array_length(current_poly_points) > 2) {
            var first = current_poly_points[0];
            var last = current_poly_points[array_length(current_poly_points)-1];
            draw_set_alpha(0.5);
            draw_line_width(cx + last.x, cy + last.y, cx + first.x, cy + first.y, 1);
            draw_set_alpha(1);
        }
        draw_set_color(c_white);
    }
}

