
var gw = display_get_gui_width();
var gh = display_get_gui_height();

var spr = asset_get_index("sQuete");
var sc = 0.2;

// Position relative to top-right (near currency HUD)
var bx = gw - 200;
var by = 60;
var qw = (spr != -1) ? (sprite_get_width(spr) * sc) : (radius * 2);
var qh = (spr != -1) ? (sprite_get_height(spr) * sc) : (radius * 2);
bx = gw * 0.5 - 302;
by = 900;
bx = clamp(bx, qw * 0.5 + 10, gw - qw * 0.5 - 10);
by = clamp(by, qh * 0.5 + 10, gh - qh * 0.5 - 10);

// Mouse Check
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var hover = false;
if (spr != -1) {
    var w = sprite_get_width(spr) * sc;
    var h = sprite_get_height(spr) * sc;
    hover = point_in_rectangle(mx, my, bx - w * 0.5, by - h * 0.5, bx + w * 0.5, by + h * 0.5);
} else {
    var dist = point_distance(mx, my, bx, by);
    hover = (dist <= radius);
}

// Draw Button
if (spr != -1) {
    draw_sprite_ext(spr, 0, bx, by, sc, sc, 0, c_white, 1);
} else {
    draw_set_color(hover ? color_hover : color_normal);
    draw_circle(bx, by, radius, false);
    draw_set_color(c_white);
    draw_circle(bx, by, radius, true); // Outline
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(bx, by, "Q"); // Or "!"
}

// Logic (Click)
if (hover && mouse_check_button_pressed(mb_left)) {
    if (!instance_exists(oQuestPanel)) {
        instance_create_depth(0, 0, -10000, oQuestPanel); // Depth high to be on top
    } else {
        instance_destroy(oQuestPanel);
    }
}

// Notification badge (if any quest completed and not claimed)
var notify = false;
if (instance_exists(oQuestManager)) {
    var qm = oQuestManager;
    var check = function(q) { return (q != noone && !q.claimed && q.is_completed()); };
    if (check(qm.quest_slots.A) || check(qm.quest_slots.B) || check(qm.quest_slots.C)) {
        notify = true;
    }
}

if (notify) {
    draw_set_color(c_red);
    draw_circle(bx + radius * 0.7, by - radius * 0.7, 10, false);
    draw_set_color(c_white);
    draw_text(bx + radius * 0.7, by - radius * 0.7, "!");
}
