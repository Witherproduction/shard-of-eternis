// === oStoryManager - Draw Event ===

// Dessiner la vue du lieu (Transition Map -> Lieu)
// NOTE: Logique déplacée vers oMapManager

draw_set_font(fontCardDisplay);
draw_set_valign(fa_middle);

// --- 1. Dessiner le Panel Héros (Gauche) ---

// Fond du panel gauche
draw_set_color(c_white);
draw_sprite_stretched(sDeckBuilder, 0, panel_hero_x - 10, panel_hero_y - 10, panel_hero_w + 20, panel_hero_h + 20);

// Titre liste héros
draw_set_halign(fa_center);
draw_set_color(col_text_main);
draw_text(panel_hero_x + panel_hero_w/2, panel_hero_y - 40, "HÉROS");

for (var i = 0; i < array_length(heroes); i++) {
    var h = heroes[i];
    var item_y = panel_hero_y + i * (item_hero_h + item_hero_margin);
    var center_y = item_y + item_hero_h / 2;
    
    // Fond de l'item
    var bg_col = col_bg_panel;
    if (selected_hero_index == i) bg_col = col_selected;
    else if (hover_hero_index == i) bg_col = make_color_rgb(50, 50, 60);
    
    draw_set_color(bg_col);
    draw_roundrect(panel_hero_x, item_y, panel_hero_x + panel_hero_w, item_y + item_hero_h, false);
    
    // Bordure si sélectionné
    if (selected_hero_index == i) {
        draw_set_color(c_yellow);
        draw_roundrect(panel_hero_x, item_y, panel_hero_x + panel_hero_w, item_y + item_hero_h, true);
    }
    
    // Contenu (Portrait + Nom)
    var has_portrait = false;
    if (variable_struct_exists(h, "portrait") && is_string(h.portrait)) {
        var spr = asset_get_index(h.portrait);
        if (spr != -1) {
            var spr_w = sprite_get_width(spr);
            var spr_h = sprite_get_height(spr);
            var target_size = 80;
            var scale = target_size / max(spr_w, spr_h);
            
            var ox = sprite_get_xoffset(spr);
            var oy = sprite_get_yoffset(spr);
            
            var draw_x = (panel_hero_x + 60) - (spr_w * scale / 2) + (ox * scale);
            var draw_y = center_y - (spr_h * scale / 2) + (oy * scale);
            
            draw_sprite_ext(spr, 0, draw_x, draw_y, scale, scale, 0, c_white, 1);
            has_portrait = true;
        }
    }
    
    if (!has_portrait) {
        // Placeholder Portrait
        draw_set_color(c_dkgray);
        draw_circle(panel_hero_x + 60, center_y, 40, false);
    }
    
    draw_set_color(col_text_main);
    draw_set_halign(fa_left);
    draw_text(panel_hero_x + 120, center_y, h.name);
    
    // Petite description ou info
    draw_set_font(fontLP);
    draw_set_color(col_text_dim);
    // draw_text_transformed(panel_hero_x + 120, center_y + 25, string(array_length(h.chapters)) + " Chapitre(s)", 0.8, 0.8, 0);
    draw_set_font(fontCardDisplay);
}


// --- 2. Dessiner le Panel Chapitres (Droit) ---

if (selected_hero_index != -1) {
    var hero = heroes[selected_hero_index];
    
    // Fond du panel droit
    draw_set_color(c_white);
    draw_sprite_stretched(sDeckBuilder, 0, panel_chap_x - 10, panel_chap_y - 10, panel_chap_w + 20, panel_chap_h + 20);
    
    var cx = panel_chap_x;
    var cy = panel_chap_y;
    
    cy += 20;
    
    // Liste des Chapitres
    for (var i = 0; i < array_length(hero.chapters); i++) {
        var ch_id = hero.chapters[i];
        var ch_data = get_chapter_data(ch_id);
        var ch_unlocked = is_chapter_unlocked(ch_id);
        
        var ch_h = 60;
        
        // Barre de titre du chapitre
        var bg_ch_col = (selected_chapter_id == ch_id) ? col_selected : col_bg_panel;
        if (hover_chapter_id == ch_id && selected_chapter_id != ch_id) bg_ch_col = make_color_rgb(50, 50, 60);
        
        draw_set_color(bg_ch_col);
        draw_roundrect(cx, cy, cx + panel_chap_w, cy + ch_h, false);
        
        // Texte Titre
        draw_set_halign(fa_left);
        draw_set_color(ch_unlocked ? col_text_main : c_gray);
        draw_text(cx + 20, cy + ch_h/2, "Chapitre " + string(i + 1) + " : " + ch_data.title);
        
        // Cadenas si verrouillé
        if (!ch_unlocked) {
            draw_set_halign(fa_right);
            draw_text(cx + panel_chap_w - 20, cy + ch_h/2, "Verrouillé");
        }
        
        // Si sélectionné, on dessine les détails (Actes + Bouton)
        if (selected_chapter_id == ch_id) {
            var ay = cy + ch_h + 10;
            var acts_height = 0;
            
            if (ch_unlocked) {
                // Liste des actes
                for (var j = 0; j < array_length(ch_data.acts); j++) {
                    var act_num = j + 1;
                    var act_unlocked = false;
                    var act_txt = ch_data.acts[j];
                    
                    if (act_num == 1) act_unlocked = true;
                    else if (act_num == 2) act_unlocked = is_act_complete(ch_id, 1);
                    else if (act_num == 3) act_unlocked = is_act_complete(ch_id, 2);
                    else if (act_num == 4) act_unlocked = is_act_complete(ch_id, 3);
                    
                    var is_selected_act = (global.current_act == act_num);
                    var act_col = act_unlocked ? col_text_main : c_dkgray;
                    
                    if (is_selected_act) act_col = c_lime;
                    else if (hover_act_index == act_num) act_col = c_yellow;
                    
                    if (!act_unlocked) act_txt = "???";
                    
                    draw_set_halign(fa_left);
                    draw_set_color(act_col);
                    draw_text(cx + 40, ay + 15, "Acte " + string(act_num) + " : " + act_txt);
                    
                    ay += 40;
                    acts_height += 40;
                }
                
                // Bouton Commencer
                ay += 20;
                acts_height += 20;
                
                var btn_col = hover_start_btn ? make_color_rgb(60, 40, 40) : make_color_rgb(40, 40, 40);
                draw_set_color(btn_col);
                draw_roundrect(btn_start_rect.x1, btn_start_rect.y1, btn_start_rect.x2, btn_start_rect.y2, false);
                
                draw_set_color(c_orange);
                draw_roundrect(btn_start_rect.x1, btn_start_rect.y1, btn_start_rect.x2, btn_start_rect.y2, true);
                
                draw_set_halign(fa_center);
                draw_set_color(c_white);
                draw_text((btn_start_rect.x1 + btn_start_rect.x2)/2, (btn_start_rect.y1 + btn_start_rect.y2)/2, "COMMENCER");
                
                acts_height += 80; // Espace bouton
            } else {
                // Message verrouillé
                draw_set_halign(fa_center);
                draw_set_color(c_gray);
                draw_text(cx + panel_chap_w/2, ay + 20, "Terminez le chapitre précédent pour accéder.");
                acts_height += 50;
            }
            
            cy += acts_height;
        }
        
        cy += ch_h + 10;
    }
}
