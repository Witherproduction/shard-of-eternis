event_inherited();
if (instance_exists(oPanelOptions) || instance_exists(oQuestPanel)) { exit; }
if (room != rAcceuil) { exit; }
if (mouse_check_button_pressed(mb_left)) {
    var mouse_x_pos = mouse_x;
    var mouse_y_pos = mouse_y;
    var spr = asset_get_index("sBoutique");
    var sc = 0.2;
    var inside = false;
    if (spr != -1) {
        var w = sprite_get_width(spr) * sc;
        var h = sprite_get_height(spr) * sc;
        inside = point_in_rectangle(mouse_x_pos, mouse_y_pos, x - w * 0.5, y - h * 0.5, x + w * 0.5, y + h * 0.5);
    } else {
        var button_left = x - button_width / 2;
        var button_top = y - button_height / 2;
        var button_right = x + button_width / 2;
        var button_bottom = y + button_height / 2;
        inside = (mouse_x_pos >= button_left && mouse_x_pos <= button_right && mouse_y_pos >= button_top && mouse_y_pos <= button_bottom);
    }
    if (inside) {
        var _r = asset_get_index("rBoutique");
        if (_r != -1) {
            room_goto(_r);
        } else {
            show_debug_message("### rBoutique introuvable");
        }
    }
}
