// === oButtonScenarioCreator - Draw Event ===
// Admin mode check
if (!variable_global_exists("admin_mode") || !global.admin_mode) exit;

var draw_x = x - button_width / 2;
var draw_y = y - button_height / 2;

draw_sprite_stretched(sButton, 0, draw_x, draw_y, button_width, button_height);

draw_set_color(make_color_rgb(80, 50, 20));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + 2, y + 2, "Créateur de scénario");

draw_set_color(make_color_rgb(230, 200, 120));
draw_text(x, y, "Créateur de scénario");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
