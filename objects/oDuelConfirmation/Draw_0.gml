// Draw window background
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Draw Panel
if (sprite_exists(sCimetiere)) {
    draw_sprite_stretched(sCimetiere, 0, x, y, width, height);
} else {
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_roundrect(x, y, x + width, y + height, false);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(x, y, x + width, y + height, true);
}

var draw_fit_center = function(cx, cy, tx, kind, px, min_px, max_w, max_h, col) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(col);
    if (variable_global_exists("get_runtime_font")) {
        var sz = max(min_px, floor(px));
        var f = global.get_runtime_font(kind, sz);
        while (sz > min_px && f != -1) {
            draw_set_font(f);
            if (string_width(tx) <= max_w && string_height("Ag") <= max_h) break;
            sz -= 1;
            f = global.get_runtime_font(kind, sz);
        }
        if (f != -1) {
            draw_set_font(f);
            draw_text(cx, cy, tx);
        } else {
            draw_text(cx, cy, tx);
        }
    } else {
        var f2 = -1;
        if (kind == "title") {
            if (font_exists(fontTitle)) f2 = fontTitle;
            else if (font_exists(fontText)) f2 = fontText;
            else if (font_exists(fontUI)) f2 = fontUI;
        } else {
            if (font_exists(fontText)) f2 = fontText;
            else if (font_exists(fontTitle)) f2 = fontTitle;
            else if (font_exists(fontUI)) f2 = fontUI;
        }
        if (f2 != -1) draw_set_font(f2);
        var sw = string_width(tx);
        var sh = string_height("Ag");
        var sc = 1;
        if (sw > 0) sc = min(sc, max_w / sw);
        if (sh > 0) sc = min(sc, max_h / sh);
        sc = min(1, sc);
        draw_text_transformed(cx, cy, tx, sc, sc, 0);
    }
};

// Draw Text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_fit_center(x + width * 0.5, y + 60, text, "title", 30, 14, width - 80, 40, c_white);

// --- VS Display ---
var hero_name = "Deck Héros";

// Determine hero name based on selection mode
if (variable_instance_exists(id, "use_custom_deck") && use_custom_deck) {
    if (variable_global_exists("saved_decks") && array_length(global.saved_decks) > 0) {
        // Ensure index is valid
        if (selected_custom_deck_index >= array_length(global.saved_decks)) selected_custom_deck_index = 0;
        
        var deck = global.saved_decks[selected_custom_deck_index];
        if (variable_struct_exists(deck, "name")) hero_name = deck.name;
    } else {
        hero_name = "Aucun deck";
    }
} else {
    // Default Scenario Deck
    if (variable_global_exists("selected_player_deck") && is_struct(global.selected_player_deck)) {
        if (variable_struct_exists(global.selected_player_deck, "name")) {
            hero_name = global.selected_player_deck.name;
        }
    }
}

var bot_name = "Adversaire";
if (variable_global_exists("selected_bot_deck_id")) {
    bot_name = get_bot_deck_name(global.selected_bot_deck_id);
}

draw_set_color(c_yellow);
draw_fit_center(x + width * 0.5, y + 90, hero_name + " VS " + bot_name, "title", 24, 12, width - 80, 34, c_yellow);
draw_set_color(c_white);
// ------------------

// --- Custom Deck UI ---
if (variable_instance_exists(id, "checkbox_x")) {
    // Checkbox
    var cb_hover = (mouse_x >= checkbox_x && mouse_x <= checkbox_x + checkbox_size + 200 && mouse_y >= checkbox_y && mouse_y <= checkbox_y + checkbox_size);
    
    draw_set_color(cb_hover ? c_ltgray : c_white);
    draw_rectangle(checkbox_x, checkbox_y, checkbox_x + checkbox_size, checkbox_y + checkbox_size, true);
    
    if (use_custom_deck) {
        // Draw Checkmark (X)
        draw_line(checkbox_x + 4, checkbox_y + 4, checkbox_x + checkbox_size - 4, checkbox_y + checkbox_size - 4);
        draw_line(checkbox_x + checkbox_size - 4, checkbox_y + 4, checkbox_x + 4, checkbox_y + checkbox_size - 4);
    }
    
    var label_x = checkbox_x + checkbox_size + 10;
    var label_y = checkbox_y + checkbox_size * 0.5;
    var label_w = (x + width - 30) - label_x;
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    if (variable_global_exists("get_runtime_font")) {
        var sz_lbl = 18;
        var f_lbl = global.get_runtime_font("text", sz_lbl);
        while (sz_lbl > 10 && f_lbl != -1) {
            draw_set_font(f_lbl);
            if (string_width("Utiliser un deck perso") <= label_w && string_height("Ag") <= 26) break;
            sz_lbl -= 1;
            f_lbl = global.get_runtime_font("text", sz_lbl);
        }
        if (f_lbl != -1) draw_set_font(f_lbl);
        draw_text(label_x, label_y, "Utiliser un deck perso");
    } else {
        var f_lbl2 = -1;
        if (font_exists(fontText)) f_lbl2 = fontText;
        else if (font_exists(fontTitle)) f_lbl2 = fontTitle;
        else if (font_exists(fontUI)) f_lbl2 = fontUI;
        if (f_lbl2 != -1) draw_set_font(f_lbl2);
        var sw2 = string_width("Utiliser un deck perso");
        var sh2 = string_height("Ag");
        var sc2 = 1;
        if (sw2 > 0) sc2 = min(sc2, label_w / sw2);
        if (sh2 > 0) sc2 = min(sc2, 26 / sh2);
        sc2 = min(1, sc2);
        draw_text_transformed(label_x, label_y, "Utiliser un deck perso", sc2, sc2, 0);
    }
    draw_set_halign(fa_center);
    
    // Selector
    if (use_custom_deck) {
        var deck_display = "Aucun deck";
        if (variable_global_exists("saved_decks") && array_length(global.saved_decks) > 0) {
             var deck = global.saved_decks[selected_custom_deck_index];
             if (variable_struct_exists(deck, "name")) deck_display = deck.name;
        }
        
        // Draw Arrows
        var sel_y_center = selector_y + selector_h/2;
        draw_text(selector_x - 100, sel_y_center, "<");
        draw_text(selector_x + 100, sel_y_center, ">");
        
        draw_set_color(c_aqua);
        draw_fit_center(selector_x, sel_y_center, deck_display, "text", 18, 10, selector_w - 80, selector_h, c_aqua);
        draw_set_color(c_white);
    }
}
// ----------------------

// Draw Button
var mx = mouse_x;
var my = mouse_y;

var hover = (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height);

draw_set_color(hover ? make_color_rgb(60, 45, 25) : make_color_rgb(40, 40, 40));
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
draw_set_color(make_color_rgb(220, 200, 120)); // Gold border
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);

draw_set_color(c_white);
draw_text(btn_x + btn_width/2, btn_y + btn_height/2, "CONFIRMER");
