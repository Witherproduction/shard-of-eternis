var spr = sprite_panel;
var sw = (spr != -1) ? sprite_get_width(spr) : (560 * k);
var sh = (spr != -1) ? sprite_get_height(spr) : (sw * 1.5);
var cx = room_width * 0.5;
var off = (sw * scale_center) * 0.5 + gap + (sw * scale_side) * 0.5;
var lx = cx - off;
var rx = cx + off;
var chap_center = index + 1;
var chap_left = ((index - 1 + count) mod count) + 1;
var chap_right = ((index + 1) mod count) + 1;
var bg_center = asset_get_index("BG_Chapitre" + string(chap_center));
if (bg_center == -1) bg_center = asset_get_index("sHistoireBG_" + string(chap_center));
var bg_left = asset_get_index("BG_Chapitre" + string(chap_left));
if (bg_left == -1) bg_left = asset_get_index("sHistoireBG_" + string(chap_left));
var bg_right = asset_get_index("BG_Chapitre" + string(chap_right));
if (bg_right == -1) bg_right = asset_get_index("sHistoireBG_" + string(chap_right));

// --- Rendu des panneaux latéraux (arrière-plan) ---
if (bg_left != -1) draw_sprite_ext(bg_left, 0, lx, panel_y, scale_side, scale_side, 0, c_white, alpha_side);
if (bg_right != -1) draw_sprite_ext(bg_right, 0, rx, panel_y, scale_side, scale_side, 0, c_white, alpha_side);
if (bg_center != -1) draw_sprite_ext(bg_center, 0, cx, panel_y, scale_center, scale_center, 0, c_white, 1);

// --- Rendu des cadres ---
if (spr != -1) {
    draw_sprite_ext(spr, 0, lx, panel_y, scale_side, scale_side, 0, c_white, alpha_side);
    draw_sprite_ext(spr, 0, rx, panel_y, scale_side, scale_side, 0, c_white, alpha_side);
    draw_sprite_ext(spr, 0, cx, panel_y, scale_center, scale_center, 0, c_white, 1);
} else {
    var side_w = sw * scale_side;
    var side_h = side_w * 1.5;
    var cen_w = sw * scale_center;
    var cen_h = cen_w * 1.5;
    draw_set_alpha(alpha_side);
    draw_set_color(make_color_rgb(220,220,220));
    draw_rectangle(lx - side_w*0.5, panel_y - side_h*0.5, lx + side_w*0.5, panel_y + side_h*0.5, false);
    draw_rectangle(rx - side_w*0.5, panel_y - side_h*0.5, rx + side_w*0.5, panel_y + side_h*0.5, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(cx - cen_w*0.5, panel_y - cen_h*0.5, cx + cen_w*0.5, panel_y + cen_h*0.5, false);
}

// --- Flèches de navigation ---
var arr_w = 40 * k;
var arr_h = 64 * k;
var axl = lx - (sw * scale_side) * 0.5 - arr_w * 1.5;
var axr = rx + (sw * scale_side) * 0.5 + arr_w * 1.5;
var ay = panel_y;
draw_set_alpha(0.9);
draw_set_color(c_white);
draw_triangle(axl, ay, axl + arr_w, ay - arr_h * 0.5, axl + arr_w, ay + arr_h * 0.5, false);
draw_triangle(axr, ay, axr - arr_w, ay - arr_h * 0.5, axr - arr_w, ay + arr_h * 0.5, false);
draw_set_alpha(1);
draw_set_color(c_white);

// --- Contenu du panneau central ---
var cen_w2 = sw * scale_center;
var cen_h2 = sh * scale_center;
var ixl = cx - cen_w2 * 0.5 + inner_margin_left * cen_w2;
var ixr = cx + cen_w2 * 0.5 - inner_margin_right * cen_w2;
var iyt = panel_y - cen_h2 * 0.5 + inner_margin_top * cen_h2;
var iyb = panel_y + cen_h2 * 0.5 - inner_margin_bottom * cen_h2;
var top_y = iyt;
var center_x = (ixl + ixr) * 0.5;
var inner_w = ixr - ixl; // Defined here, should be safe

// Vérification du verrouillage via le ProgressionManager
var unlocked = is_chapter_unlocked(chap_center);

// Récupération des données du chapitre
var current_data = (index < array_length(chapters_data)) ? chapters_data[index] : { title: "Chapitre Inconnu", acts: ["???", "???", "???", "???"] };

draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fontLP);
draw_text(center_x, top_y - title_offset, "Chapitre " + string(chap_center));
draw_set_font(fontCardDisplay);

if (unlocked) {
    draw_text(center_x, top_y + 48 * k, current_data.title);
    
    // Récupérer le nom du héros (legacy pour l'instant)
    var legacy_prog = story_progress_read_chapter(chap_center);
    var act1_done = is_act_complete(chap_center, 1);
    var act2_done = is_act_complete(chap_center, 2);
    var act3_done = is_act_complete(chap_center, 3);
    
    var hero_display = act1_done ? (legacy_prog.hero_name != "" ? legacy_prog.hero_name : "Kaelen") : "??????";
    
    draw_text(center_x, top_y + 92 * k, "Heros : " + string(hero_display));
    draw_text(center_x, top_y + 136 * k, "Acte :");
    
    var y0 = top_y + 180 * k;
    
    // Affichage des actes selon la progression
    var act_names = current_data.acts;
    var n_acts = array_length(act_names);
    
    // Acte 1 (Toujours visible si chapitre débloqué)
    var act_click_w = inner_w * 0.9;
    var act_click_h = line_gap;
    
    for (var i = 0; i < 4; i++) {
        var act_num = i + 1;
        var ay = y0 + i * line_gap;
        
        var is_unlocked = false;
        var txt = "???";
        
        if (act_num == 1) {
            is_unlocked = true;
            txt = (n_acts > 0) ? act_names[0] : "???";
        } else if (act_num == 2) {
            is_unlocked = act1_done;
            txt = act1_done ? ((n_acts > 1) ? act_names[1] : "???") : "????????";
        } else if (act_num == 3) {
            is_unlocked = act2_done;
            txt = act2_done ? ((n_acts > 2) ? act_names[2] : "???") : "?????????";
        } else if (act_num == 4) {
            is_unlocked = act3_done;
            txt = act3_done ? ((n_acts > 3) ? act_names[3] : "???") : "??????????";
        }
        
        var col = c_white;
        var is_selected = (variable_global_exists("current_act") && global.current_act == act_num);
        
        if (is_unlocked) {
            if (is_selected) {
                col = c_lime; // Highlight selected act
            } else if (point_in_rectangle(mouse_x, mouse_y, center_x - act_click_w * 0.5, ay - act_click_h * 0.5, center_x + act_click_w * 0.5, ay + act_click_h * 0.5)) {
                col = c_yellow; // Hover
            }
        } else {
            col = c_dkgray;
        }
        
        draw_set_color(col);
        draw_text(center_x, ay, txt);
    }
    
    draw_set_color(c_white);
    
    // --- Bouton Commencer ---
    var btn_w = inner_w * btn_start_width_ratio;
    var btn_h = btn_start_height;
    var btn_x1 = center_x - btn_w * 0.5;
    var btn_x2 = center_x + btn_w * 0.5;
    var btn_y2 = iyb - btn_start_margin_bottom;
    var btn_y1 = btn_y2 - btn_h;
    btn_rect_x1 = btn_x1;
    btn_rect_y1 = btn_y1;
    btn_rect_x2 = btn_x2;
    btn_rect_y2 = btn_y2;

    var over = point_in_rectangle(mouse_x, mouse_y, btn_x1, btn_y1, btn_x2, btn_y2);
    btn_start_hover = over;
    draw_set_alpha(0.95);
    draw_set_color(over ? make_color_rgb(50, 30, 30) : make_color_rgb(40, 40, 40));
    draw_roundrect(btn_x1, btn_y1, btn_x2, btn_y2, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(btn_x1, btn_y1, btn_x2, btn_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(center_x, (btn_y1 + btn_y2) * 0.5, "Commencer", 1, 1, 0);

} else {
    // --- Chapitre Verrouillé ---
    draw_set_color(c_gray);
    draw_text(center_x, top_y + 48 * k, "Verrouillé");
    draw_set_color(c_white);
    
    draw_text(center_x, top_y + 120 * k, "Terminez le chapitre précédent");
    draw_text(center_x, top_y + 150 * k, "pour accéder à ce contenu.");
    
    // Reset bouton rect pour ne pas cliquer
    btn_rect_x1 = -100; btn_rect_y1 = -100; btn_rect_x2 = -100; btn_rect_y2 = -100;
}
