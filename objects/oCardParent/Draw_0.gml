// === oCardParent - Draw Event ===

var __attackable = false;
if (room == rDuel
    && variable_instance_exists(id, "type") && type == "Monster"
    && variable_instance_exists(id, "isHeroOwner") && isHeroOwner
    && variable_instance_exists(id, "zone") && (zone == "Field" || zone == "FieldSelected")
    && instance_exists(game)
) {
    var __is_turn = false;
    if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
        __is_turn = (variable_instance_exists(game, "is_local_turn") && game.is_local_turn);
    } else {
        __is_turn = (variable_instance_exists(game, "player_current") && game.player_current == 0);
    }

    var __phase = (variable_instance_exists(game, "phase") && variable_instance_exists(game, "phase_current")) ? game.phase[game.phase_current] : "";
    var __turn1_lock = (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1);
    if (__is_turn && __phase == "Main" && !__turn1_lock) {
        if (variable_instance_exists(id, "orientation") && orientation == "Attack") {
            var __entrave_blocks = (variable_instance_exists(id, "entrave_turns_remaining") && entrave_turns_remaining > 0
                                    && variable_instance_exists(id, "entrave_block_attack") && entrave_block_attack);
            if (!__entrave_blocks) {
                var __attack_limit = (variable_instance_exists(id, "isAmbidextrous") && isAmbidextrous) ? 2 : 1;
                var __used_attacks = (variable_instance_exists(id, "attacksUsedThisTurn") ? attacksUsedThisTurn : 0);
                __attackable = (__used_attacks < __attack_limit);
            }
        }
    }
}

if (__attackable) {
    var __spr_glow = sprite_index;
    if (!sprite_exists(__spr_glow)) __spr_glow = asset_get_index("sCarteBack");
    var __subimg = (__spr_glow == sprite_index) ? image_index : 0;
    var __t = current_time / 1000.0;
    var __period = 2.5;
    var __a = (sin((__t * (2 * pi)) / __period - (pi * 0.5)) + 1) * 0.5;

    if (sprite_exists(__spr_glow)) {
        gpu_set_blendmode(bm_normal);
        var __col_base = make_color_rgb(180, 0, 0);
        draw_sprite_ext(__spr_glow, __subimg, x, y, image_xscale * 1.10, image_yscale * 1.10, image_angle, __col_base, 0.55 * __a);

        gpu_set_blendmode(bm_add);
        var __col = make_color_rgb(255, 70, 70);
        draw_sprite_ext(__spr_glow, __subimg, x, y, image_xscale * 1.03, image_yscale * 1.03, image_angle, __col, 0.75 * __a);
        draw_sprite_ext(__spr_glow, __subimg, x, y, image_xscale * 1.08, image_yscale * 1.08, image_angle, __col, 0.45 * __a);
        draw_sprite_ext(__spr_glow, __subimg, x, y, image_xscale * 1.14, image_yscale * 1.14, image_angle, __col, 0.25 * __a);
        draw_sprite_ext(__spr_glow, __subimg, x, y, image_xscale * 1.22, image_yscale * 1.22, image_angle, __col, 0.14 * __a);
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// --- AMBIDEXTROUS VISUAL (Doppelgänger / Mirage Statique) ---
if (variable_instance_exists(id, "isAmbidextrous") && isAmbidextrous && variable_instance_exists(id, "zone") && zone == "Field") {
    // Configuration
    var _ghost_off_x = 15; // Décalage fixe X (vers la droite)
    var _ghost_off_y = -8; // Décalage fixe Y (plus haut)
    var _ghost_alpha = 0.5; // Semi-transparent
    var _ghost_col = c_white; // Couleurs naturelles
    
    if (sprite_exists(sprite_index)) {
        // Single Static Ghost (Le "Double" naturel semi-transparent)
        draw_sprite_ext(sprite_index, image_index, x + _ghost_off_x, y + _ghost_off_y, image_xscale, image_yscale, image_angle, _ghost_col, _ghost_alpha);
    }
}
// ----------------------------------------------------

// --- ILLUSION VISUAL (Double bleuté en décalage) ---
if (variable_instance_exists(id, "HasIllusion") && HasIllusion && variable_instance_exists(id, "zone") && zone == "Field") {
    var _illu_off_x = -10; // Décalage vers la gauche pour différencier d'Ambidextre
    var _illu_off_y = -5;
    var _illu_alpha = 0.6;
    var _illu_col = make_color_rgb(100, 100, 255); // Bleuté clair

    if (sprite_exists(sprite_index)) {
        draw_sprite_ext(sprite_index, image_index, x + _illu_off_x, y + _illu_off_y, image_xscale, image_yscale, image_angle, _illu_col, _illu_alpha);
    }
}
// ----------------------------------------------------

// Dessiner la carte à sa position
if (sprite_exists(sprite_index)) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
} else {
    // Fallback pour éviter le crash si le sprite est invalide (-1)
    var _spr_fallback = asset_get_index("sCarteBack");
    if (sprite_exists(_spr_fallback)) {
        draw_sprite_ext(_spr_fallback, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    }
}

// --- POISON BUBBLES DRAW ---
if (variable_instance_exists(id, "poison_bubbles") && array_length(poison_bubbles) > 0) {
    var _c_poison = make_color_rgb(60, 200, 80); // Toxic Green
    draw_set_color(_c_poison);
    
    // Pre-calculate rotation math (dcos/dsin take degrees)
    var _cos = dcos(image_angle);
    var _sin = dsin(image_angle);
    
    for (var i = 0; i < array_length(poison_bubbles); i++) {
        var b = poison_bubbles[i];
        
        // Rotate offsets: x' = x*cos - y*sin, y' = x*sin + y*cos
        // Note: standard rotation formula 
        // GML angles: 0 is right, 90 is up (or down depending on y-axis, usually down in 2D)
        // Actually simpler to use lengthdir functions or just manual rotation
        // Manual rotation for standard Cartesian:
        // x_rot = x * cos(a) - y * sin(a)
        // y_rot = x * sin(a) + y * cos(a)
        // Since y is down, positive angle is usually counter-clockwise (in math) but GML is counter-clockwise too.
        
        var _rot_x = x + (b.off_x * _cos + b.off_y * _sin);
        var _rot_y = y + (-b.off_x * _sin + b.off_y * _cos); // Adjusted for GML rotation quirks if needed, but let's stick to standard 2D rotation matrix for now
        
        // Actually, let's use the same math as the hover detection for consistency
        // var ca = cos(image_angle * pi / 180); var sa = sin(image_angle * pi / 180);
        // x_new = cx + lx*ca - ly*sa;
        // y_new = cy + lx*sa + ly*ca;
        
        var _ca = dcos(image_angle); // cos
        var _sa = -dsin(image_angle); // sin (GML dsin returns positive for 90, but y is inverted... wait)
        // Let's rely on lengthdir for safety if unsure, but matrix is faster.
        // Let's use the formula from hover check:
        // ca = cos(rad), sa = sin(rad)
        // x = cx + lx*ca - ly*sa
        // y = cy + lx*sa + ly*ca
        
        var _rad = degtorad(image_angle);
        var _ca_r = cos(_rad);
        var _sa_r = sin(_rad);
        
        _rot_x = x + b.off_x * _ca_r - b.off_y * _sa_r;
        _rot_y = y + b.off_x * _sa_r + b.off_y * _ca_r;
        
        draw_set_alpha(b.alpha * 0.8); // Slight transparency max
        draw_circle(_rot_x, _rot_y, b.r, false);
        
        // Optional: Highlight
        draw_set_alpha(b.alpha * 0.4);
        draw_set_color(c_white);
        draw_circle(_rot_x - b.r*0.3, _rot_y - b.r*0.3, b.r*0.3, false);
        draw_set_color(_c_poison);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

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
        var w = 0, h = 0;
        if (sprite_exists(sprite_index)) {
             w = sprite_get_width(sprite_index) * image_xscale;
             h = sprite_get_height(sprite_index) * image_yscale;
        } else {
             var _spr_fb = asset_get_index("sCarteBack");
             if (sprite_exists(_spr_fb)) {
                 w = sprite_get_width(_spr_fb) * image_xscale;
                 h = sprite_get_height(_spr_fb) * image_yscale;
             }
        }
        
        // Simple rectangle border for now (Shield shape would be better but requires sprite)
        for(var i=0; i<border_w; i++) {
            draw_rectangle(x - w/2 - i, y - h/2 - i, x + w/2 + i, y + h/2 + i, true);
        }
        draw_set_color(c_white);
    }
    
    if (isStealth) {
        // Draw Stealth Fog / Alpha Overlay
        var overlaySpr = asset_get_index("sCamouflageOverlay");
        
        // Determine reference sprite for dimensions (Card itself or Back)
        var refSpr = sprite_index;
        if (!sprite_exists(refSpr)) refSpr = asset_get_index("sCarteBack");
        
        if (sprite_exists(overlaySpr) && sprite_exists(refSpr)) {
            // Calculate scale to match card dimensions exactly
            var s_x = (sprite_get_width(refSpr) / sprite_get_width(overlaySpr)) * image_xscale;
            var s_y = (sprite_get_height(refSpr) / sprite_get_height(overlaySpr)) * image_yscale;
            
            draw_sprite_ext(overlaySpr, 0, x, y, s_x, s_y, image_angle, c_white, 0.6);
        } else {
            // Fallback (Old Circle)
            draw_set_alpha(0.6);
            draw_set_color(c_black);
            var radius = 20;
            if (sprite_exists(sprite_index)) {
                radius = (sprite_get_width(sprite_index) * image_xscale) * 0.4;
            } else {
                var _spr_fb = asset_get_index("sCarteBack");
                 if (sprite_exists(_spr_fb)) {
                     radius = (sprite_get_width(_spr_fb) * image_xscale) * 0.4;
                 }
            }
            draw_circle(x, y, radius, false);
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
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
        var card_w = 0, card_h = 0;
        if (sprite_exists(sprite_index)) {
             card_w = sprite_get_width(sprite_index) * image_xscale;
             card_h = sprite_get_height(sprite_index) * image_yscale;
        } else {
             var _spr_fb = asset_get_index("sCarteBack");
             if (sprite_exists(_spr_fb)) {
                 card_w = sprite_get_width(_spr_fb) * image_xscale;
                 card_h = sprite_get_height(_spr_fb) * image_yscale;
             }
        }
        
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
        var _sw = 0, _sh = 0;
        if (sprite_exists(sprite_index)) {
             _sw = sprite_get_width(sprite_index);
             _sh = sprite_get_height(sprite_index);
        } else {
             var _spr_fb = asset_get_index("sCarteBack");
             if (sprite_exists(_spr_fb)) {
                 _sw = sprite_get_width(_spr_fb);
                 _sh = sprite_get_height(_spr_fb);
             }
        }
        
        var star_x = x - (_sw * image_xscale)/2 + 8;
        var star_y = y - (_sh * image_yscale)/2 + 8;
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
        var cw = 0, ch = 0;
        if (sprite_exists(spr)) {
            cw = sprite_get_width(spr) * s;
            ch = sprite_get_height(spr) * s;
        } else {
             var _spr_fb = asset_get_index("sCarteBack");
             if (sprite_exists(_spr_fb)) {
                 cw = sprite_get_width(_spr_fb) * s;
                 ch = sprite_get_height(_spr_fb) * s;
             }
        }
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
                var a_norm = ((image_angle % 360) + 360) % 360;
                if (a_norm == 0 || a_norm == 90 || a_norm == 180 || a_norm == 270) {
                    ang_overlay = image_angle;
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
            draw_debug_rect("race", arch_x1, arch_y1, arch_x2, arch_y2, tlx, tly, s, active_field);
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
            // Si la race est incluse dans le genre (format "Genre - Race"), on la retire pour l'affichage propre
            if (variable_instance_exists(self, "race") && string_length(race) > 0) {
                var split = string_split(tx, " - ");
                if (array_length(split) > 0) {
                    tx = split[0];
                }
            }
            
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
        if (variable_instance_exists(self, "race")) {
            var tx = string(race);
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
                var colA = c_lime; // Always Green per user request
                if (variable_instance_exists(self, "effective_attack")) {
                    valA = effective_attack;
                    // SAFETY FALLBACK: If effective is 0 but base is > 0, use base
                    if (valA == 0 && attack > 0) valA = attack;
                }
                var txA = string(valA);
                
                var circleA_x = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s;
                var circleA_y = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
                circleA_x = round(circleA_x);
                circleA_y = round(circleA_y);
                
                // Font Size
                var scA = 1.2 * rel; // Bigger font
                
                // Draw Outline (Black)
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(circleA_x - o_dist, circleA_y, txA, scA, scA, angle_draw);
                draw_text_transformed(circleA_x + o_dist, circleA_y, txA, scA, scA, angle_draw);
                draw_text_transformed(circleA_x, circleA_y - o_dist, txA, scA, scA, angle_draw);
                draw_text_transformed(circleA_x, circleA_y + o_dist, txA, scA, scA, angle_draw);
                
                draw_set_color(colA); // Text Color
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

                // Color Logic
                var hpColor = c_lime; // Always Green per user request
                
                var txD = string(hpVal);
                
                var circleD_x = tlx + (def_x1 + (def_x2-def_x1)/2) * s;
                var circleD_y = tly + (def_y1 + (def_y2-def_y1)/2) * s;
                circleD_x = round(circleD_x);
                circleD_y = round(circleD_y);
                
                var scD = 1.2 * rel;
                
                // Draw Outline (Black)
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(circleD_x - o_dist, circleD_y, txD, scD, scD, angle_draw);
                draw_text_transformed(circleD_x + o_dist, circleD_y, txD, scD, scD, angle_draw);
                draw_text_transformed(circleD_x, circleD_y - o_dist, txD, scD, scD, angle_draw);
                draw_text_transformed(circleD_x, circleD_y + o_dist, txD, scD, scD, angle_draw);
                
                // Text Color
                draw_set_color(hpColor);
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

