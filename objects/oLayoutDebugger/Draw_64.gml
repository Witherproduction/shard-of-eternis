// === oLayoutDebugger - Draw GUI Event ===

if (!active) exit;

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var xx = 10;
var yy = 10;
var line_h = 20;

// Fond semi-transparent
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, 300, 300, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_text(xx, yy, "LAYOUT DEBUGGER (F3: ON/OFF)"); yy += line_h;
draw_text(xx, yy, "TAB: Changer Champ | ESPACE: Changer coord"); yy += line_h;
draw_text(xx, yy, "Fleches: Bouger | SHIFT: Rapide"); yy += line_h * 2;

for (var i = 0; i < array_length(fields); i++) {
    var f = fields[i];
    var s = variable_struct_get(global.card_layout, f);
    
    var prefix = (i == current_field_index) ? ">> " : "   ";
    var color = (i == current_field_index) ? c_yellow : c_white;
    
    draw_set_color(color);
    var str = prefix + string_upper(f) + ": [" + string(s.x1) + "," + string(s.y1) + "] -> [" + string(s.x2) + "," + string(s.y2) + "]";
    draw_text(xx, yy, str);
    
    // Indiquer quel coordonnée est éditée
    if (i == current_field_index) {
        var cursor_x = xx + 150;
        if (edit_mode == 0) cursor_x = xx + 100; // x1
        if (edit_mode == 1) cursor_x = xx + 130; // y1
        if (edit_mode == 2) cursor_x = xx + 180; // x2
        if (edit_mode == 3) cursor_x = xx + 210; // y2
        
        draw_text(xx, yy + 15, "Mode: " + edit_labels[edit_mode]);
    }
    
    yy += line_h * 1.5;
}
