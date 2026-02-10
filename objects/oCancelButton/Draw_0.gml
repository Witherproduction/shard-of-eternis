// === oCancelButton - Draw Event ===
if (!visible) exit;

// Hover effect
var isHover = position_meeting(mouse_x, mouse_y, id);
var col = isHover ? merge_color(c_red, c_white, 0.2) : c_red;

// Draw Button Sprite
if (sprite_index != -1) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, col, image_alpha);
} else {
    // Fallback if sprite is missing
    var w = 100;
    var h = 30;
    draw_set_color(col);
    draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, false);
    draw_set_color(c_white);
    draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, true);
}

// Draw Text
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, text);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
