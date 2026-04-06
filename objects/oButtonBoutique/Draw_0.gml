var spr = asset_get_index("sBoutique");
var sc = 0.2;
if (spr != -1) {
    var subimg = 0;
    if (sprite_get_number(spr) > 1) {
        var w = sprite_get_width(spr) * sc;
        var h = sprite_get_height(spr) * sc;
        if (point_in_rectangle(mouse_x, mouse_y, x - w * 0.5, y - h * 0.5, x + w * 0.5, y + h * 0.5)) subimg = 1;
    }
    draw_sprite_ext(spr, subimg, x, y, sc, sc, 0, c_white, 1);
} else {
    var draw_x = x - button_width / 2;
    var draw_y = y - button_height / 2;
    var subimg2 = 0;
    if (sprite_get_number(sButton) > 1 && point_in_rectangle(mouse_x, mouse_y, draw_x, draw_y, draw_x + button_width, draw_y + button_height)) subimg2 = 1;
    draw_sprite_stretched(sButton, subimg2, draw_x, draw_y, button_width, button_height);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var f = -1;
    if (variable_global_exists("get_runtime_font")) f = global.get_runtime_font("title", 16);
    if (f == -1) {
        if (font_exists(fontTitle)) f = fontTitle;
        else if (font_exists(fontText)) f = fontText;
        else if (font_exists(fontUI)) f = fontUI;
    }
    if (f != -1) draw_set_font(f);
    var sc2 = 1;
    if (f != -1) {
        var base_sz2 = font_get_size(f);
        if (base_sz2 > 0) sc2 = 16 / base_sz2;
    }
    draw_text_transformed(x + 2, y + 2, "Boutique", sc2, sc2, 0);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(x, y, "Boutique", sc2, sc2, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
