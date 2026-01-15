// === oChoixMultijoueur - Step Event ===

event_inherited();
if (instance_exists(oPanelOptions)) { exit; }

if (mouse_check_button_released(mb_left)) {
    var mouse_x_pos = mouse_x;
    var mouse_y_pos = mouse_y;
    
    var button_left = x - button_width / 2;
    var button_top = y - button_height / 2;
    var button_right = x + button_width / 2;
    var button_bottom = y + button_height / 2;
    
    if (mouse_x_pos >= button_left && mouse_x_pos <= button_right &&
        mouse_y_pos >= button_top && mouse_y_pos <= button_bottom) {
        
        show_debug_message("### oChoixMultijoueur.Step_0 - Clic détecté dans la zone du bouton!");
        show_debug_message("### Navigation vers rLobby depuis " + string(room_get_name(room)));
        room_goto(rLobby);
    }
}

