var spr = asset_get_index("sBoutique");
var sc = 0.2;
if (spr != -1) {
    button_width = sprite_get_width(spr) * sc;
    button_height = sprite_get_height(spr) * sc;
} else {
    button_width = 400;
    button_height = 100;
}
collision_left = x - button_width / 2;
collision_top = y - button_height / 2;
collision_right = x + button_width / 2;
collision_bottom = y + button_height / 2;
