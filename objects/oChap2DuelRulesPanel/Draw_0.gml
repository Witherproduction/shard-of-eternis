draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

if (sprite_exists(sCimetiere)) {
    draw_sprite_stretched(sCimetiere, 0, x, y, width, height);
} else {
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_roundrect(x, y, x + width, y + height, false);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(x, y, x + width, y + height, true);
}

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

var title_y = y + 36;
var f_title = -1;
if (variable_global_exists("get_runtime_font")) {
    f_title = global.get_runtime_font("title", 28);
} else if (font_exists(fontTitle)) {
    f_title = fontTitle;
}
if (f_title != -1) draw_set_font(f_title);
draw_text(x + width * 0.5, title_y, title_text);

var f_body = -1;
if (variable_global_exists("get_runtime_font")) {
    f_body = global.get_runtime_font("text", 18);
} else if (font_exists(fontText)) {
    f_body = fontText;
} else if (font_exists(fontUI)) {
    f_body = fontUI;
}
if (f_body != -1) draw_set_font(f_body);

var line_y = y + 88;
var line_sep = 36;
var pad_x = 40;
var text_w = width - pad_x * 2;
draw_set_halign(fa_left);

for (var i = 0; i < array_length(rule_lines); i++) {
    draw_text_ext(x + pad_x, line_y + i * line_sep, rule_lines[i], line_sep - 4, text_w);
}

var mx = mouse_x;
var my = mouse_y;
var hover = (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(hover ? make_color_rgb(60, 45, 25) : make_color_rgb(40, 40, 40));
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
draw_set_color(make_color_rgb(220, 200, 120));
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);
draw_set_color(c_white);
draw_text(btn_x + btn_width * 0.5, btn_y + btn_height * 0.5, "J'ai compris");
