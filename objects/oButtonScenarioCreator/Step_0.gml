// === oButtonScenarioCreator - Step Event ===
event_inherited();
if (instance_exists(oPanelOptions)) { exit; }
if (room != rAcceuil) exit;

// Admin mode check
if (!variable_global_exists("admin_mode") || !global.admin_mode) exit;

if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    var left = x - button_width / 2;
    var top = y - button_height / 2;
    var right = x + button_width / 2;
    var bottom = y + button_height / 2;
    if (mx >= left && mx <= right && my >= top && my <= bottom) {
        room_goto(rScenarioEditor);
    }
}
