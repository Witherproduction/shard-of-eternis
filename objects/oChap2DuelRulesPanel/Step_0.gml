if (!mouse_check_button_pressed(mb_left)) exit;

var mx = mouse_x;
var my = mouse_y;
if (mx < btn_x || mx > btn_x + btn_width || my < btn_y || my > btn_y + btn_height) exit;

var game_inst = instance_find(oGame, 0);
if (game_inst != noone) {
    game_inst.ch2_duel_rules_blocking = false;
}

instance_destroy();
