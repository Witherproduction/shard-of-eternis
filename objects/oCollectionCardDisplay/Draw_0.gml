// === oCollectionCardDisplay - Draw Event ===

// Affiche la carte sélectionnée uniquement dans rCollection
if (room == rCollection && selectedCard != noone && instance_exists(selectedCard)) {
    // ------------------------------------------------------

    // Position pour l'affichage agrandi (utilise la position de l'instance)
    var display_x = x;
    var display_y = y;
    var display_scale = 0.6;
    
    // Fond semi-transparent derrière la carte
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    var card_width = sprite_get_width(selectedCard.sprite_index) * display_scale;
    var card_height = sprite_get_height(selectedCard.sprite_index) * display_scale;
    draw_rectangle(display_x - card_width/2 - 10, display_y - card_height/2 - 10, 
                   display_x + card_width/2 + 10, display_y + card_height/2 + 10, false);
    draw_set_alpha(1);
    
    // --- ANIMATION PORTAIL (SPECIAL SUMMON) - DEPRECATED ---
    // Cette section est désormais gérée par le bloc modal au début de Draw
    /*
    var card_scale_mod = 1.0;
    
    if (variable_instance_exists(id, "portal_active") && portal_active && portal_sprite != -1) {
       // ... code déplacé ...
    }
    */
    var card_scale_mod = 1.0;
    // ------------------------------------------

    draw_sprite_ext(selectedCard.sprite_index, selectedCard.image_index, 
                    display_x, display_y, display_scale * card_scale_mod, display_scale * card_scale_mod, 0, c_white, 1);
    
    // ---------------------------------
    
    if (variable_instance_exists(selectedCard, "rarity")) {
        var rarity_color = getRarityColor(selectedCard.rarity);
        var glow_intensity = getRarityGlowIntensity(selectedCard.rarity);
        
        if (glow_intensity > 0) {
            // Dessiner une bordure colorée selon la rareté
            draw_set_color(rarity_color);
            draw_set_alpha(glow_intensity);
            
            var border_thickness = 6;
            for (var i = 1; i <= border_thickness; i++) {
                draw_rectangle(display_x - card_width/2 - i, display_y - card_height/2 - i, 
                              display_x + card_width/2 + i, display_y + card_height/2 + i, true);
            }
            
            draw_set_alpha(1);
            draw_set_color(c_black);
        }
    }
    
    var card_id = selectedCard.name;
    
    if (is_card_favorite(card_id)) {
            // Position de l'étoile en haut à gauche de la carte
            var star_x = display_x - card_width/2 + 15;
            var star_y = display_y - card_height/2 + 15;
            var star_size = 12;
            
            // Dessiner l'étoile jaune (même méthode que le bouton)
            draw_set_color(c_yellow);
            draw_set_alpha(1);
            
            // Points extérieurs et intérieurs de l'étoile
            var points = 5;
            var outer_radius = star_size;
            var inner_radius = star_size * 0.5;
            var angle = -pi/2; // départ en haut

            var verts = array_create(points * 2);
            for (var p = 0; p < points * 2; p++) {
                var radius = (p % 2 == 0) ? outer_radius : inner_radius;
                var vx = star_x + lengthdir_x(radius, radtodeg(angle + p * pi / points));
                var vy = star_y + lengthdir_y(radius, radtodeg(angle + p * pi / points));
                verts[p] = [vx, vy];
            }

            // Tracer les triangles de l'étoile
            for (var t = 1; t < array_length(verts) - 1; t++) {
                draw_triangle(verts[0][0], verts[0][1], verts[t][0], verts[t][1], verts[t+1][0], verts[t+1][1], false);
            }

            draw_set_color(c_black);
    }

    {
        var spr = selectedCard.sprite_index;
        var s = display_scale;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx = display_x - cw * 0.5;
        var tly = display_y - ch * 0.5;

        // Utilisation des coordonnées globales
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        // Description
        var desc_x1  = layout.description.x1, desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
        // ATK
        var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
        // PV
        var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;

        // Utilisation directe des x2/y2 fournis pour tous les champs
        // (les tailles par défaut sont supprimées pour éviter d'écraser vos coordonnées)

        // Dessin des rectangles (haut-gauche -> bas-droite), avec mise à l'échelle et offset carte
        // Masqués par défaut; activer via global.show_green_frames
        if (variable_global_exists("show_green_frames") && global.show_green_frames) {
            var active_field = (variable_global_exists("debug_selected_field")) ? global.debug_selected_field : "";
            
            var draw_debug_rect = function(f_name, x1, y1, x2, y2, tlx, tly, s, active_f) {
                if (f_name == active_f) {
                    draw_set_color(c_red); // Champ actif en ROUGE
                    draw_set_alpha(0.6);   // Semi-transparent pour voir le texte dessous
                } else {
                    draw_set_color(c_lime); // Autres en VERT
                    draw_set_alpha(0.3);    // Plus transparent
                }
                
                // Dessiner le fond
                draw_rectangle(tlx + x1 * s, tly + y1 * s, tlx + x2 * s, tly + y2 * s, false);
                
                // Dessiner le contour
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
    }

    {
        var s = display_scale;
        var rel = s / 0.6;
        var spr = selectedCard.sprite_index;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx = display_x - cw * 0.5;
        var tly = display_y - ch * 0.5;
        // Détection carte magique pour masquer coût et ATK/PV
    var is_magic = object_is_ancestor(selectedCard.object_index, oCardMagic) || (variable_instance_exists(selectedCard, "type") && string_lower(string(selectedCard.type)) == "magic");

        // Utiliser la police de carte
        if (font_exists(fontCardText)) draw_set_font(fontCardText);
        draw_set_color(c_black);

        // Fonction utilitaire de calcul d'échelle pour une ligne
        var fit_line = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var w0 = string_width(text);
            var h0 = base_line_h;
            var s_max = (h0 > 0) ? max_px / h0 : 1;
            var s_w = (w0 > 0) ? rw / w0 : s_max;
            var s_h = (h0 > 0) ? rh / h0 : s_max;
            return min(s_max, s_w, s_h);
        };

        // Fonction utilitaire pour texte multilignes (description)
        // Version itérative qui tient compte de la largeur pour converger sur la hauteur disponible
        var fit_block = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var s = (base_line_h > 0) ? max_px / base_line_h : 1; // cap max
            // Itératif: calcule la hauteur avec séparation non-scalée et largeur rw/s
            for (var it = 0; it < 3; it++) {
                var sep = base_line_h;                 // séparation à l'échelle 1
                var w_eff = (s > 0) ? (rw / s) : rw;   // largeur efficace pour le wrap à scale 1
                var h = string_height_ext(text, sep, w_eff); // hauteur à scale 1
                if (h <= 0) break;
                var s_h = rh / h;                      // scale pour que h*s <= rh
                s = min(s, s_h);
            }
            return s;
        };

        // Marges internes
        var pad = 0;

        if (variable_instance_exists(selectedCard, "name")) {
            var tx = string(selectedCard.name);
            var mar = 7;
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var scale = fit_line(tx, 20, rw, rh);
            scale = round(scale * 20) / 20;
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            left = round(left);
            top  = round(top);
            draw_text_transformed(left, top + 2, tx, scale, scale, 0);
        }

    var display_cost = 0;
    if (variable_instance_exists(selectedCard, "mana_cost")) display_cost = selectedCard.mana_cost;
    
    // Fallback: If mana_cost is 0 but mana_cost is set
    if (display_cost == 0 && variable_instance_exists(selectedCard, "mana_cost") && selectedCard.mana_cost > 0) {
        display_cost = selectedCard.mana_cost;
    }
    
    if (variable_instance_exists(selectedCard, "mana_cost") || (variable_instance_exists(selectedCard, "mana_cost") && selectedCard.mana_cost > 0)) {
        var tx = string(display_cost);
        // Define Mana position (Top Right) - Updated to match card design
        var mana_x1 = layout.mana.x1; var mana_y1 = layout.mana.y1;
        var mana_x2 = layout.mana.x2; var mana_y2 = layout.mana.y2;
        
        // Draw Blue Circle Background - REMOVED per user request
        // var circle_x = tlx + (mana_x1 + (mana_x2-mana_x1)/2) * s;
        // var circle_y = tly + (mana_y1 + (mana_y2-mana_y1)/2) * s;
        
        // draw_set_color(c_aqua);
        // draw_circle(circle_x, circle_y, 18 * s, false);
        // draw_set_color(c_black); // Border
        // draw_circle(circle_x, circle_y, 18 * s, true);
        
        draw_set_color(c_black); // Text Color
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var rw = (mana_x2 - mana_x1) * s;
        var rh = (mana_y2 - mana_y1) * s;
        var center_x = tlx + (mana_x1 + (mana_x2-mana_x1)/2) * s;
        var center_y = tly + (mana_y1 + (mana_y2-mana_y1)/2) * s;
        center_x = round(center_x);
        center_y = round(center_y);
        
        // Use larger font scale for Mana
        var sc = fit_line(tx, 22 * rel, rw, rh);
        sc = round(sc * 20) / 20;
        
        draw_text_transformed(center_x, center_y, tx, sc, sc, 0);
        
        // Reset Align
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

        if (variable_instance_exists(selectedCard, "genre")) {
            var tx = string(selectedCard.genre);
            // Include Race
            if (variable_instance_exists(selectedCard, "race") && string_length(string(selectedCard.race)) > 0 && string_lower(string(selectedCard.race)) != "inconnu" && string_lower(string(selectedCard.race)) != "neutre") {
                if (string_length(tx) > 0) tx += " - " + string(selectedCard.race);
                else tx = string(selectedCard.race);
            }

            var mar = 7;
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            var scale = fit_line(tx, 16, rw, rh);
            scale = round(scale * 20) / 20;
            var gx = tlx + genre_x1 * s + pad + mar;
            var gy = tly + genre_y1 * s + pad;
            gx = round(gx);
            gy = round(gy);
            draw_text_transformed(gx, gy + 2, tx, scale, scale, 0);
        }

        if (variable_instance_exists(selectedCard, "archetype")) {
            var tx = string(selectedCard.archetype);
            var mar = 7;
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            var scale = fit_line(tx, 16, rw, rh);
            scale = round(scale * 20) / 20;
            var ax = tlx + arch_x1 * s + pad + mar;
            var ay = tly + arch_y1 * s + pad;
            ax = round(ax);
            ay = round(ay);
            draw_text_transformed(ax, ay + 2, tx, scale, scale, 0);
        }

        if (variable_instance_exists(selectedCard, "description")) {
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var tx = string(selectedCard.description);
            var mar = 7;
            var rw = (desc_x2 - desc_x1) * s - pad * 2 - mar * 2;
            var rh = (desc_y2 - desc_y1) * s - pad * 2;
            var left = tlx + desc_x1 * s + pad + mar;
            var top  = tly + desc_y1 * s + pad;
            var base_h = string_height("Ag");
            var sc0 = (base_h > 0) ? 20 / base_h : 1;
            var sc = sc0;
            for (var ii = 0; ii < 8; ii++) {
                var w_pre = (sc > 0) ? (rw / sc) : rw;
                var h_un = string_height_ext(tx, base_h, w_pre);
                var h_sc = h_un * sc;
                if (h_sc <= rh) break;
                var k = rh / max(1, h_sc);
                sc *= max(0.6, min(0.95, k));
                sc = min(sc, sc0);
            }
            sc = round(sc * 20) / 20;
            left = round(left);
            top  = round(top);
            var w_eff = round(rw / sc);
            draw_text_ext_transformed(left, top + 2, tx, base_h, w_eff, sc, sc, 0);
        }

        if (!is_magic) {
            // New Positions (Using Global Layout)
            var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2; 
            var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2; 
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);

            if (variable_instance_exists(selectedCard, "attack")) {
                var valA = selectedCard.attack;
                var colA = c_lime; // Always Green per user request
                // Note: effective_attack might not exist in collection, check if needed
                if (variable_instance_exists(selectedCard, "effective_attack")) {
                    valA = selectedCard.effective_attack;
                    // SAFETY FALLBACK: If effective is 0 but base is > 0, use base
                    if (valA == 0 && selectedCard.attack > 0) valA = selectedCard.attack;
                }
                var txA = string(valA);
                
                // Draw Yellow Circle Background for Attack
                var circleA_x = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s;
                var circleA_y = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
                circleA_x = round(circleA_x);
                circleA_y = round(circleA_y);
                
                var scA = 1.2 * rel; // Bigger font

                // Draw Outline (Black)
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(circleA_x - o_dist, circleA_y, txA, scA, scA, 0);
                draw_text_transformed(circleA_x + o_dist, circleA_y, txA, scA, scA, 0);
                draw_text_transformed(circleA_x, circleA_y - o_dist, txA, scA, scA, 0);
                draw_text_transformed(circleA_x, circleA_y + o_dist, txA, scA, scA, 0);
                
                // Text Color
                draw_set_color(colA);
                draw_text_transformed(circleA_x, circleA_y, txA, scA, scA, 0);
            }

            var hpVal = 0;
            var hpMax = 0;
            
            if (variable_instance_exists(selectedCard, "current_hp")) {
                hpVal = selectedCard.current_hp;
                hpMax = (variable_instance_exists(selectedCard, "max_hp") ? selectedCard.max_hp : hpVal);
            } else if (variable_instance_exists(selectedCard, "PV")) {
                hpVal = selectedCard.PV;
                hpMax = hpVal;
            }

            if (hpVal >= 0 || variable_instance_exists(selectedCard, "PV")) {
                // Use effective stats if available
                if (variable_instance_exists(selectedCard, "effective_defense") && variable_instance_exists(selectedCard, "PV")) {
                    // Safety check: ignore effective_defense if 0
                    if (selectedCard.effective_defense > 0) {
                        var bonusHP = selectedCard.effective_defense - selectedCard.PV;
                        hpVal = hpVal + bonusHP;
                        hpMax = selectedCard.effective_defense;
                    }
                }

                var hpColor = c_lime; // Always Green per user request
                
                var txD = string(hpVal);
                
                var circleD_x = tlx + (def_x1 + (def_x2-def_x1)/2) * s;
                var circleD_y = tly + (def_y1 + (def_y2-def_y1)/2) * s;
                circleD_x = round(circleD_x);
                circleD_y = round(circleD_y);
                
                var scD = 1.2 * rel;
                
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(circleD_x - o_dist, circleD_y, txD, scD, scD, 0);
                draw_text_transformed(circleD_x + o_dist, circleD_y, txD, scD, scD, 0);
                draw_text_transformed(circleD_x, circleD_y - o_dist, txD, scD, scD, 0);
                draw_text_transformed(circleD_x, circleD_y + o_dist, txD, scD, scD, 0);
                
                draw_set_color(hpColor);
                draw_text_transformed(circleD_x, circleD_y, txD, scD, scD, 0);
            }
            
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_black);
        }
    }

    if (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode) {
        var cost_rar = "commun";
        if (variable_instance_exists(selectedCard, "rarity")) {
            cost_rar = string_lower(string(selectedCard.rarity));
        }
        var cost = 8;
        if (cost_rar == "rare") cost = 20;
        else if (cost_rar == "epique") cost = 80;
        else if (cost_rar == "legendaire") cost = 320;
        var cid_val = "";
        if (variable_instance_exists(selectedCard, "card_id") && string(selectedCard.card_id) != "") {
            cid_val = string(selectedCard.card_id);
        } else if (variable_instance_exists(selectedCard, "name")) {
            var normalize = function(s) {
                var r = string_lower(string(s));
                r = string_replace_all(r, "à", "a"); r = string_replace_all(r, "â", "a"); r = string_replace_all(r, "ä", "a");
                r = string_replace_all(r, "é", "e"); r = string_replace_all(r, "è", "e"); r = string_replace_all(r, "ê", "e"); r = string_replace_all(r, "ë", "e");
                r = string_replace_all(r, "î", "i"); r = string_replace_all(r, "ï", "i");
                r = string_replace_all(r, "ô", "o"); r = string_replace_all(r, "ö", "o");
                r = string_replace_all(r, "ù", "u"); r = string_replace_all(r, "û", "u"); r = string_replace_all(r, "ü", "u");
                r = string_replace_all(r, "ç", "c");
                return r;
            };
            var nm = normalize(selectedCard.name);
            var matches = dbGetCardsByName(selectedCard.name);
            for (var mi = 0; mi < array_length(matches); mi++) {
                var dc = matches[mi];
                if (variable_struct_exists(dc, "name") && normalize(dc.name) == nm && variable_struct_exists(dc, "id")) {
                    cid_val = string(dc.id);
                    break;
                }
            }
        }
        var owned = 0;
        var maxc = 0;
        if (cid_val != "") {
            owned = get_card_count(cid_val);
            maxc = get_max_copies_for_card_id(cid_val);
        }
        var stones = variable_global_exists("arcane_stones") ? max(0, real(global.arcane_stones)) : 0;
        var can_conv = (cid_val != "" && stones >= cost && owned < maxc);
        var btn_w = 260;
        var btn_h = 44;
        var btn_x = display_x;
        var btn_y = display_y + card_height * 0.5 + 50;
        var bx1 = btn_x - btn_w * 0.5;
        var by1 = btn_y - btn_h * 0.5;
        var bx2 = btn_x + btn_w * 0.5;
        var by2 = btn_y + btn_h * 0.5;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(bx1, by1, bx2, by2, false);
        if (can_conv) {
            draw_set_color(make_color_rgb(40, 160, 255));
        } else {
            draw_set_color(make_color_rgb(50, 50, 50));
        }
        draw_rectangle(bx1, by1, bx2, by2, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (can_conv) {
            draw_set_color(c_white);
        } else {
            draw_set_color(make_color_rgb(140, 140, 140));
        }
        var label = "Convoquer (" + string(cost) + ")";
        draw_text(btn_x, btn_y, label);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // --- CLEANUP ---
    if (variable_instance_exists(id, "portal_active") && portal_active) {
        // Already handled by early return
    }
    // ----------------
}
