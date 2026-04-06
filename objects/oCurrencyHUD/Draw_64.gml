var gold_label = string(max(0, variable_global_exists("gold_coins") ? global.gold_coins : 0));
var stone_label = string(max(0, variable_global_exists("arcane_stones") ? global.arcane_stones : 0));
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
var f = -1;
if (variable_global_exists("get_runtime_font")) f = global.get_runtime_font("title", 22);
if (f == -1) {
    if (font_exists(fontTitle)) f = fontTitle;
    else if (font_exists(fontText)) f = fontText;
    else if (font_exists(fontUI)) f = fontUI;
}
if (f != -1) draw_set_font(f);
var sc = 1;
if (f != -1) {
    var base_sz = font_get_size(f);
    if (base_sz > 0) sc = 22 / base_sz;
}
var tw1 = string_width(gold_label) * sc;
var th1 = string_height(gold_label) * sc;
var pad = 12;
var y1 = y0 - th1 * 0.5 - pad;
var y2 = y0 + th1 * 0.5 + pad;
var frame_h1 = y2 - y1;
var icon_w1 = frame_h1;
var inner_gap = 8;
var x1 = x0 - pad;
var x2 = x1 + pad + icon_w1 + inner_gap + tw1 + pad;
var spr_gold = asset_get_index("sMonnaie1");
if (spr_gold != -1) {
    draw_sprite_stretched(spr_gold, 0, x1, y1, x2 - x1, y2 - y1);
} else {
    draw_set_color(make_color_rgb(20, 20, 20));
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_rectangle(x1, y1, x2, y2, true);
}
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(x2 - pad + 2, y0 + 2, gold_label, sc, sc, 0);
draw_set_color(make_color_rgb(230, 200, 120));
draw_text_transformed(x2 - pad, y0, gold_label, sc, sc, 0);
var gap = 18;
var x0b = x2 + gap;
var tw2 = string_width(stone_label) * sc;
var th2 = string_height(stone_label) * sc;
var yb1 = y0 - th2 * 0.5 - pad;
var yb2 = y0 + th2 * 0.5 + pad;
var frame_h2 = yb2 - yb1;
var icon_w2 = frame_h2;
var xb1 = x0b - pad;
var xb2 = xb1 + pad + icon_w2 + inner_gap + tw2 + pad;
var spr_stone = asset_get_index("sMonnaie2");
if (spr_stone != -1) {
    draw_sprite_stretched(spr_stone, 0, xb1, yb1, xb2 - xb1, yb2 - yb1);
} else {
    draw_set_color(make_color_rgb(20, 20, 20));
    draw_rectangle(xb1, yb1, xb2, yb2, false);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_rectangle(xb1, yb1, xb2, yb2, true);
}
draw_set_color(c_black);
draw_text_transformed(xb2 - pad + 2, y0 + 2, stone_label, sc, sc, 0);
draw_set_color(make_color_rgb(230, 200, 120));
draw_text_transformed(xb2 - pad, y0, stone_label, sc, sc, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
