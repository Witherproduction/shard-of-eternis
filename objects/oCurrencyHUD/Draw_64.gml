var scale = 0.7;
var gold_label = "Or: " + string(max(0, variable_global_exists("gold_coins") ? global.gold_coins : 0));
var stone_label = "Pierres: " + string(max(0, variable_global_exists("arcane_stones") ? global.arcane_stones : 0));
var x0 = display_get_gui_width() - 40;
var y0 = 40;
if (room == rAcceuil || room == rCollection) {
    if (instance_exists(oOptionButton)) {
        var opt = instance_find(oOptionButton, 0);
        x0 = 40;
        y0 = opt.y;
    } else {
        x0 = 40;
        y0 = 992;
    }
} else if (room == rBoutique) {
    x0 = 40;
    y0 = 992;
}
draw_set_font(fontStep);
var tw1 = string_width(gold_label) * scale;
var th1 = string_height(gold_label) * scale;
var pad = 12;
var x1 = x0 - pad;
var y1 = y0 - th1 * 0.5 - pad;
var x2 = x0 + tw1 + pad;
var y2 = y0 + th1 * 0.5 + pad;
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(x1, y1, x2, y2, false);
draw_set_color(make_color_rgb(230, 200, 120));
draw_rectangle(x1, y1, x2, y2, true);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text_transformed(x0, y0, gold_label, scale, scale, 0);
var gap = 18;
var x0b = x2 + gap;
var tw2 = string_width(stone_label) * scale;
var th2 = string_height(stone_label) * scale;
var xb1 = x0b - pad;
var yb1 = y0 - th2 * 0.5 - pad;
var xb2 = x0b + tw2 + pad;
var yb2 = y0 + th2 * 0.5 + pad;
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(xb1, yb1, xb2, yb2, false);
draw_set_color(make_color_rgb(230, 200, 120));
draw_rectangle(xb1, yb1, xb2, yb2, true);
draw_text_transformed(x0b, y0, stone_label, scale, scale, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
