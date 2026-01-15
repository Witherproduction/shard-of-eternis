draw_sprite_ext(sLP_Enemy, 0, x, y+5, 1, 1, 0, c_white, 1);
draw_set_font(fontLP);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var text_x_enemy = x - 40;
var text_y_enemy = y + 5;
var t_enemy = clamp(nbLP / 50, 0, 1);
var col_enemy = make_color_rgb(round(255 * (1 - t_enemy)), round(255 * t_enemy), 0);
draw_text_color(text_x_enemy, text_y_enemy, nbLP, col_enemy, col_enemy, col_enemy, col_enemy, 1);
