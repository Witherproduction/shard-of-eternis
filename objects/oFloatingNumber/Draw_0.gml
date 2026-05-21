var txt = is_heal ? ("+" + string(value)) : ("-" + string(value));
var col = is_heal ? make_color_rgb(80, 220, 120) : make_color_rgb(255, 90, 70);
var sc = 1.1 + (1 - image_alpha) * 0.3;

if (font_exists(fontUI)) draw_set_font(fontUI);
else if (font_exists(fontText)) draw_set_font(fontText);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(x + 2, y + 2, txt, sc, sc, 0);
draw_set_color(col);
draw_text_transformed(x, y, txt, sc, sc, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
