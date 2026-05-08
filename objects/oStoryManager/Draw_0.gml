// === oStoryManager - Draw Event ===

// Dessiner l'interface Histoire

draw_set_valign(fa_middle);
text_col = make_color_rgb(230, 200, 120);

ui_font_16 = -1;
ui_font_15 = -1;
ui_font_14 = -1;
if (variable_global_exists("get_runtime_font")) {
    ui_font_16 = global.get_runtime_font("title", 16);
    ui_font_15 = global.get_runtime_font("title", 15);
    ui_font_14 = global.get_runtime_font("title", 14);
}
if (ui_font_16 == -1) {
    if (font_exists(fontTitle)) ui_font_16 = fontTitle;
    else if (font_exists(fontText)) ui_font_16 = fontText;
    else if (font_exists(fontUI)) ui_font_16 = fontUI;
}
if (ui_font_15 == -1) ui_font_15 = ui_font_16;
if (ui_font_14 == -1) ui_font_14 = ui_font_15;

draw_shadow_text_col = function(_x, _y, _t, _col, _font) {
    var dx = round(_x);
    var dy = round(_y);
    if (_font != -1) draw_set_font(_font);
    draw_set_color(c_black);
    draw_text(dx + 2, dy + 2, _t);
    draw_set_color(_col);
    draw_text(dx, dy, _t);
};
draw_shadow_text = function(_x, _y, _t, _font) {
    draw_shadow_text_col(_x, _y, _t, text_col, _font);
};

// --- 1. Dessiner le Panel Héros (Gauche) ---

// Fond du panel gauche
draw_set_color(c_white);
draw_sprite_stretched(sDeckBuilder, 0, panel_hero_x - 10, panel_hero_y - 10, panel_hero_w + 20, panel_hero_h + 20);

// Titre liste héros
draw_set_halign(fa_center);
draw_shadow_text(panel_hero_x + panel_hero_w/2, panel_hero_y - 40, "HÉROS", ui_font_16);

for (var i = 0; i < array_length(heroes); i++) {
    var h = heroes[i];
    var item_y = panel_hero_y + i * (item_hero_h + item_hero_margin);
    var center_y = item_y + item_hero_h / 2;
    
    // Fond de l'item
    var subimg_hero = 0;
    if (sprite_get_number(sButton) > 1 && selected_hero_index == i) subimg_hero = 1;
    draw_sprite_stretched(sButton, subimg_hero, panel_hero_x, item_y, panel_hero_w, item_hero_h);
    
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
    
    draw_set_halign(fa_left);
    draw_shadow_text(panel_hero_x + 120, center_y, h.name, ui_font_15);
    
    // Petite description ou info
    draw_set_font(fontLife);
    draw_set_color(col_text_dim);
    // draw_text_transformed(panel_hero_x + 120, center_y + 25, string(array_length(h.chapters)) + " Chapitre(s)", 0.8, 0.8, 0);
    if (ui_font_16 != -1) draw_set_font(ui_font_16);
}


// --- 2. Dessiner le Panel Chapitres (Droit) ---

if (selected_hero_index != -1) {
    var hero = heroes[selected_hero_index];
    
    // Fond du panel droit
    draw_set_color(c_white);
    draw_sprite_stretched(sDeckBuilder, 0, panel_chap_x - 10, panel_chap_y - 10, panel_chap_w + 20, panel_chap_h + 20);
    
    var cx = panel_chap_x;
    var cy = panel_chap_y;
    
    // Liste des Chapitres
    for (var i = 0; i < array_length(hero.chapters); i++) {
        var ch_id = hero.chapters[i];
        var ch_data = get_chapter_data(ch_id);
        var ch_unlocked = is_chapter_unlocked(ch_id);
        
        var ch_h = chapter_btn_h;
        
        // Barre de titre du chapitre
        var subimg_ch = 0;
        if (sprite_get_number(sButton) > 1 && selected_chapter_id == ch_id) subimg_ch = 1;
        draw_set_alpha(ch_unlocked ? 1 : 0.6);
        draw_sprite_stretched(sButton, subimg_ch, cx, cy, panel_chap_w, ch_h);
        draw_set_alpha(1);
        
        // Texte Titre
        draw_set_halign(fa_left);
        var ch_text_col = ch_unlocked ? text_col : c_gray;
        draw_shadow_text_col(cx + 20, cy + ch_h/2, "Chapitre " + string(i + 1) + " : " + ch_data.title, ch_text_col, ui_font_15);
        
        // Cadenas si verrouillé
        if (!ch_unlocked) {
            draw_set_halign(fa_right);
            draw_shadow_text_col(cx + panel_chap_w - 20, cy + ch_h/2, "Verrouillé", c_gray, ui_font_15);
        }
        
        // Si sélectionné, on dessine les détails (Actes + Bouton)
        if (selected_chapter_id == ch_id) {
            var ay = cy + ch_h + acts_top_gap;
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
                    var act_col = act_unlocked ? text_col : c_dkgray;
                    
                    if (is_selected_act) act_col = c_lime;
                    else if (hover_act_index == act_num) act_col = c_yellow;
                    
                    if (!act_unlocked) act_txt = "???";
                    
                    var act_btn_x = cx + 20;
                    var act_btn_y = ay;
                    var act_btn_w = panel_chap_w - 40;
                    var subimg_act = 0;
                    if (sprite_get_number(sButton) > 1 && is_selected_act) subimg_act = 1;
                    draw_sprite_stretched(sButton, subimg_act, act_btn_x, act_btn_y, act_btn_w, act_btn_h);
                    
                    draw_set_halign(fa_left);
                    draw_shadow_text_col(cx + 40, ay + act_btn_h / 2, "Acte " + string(act_num) + " : " + act_txt, act_col, ui_font_14);
                    
                    ay += act_row_step;
                    acts_height += act_row_step;
                }
                
                // Bouton Commencer
                ay += start_btn_top_gap;
                acts_height += start_btn_top_gap;
                
                var subimg_start = 0;
                if (sprite_get_number(sButton) > 1 && hover_start_btn) subimg_start = 1;
                draw_sprite_stretched(sButton, subimg_start, btn_start_rect.x1, btn_start_rect.y1, btn_start_rect.x2 - btn_start_rect.x1, btn_start_rect.y2 - btn_start_rect.y1);
                
                draw_set_halign(fa_center);
                draw_shadow_text((btn_start_rect.x1 + btn_start_rect.x2)/2, (btn_start_rect.y1 + btn_start_rect.y2)/2, "COMMENCER", ui_font_16);
                
                acts_height += start_btn_h + start_btn_bottom_gap;
            } else {
                // Message verrouillé
                draw_set_halign(fa_center);
                draw_shadow_text_col(cx + panel_chap_w/2, ay + 20, "Terminez le chapitre précédent pour accéder.", c_gray, ui_font_15);
                acts_height += 50;
            }
            
            cy += acts_height;
        }
        
        cy += ch_h + chapter_gap;
    }
}
