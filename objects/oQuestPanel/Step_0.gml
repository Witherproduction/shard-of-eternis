if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Check Close
    if (variable_global_exists("quest_panel_close_rect")) {
        var r = global.quest_panel_close_rect;
        if (mx >= r.x1 && mx <= r.x2 && my >= r.y1 && my <= r.y2) {
            instance_destroy();
            exit;
        }
    }
    
    // Check Buttons
    if (variable_global_exists("quest_panel_buttons")) {
        var btns = global.quest_panel_buttons;
        for (var i = 0; i < array_length(btns); i++) {
            var b = btns[i];
            if (mx >= b.rect.x1 && mx <= b.rect.x2 && my >= b.rect.y1 && my <= b.rect.y2) {
                if (b.type == "claim") {
                    if (instance_exists(oQuestManager)) {
                        oQuestManager.claim_reward(b.slot);
                    }
                } else if (b.type == "reroll") {
                    if (instance_exists(oQuestManager)) {
                        oQuestManager.reroll_quest(b.slot);
                    }
                }
                break; // Stop checking buttons
            }
        }
    }
}
