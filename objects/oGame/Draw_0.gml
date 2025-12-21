var spr = asset_get_index("sDeckBuilder");
if (spr != -1) {
    var sw = sprite_get_width(spr);
    var sh = sprite_get_height(spr);
    var banner_h = 240 + 50;
    var scale_y = banner_h / max(1, sh);
    var scale_x = 0.5;
    var banner_x_center = 1650 + 80;
    var banner_y_center = 510;
    var panel_x = banner_x_center - (sw * scale_x * 0.5);
    var panel_y = banner_y_center - (banner_h * 0.5);
    draw_set_alpha(0.9);
    draw_sprite_ext(spr, 0, panel_x, panel_y, scale_x, scale_y, 0, c_white, 1);
    draw_set_alpha(1);
}
draw_set_font(fontStep);
var base_x = 1650 + 80;
draw_text_color(base_x, 414, player[player_current], c_black, c_black, c_black, c_black, 1);
draw_set_color(c_white);
draw_text(base_x, 410, player[player_current]);
draw_text_color(base_x, 514, phase[phase_current], c_black, c_black, c_black, c_black, 1);
draw_set_color(c_white);
draw_text(base_x, 510, phase[phase_current]);
draw_text_color(base_x, 614, "Tour " + string(nbTurn), c_black, c_black, c_black, c_black, 1);
draw_set_color(c_white);
draw_text(base_x, 610, "Tour " + string(nbTurn));
