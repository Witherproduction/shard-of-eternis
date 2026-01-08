// oTutorielManager - Step Event

if (mouse_check_button_pressed(mb_left)) {
    if (button_hover) {
        current_step++;
        if (current_step >= array_length(steps)) {
            instance_destroy();
        }
    }
}
