
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Position relative to top-right (near currency HUD)
var bx = gw - 200;
var by = 60;

// Mouse Check
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var dist = point_distance(mx, my, bx, by);
var hover = (dist <= radius);

// Draw Button
draw_set_color(hover ? color_hover : color_normal);
draw_circle(bx, by, radius, false);
draw_set_color(c_white);
draw_circle(bx, by, radius, true); // Outline

// Draw Icon
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text(bx, by, "Q"); // Or "!"

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
