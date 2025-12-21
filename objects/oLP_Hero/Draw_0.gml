draw_sprite_ext(sLP_Hero, 0, x, y, 1, 1, 0, c_white, 1);
draw_set_font(fontLP);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var text_x_hero = x + 40;
var text_y_hero = y;
var t_hero = clamp(nbLP / 100, 0, 1);
var col_hero = make_color_rgb(round(255 * (1 - t_hero)), round(255 * t_hero), 0);
draw_text_color(text_x_hero, text_y_hero, nbLP, col_hero, col_hero, col_hero, col_hero, 1);
