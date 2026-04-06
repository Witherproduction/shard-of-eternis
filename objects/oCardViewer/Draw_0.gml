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
        var show_badge = false;

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

        if (show_badge) { }

        // Afficher la quantité possédée (x1, x2, x3) en bas à droite de chaque carte
        var owned = 0;
        if (variable_instance_exists(inst, "card_id") && inst.card_id != "") {
            owned = get_card_count(inst.card_id);
        }
        if (owned > 0) {
            var label = "x" + string(owned);
            var margin_under = 4;
            var lx = inst.x;
            var ly = tly + h + margin_under - 2;
            var prev_font2 = -1;
            var font_idx2 = asset_get_index("fontUI");
            if (font_idx2 != -1) {
                prev_font2 = draw_get_font();
                draw_set_font(font_idx2);
            }
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(lx, ly, label, 0.4, 0.4, 0);
            if (prev_font2 != -1) { draw_set_font(prev_font2); }
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
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
    } // End if (spr != -1)
    } // End for loop
} // End if (is_array)

// === Bouton Mode Invocation (Variables) ===
var inv_w = 200;
var inv_h = 40;
var inv_x1 = room_width - inv_w - 30; // Position par défaut (sera écrasée par oRetour1)
var inv_y1 = 32;
var inv_label = "Mode Invocation";

if (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode) {
    inv_label = "Invocation Active";
}

// === Positionnement dynamique du bouton par rapport au bouton Retour ===
var ret = instance_find(oRetour1, 0);
if (ret != noone && instance_exists(ret)) {
    inv_y1 = ret.y - inv_h * 0.5;
}
    var inv_x2 = inv_x1 + inv_w;
    var inv_y2 = inv_y1 + inv_h;
    var active = (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode);
    // Fond bouton via sprite cadre
    draw_sprite_stretched(sButton, 0, inv_x1, inv_y1, inv_w, inv_h);
    // Texte centré
    var f_inv = -1;
    if (variable_global_exists("get_runtime_font")) f_inv = global.get_runtime_font("title", 16);
    else if (font_exists(fontTitle)) f_inv = fontTitle;
    else if (font_exists(fontText)) f_inv = fontText;
    else if (font_exists(fontUI)) f_inv = fontUI;
    if (f_inv != -1) draw_set_font(f_inv);
    var inv_text_color = make_color_rgb(230, 200, 120);
    var inv_sc = 1;
    if (f_inv != -1) {
        var inv_base_sz = font_get_size(f_inv);
        if (inv_base_sz > 0) inv_sc = 16 / inv_base_sz;
    }
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed((inv_x1 + inv_x2)/2 + 2, (inv_y1 + inv_y2)/2 + 2, inv_label, inv_sc, inv_sc, 0);
    draw_set_color(inv_text_color);
    draw_text_transformed((inv_x1 + inv_x2)/2, (inv_y1 + inv_y2)/2, inv_label, inv_sc, inv_sc, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // === AFFICHAGE DU PANNEAU DÉTAILLÉ + 3 BOUTONS ===
    // Afficher uniquement quand une carte est selectionnee
    if (instance_exists(oCollectionCardDisplay) && 
        oCollectionCardDisplay.selectedCard != noone && 
        instance_exists(oCollectionCardDisplay.selectedCard)) {
        
        // Position du viewer de carte
        var viewer_x = oCollectionCardDisplay.x;
        var viewer_y = oCollectionCardDisplay.y;
        var display_scale = 0.6;
        var card_width = sprite_get_width(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;
        var card_height = sprite_get_height(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;

        // Le panneau détaillé est dessiné par oCollectionCardDisplay
        
        // Position des cadres a gauche du viewer
        var frames_x = viewer_x - card_width/2 - 60; // 60 pixels a gauche du viewer
        var frames_start_y = viewer_y - card_height/2; // Commencer du haut de la carte
        
        // Espacement vertical entre les cadres
        var spacing = 50;
        
        // Premier cadre (en haut) avec un "+" vert
        draw_set_color(c_gray);
        draw_set_alpha(1);
        draw_rectangle(frames_x - 20, frames_start_y - 20, frames_x + 20, frames_start_y + 20, false);
        
        // Dessiner le "+" vert dans le premier cadre
        draw_set_color(c_lime);
        draw_set_alpha(1);
        // Ligne horizontale du "+"
        draw_line_width(frames_x - 10, frames_start_y, frames_x + 10, frames_start_y, 3);
        // Ligne verticale du "+"
        draw_line_width(frames_x, frames_start_y - 10, frames_x, frames_start_y + 10, 3);
        
        // Deuxieme cadre (au milieu) avec un "-" rouge
        draw_set_color(c_gray);
        draw_rectangle(frames_x - 20, frames_start_y + spacing - 20, frames_x + 20, frames_start_y + spacing + 20, false);
        
        // Dessiner le "-" rouge dans le deuxieme cadre
        draw_set_color(c_red);
        draw_set_alpha(1);
        // Ligne horizontale du "-"
        draw_line_width(frames_x - 10, frames_start_y + spacing, frames_x + 10, frames_start_y + spacing, 3);
        
        // Troisieme cadre (en bas) avec une etoile jaune
        draw_set_color(c_gray);
        draw_rectangle(frames_x - 20, frames_start_y + spacing * 2 - 20, frames_x + 20, frames_start_y + spacing * 2 + 20, false);
        
        // Dessiner l'etoile jaune dans le troisieme cadre
        draw_set_color(c_yellow);
        draw_set_alpha(1);
        var star_x = frames_x;
        var star_y = frames_start_y + spacing * 2;
        var star_size = 12;
        
        // Dessiner une etoile a 5 branches
         // Points exterieurs et interieurs de l'etoile
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
        
        // Dessiner l'etoile pleine en utilisant des triangles
        for (var i = 0; i < 5; i++) {
            var next_i = (i + 1) % 5;
            
            // Triangle du centre vers chaque branche de l'etoile
            draw_triangle(star_x, star_y, 
                         outer_points_x[i], outer_points_y[i], 
                         inner_points_x[i], inner_points_y[i], false);
            draw_triangle(star_x, star_y, 
                         inner_points_x[i], inner_points_y[i], 
                         outer_points_x[next_i], outer_points_y[next_i], false);
        }
    }
