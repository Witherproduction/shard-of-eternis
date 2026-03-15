var gw = display_get_gui_width();
var gh = display_get_gui_height();

var fi = fade_in_ms;
var hold = hold_ms;
var fo = fade_out_ms;
var total = fi + hold + fo;
var elapsed = current_time - start_ms;

var a = 1;
if (elapsed < fi) a = (fi <= 0) ? 1 : (elapsed / fi);
else if (elapsed < fi + hold) a = 1;
else if (elapsed < total) a = (fo <= 0) ? 0 : (1 - ((elapsed - fi - hold) / fo));
else a = 0;
a = clamp(a, 0, 1);

if (a <= 0) exit;

draw_set_font(font);
var pad_x = padding_x;
var pad_y = padding_y;
var sep = line_sep;

var w = window_width;
var h = window_height;

var portrait_w = 0;
if (variable_instance_exists(id, "show_portrait") && show_portrait && variable_instance_exists(id, "portrait_sprite") && portrait_sprite != -1) {
    portrait_w = portrait_size + portrait_gap;
}

if (variable_instance_exists(id, "text") && text != "") {
    var desired_w = string_width(text) + pad_x + portrait_w;
    w = clamp(desired_w, min_width, max_width);
    var wrap_w = max(1, (w - pad_x - portrait_w));
    var text_h = string_height_ext(text, sep, wrap_w);
    h = max(min_height, text_h + pad_y);
}

if (portrait_w > 0) {
    h = max(h, portrait_size + pad_y);
}

var wy = margin_top;
var anchor_x = gw * 0.5;
var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

if (variable_instance_exists(id, "center_on_screen") && center_on_screen) {
    anchor_x = gw * 0.5;
    wy = (gh - h) * 0.5;
}
else if (anchor_to_enemy_field) {
    var fm = instance_find(oFieldMagicTrapEnemy, 0);
    var fmon = instance_find(oFieldMonsterEnemy, 0);
    
    if (fm != noone && fmon != noone) {
        anchor_x = ((fm.x + fmon.x) * 0.5) - cam_x;
        var center_y = ((fm.y + fmon.y) * 0.5) - cam_y;
        wy = center_y - (h * 0.5) + anchor_offset_y;
    }
    else if (fmon != noone) {
        anchor_x = fmon.x - cam_x;
        wy = (fmon.y - cam_y) - (h * 0.5) + anchor_offset_y;
    }
    else if (fm != noone) {
        anchor_x = fm.x - cam_x;
        wy = (fm.y - cam_y) - (h * 0.5) + anchor_offset_y;
    }
}
else if (anchor_to_enemy_lp && instance_exists(oLP_Enemy)) {
    var lp = instance_find(oLP_Enemy, 0);
    if (lp != noone) {
        anchor_x = (lp.x - 40) - cam_x;
        var sp = sLP_Enemy;
        var sp_h = sprite_get_height(sp);
        wy = ((lp.y + 5) - cam_y) + (sp_h * 0.5) + anchor_offset_y;
    }
}

var wx = anchor_x - (w * 0.5);
wx = clamp(wx, screen_margin, gw - w - screen_margin);
var tail_h = (variable_instance_exists(id, "show_tail") && show_tail) ? tail_height : 0;
wy = clamp(wy, screen_margin + tail_h, gh - h - screen_margin);

draw_set_alpha(a);
draw_set_color(window_color);
draw_roundrect(wx, wy, wx + w, wy + h, false);
draw_set_color(border_color);
draw_roundrect(wx, wy, wx + w, wy + h, true);

if (variable_instance_exists(id, "show_tail") && show_tail && tail_height > 0 && tail_width > 0) {
    var tx = wx + (w * 0.5);
    if (variable_instance_exists(id, "tail_to_enemy") && tail_to_enemy && instance_exists(oLP_Enemy)) {
        var lp = instance_find(oLP_Enemy, 0);
        if (lp != noone) {
            tx = (lp.x - 40) - cam_x;
        }
    }
    var half_tw = tail_width * 0.5;
    tx = clamp(tx, wx + corner_radius + half_tw + 4, wx + w - corner_radius - half_tw - 4);
    var y0 = wy;
    var x1 = tx - half_tw;
    var x2 = tx + half_tw;
    var y_tip = wy - tail_height;
    draw_set_color(window_color);
    draw_triangle(x1, y0, x2, y0, tx, y_tip, false);
    draw_set_color(border_color);
    draw_line(x1, y0, x2, y0);
    draw_line(x2, y0, tx, y_tip);
    draw_line(tx, y_tip, x1, y0);
}

if (portrait_w > 0) {
    var spr = portrait_sprite;
    var box = portrait_size;
    var px = wx + (pad_x * 0.5);
    var py = wy + (h - box) * 0.5;
    var spr_w = sprite_get_width(spr);
    var spr_h = sprite_get_height(spr);
    var sc = box / max(spr_w, spr_h);
    var ox = sprite_get_xoffset(spr);
    var oy = sprite_get_yoffset(spr);
    var draw_px = px + (box - spr_w * sc) * 0.5 + (ox * sc);
    var draw_py = py + (box - spr_h * sc) * 0.5 + (oy * sc);
    draw_set_color(c_white);
    draw_sprite_ext(spr, 0, draw_px, draw_py, sc, sc, 0, c_white, a);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(text_color);
var text_left = wx;
var text_w = w;
if (portrait_w > 0) {
    text_left = wx + portrait_w;
    text_w = w - portrait_w;
}
draw_text_ext(text_left + text_w * 0.5, wy + h * 0.5, text, sep, max(1, text_w - pad_x));

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
