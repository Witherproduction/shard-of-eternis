/// @description Draw Region + Mask
// Synchro avec continent
if (instance_exists(oContinentOuest)) {
    var cont = instance_find(oContinentOuest, 0);
    x = cont.x;
    y = cont.y;
    image_xscale = cont.image_xscale;
    image_yscale = cont.image_yscale;
    image_alpha = cont.image_alpha;
}

if (room == rAcceuil) exit; // Dans l'accueil, la région ne se dessine pas (ni sprite ni masque), elle sert juste de donnée pour le continent

if (image_alpha > 0) {
    draw_self(); // Dessine la région (ex: sForetDesVoleur)

    if (mask_sprite != -1) {
        if (!surface_exists(surf_mask)) {
            surf_mask = surface_create(room_width, room_height);
        }

        surface_set_target(surf_mask);
        draw_clear_alpha(c_black, 0);

        // Masque (Brouillard)
        draw_sprite_ext(mask_sprite, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);

        // Révélation (Pochoir)
        var is_revealed = false;
        
        // Logique de condition de révélation
        if (required_chapter != -1 && required_act != -1) {
            try {
                if (is_act_complete(required_chapter, required_act)) {
                    is_revealed = true;
                }
            } catch(e) { 
                is_revealed = true; // Fallback
            }
        } else {
            // Si aucune condition définie, on considère révélé par défaut (ou à changer selon besoin)
            is_revealed = true;
        }

        if (is_revealed && array_length(mask_points) > 2) {
            gpu_set_blendmode(bm_subtract);
            draw_primitive_begin(pr_trianglefan);
            
            // Centre
            var cx = 0; var cy = 0;
            for (var i = 0; i < array_length(mask_points); i++) {
                cx += mask_points[i].x;
                cy += mask_points[i].y;
            }
            cx /= array_length(mask_points);
            cy /= array_length(mask_points);
            
            var world_cx = x + cx * image_xscale;
            var world_cy = y + cy * image_yscale;
            draw_vertex(world_cx, world_cy);
            
            // Points
            for (var i = 0; i < array_length(mask_points); i++) {
                var p = mask_points[i];
                draw_vertex(x + p.x * image_xscale, y + p.y * image_yscale);
            }
            var first = mask_points[0];
            draw_vertex(x + first.x * image_xscale, y + first.y * image_yscale);
            
            draw_primitive_end();
            gpu_set_blendmode(bm_normal);
        }

        surface_reset_target();

        // Affichage surface
        var fog_alpha = 1;
        if (instance_exists(oMapManager)) {
            var mgr = instance_find(oMapManager, 0);
            if (variable_instance_exists(mgr, "editor_active") && mgr.editor_active) {
                fog_alpha = 0.5;
            }
        }
        draw_surface_ext(surf_mask, 0, 0, 1, 1, 0, c_white, fog_alpha);
    }
}
