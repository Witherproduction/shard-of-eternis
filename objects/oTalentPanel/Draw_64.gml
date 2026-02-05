// oTalentPanel - Draw GUI Event

draw_set_font(fontCardDisplay);
draw_set_valign(fa_top);

// Fond semi-transparent global
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// Panel Principal
draw_set_color(make_color_rgb(40, 40, 50));
draw_roundrect(x, y, x + width, y + height, false);
draw_set_color(c_ltgray);
draw_roundrect(x, y, x + width, y + height, true);

// --- Header: Pouvoir Héroïque ---
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(x + width/2, y + 20, "TALENTS DE " + string_upper(hero_name));

// Info Pouvoir
var hp_x = x + 100;
var hp_y = y + 60;
var hp_w = width - 200;
var hp_h = 80;

draw_set_color(make_color_rgb(60, 60, 70));
draw_roundrect(hp_x, hp_y, hp_x + hp_w, hp_y + hp_h, false);

// Texte Centré (Sans Icone)
draw_set_halign(fa_center);
draw_set_color(c_yellow);
draw_text(hp_x + hp_w/2, hp_y + 15, hero_power.name + " (" + string(hero_power.mana_cost) + " Mana)");
draw_set_color(c_white);
draw_text(hp_x + hp_w/2, hp_y + 45, hero_power.description);


// --- Arbre des Talents ---
var start_y = y + header_h + 20;

for (var i = 0; i < array_length(talent_tree); i++) {
    var tier = talent_tree[i];
    var tier_y = start_y + i * row_h;
    
    // Label Tier
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text(x + width/2, tier_y - 10, "Palier " + string(i + 1));
    
    // Check Unlock
    var unlocked = true;
    if (variable_struct_exists(tier, "req_chapter")) {
        unlocked = is_act_complete(tier.req_chapter, 4); // Hack: Check fin acte 4
    }
    
    if (!unlocked) {
        draw_set_color(c_red);
        draw_text(x + width/2, tier_y + 60, "Verrouillé (Terminer Chapitre " + string(tier.req_chapter) + ")");
        continue;
    }
    
    // Choix
    var choices = tier.choices;
    // var choice_w = 300; // Utilise variable instance
    // var choice_h = 140; // Utilise variable instance
    
    var ax = x + width/2 - choice_w - 20;
    var bx = x + width/2 + 20;
    var cy = tier_y + 20;
    
    // Draw Choice A
    draw_talent_choice(ax, cy, choice_w, choice_h, choices[0], selected_talents[i] == 0, hover_choice.tier == i && hover_choice.choice == 0);
    
    // Draw Choice B
    draw_talent_choice(bx, cy, choice_w, choice_h, choices[1], selected_talents[i] == 1, hover_choice.tier == i && hover_choice.choice == 1);
    
    // "OU" au milieu
    draw_set_color(c_white);
    draw_text(x + width/2, cy + choice_h/2, "OU");
}

// --- Bouton Fermer ---
draw_set_color(hover_close ? c_red : c_maroon);
draw_rectangle(close_btn_rect.x1, close_btn_rect.y1, close_btn_rect.x2, close_btn_rect.y2, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text((close_btn_rect.x1 + close_btn_rect.x2)/2, (close_btn_rect.y1 + close_btn_rect.y2)/2, "X");


// --- Helper Function (Interne) ---
function draw_talent_choice(dx, dy, w, h, data, is_selected, is_hover) {
    var col_bg = is_selected ? make_color_rgb(40, 60, 40) : make_color_rgb(50, 50, 50);
    if (is_hover) col_bg = is_selected ? make_color_rgb(50, 80, 50) : make_color_rgb(70, 70, 70);
    
    draw_set_color(col_bg);
    draw_roundrect(dx, dy, dx + w, dy + h, false);
    
    var border_col = is_selected ? c_lime : c_dkgray;
    if (is_hover && !is_selected) border_col = c_white;
    
    draw_set_color(border_col);
    draw_roundrect(dx, dy, dx + w, dy + h, true);
    
    // Texte
    draw_set_halign(fa_center);
    draw_set_color(is_selected ? c_lime : c_white);
    draw_text(dx + w/2, dy + 20, data.name);
    
    draw_set_color(c_ltgray);
    draw_text_ext(dx + w/2, dy + 60, data.description, 20, w - 20);
}
