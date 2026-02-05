// === oCardViewer - Draw Event ===
// Afficher un badge numérique pour les cartes limitées à 1 ou 2

// Dessiner les badges au-dessus des cartes
if (is_array(cardInstances)) {
    for (var i = 0; i < array_length(cardInstances); i++) {
        var inst = cardInstances[i];
        if (inst == noone || !instance_exists(inst)) continue;

        // Lire la limite depuis l'instance
        var lim = 3;
        if (variable_instance_exists(inst, "limited")) {
            lim = real(inst.limited);
        }
        var show_badge = (is_real(lim) && lim < 3);

        // Couleur selon la limite
        var badge_color = c_red; // 1 -> rouge
        if (lim == 2) {
            badge_color = make_color_rgb(255, 128, 0); // 2 -> orange
        }

        // Calcul de la position (coin haut-gauche de la carte)
        var spr = inst.sprite_index;
        var w = (spr != -1) ? sprite_get_width(spr) * inst.image_xscale : 100;
        var h = (spr != -1) ? sprite_get_height(spr) * inst.image_yscale : 150;
        var tlx = inst.x - w * 0.5;
        var tly = inst.y - h * 0.5;

        if (show_badge) {
            // Dimensions et position du badge (rond)
            var margin = 6;
            var radius = 10; // plus petit qu'avant
            var cx = tlx + margin + radius;
            var cy = tly + margin + radius;

            // Dessiner le badge rond (rempli puis contour)
            draw_set_alpha(0.85);
            draw_set_color(badge_color);
            draw_circle(cx, cy, radius, false);

            draw_set_alpha(1);
            draw_set_color(c_black);
            draw_circle(cx, cy, radius, true);

            // Dessiner le chiffre plus petit au centre
            var prev_font = -1;
            var font_idx = asset_get_index("fontStep");
            if (font_idx != -1) {
                prev_font = draw_get_font();
                draw_set_font(font_idx);
            }
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            // réduire la taille via transformation (moitié de la taille)
            draw_text_transformed(cx, cy, string(lim), 0.5, 0.5, 0);
            if (prev_font != -1) { draw_set_font(prev_font); }
        }

        // === Cadres verts + textes sur chaque carte (adaptés à l'échelle de l'instance) ===
        // Échelle proportionnelle au sprite de la carte dans la grille
        var s = min(inst.image_xscale, inst.image_yscale);
        if (spr != -1 && s > 0) {
            // Coordonnées de référence via global.card_layout
            var layout = global.card_layout;
            var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
            var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
            var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
            var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
            var desc_x1  = layout.description.x1, desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
            var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
            var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;

            // Dessiner les cadres verts (contours) uniquement si le flag global est actif
            var show_frames = variable_global_exists("show_green_frames") && global.show_green_frames;
            if (show_frames) {
                var active_field = (variable_global_exists("debug_selected_field")) ? global.debug_selected_field : "";
                
                var draw_debug_rect = function(f_name, x1, y1, x2, y2, tlx, tly, s, active_f) {
                    if (f_name == active_f) {
                        draw_set_color(c_red);
                        draw_set_alpha(0.6);
                    } else {
                        draw_set_color(c_lime);
                        draw_set_alpha(0.3);
                    }
                    draw_rectangle(tlx + x1 * s, tly + y1 * s, tlx + x2 * s, tly + y2 * s, false);
                    draw_set_alpha(1);
                    draw_rectangle(tlx + x1 * s, tly + y1 * s, tlx + x2 * s, tly + y2 * s, true);
                };
                
                draw_debug_rect("name", name_x1, name_y1, name_x2, name_y2, tlx, tly, s, active_field);
                draw_debug_rect("mana", star_x1, star_y1, star_x2, star_y2, tlx, tly, s, active_field);
                draw_debug_rect("genre", genre_x1, genre_y1, genre_x2, genre_y2, tlx, tly, s, active_field);
                draw_debug_rect("archetype", arch_x1, arch_y1, arch_x2, arch_y2, tlx, tly, s, active_field);
                draw_debug_rect("description", desc_x1, desc_y1, desc_x2, desc_y2, tlx, tly, s, active_field);
                draw_debug_rect("atk", atk_x1, atk_y1, atk_x2, atk_y2, tlx, tly, s, active_field);
                draw_debug_rect("hp", def_x1, def_y1, def_x2, def_y2, tlx, tly, s, active_field);
                
                draw_set_color(c_black);
            }

            // Text drawing removed to prevent double rendering (now handled by oCardParent)
        }
    }
}
