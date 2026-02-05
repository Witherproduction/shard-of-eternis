// === oCardParent - Draw Event ===

// Dessiner la carte à sa position
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// --- COMBO / SPELL ALERT VISUAL (WoW Proc Style) ---
if (variable_instance_exists(id, "isComboActive") && isComboActive) {
    // Dessiner des "parenthèses" d'énergie autour de la carte
    // Utilise draw_sprite_part ou draw_primitive pour un effet propre sans sprite dédié si besoin
    // Ici on simule avec des formes simples animées
    
    var glowAlpha = 0.6 + 0.4 * sin(comboAnimTimer * 0.1); // Pulsation
    var glowScale = 1.0 + 0.05 * sin(comboAnimTimer * 0.05);
    var cardW = sprite_get_width(sprite_index) * image_xscale;
    var cardH = sprite_get_height(sprite_index) * image_yscale;
    
    // Couleur "Magie Universelle" (Violet/Bleu néon) ou "Feu" selon préférence
    // Pour "universel" : un Cyan/Bleu électrique marche bien
    var glowCol = make_color_rgb(0, 255, 255); 
    
    gpu_set_blendmode(bm_add); // Mode additif pour l'effet lumineux
    
    // Effet "Arc" gauche
    draw_sprite_ext(sCardBack, 0, x - cardW/2, y, 0.2 * glowScale, 0.8 * image_yscale, 0, glowCol, glowAlpha * 0.5);
    
    // Effet "Arc" droit
    draw_sprite_ext(sCardBack, 0, x + cardW/2, y, 0.2 * glowScale, 0.8 * image_yscale, 0, glowCol, glowAlpha * 0.5);
    
    // Particules simples (cercles qui montent)
    var pTime = (comboAnimTimer % 60) / 60;
    var pY = y + cardH/2 - (cardH * pTime);
    var pX_L = x - cardW/2 + sin(pY * 0.1) * 5;
    var pX_R = x + cardW/2 - sin(pY * 0.1) * 5;
    
    draw_circle_color(pX_L, pY, 4, glowCol, c_black, false);
    draw_circle_color(pX_R, pY, 4, glowCol, c_black, false);

    gpu_set_blendmode(bm_normal);
}
// --------------------------------------------------

// --- TAUNT / STEALTH VISUALS (Hearthstone Style) ---
var hasTaunt = (variable_instance_exists(self, "has_taunt") && has_taunt);
var isStealth = (variable_instance_exists(self, "isCamouflage") && isCamouflage);

if (hasTaunt) {
    // Draw Shield Border (Grey Thick Border)
    var taunt_col = make_color_rgb(100, 100, 100);
    draw_set_color(taunt_col);
    var border_w = 3;
    var w = sprite_get_width(sprite_index) * image_xscale;
    var h = sprite_get_height(sprite_index) * image_yscale;
    
    // Simple rectangle border for now (Shield shape would be better but requires sprite)
    for(var i=0; i<border_w; i++) {
        draw_rectangle(x - w/2 - i, y - h/2 - i, x + w/2 + i, y + h/2 + i, true);
    }
    draw_set_color(c_white);
}

if (isStealth) {
    // Draw Stealth Fog / Alpha Overlay
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_circle(x, y, (sprite_get_width(sprite_index) * image_xscale) * 0.4, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
// --------------------------------------------------


// --- Bordure de rareté pour les petites cartes ---
if (room == rCollection && variable_instance_exists(self, "rarity")) {
    var rarity_color = getRarityColor(rarity);
    var glow_intensity = getRarityGlowIntensity(rarity);
    
    if (glow_intensity > 0) {
        // Dessiner une bordure colorée selon la rareté
        draw_set_color(rarity_color);
        draw_set_alpha(glow_intensity * 0.7); // Moins intense pour les petites cartes
        
        // Bordure épaisse pour les petites cartes
        var border_thickness = 4;
        var card_w = sprite_get_width(sprite_index) * image_xscale;
        var card_h = sprite_get_height(sprite_index) * image_yscale;
        
        for (var i = 1; i <= border_thickness; i++) {
            draw_rectangle(x - card_w/2 - i, y - card_h/2 - i, 
                          x + card_w/2 + i, y + card_h/2 + i, true);
        }
        
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// Afficher l'étoile de favori si la carte est dans la collection et en favoris
if (room == rCollection && zone == "Collection") {
    var card_id = name;
    
    if (is_card_favorite(card_id)) {
        // Position de l'étoile en haut à gauche de la petite carte
        var star_x = x - (sprite_get_width(sprite_index) * image_xscale)/2 + 8;
        var star_y = y - (sprite_get_height(sprite_index) * image_yscale)/2 + 8;
        var star_size = 8;
        
        // Dessiner l'étoile jaune (même méthode que le bouton)
        draw_set_color(c_yellow);
        draw_set_alpha(1);
        
        // Points extérieurs et intérieurs de l'étoile
        var outer_points_x = [];
        var outer_points_y = [];
        var inner_points_x = [];
        var inner_points_y = [];
        
        for (var i = 0; i < 5; i++) {
            var angle_outer = (i * 72 - 90) * pi / 180; // -90 pour commencer par le haut
            var angle_inner = ((i * 72 + 36) - 90) * pi / 180;
            
            outer_points_x[i] = star_x + cos(angle_outer) * star_size;
            outer_points_y[i] = star_y + sin(angle_outer) * star_size;
            inner_points_x[i] = star_x + cos(angle_inner) * (star_size * 0.4);
            inner_points_y[i] = star_y + sin(angle_inner) * (star_size * 0.4);
        }
        
        // Dessiner l'étoile pleine en utilisant des triangles
        for (var i = 0; i < 5; i++) {
            var next_i = (i + 1) % 5;
            
            // Triangle du centre vers chaque branche de l'étoile
            draw_triangle(star_x, star_y, 
                         outer_points_x[i], outer_points_y[i], 
                         inner_points_x[i], inner_points_y[i], false);
            draw_triangle(star_x, star_y, 
                         inner_points_x[i], inner_points_y[i], 
                         outer_points_x[next_i], outer_points_y[next_i], false);
        }
        
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// Si la carte est sélectionnée, dessiner un contour
if (isSelected) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.8);
    draw_rectangle(x - sprite_width/2, y - sprite_height/2, x + sprite_width/2, y + sprite_height/2, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Si la carte est survolée (mais pas sélectionnée), dessiner un contour plus subtil
else if (isHovered) {
    draw_set_color(c_white);
    draw_set_alpha(0.5);
    draw_rectangle(x - sprite_width/2, y - sprite_height/2, x + sprite_width/2, y + sprite_height/2, true);
    draw_set_alpha(1);
}

 

// (overlay texte Hand/Field supprimé)

if (variable_instance_exists(self, "zone") && (zone == "Hand" || zone == "HandSelected" || zone == "Field" || zone == "FieldSelected" || (zone == "Collection" && !isSelected))) {
    var face_down = (variable_instance_exists(self, "isFaceDown") && isFaceDown);
    var can_show = true;
    if (zone == "Hand" || zone == "HandSelected") {
        can_show = (variable_instance_exists(self, "isHeroOwner") && isHeroOwner);
    } else if (zone == "Field" || zone == "FieldSelected") {
        can_show = !face_down;
    }
    if (can_show) {
        var spr = sprite_index;
        var s = image_xscale;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx = x - cw * 0.5;
        var tly = y - ch * 0.5;
        // Utilisation des coordonnées globales
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        // Description (désactivée mais variables gardées pour compatibilité structure si besoin)
        var desc_x1  = 23,  desc_y1  = 438; var desc_x2  = 421, desc_y2  = 592;
        
        var is_magic = object_is_ancestor(object_index, oCardMagic) || (variable_instance_exists(self, "type") && string_lower(string(type)) == "magic");
        if (font_exists(fontCardText)) draw_set_font(fontCardText);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_black);
        var fit_line = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var w0 = string_width(text);
            var h0 = base_line_h;
            var s_max = (h0 > 0) ? max_px / h0 : 1;
            var s_w = (w0 > 0) ? rw / w0 : s_max;
            var s_h = (h0 > 0) ? rh / h0 : s_max;
            return min(s_max, s_w, s_h);
        };
        var fit_block = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var sc = (base_line_h > 0) ? max_px / base_line_h : 1;
            for (var it = 0; it < 3; it++) {
                var sep = base_line_h;
                var w_eff = (sc > 0) ? (rw / sc) : rw;
                var h = string_height_ext(text, sep, w_eff);
                if (h <= 0) break;
                var s_h2 = rh / h;
                sc = min(sc, s_h2);
            }
            return sc;
        };
        var pad = 0;
        var rel = s / 0.6;
        var mar = 7;
        var ang_overlay = 0;
        if ((zone == "Field" || zone == "FieldSelected") && !face_down) {
            if (variable_instance_exists(self, "orientation") && orientation == "DefenseVisible") {
                ang_overlay = image_angle;
            } else {
                var owner_hero = (variable_instance_exists(self, "isHeroOwner") && isHeroOwner);
                var a_norm = ((image_angle % 360) + 360) % 360;
                if (a_norm == 0 || a_norm == 90 || a_norm == 180 || a_norm == 270) {
                    ang_overlay = owner_hero ? image_angle : -image_angle;
                }
            }
        }
        var use_matrix = (ang_overlay != 0);
        var prev_world;
        if (use_matrix) {
            prev_world = matrix_get(matrix_world);
            var mat = matrix_build(x, y, 0, 0, 0, ang_overlay, 1, 1, 1);
            matrix_set(matrix_world, mat);
            tlx = -cw * 0.5;
            tly = -ch * 0.5;
        }
        var angle_draw = use_matrix ? 0 : ang_overlay;
        
        // --- DEBUG FRAMES ---
        if (variable_global_exists("show_green_frames") && global.show_green_frames) {
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
            // Description frames hidden on small cards as text is hidden
            // draw_debug_rect("description", desc_x1, desc_y1, desc_x2, desc_y2, tlx, tly, s, active_field);
            // ATK/HP logic is further down, but we can draw frames here using layout vars
            var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
            var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
            draw_debug_rect("atk", atk_x1, atk_y1, atk_x2, atk_y2, tlx, tly, s, active_field);
            draw_debug_rect("hp", def_x1, def_y1, def_x2, def_y2, tlx, tly, s, active_field);
            
            draw_set_color(c_black);
        }

        // Toujours aligner comme en Collection
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        if (variable_instance_exists(self, "name")) {
            var tx = string(name);
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var sc = fit_line(tx, 20 * rel, rw, rh);
            sc = round(sc * 20) / 20;
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            left = round(left);
            top  = round(top);
            draw_text_transformed(left, top + 2, tx, sc, sc, angle_draw);
        }
        // --- MANA COST DISPLAY (Top Right) ---
        var display_cost = 0;
        if (variable_instance_exists(self, "mana_cost")) display_cost = mana_cost;
        
        // Fallback: If mana_cost is 0 but mana_cost is set
        if (display_cost == 0 && variable_instance_exists(self, "mana_cost") && mana_cost > 0) {
            display_cost = mana_cost;
        }
        
        if (variable_instance_exists(self, "mana_cost") || (variable_instance_exists(self, "mana_cost") && mana_cost > 0)) {
            var tx = string(display_cost);
            // Define Mana position (Top Right)
            // Using global layout
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
            // Center in the designated area
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
            
            draw_text_transformed(center_x, center_y, tx, sc, sc, angle_draw);
            
            // Reset Align
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        if (variable_instance_exists(self, "genre")) {
            var tx = string(genre);
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            var sc = fit_line(tx, 16 * rel, rw, rh);
            sc = round(sc * 20) / 20;
            var left_g = tlx + genre_x1 * s + pad + mar;
            var top_g  = tly + genre_y1 * s + pad;
            left_g = round(left_g);
            top_g  = round(top_g);
            draw_text_transformed(left_g, top_g + 2, tx, sc, sc, angle_draw);
        }
        if (variable_instance_exists(self, "archetype")) {
            var tx = string(archetype);
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            var sc = fit_line(tx, 16 * rel, rw, rh);
            sc = round(sc * 20) / 20;
            var left_a = tlx + arch_x1 * s + pad + mar;
            var top_a  = tly + arch_y1 * s + pad;
            left_a = round(left_a);
            top_a  = round(top_a);
            draw_text_transformed(left_a, top_a + 2, tx, sc, sc, angle_draw);
        }
        // Description supprimée de l'affichage sur la carte (Terrain/Main/Collection)
        // if (variable_instance_exists(self, "description")) { ... }

        // ATK/HP overlay (Hearthstone Style)
        if (!is_magic) {
            // New Positions from Global Layout
            var atk_x1 = layout.atk.x1, atk_y1 = layout.atk.y1; var atk_x2 = layout.atk.x2, atk_y2 = layout.atk.y2;
            var def_x1 = layout.hp.x1, def_y1 = layout.hp.y1; var def_x2 = layout.hp.x2, def_y2 = layout.hp.y2;
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);

            // --- ATTACK ---
            if (variable_instance_exists(self, "attack")) {
                var valA = attack;
                var colA = c_black;
                if (variable_instance_exists(self, "effective_attack")) {
                    valA = effective_attack;
                    // SAFETY FALLBACK: If effective is 0 but base is > 0, use base
                    if (valA == 0 && attack > 0) valA = attack;
                    
                    if (valA > attack) colA = c_lime; // Buffed
                    else if (valA < attack) colA = c_red; // Debuffed
                }
                var txA = string(valA);
                
                // Draw Yellow Circle Background for Attack REMOVED
                var circleA_x = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s;
                var circleA_y = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
                circleA_x = round(circleA_x);
                circleA_y = round(circleA_y);
                /*
                draw_set_color(c_yellow);
                draw_circle(circleA_x, circleA_y, 22 * s, false);
                */
                
                draw_set_color(colA); // Text Color
                /*
                // Border is usually black, but let's keep it simple or split
                draw_set_color(c_black); 
                draw_circle(circleA_x, circleA_y, 22 * s, true);
                */
                
                // Font Size
                var scA = 1.2 * rel; // Bigger font
                
                draw_set_color(c_black); // Force BLACK
                draw_text_transformed(circleA_x, circleA_y, txA, scA, scA, angle_draw);
            }

            // --- HP ---
            var hasHP = false;
            var hpVal = 0;
            var hpMax = 0;

            if (variable_instance_exists(self, "current_hp")) {
                hpVal = current_hp;
                hpMax = (variable_instance_exists(self, "max_hp") ? max_hp : hpVal);
                hasHP = true;
            } else if (variable_instance_exists(self, "PV")) {
                hpVal = PV;
                hpMax = PV;
                hasHP = true;
            }

            if (hasHP) {
                // Use effective stats if available
                if (variable_instance_exists(self, "effective_defense") && variable_instance_exists(self, "PV")) {
                    // Safety check: ignore effective_defense if 0
                    if (effective_defense > 0) {
                        var bonusHP = effective_defense - PV;
                        hpVal = hpVal + bonusHP;
                        hpMax = effective_defense;
                    }
                }

                // Color Logic (kept for reference but unused for text)
                var hpColor = c_black;
                if (hpVal < hpMax) hpColor = c_red;
                else if (hpVal > hpMax) hpColor = c_lime;
                
                var txD = string(hpVal);
                
                // Draw Blood Drop / Circle Background for HP REMOVED
                var circleD_x = tlx + (def_x1 + (def_x2-def_x1)/2) * s;
                var circleD_y = tly + (def_y1 + (def_y2-def_y1)/2) * s;
                circleD_x = round(circleD_x);
                circleD_y = round(circleD_y);
                
                // Background (Dark Red/Black) REMOVED
                /*
                draw_set_color(make_color_rgb(50, 0, 0));
                draw_circle(circleD_x, circleD_y, 22 * s, false);
                draw_set_color(c_red); // Border
                draw_circle(circleD_x, circleD_y, 22 * s, true);
                */
                
                // Text Color forced to BLACK
                draw_set_color(c_black);
                
                var scD = 1.2 * rel;
                draw_text_transformed(circleD_x, circleD_y, txD, scD, scD, angle_draw);
            }
            
            // Reset
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
        }
        if (use_matrix) {
            matrix_set(matrix_world, prev_world);
        }
    }
}

