// === oButtonScenarioCreator - Draw Event ===
// Admin mode check
if (!variable_global_exists("admin_mode") || !global.admin_mode) exit;

var draw_x = x - button_width / 2;
var draw_y = y - button_height / 2;

var subimg = 0;
if (sprite_get_number(sButton) > 1 && point_in_rectangle(mouse_x, mouse_y, draw_x, draw_y, draw_x + button_width, draw_y + button_height)) subimg = 1;
draw_sprite_stretched(sButton, subimg, draw_x, draw_y, button_width, button_height);

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
var sc = 1;
if (f != -1) {
    var base_sz = font_get_size(f);
    if (base_sz > 0) sc = 16 / base_sz;
}
draw_text_transformed(x + 2, y + 2, "Créateur de scénario", sc, sc, 0);

draw_set_color(make_color_rgb(230, 200, 120));
draw_text_transformed(x, y, "Créateur de scénario", sc, sc, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
