/// FX_Poison Draw: flaque verte qui s’élargit autour de la cible
var elapsed = current_time - start_time;
var t = clamp(elapsed / duration_ms, 0, 1);
var a = 1;
var spr = sprite_index;
if (spr != -1) {
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(a);
    var fc = sprite_get_number(spr);
    var fr = min(fc - 1, floor(t * fc));
    draw_sprite_ext(spr, fr, x, y, 1, 1, 0, c_white, 1);
    draw_set_alpha(prev_alpha);
} else {
    var r = lerp(radius_start, radius_max, t);
    var col = variable_instance_exists(self, "color") ? color : make_color_rgb(60, 200, 80);
    var rx = r;
    var ry = r * 0.6;
    var prev_col = draw_get_color();
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(a);
    draw_set_color(col);
    draw_ellipse(x - rx, y - ry, x + rx, y + ry, false);
    var edge_col = merge_color(col, c_black, 0.35);
    draw_set_alpha(a * 0.8);
    draw_set_color(edge_col);
    draw_ellipse(x - rx, y - ry, x + rx, y + ry, true);
    draw_set_alpha(prev_alpha);
    draw_set_color(prev_col);
}