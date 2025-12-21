// Draw window background
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Draw Panel
draw_set_color(make_color_rgb(40, 40, 40));
draw_roundrect(x, y, x + width, y + height, false);
draw_set_color(make_color_rgb(220, 200, 120)); // Gold border
draw_roundrect(x, y, x + width, y + height, true);

// Draw Text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x + width/2, y + 60, text);

// Draw Button
var mx = mouse_x;
var my = mouse_y;

var hover = (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height);

draw_set_color(hover ? make_color_rgb(60, 45, 25) : make_color_rgb(40, 40, 40));
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
draw_set_color(make_color_rgb(220, 200, 120)); // Gold border
draw_roundrect(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);

draw_set_color(c_white);
draw_text(btn_x + btn_width/2, btn_y + btn_height/2, "CONFIRMER");
