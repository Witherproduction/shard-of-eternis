// Timer for notifications
if (variable_instance_exists(id, "save_notification_timer") && save_notification_timer > 0) {
    save_notification_timer--;
}

var k = min(room_width / 1920, room_height / 1080);

if (variable_instance_exists(id, "show_act_settings_window") && show_act_settings_window) {
    // Reuse window dimensions logic
    var k = min(room_width / 1920, room_height / 1080);
    var win_w = 600 * k;
    var win_h = 400 * k;
    var win_x = (room_width - win_w) / 2;
    var win_y = (room_height - win_h) / 2;

    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        
        // Close Button (Top Right)
        var close_size = 40 * k;
        if (point_in_rectangle(mx, my, win_x + win_w - close_size, win_y, win_x + win_w, win_y + close_size)) {
            show_act_settings_window = false;
            field_focused = "";
        }
        
        // Confirm/Close Button (Bottom)
        var btn_w_local = 200 * k;
        var btn_h_local = 50 * k;
        var btn_y_local = win_y + win_h - 70 * k;
        var btn_save_x = win_x + win_w / 2 - btn_w_local / 2;
        if (point_in_rectangle(mx, my, btn_save_x, btn_y_local, btn_save_x + btn_w_local, btn_y_local + btn_h_local)) {
            show_act_settings_window = false;
            field_focused = "";
            // Save settings to current scene
            if (scene_idx >= 0 && scene_idx < array_length(editor_scenes)) {
                editor_scenes[scene_idx].is_act_end = current.is_act_end;
                editor_scenes[scene_idx].act_reward_type = act_reward_type;
                editor_scenes[scene_idx].act_reward_value = act_reward_value;
            }
        }
        
        // Act End Checkbox
        var chk_size = 30 * k;
        var chk_x = win_x + 50 * k;
        var chk_y = win_y + 40 * k;
        if (point_in_rectangle(mx, my, chk_x, chk_y, chk_x + chk_size, chk_y + chk_size)) {
            current.is_act_end = !current.is_act_end;
        }

        // Reward Type Options
        var start_y = win_y + 80 * k;
        for (var i = 0; i < array_length(act_reward_options); i++) {
            var opt_x = win_x + 250 * k + (i * 100 * k);
            var opt_y = start_y;
            if (point_in_rectangle(mx, my, opt_x, opt_y, opt_x + 90 * k, opt_y + 30 * k)) {
                act_reward_type = act_reward_options[i];
            }
        }
        
        // Reward Value Field
        var line_h = 50 * k;
        var val_field_x1 = win_x + 300 * k;
        var val_field_y1 = start_y + line_h;
        var val_field_x2 = win_x + 550 * k;
        var val_field_y2 = val_field_y1 + 30 * k;
        if (point_in_rectangle(mx, my, val_field_x1, val_field_y1, val_field_x2, val_field_y2)) {
            field_focused = "act_reward_value";
            str_input = act_reward_value;
            cursor_pos = string_length(str_input);
        } else if (!point_in_rectangle(mx, my, win_x, win_y, win_x + win_w, win_y + win_h)) {
             // Click outside closes window? Maybe not, just unfocus
             field_focused = "";
        }
    }
    
    // Allow typing if field focused
    var ks = keyboard_string;
    if (field_focused == "act_reward_value" && ks != "") {
        act_reward_value += ks;
        keyboard_string = "";
    }
    if (field_focused == "act_reward_value" && keyboard_check_pressed(vk_backspace)) {
        var len = string_length(act_reward_value);
        if (len > 0) act_reward_value = string_delete(act_reward_value, len, 1);
    }
    
    exit;
}

if (variable_instance_exists(id, "show_duel_window") && show_duel_window) {
    duel_window_x = (room_width - duel_window_w) / 2;
    duel_window_y = (room_height - duel_window_h) / 2;
    
    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        
        // Close Button (Top Right)
        var close_size = 40 * k;
        if (point_in_rectangle(mx, my, duel_window_x + duel_window_w - close_size, duel_window_y, duel_window_x + duel_window_w, duel_window_y + close_size)) {
            show_duel_window = false;
        }
        
        // Confirm Button
        var btn_w_local = 200 * k;
        var btn_h_local = 50 * k;
        var btn_y_local = duel_window_y + duel_window_h - 70 * k;
        var btn_save_x = duel_window_x + duel_window_w / 2 - btn_w_local / 2;
        
        if (point_in_rectangle(mx, my, btn_save_x, btn_y_local, btn_save_x + btn_w_local, btn_y_local + btn_h_local)) {
            if (scene_idx >= 0 && scene_idx < array_length(editor_scenes)) {
                editor_scenes[scene_idx].duel_bot_id = current.duel_bot_id;
                editor_scenes[scene_idx].duel_player_deck = current.duel_player_deck;
            }
            save_notification_text = "Duel configuré !";
            save_notification_timer = 120;
            show_duel_window = false;
        }
        
        // Delete Duel Button
        var btn_del_x = duel_window_x + 30 * k;
        if (current.duel_bot_id > 0 && point_in_rectangle(mx, my, btn_del_x, btn_y_local, btn_del_x + btn_w_local, btn_y_local + btn_h_local)) {
             current.duel_bot_id = 0;
             current.duel_player_deck = noone;
             if (scene_idx >= 0 && scene_idx < array_length(editor_scenes)) {
                editor_scenes[scene_idx].duel_bot_id = 0;
                editor_scenes[scene_idx].duel_player_deck = noone;
            }
             save_notification_text = "Duel supprimé.";
             save_notification_timer = 120;
             show_duel_window = false;
        }

        // Deck Selection
        var list_y_start = duel_window_y + 80 * k;
        var item_h = 40 * k;
        
        // Player Decks (Left side)
        if (mx > duel_window_x + 20*k && mx < duel_window_x + duel_window_w/2 - 20*k) {
             if (variable_instance_exists(id, "player_deck_options")) {
                 for (var i = 0; i < array_length(player_deck_options); i++) {
                     var item_y = list_y_start + i * item_h;
                     if (my >= item_y && my < item_y + item_h) {
                         current.duel_player_deck = player_deck_options[i];
                     }
                 }
             }
        }
        
        // Bot Decks (Right side)
        if (mx > duel_window_x + duel_window_w/2 + 20*k && mx < duel_window_x + duel_window_w - 20*k) {
             if (variable_instance_exists(id, "bot_deck_options")) {
                 for (var i = 0; i < array_length(bot_deck_options); i++) {
                     var item_y = list_y_start + i * item_h;
                     if (my >= item_y && my < item_y + item_h) {
                         current.duel_bot_id = bot_deck_options[i].id;
                     }
                 }
             }
        }
    }
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    var hs = resize_handle_size;
    var sp1_hr_x1 = speaker1.x + speaker1.w * 0.5 - hs;
    var sp1_hr_y1 = speaker1.y + speaker1.h * 0.5 - hs;
    var sp1_hr_x2 = sp1_hr_x1 + hs;
    var sp1_hr_y2 = sp1_hr_y1 + hs;
    var sp2_hr_x1 = speaker2.x + speaker2.w * 0.5 - hs;
    var sp2_hr_y1 = speaker2.y + speaker2.h * 0.5 - hs;
    var sp2_hr_x2 = sp2_hr_x1 + hs;
    var sp2_hr_y2 = sp2_hr_y1 + hs;
    var ob1_hr_x1 = object1.x + object1.w * 0.5 - hs;
    var ob1_hr_y1 = object1.y + object1.h * 0.5 - hs;
    var ob1_hr_x2 = ob1_hr_x1 + hs;
    var ob1_hr_y2 = ob1_hr_y1 + hs;
    var ob2_hr_x1 = object2.x + object2.w * 0.5 - hs;
    var ob2_hr_y1 = object2.y + object2.h * 0.5 - hs;
    var ob2_hr_x2 = ob2_hr_x1 + hs;
    var ob2_hr_y2 = ob2_hr_y1 + hs;
    var sp3_hr_x1 = speaker3.x + speaker3.w * 0.5 - hs;
    var sp3_hr_y1 = speaker3.y + speaker3.h * 0.5 - hs;
    var sp3_hr_x2 = sp3_hr_x1 + hs;
    var sp3_hr_y2 = sp3_hr_y1 + hs;

    if (sp1_enabled && point_in_rectangle(mouse_x, mouse_y, sp1_hr_x1, sp1_hr_y1, sp1_hr_x2, sp1_hr_y2)) { resizing = "speaker1"; resize_start_mouse_x = mouse_x; resize_start_mouse_y = mouse_y; resize_start_w = speaker1.w; resize_start_h = speaker1.h; }
    else if (sp2_enabled && point_in_rectangle(mouse_x, mouse_y, sp2_hr_x1, sp2_hr_y1, sp2_hr_x2, sp2_hr_y2)) { resizing = "speaker2"; resize_start_mouse_x = mouse_x; resize_start_mouse_y = mouse_y; resize_start_w = speaker2.w; resize_start_h = speaker2.h; }
    else if (obj1_enabled && point_in_rectangle(mouse_x, mouse_y, ob1_hr_x1, ob1_hr_y1, ob1_hr_x2, ob1_hr_y2)) { resizing = "object1"; resize_start_mouse_x = mouse_x; resize_start_mouse_y = mouse_y; resize_start_w = object1.w; resize_start_h = object1.h; }
    else if (obj2_enabled && point_in_rectangle(mouse_x, mouse_y, ob2_hr_x1, ob2_hr_y1, ob2_hr_x2, ob2_hr_y2)) { resizing = "object2"; resize_start_mouse_x = mouse_x; resize_start_mouse_y = mouse_y; resize_start_w = object2.w; resize_start_h = object2.h; }
    else if (sp3_enabled && point_in_rectangle(mouse_x, mouse_y, sp3_hr_x1, sp3_hr_y1, sp3_hr_x2, sp3_hr_y2)) { resizing = "speaker3"; resize_start_mouse_x = mouse_x; resize_start_mouse_y = mouse_y; resize_start_w = speaker3.w; resize_start_h = speaker3.h; }
    else {
        if (sp1_enabled && rect_contains(speaker1, mouse_x, mouse_y)) { dragging = "speaker1"; offset_x = mouse_x - speaker1.x; offset_y = mouse_y - speaker1.y; current.speaker = 1; }
        else if (sp2_enabled && rect_contains(speaker2, mouse_x, mouse_y)) { dragging = "speaker2"; offset_x = mouse_x - speaker2.x; offset_y = mouse_y - speaker2.y; current.speaker = 2; }
        else if (sp3_enabled && rect_contains(speaker3, mouse_x, mouse_y)) { dragging = "speaker3"; offset_x = mouse_x - speaker3.x; offset_y = mouse_y - speaker3.y; current.speaker = 3; }
        else if (textbox_enabled && rect_contains(textbox, mouse_x, mouse_y))  { dragging = "textbox";  offset_x = mouse_x - textbox.x;  offset_y = mouse_y - textbox.y; }
        else if (obj1_enabled && rect_contains(object1, mouse_x, mouse_y))  { dragging = "object1";  offset_x = mouse_x - object1.x;  offset_y = mouse_y - object1.y; }
        else if (obj2_enabled && rect_contains(object2, mouse_x, mouse_y))  { dragging = "object2";  offset_x = mouse_x - object2.x;  offset_y = mouse_y - object2.y; }
    }
}

if (mouse_check_button(mb_left)) {
    if (resizing != "") {
        var dx = mouse_x - resize_start_mouse_x;
        var dy = mouse_y - resize_start_mouse_y;
        if (resizing == "speaker1") { speaker1.w = max(min_resize_w, resize_start_w + dx); speaker1.h = max(min_resize_h, resize_start_h + dy); }
        else if (resizing == "speaker2") { speaker2.w = max(min_resize_w, resize_start_w + dx); speaker2.h = max(min_resize_h, resize_start_h + dy); }
        else if (resizing == "object1") { object1.w = max(min_resize_w, resize_start_w + dx); object1.h = max(min_resize_h, resize_start_h + dy); }
        else if (resizing == "object2") { object2.w = max(min_resize_w, resize_start_w + dx); object2.h = max(min_resize_h, resize_start_h + dy); }
        else if (resizing == "speaker3") { speaker3.w = max(min_resize_w, resize_start_w + dx); speaker3.h = max(min_resize_h, resize_start_h + dy); }
    } else {
        if (dragging == "speaker1") { speaker1.x = mouse_x - offset_x; speaker1.y = mouse_y - offset_y; }
        else if (dragging == "speaker2") { speaker2.x = mouse_x - offset_x; speaker2.y = mouse_y - offset_y; }
        else if (dragging == "textbox")  { textbox.x  = mouse_x - offset_x; textbox.y  = mouse_y - offset_y; }
        else if (dragging == "speaker3") { speaker3.x = mouse_x - offset_x; speaker3.y = mouse_y - offset_y; }
        else if (dragging == "object1")  { object1.x  = mouse_x - offset_x; object1.y  = mouse_y - offset_y; }
        else if (dragging == "object2")  { object2.x  = mouse_x - offset_x; object2.y  = mouse_y - offset_y; }
    }
}

if (mouse_check_button_released(mb_left)) { dragging = ""; resizing = ""; }

if (mouse_check_button_pressed(mb_left)) {
    var mxf = mouse_x; var myf = mouse_y;
    if (variable_instance_exists(id, "btn_create_duel_x1") && point_in_rectangle(mxf, myf, btn_create_duel_x1, btn_create_duel_y1, btn_create_duel_x2, btn_create_duel_y2)) {
        if (variable_instance_exists(id, "refresh_deck_options")) refresh_deck_options();
        show_duel_window = true;
    }
    else if (sp1_enabled && point_in_rectangle(mxf, myf, sp1_field_x1, sp1_field_y1, sp1_field_x2, sp1_field_y2)) { field_focused = "portrait1"; str_input = current.portrait1_name; current.speaker = 1; cursor_pos = string_length(str_input); }
    else if (sp1_enabled && point_in_rectangle(mxf, myf, sp1_flip_btn_x1, sp1_flip_btn_y1, sp1_flip_btn_x2, sp1_flip_btn_y2)) { current.speaker1_flip = !current.speaker1_flip; }
    else if (sp2_enabled && point_in_rectangle(mxf, myf, sp2_field_x1, sp2_field_y1, sp2_field_x2, sp2_field_y2)) { field_focused = "portrait2"; str_input = current.portrait2_name; current.speaker = 2; cursor_pos = string_length(str_input); }
    else if (sp3_enabled && point_in_rectangle(mxf, myf, sp3_field_x1, sp3_field_y1, sp3_field_x2, sp3_field_y2)) { field_focused = "portrait3"; str_input = current.portrait3_name; current.speaker = 3; cursor_pos = string_length(str_input); }
    else if (sp2_enabled && point_in_rectangle(mxf, myf, sp2_flip_btn_x1, sp2_flip_btn_y1, sp2_flip_btn_x2, sp2_flip_btn_y2)) { current.speaker2_flip = !current.speaker2_flip; }
    else if (sp3_enabled && point_in_rectangle(mxf, myf, sp3_flip_btn_x1, sp3_flip_btn_y1, sp3_flip_btn_x2, sp3_flip_btn_y2)) { current.speaker3_flip = !current.speaker3_flip; }
    else if (obj1_enabled && point_in_rectangle(mxf, myf, obj1_field_x1, obj1_field_y1, obj1_field_x2, obj1_field_y2)) { field_focused = "obj1"; str_input = current.obj1_name; cursor_pos = string_length(str_input); }
    else if (obj1_enabled && point_in_rectangle(mxf, myf, obj1_flip_btn_x1, obj1_flip_btn_y1, obj1_flip_btn_x2, obj1_flip_btn_y2)) { current.obj1_flip = !current.obj1_flip; }
    else if (obj2_enabled && point_in_rectangle(mxf, myf, obj2_field_x1, obj2_field_y1, obj2_field_x2, obj2_field_y2)) { field_focused = "obj2"; str_input = current.obj2_name; cursor_pos = string_length(str_input); }
    else if (obj2_enabled && point_in_rectangle(mxf, myf, obj2_flip_btn_x1, obj2_flip_btn_y1, obj2_flip_btn_x2, obj2_flip_btn_y2)) { current.obj2_flip = !current.obj2_flip; }
    else if (point_in_rectangle(mxf, myf, bg_field_x1, bg_field_y1, bg_field_x2, bg_field_y2)) { field_focused = "bg"; str_input = current.bg_name; cursor_pos = string_length(str_input); }
    else if (sounds_count >= 1 && point_in_rectangle(mxf, myf, bg_sound_field_x1, bg_sound_field_y1, bg_sound_field_x2, bg_sound_field_y2)) { field_focused = "bg_sound"; str_input = current.bg_sound; cursor_pos = string_length(str_input); }
    else if (sounds_count >= 2 && point_in_rectangle(mxf, myf, bg_sound2_field_x1, bg_sound2_field_y1, bg_sound2_field_x2, bg_sound2_field_y2)) { field_focused = "bg_sound2"; str_input = current.bg_sound2; cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, text_field_x1, text_field_y1, text_field_x2, text_field_y2)) { field_focused = "text"; str_input = current.text; cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, timer_field_x1, timer_field_y1, timer_field_x2, timer_field_y2)) { field_focused = "wait_after_ms"; str_input = string(current.wait_after_ms); cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, chap_field_x1, chap_field_y1, chap_field_x2, chap_field_y2)) { field_focused = "chapter"; str_input = string(global.current_chapter); cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, act_field_x1, act_field_y1, act_field_x2, act_field_y2)) { field_focused = "act"; str_input = string(global.current_act); cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, duel_field_x1, duel_field_y1, duel_field_x2, duel_field_y2)) { field_focused = "duel"; str_input = string(current.duel_bot_id); cursor_pos = string_length(str_input); }
    else if (point_in_rectangle(mxf, myf, btn_speakers_minus_x1, btn_speakers_minus_y1, btn_speakers_minus_x2, btn_speakers_minus_y2)) {
        speakers_count = max(0, speakers_count - 1);
        if (speakers_count == 0) { sp1_enabled = false; sp2_enabled = false; sp3_enabled = false; }
        else if (speakers_count == 1) { sp1_enabled = true; sp2_enabled = false; sp3_enabled = false; }
        else if (speakers_count == 2) { sp1_enabled = true; sp2_enabled = true; sp3_enabled = false; }
        else if (speakers_count == 3) { sp1_enabled = true; sp2_enabled = true; sp3_enabled = true; }
        if (!sp1_enabled && dropdown_open_for == "portrait1") dropdown_open_for = "";
        if (!sp2_enabled && dropdown_open_for == "portrait2") dropdown_open_for = "";
        if (!sp3_enabled && dropdown_open_for == "portrait3") dropdown_open_for = "";
    }
    else if (point_in_rectangle(mxf, myf, btn_speakers_plus_x1, btn_speakers_plus_y1, btn_speakers_plus_x2, btn_speakers_plus_y2)) {
        speakers_count = min(3, speakers_count + 1);
        if (speakers_count == 1) { sp1_enabled = true; sp2_enabled = false; sp3_enabled = false; }
        else if (speakers_count == 2) { sp1_enabled = true; sp2_enabled = true; sp3_enabled = false; }
        else if (speakers_count == 3) { sp1_enabled = true; sp2_enabled = true; sp3_enabled = true; }
    }
    else if (point_in_rectangle(mxf, myf, btn_sounds_minus_x1, btn_sounds_minus_y1, btn_sounds_minus_x2, btn_sounds_minus_y2)) {
        sounds_count = max(0, sounds_count - 1);
        if (sounds_count == 0) { current.bg_sound = ""; current.bg_sound2 = ""; }
        else if (sounds_count == 1) { current.bg_sound2 = ""; }
    }
    else if (point_in_rectangle(mxf, myf, btn_sounds_plus_x1, btn_sounds_plus_y1, btn_sounds_plus_x2, btn_sounds_plus_y2)) {
        sounds_count = min(2, sounds_count + 1);
    }
    else if (point_in_rectangle(mxf, myf, btn_objects_minus_x1, btn_objects_minus_y1, btn_objects_minus_x2, btn_objects_minus_y2)) {
        objects_count = max(0, objects_count - 1);
        if (objects_count == 0) { obj1_enabled = false; obj2_enabled = false; }
        else if (objects_count == 1) { obj1_enabled = true; obj2_enabled = false; }
        else if (objects_count == 2) { obj1_enabled = true; obj2_enabled = true; }
        if (!obj2_enabled && dropdown_open_for == "obj2") dropdown_open_for = "";
    }
    else if (point_in_rectangle(mxf, myf, btn_objects_plus_x1, btn_objects_plus_y1, btn_objects_plus_x2, btn_objects_plus_y2)) {
        objects_count = min(2, objects_count + 1);
        if (objects_count == 0) { obj1_enabled = false; obj2_enabled = false; }
        else if (objects_count == 1) { obj1_enabled = true; obj2_enabled = false; }
        else if (objects_count == 2) { obj1_enabled = true; obj2_enabled = true; }
    }
}

var ks = keyboard_string;
if (field_focused != "") {
    // Ensure cursor is within bounds
    var len = string_length(str_input);
    if (cursor_pos > len) cursor_pos = len;
    
    // Navigation
    if (keyboard_check_pressed(vk_left)) {
        cursor_pos = max(0, cursor_pos - 1);
    }
    if (keyboard_check_pressed(vk_right)) {
        cursor_pos = min(len, cursor_pos + 1);
    }

    var text_changed = false;

    // Typing
    if (ks != "") {
        str_input = string_insert(ks, str_input, cursor_pos + 1);
        cursor_pos += string_length(ks);
        keyboard_string = "";
        text_changed = true;
    }

    // Backspace
    if (keyboard_check_pressed(vk_backspace)) {
        if (cursor_pos > 0) {
            str_input = string_delete(str_input, cursor_pos, 1);
            cursor_pos--;
            text_changed = true;
        }
    }
    
    // Delete
    if (keyboard_check_pressed(vk_delete)) {
        if (cursor_pos < string_length(str_input)) {
            str_input = string_delete(str_input, cursor_pos + 1, 1);
            text_changed = true;
        }
    }

    if (text_changed) {
        if (field_focused == "portrait1") current.portrait1_name = str_input;
        else if (field_focused == "portrait2") current.portrait2_name = str_input;
        else if (field_focused == "portrait3") current.portrait3_name = str_input;
        else if (field_focused == "obj1") current.obj1_name = str_input;
        else if (field_focused == "obj2") current.obj2_name = str_input;
        else if (field_focused == "bg") current.bg_name = str_input;
        else if (field_focused == "bg_sound") current.bg_sound = str_input;
        else if (field_focused == "bg_sound2") current.bg_sound2 = str_input;
        else if (field_focused == "text") current.text = str_input;
        else if (field_focused == "wait_after_ms") {
            var v_in = (str_input == "") ? 0 : real(str_input);
            current.wait_after_ms = max(0, floor(v_in));
        }
        else if (field_focused == "chapter") global.current_chapter = max(1, floor(real(str_input)));
        else if (field_focused == "act") global.current_act = max(1, floor(real(str_input)));
        else if (field_focused == "duel") current.duel_bot_id = max(0, floor(real(str_input)));
        
        if (array_length(timeline) > 0 && line_idx >= 0) {
            var ln_update = timeline[line_idx];
            if (field_focused == "text") ln_update.text = string(current.text);
            else if (field_focused == "portrait1") ln_update.portrait1_name = current.portrait1_name;
            else if (field_focused == "portrait2") ln_update.portrait2_name = current.portrait2_name;
            else if (field_focused == "portrait3") ln_update.portrait3_name = current.portrait3_name;
            else if (field_focused == "obj1") ln_update.obj1_name = current.obj1_name;
            else if (field_focused == "obj2") ln_update.obj2_name = current.obj2_name;
            else if (field_focused == "wait_after_ms") ln_update.wait_after_ms = current.wait_after_ms;
            timeline[line_idx] = ln_update;
        }
    }
}

if (field_focused != "" && keyboard_check_pressed(vk_enter)) { field_focused = ""; str_input = ""; }

if (false) {
    var line = { speaker: current.speaker, text: current.text, bg_name: current.bg_name, portrait1_name: current.portrait1_name, portrait2_name: current.portrait2_name, obj1_name: current.obj1_name, obj2_name: current.obj2_name };
    array_push(timeline, line);
    current.text = "";
}

if (false) { current = { speaker: current.speaker, text: "", bg_name: current.bg_name, bg_sound: (variable_struct_exists(current, "bg_sound") ? current.bg_sound : ""), portrait1_name: current.portrait1_name, portrait2_name: current.portrait2_name, obj1_name: current.obj1_name, obj2_name: current.obj2_name }; }

if (false) {}

if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x; var my = mouse_y;
    if (point_in_rectangle(mx, my, btn_save_x1, btn_save_y1, btn_save_x2, btn_save_y2)) {
        var tl = timeline;
        if (array_length(tl) == 0 && current.text != "") {
            var line_fallback = { speaker: current.speaker, text: current.text, portrait1_name: current.portrait1_name, portrait2_name: current.portrait2_name, portrait3_name: current.portrait3_name, obj1_name: current.obj1_name, obj2_name: current.obj2_name, wait_after_ms: current.wait_after_ms, portrait1_effect: selected_effect_portrait1, portrait2_effect: selected_effect_portrait2, portrait3_effect: selected_effect_portrait3, obj1_effect: selected_effect_obj1, obj2_effect: selected_effect_obj2, text_effect: selected_effect_text, speaker1_flip: current.speaker1_flip, speaker2_flip: current.speaker2_flip, speaker3_flip: current.speaker3_flip, obj1_flip: current.obj1_flip, obj2_flip: current.obj2_flip, speaker1_x: speaker1.x, speaker1_y: speaker1.y, speaker1_w: speaker1.w, speaker1_h: speaker1.h, speaker2_x: speaker2.x, speaker2_y: speaker2.y, speaker2_w: speaker2.w, speaker2_h: speaker2.h, speaker3_x: speaker3.x, speaker3_y: speaker3.y, speaker3_w: speaker3.w, speaker3_h: speaker3.h, obj1_x: object1.x, obj1_y: object1.y, obj1_w: object1.w, obj1_h: object1.h, obj2_x: object2.x, obj2_y: object2.y, obj2_w: object2.w, obj2_h: object2.h, textbox_x: textbox.x, textbox_y: textbox.y };
            tl = [ line_fallback ];
        }
        if (array_length(tl) > 0 && line_idx >= 0) {
            var ln_save = tl[line_idx];
            ln_save.text = string(current.text);
            ln_save.speaker = current.speaker;
            ln_save.portrait1_name = current.portrait1_name;
            ln_save.portrait2_name = current.portrait2_name;
            ln_save.portrait3_name = current.portrait3_name;
            ln_save.obj1_name = current.obj1_name;
            ln_save.obj2_name = current.obj2_name;
            ln_save.wait_after_ms = current.wait_after_ms;
            ln_save.portrait1_effect = selected_effect_portrait1;
            ln_save.portrait2_effect = selected_effect_portrait2;
            ln_save.portrait3_effect = selected_effect_portrait3;
            ln_save.obj1_effect = selected_effect_obj1;
            ln_save.obj2_effect = selected_effect_obj2;
            ln_save.text_effect = selected_effect_text;
            ln_save.speaker1_flip = current.speaker1_flip;
            ln_save.speaker2_flip = current.speaker2_flip;
            ln_save.speaker3_flip = current.speaker3_flip;
            ln_save.obj1_flip = current.obj1_flip;
            ln_save.obj2_flip = current.obj2_flip;
            ln_save.speaker1_x = speaker1.x; ln_save.speaker1_y = speaker1.y; ln_save.speaker1_w = speaker1.w; ln_save.speaker1_h = speaker1.h;
            ln_save.speaker2_x = speaker2.x; ln_save.speaker2_y = speaker2.y; ln_save.speaker2_w = speaker2.w; ln_save.speaker2_h = speaker2.h;
            ln_save.speaker3_x = speaker3.x; ln_save.speaker3_y = speaker3.y; ln_save.speaker3_w = speaker3.w; ln_save.speaker3_h = speaker3.h;
            ln_save.obj1_x = object1.x; ln_save.obj1_y = object1.y; ln_save.obj1_w = object1.w; ln_save.obj1_h = object1.h;
            ln_save.obj2_x = object2.x; ln_save.obj2_y = object2.y; ln_save.obj2_w = object2.w; ln_save.obj2_h = object2.h;
            ln_save.textbox_x = textbox.x; ln_save.textbox_y = textbox.y;
            tl[line_idx] = ln_save;
            timeline = tl;
        }
        var chap2 = global.current_chapter; if (is_undefined(chap2)) chap2 = 1;
        var actn2 = global.current_act; if (is_undefined(actn2)) actn2 = 1;
        var scenes_out = editor_scenes;
        if (array_length(scenes_out) == 0) {
            var scene_new = { id: "editor_scene", bg: current.bg_name, bg_sound: current.bg_sound, bg_sound2: current.bg_sound2, speaker1_flip: current.speaker1_flip, speaker2_flip: current.speaker2_flip, speaker3_flip: current.speaker3_flip, obj1_flip: current.obj1_flip, obj2_flip: current.obj2_flip, lines: tl, duel_bot_id: current.duel_bot_id, duel_player_deck: current.duel_player_deck };
            scenes_out = [ scene_new ];
            editor_scenes = scenes_out;
            scene_idx = 0;
            line_idx = 0;
        } else {
            var si = scene_idx; if (si >= 0) { editor_scenes[si].bg = current.bg_name; editor_scenes[si].bg_sound = current.bg_sound; editor_scenes[si].bg_sound2 = current.bg_sound2; editor_scenes[si].duel_bot_id = current.duel_bot_id; editor_scenes[si].duel_player_deck = current.duel_player_deck; }
            if (si >= 0) {
                editor_scenes[si].speaker1_flip = current.speaker1_flip;
                editor_scenes[si].speaker2_flip = current.speaker2_flip;
                editor_scenes[si].speaker3_flip = current.speaker3_flip;
                editor_scenes[si].obj1_flip = current.obj1_flip;
                editor_scenes[si].obj2_flip = current.obj2_flip;
                editor_scenes[si].lines = timeline;
                if (array_length(editor_scenes[si].lines) == 0 && current.text != "") {
                    var line_fb2 = { speaker: current.speaker, text: current.text, portrait1_name: current.portrait1_name, portrait2_name: current.portrait2_name, portrait3_name: current.portrait3_name, obj1_name: current.obj1_name, obj2_name: current.obj2_name, wait_after_ms: current.wait_after_ms, portrait1_effect: selected_effect_portrait1, portrait2_effect: selected_effect_portrait2, portrait3_effect: selected_effect_portrait3, obj1_effect: selected_effect_obj1, obj2_effect: selected_effect_obj2, text_effect: selected_effect_text, speaker1_flip: current.speaker1_flip, speaker2_flip: current.speaker2_flip, speaker3_flip: current.speaker3_flip, obj1_flip: current.obj1_flip, obj2_flip: current.obj2_flip, speaker1_x: speaker1.x, speaker1_y: speaker1.y, speaker1_w: speaker1.w, speaker1_h: speaker1.h, speaker2_x: speaker2.x, speaker2_y: speaker2.y, speaker2_w: speaker2.w, speaker2_h: speaker2.h, speaker3_x: speaker3.x, speaker3_y: speaker3.y, speaker3_w: speaker3.w, speaker3_h: speaker3.h, obj1_x: object1.x, obj1_y: object1.y, obj1_w: object1.w, obj1_h: object1.h, obj2_x: object2.x, obj2_y: object2.y, obj2_w: object2.w, obj2_h: object2.h, textbox_x: textbox.x, textbox_y: textbox.y };
                    editor_scenes[si].lines = [ line_fb2 ];
                }
            }
        }
        var scen2 = { chapter_id: chap2, act: actn2, scenes: scenes_out };
        var json2 = json_stringify(scen2);
        var f2 = file_text_open_write("scenario_chapter_" + string(chap2) + "_act_" + string(actn2) + ".json");
        file_text_write_string(f2, json2);
        file_text_close(f2);
    } else if (point_in_rectangle(mx, my, btn_delete_x1, btn_delete_y1, btn_delete_x2, btn_delete_y2)) {
        if (array_length(editor_scenes) > 0 && scene_idx >= 0) {
            var n_del = array_length(editor_scenes);
            var arr_del = [];
            var i_del = 0;
            while (i_del < n_del) {
                if (i_del != scene_idx) { array_push(arr_del, editor_scenes[i_del]); }
                i_del += 1;
            }
            editor_scenes = arr_del;
            if (array_length(editor_scenes) == 0) {
                scene_idx = -1;
                line_idx = -1;
                current.text = "";
            } else {
                scene_idx = max(0, scene_idx - 1);
                line_idx = 0;
            }
        }
    } else if (point_in_rectangle(mx, my, btn_load_x1, btn_load_y1, btn_load_x2, btn_load_y2)) {
        var chap3 = global.current_chapter; if (is_undefined(chap3)) chap3 = 1;
        var actn3 = global.current_act; if (is_undefined(actn3)) actn3 = 1;
        var path = "scenario_chapter_" + string(chap3) + "_act_" + string(actn3) + ".json";
        if (file_exists(path)) {
            var fr = file_text_open_read(path);
            var s = "";
            while (!file_text_eof(fr)) { s += file_text_read_string(fr); }
            file_text_close(fr);
            var data = json_parse(s);
            editor_scenes = data.scenes;
            scene_idx = 0;
            line_idx = 0;
            if (array_length(editor_scenes) > 0) {
                var sc = editor_scenes[scene_idx];
                current.bg_name = sc.bg;
                if (variable_struct_exists(sc, "bg_sound")) current.bg_sound = sc.bg_sound; else current.bg_sound = "";
                if (variable_struct_exists(sc, "bg_sound2")) current.bg_sound2 = sc.bg_sound2; else current.bg_sound2 = "";
                if (variable_struct_exists(sc, "portrait1_name")) current.portrait1_name = sc.portrait1_name;
                if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
                if (variable_struct_exists(sc, "portrait2_name")) current.portrait2_name = sc.portrait2_name;
                if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
                if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
                if (variable_struct_exists(sc, "obj1_name")) current.obj1_name = sc.obj1_name;
                if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
                if (variable_struct_exists(sc, "obj2_name")) current.obj2_name = sc.obj2_name;
                if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
                if (variable_struct_exists(sc, "speaker1_x")) speaker1.x = sc.speaker1_x;
                if (variable_struct_exists(sc, "speaker1_y")) speaker1.y = sc.speaker1_y;
                if (variable_struct_exists(sc, "speaker1_w")) speaker1.w = sc.speaker1_w;
                if (variable_struct_exists(sc, "speaker1_h")) speaker1.h = sc.speaker1_h;
                if (variable_struct_exists(sc, "speaker2_x")) speaker2.x = sc.speaker2_x;
                if (variable_struct_exists(sc, "speaker2_y")) speaker2.y = sc.speaker2_y;
                if (variable_struct_exists(sc, "speaker2_w")) speaker2.w = sc.speaker2_w;
                if (variable_struct_exists(sc, "speaker2_h")) speaker2.h = sc.speaker2_h;
                if (variable_struct_exists(sc, "obj1_x")) object1.x = sc.obj1_x;
                if (variable_struct_exists(sc, "obj1_y")) object1.y = sc.obj1_y;
                if (variable_struct_exists(sc, "obj1_w")) object1.w = sc.obj1_w;
                if (variable_struct_exists(sc, "obj1_h")) object1.h = sc.obj1_h;
                if (variable_struct_exists(sc, "obj2_x")) object2.x = sc.obj2_x;
                if (variable_struct_exists(sc, "obj2_y")) object2.y = sc.obj2_y;
                if (variable_struct_exists(sc, "obj2_w")) object2.w = sc.obj2_w;
                if (variable_struct_exists(sc, "obj2_h")) object2.h = sc.obj2_h;
                if (variable_struct_exists(sc, "textbox_x")) textbox.x = sc.textbox_x;
                if (variable_struct_exists(sc, "textbox_y")) textbox.y = sc.textbox_y;
                if (variable_struct_exists(sc, "duel_bot_id")) current.duel_bot_id = sc.duel_bot_id; else current.duel_bot_id = 0;
                if (variable_struct_exists(sc, "duel_player_deck")) current.duel_player_deck = sc.duel_player_deck; else current.duel_player_deck = noone;
                if (variable_struct_exists(sc, "portrait1_effect")) selected_effect_portrait1 = sc.portrait1_effect; else selected_effect_portrait1 = "Aucune";
                if (variable_struct_exists(sc, "portrait2_effect")) selected_effect_portrait2 = sc.portrait2_effect; else selected_effect_portrait2 = "Aucune";
                if (variable_struct_exists(sc, "obj1_effect")) selected_effect_obj1 = sc.obj1_effect; else selected_effect_obj1 = "Aucune";
                if (variable_struct_exists(sc, "obj2_effect")) selected_effect_obj2 = sc.obj2_effect; else selected_effect_obj2 = "Aucune";
                if (variable_struct_exists(sc, "text_effect")) selected_effect_text = sc.text_effect; else selected_effect_text = "Aucune";
                if (variable_struct_exists(sc, "sp1_enabled")) sp1_enabled = sc.sp1_enabled; else sp1_enabled = true;
                if (variable_struct_exists(sc, "sp2_enabled")) sp2_enabled = sc.sp2_enabled; else sp2_enabled = true;
                if (variable_struct_exists(sc, "obj1_enabled")) obj1_enabled = sc.obj1_enabled; else obj1_enabled = true;
                if (variable_struct_exists(sc, "obj2_enabled")) obj2_enabled = sc.obj2_enabled; else obj2_enabled = true;
                if (variable_struct_exists(sc, "textbox_enabled")) textbox_enabled = sc.textbox_enabled; else textbox_enabled = true;
                timeline = is_array(sc.lines) ? sc.lines : [];
                if (array_length(sc.lines) > 0) {
                    var line_data = sc.lines[line_idx];
                    current.speaker = line_data.speaker;
                    current.text = line_data.text;
                    current.portrait1_name = line_data.portrait1_name;
                    current.portrait2_name = line_data.portrait2_name;
                    if (variable_struct_exists(line_data, "portrait3_name")) current.portrait3_name = line_data.portrait3_name;
                    current.obj1_name = line_data.obj1_name;
                    current.obj2_name = line_data.obj2_name;
                    if (variable_struct_exists(line_data, "wait_after_ms")) current.wait_after_ms = line_data.wait_after_ms; else if (variable_struct_exists(line_data, "wait_after")) current.wait_after_ms = line_data.wait_after; else current.wait_after_ms = 600;
                    if (variable_struct_exists(line_data, "speaker1_flip")) current.speaker1_flip = line_data.speaker1_flip; else if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
                    if (variable_struct_exists(line_data, "speaker2_flip")) current.speaker2_flip = line_data.speaker2_flip; else if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
                    if (variable_struct_exists(line_data, "speaker3_flip")) current.speaker3_flip = line_data.speaker3_flip; else if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
                    if (variable_struct_exists(line_data, "obj1_flip")) current.obj1_flip = line_data.obj1_flip; else if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
                    if (variable_struct_exists(line_data, "obj2_flip")) current.obj2_flip = line_data.obj2_flip; else if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
                    if (variable_struct_exists(line_data, "portrait1_effect")) selected_effect_portrait1 = line_data.portrait1_effect; else selected_effect_portrait1 = "Aucune";
                    if (variable_struct_exists(line_data, "portrait2_effect")) selected_effect_portrait2 = line_data.portrait2_effect; else selected_effect_portrait2 = "Aucune";
                    if (variable_struct_exists(line_data, "portrait3_effect")) selected_effect_portrait3 = line_data.portrait3_effect; else selected_effect_portrait3 = "Aucune";
                    if (variable_struct_exists(line_data, "obj1_effect")) selected_effect_obj1 = line_data.obj1_effect; else selected_effect_obj1 = "Aucune";
                    if (variable_struct_exists(line_data, "obj2_effect")) selected_effect_obj2 = line_data.obj2_effect; else selected_effect_obj2 = "Aucune";
                    if (variable_struct_exists(line_data, "text_effect")) selected_effect_text = line_data.text_effect; else selected_effect_text = "Aucune";
                    if (variable_struct_exists(line_data, "speaker1_x")) speaker1.x = line_data.speaker1_x;
                    if (variable_struct_exists(line_data, "speaker1_y")) speaker1.y = line_data.speaker1_y;
                    if (variable_struct_exists(line_data, "speaker1_w")) speaker1.w = line_data.speaker1_w;
                    if (variable_struct_exists(line_data, "speaker1_h")) speaker1.h = line_data.speaker1_h;
                    if (variable_struct_exists(line_data, "speaker2_x")) speaker2.x = line_data.speaker2_x;
                    if (variable_struct_exists(line_data, "speaker2_y")) speaker2.y = line_data.speaker2_y;
                    if (variable_struct_exists(line_data, "speaker2_w")) speaker2.w = line_data.speaker2_w;
                    if (variable_struct_exists(line_data, "speaker2_h")) speaker2.h = line_data.speaker2_h;
                    if (variable_struct_exists(line_data, "speaker3_x")) speaker3.x = line_data.speaker3_x;
                    if (variable_struct_exists(line_data, "speaker3_y")) speaker3.y = line_data.speaker3_y;
                    if (variable_struct_exists(line_data, "speaker3_w")) speaker3.w = line_data.speaker3_w;
                    if (variable_struct_exists(line_data, "speaker3_h")) speaker3.h = line_data.speaker3_h;
                    if (variable_struct_exists(line_data, "obj1_x")) object1.x = line_data.obj1_x;
                    if (variable_struct_exists(line_data, "obj1_y")) object1.y = line_data.obj1_y;
                    if (variable_struct_exists(line_data, "obj1_w")) object1.w = line_data.obj1_w;
                    if (variable_struct_exists(line_data, "obj1_h")) object1.h = line_data.obj1_h;
                    if (variable_struct_exists(line_data, "obj2_x")) object2.x = line_data.obj2_x;
                    if (variable_struct_exists(line_data, "obj2_y")) object2.y = line_data.obj2_y;
                    if (variable_struct_exists(line_data, "obj2_w")) object2.w = line_data.obj2_w;
                    if (variable_struct_exists(line_data, "obj2_h")) object2.h = line_data.obj2_h;
                    if (variable_struct_exists(line_data, "textbox_x")) textbox.x = line_data.textbox_x;
                    if (variable_struct_exists(line_data, "textbox_y")) textbox.y = line_data.textbox_y;
                } else {
                    current.text = "";
                }
            }
        }
    } else if (point_in_rectangle(mx, my, btn_scene_minus_x1, btn_scene_minus_y1, btn_scene_minus_x2, btn_scene_minus_y2)) {
        if (array_length(editor_scenes) > 0) {
            scene_idx = max(0, scene_idx - 1);
            line_idx = 0;
            var scp = editor_scenes[scene_idx];
            current.bg_name = scp.bg;
            if (variable_struct_exists(scp, "bg_sound")) current.bg_sound = scp.bg_sound; else current.bg_sound = "";
            if (variable_struct_exists(scp, "portrait1_name")) current.portrait1_name = scp.portrait1_name;
            if (variable_struct_exists(scp, "portrait2_name")) current.portrait2_name = scp.portrait2_name;
            if (variable_struct_exists(scp, "obj1_name")) current.obj1_name = scp.obj1_name;
            if (variable_struct_exists(scp, "obj2_name")) current.obj2_name = scp.obj2_name;
            if (variable_struct_exists(scp, "speaker1_flip")) current.speaker1_flip = scp.speaker1_flip; else current.speaker1_flip = false;
            if (variable_struct_exists(scp, "speaker2_flip")) current.speaker2_flip = scp.speaker2_flip; else current.speaker2_flip = false;
            if (variable_struct_exists(scp, "obj1_flip")) current.obj1_flip = scp.obj1_flip; else current.obj1_flip = false;
            if (variable_struct_exists(scp, "obj2_flip")) current.obj2_flip = scp.obj2_flip; else current.obj2_flip = false;
            if (variable_struct_exists(scp, "speaker1_x")) speaker1.x = scp.speaker1_x;
            if (variable_struct_exists(scp, "speaker1_y")) speaker1.y = scp.speaker1_y;
            if (variable_struct_exists(scp, "speaker1_w")) speaker1.w = scp.speaker1_w;
            if (variable_struct_exists(scp, "speaker1_h")) speaker1.h = scp.speaker1_h;
            if (variable_struct_exists(scp, "speaker2_x")) speaker2.x = scp.speaker2_x;
            if (variable_struct_exists(scp, "speaker2_y")) speaker2.y = scp.speaker2_y;
            if (variable_struct_exists(scp, "speaker2_w")) speaker2.w = scp.speaker2_w;
            if (variable_struct_exists(scp, "speaker2_h")) speaker2.h = scp.speaker2_h;
            if (variable_struct_exists(scp, "obj1_x")) object1.x = scp.obj1_x;
            if (variable_struct_exists(scp, "obj1_y")) object1.y = scp.obj1_y;
            if (variable_struct_exists(scp, "obj1_w")) object1.w = scp.obj1_w;
            if (variable_struct_exists(scp, "obj1_h")) object1.h = scp.obj1_h;
            if (variable_struct_exists(scp, "obj2_x")) object2.x = scp.obj2_x;
            if (variable_struct_exists(scp, "obj2_y")) object2.y = scp.obj2_y;
            if (variable_struct_exists(scp, "obj2_w")) object2.w = scp.obj2_w;
            if (variable_struct_exists(scp, "obj2_h")) object2.h = scp.obj2_h;
            if (variable_struct_exists(scp, "textbox_x")) textbox.x = scp.textbox_x;
            if (variable_struct_exists(scp, "textbox_y")) textbox.y = scp.textbox_y;
            if (variable_struct_exists(scp, "portrait1_effect")) selected_effect_portrait1 = scp.portrait1_effect; else selected_effect_portrait1 = "Aucune";
            if (variable_struct_exists(scp, "portrait2_effect")) selected_effect_portrait2 = scp.portrait2_effect; else selected_effect_portrait2 = "Aucune";
            if (variable_struct_exists(scp, "obj1_effect")) selected_effect_obj1 = scp.obj1_effect; else selected_effect_obj1 = "Aucune";
            if (variable_struct_exists(scp, "obj2_effect")) selected_effect_obj2 = scp.obj2_effect; else selected_effect_obj2 = "Aucune";
            if (variable_struct_exists(scp, "text_effect")) selected_effect_text = scp.text_effect; else selected_effect_text = "Aucune";
            if (variable_struct_exists(scp, "duel_bot_id")) current.duel_bot_id = scp.duel_bot_id; else current.duel_bot_id = 0;
            if (variable_struct_exists(scp, "duel_player_deck")) current.duel_player_deck = scp.duel_player_deck; else current.duel_player_deck = noone;
            if (variable_struct_exists(scp, "sp1_enabled")) sp1_enabled = scp.sp1_enabled; else sp1_enabled = true;
            if (variable_struct_exists(scp, "sp2_enabled")) sp2_enabled = scp.sp2_enabled; else sp2_enabled = true;
            if (variable_struct_exists(scp, "obj1_enabled")) obj1_enabled = scp.obj1_enabled; else obj1_enabled = true;
            if (variable_struct_exists(scp, "obj2_enabled")) obj2_enabled = scp.obj2_enabled; else obj2_enabled = true;
            if (variable_struct_exists(scp, "textbox_enabled")) textbox_enabled = scp.textbox_enabled; else textbox_enabled = true;
            timeline = is_array(scp.lines) ? scp.lines : [];
            if (array_length(scp.lines) > 0) {
                var ln2 = scp.lines[line_idx];
                current.speaker = ln2.speaker;
                current.text = ln2.text;
                current.portrait1_name = ln2.portrait1_name;
                current.portrait2_name = ln2.portrait2_name;
                if (variable_struct_exists(ln2, "portrait3_name")) current.portrait3_name = ln2.portrait3_name;
                current.obj1_name = ln2.obj1_name;
                current.obj2_name = ln2.obj2_name;
                if (variable_struct_exists(ln2, "wait_after_ms")) current.wait_after_ms = ln2.wait_after_ms; else if (variable_struct_exists(ln2, "wait_after")) current.wait_after_ms = ln2.wait_after; else current.wait_after_ms = 600;
                if (variable_struct_exists(ln2, "portrait1_effect")) selected_effect_portrait1 = ln2.portrait1_effect; else selected_effect_portrait1 = "Aucune";
                if (variable_struct_exists(ln2, "portrait2_effect")) selected_effect_portrait2 = ln2.portrait2_effect; else selected_effect_portrait2 = "Aucune";
                if (variable_struct_exists(ln2, "portrait3_effect")) selected_effect_portrait3 = ln2.portrait3_effect; else selected_effect_portrait3 = "Aucune";
                if (variable_struct_exists(ln2, "obj1_effect")) selected_effect_obj1 = ln2.obj1_effect; else selected_effect_obj1 = "Aucune";
                if (variable_struct_exists(ln2, "obj2_effect")) selected_effect_obj2 = ln2.obj2_effect; else selected_effect_obj2 = "Aucune";
                if (variable_struct_exists(ln2, "text_effect")) selected_effect_text = ln2.text_effect; else selected_effect_text = "Aucune";
                if (variable_struct_exists(ln2, "speaker1_x")) speaker1.x = ln2.speaker1_x;
                if (variable_struct_exists(ln2, "speaker1_y")) speaker1.y = ln2.speaker1_y;
                if (variable_struct_exists(ln2, "speaker1_w")) speaker1.w = ln2.speaker1_w;
                if (variable_struct_exists(ln2, "speaker1_h")) speaker1.h = ln2.speaker1_h;
                if (variable_struct_exists(ln2, "speaker2_x")) speaker2.x = ln2.speaker2_x;
                if (variable_struct_exists(ln2, "speaker2_y")) speaker2.y = ln2.speaker2_y;
                if (variable_struct_exists(ln2, "speaker2_w")) speaker2.w = ln2.speaker2_w;
                if (variable_struct_exists(ln2, "speaker2_h")) speaker2.h = ln2.speaker2_h;
                if (variable_struct_exists(ln2, "speaker3_x")) speaker3.x = ln2.speaker3_x;
                if (variable_struct_exists(ln2, "speaker3_y")) speaker3.y = ln2.speaker3_y;
                if (variable_struct_exists(ln2, "speaker3_w")) speaker3.w = ln2.speaker3_w;
                if (variable_struct_exists(ln2, "speaker3_h")) speaker3.h = ln2.speaker3_h;
                if (variable_struct_exists(ln2, "obj1_x")) object1.x = ln2.obj1_x;
                if (variable_struct_exists(ln2, "obj1_y")) object1.y = ln2.obj1_y;
                if (variable_struct_exists(ln2, "obj1_w")) object1.w = ln2.obj1_w;
                if (variable_struct_exists(ln2, "obj1_h")) object1.h = ln2.obj1_h;
                if (variable_struct_exists(ln2, "obj2_x")) object2.x = ln2.obj2_x;
                if (variable_struct_exists(ln2, "obj2_y")) object2.y = ln2.obj2_y;
                if (variable_struct_exists(ln2, "obj2_w")) object2.w = ln2.obj2_w;
                if (variable_struct_exists(ln2, "obj2_h")) object2.h = ln2.obj2_h;
                if (variable_struct_exists(ln2, "textbox_x")) textbox.x = ln2.textbox_x;
                if (variable_struct_exists(ln2, "textbox_y")) textbox.y = ln2.textbox_y;
            } else {
                current.text = "";
            }
        }
    } else if (point_in_rectangle(mx, my, btn_scene_plus_x1, btn_scene_plus_y1, btn_scene_plus_x2, btn_scene_plus_y2)) {
        var n = array_length(editor_scenes);
        if (scene_idx >= n - 1) {
            var scene_new = { id: "scene_" + string(n + 1), bg: "", bg_sound: "", bg_sound2: "", lines: [], duel_bot_id: 0, duel_player_deck: noone };
            array_push(editor_scenes, scene_new);
            scene_idx = n;
            timeline = [];
        } else {
            scene_idx = scene_idx + 1;
        }

        if (true) {
            line_idx = 0;
            var scn = editor_scenes[scene_idx];
            current.bg_name = scn.bg;
            if (variable_struct_exists(scn, "bg_sound")) current.bg_sound = scn.bg_sound; else current.bg_sound = "";
            if (variable_struct_exists(scn, "portrait1_name")) current.portrait1_name = scn.portrait1_name; else current.portrait1_name = "";
            if (variable_struct_exists(scn, "portrait2_name")) current.portrait2_name = scn.portrait2_name; else current.portrait2_name = "";
            if (variable_struct_exists(scn, "obj1_name")) current.obj1_name = scn.obj1_name; else current.obj1_name = "";
            if (variable_struct_exists(scn, "obj2_name")) current.obj2_name = scn.obj2_name; else current.obj2_name = "";
            if (variable_struct_exists(scn, "speaker1_flip")) current.speaker1_flip = scn.speaker1_flip; else current.speaker1_flip = false;
            if (variable_struct_exists(scn, "speaker2_flip")) current.speaker2_flip = scn.speaker2_flip; else current.speaker2_flip = false;
            if (variable_struct_exists(scn, "obj1_flip")) current.obj1_flip = scn.obj1_flip; else current.obj1_flip = false;
            if (variable_struct_exists(scn, "obj2_flip")) current.obj2_flip = scn.obj2_flip; else current.obj2_flip = false;
            if (variable_struct_exists(scn, "speaker1_x")) speaker1.x = scn.speaker1_x;
            if (variable_struct_exists(scn, "speaker1_y")) speaker1.y = scn.speaker1_y;
            if (variable_struct_exists(scn, "speaker1_w")) speaker1.w = scn.speaker1_w;
            if (variable_struct_exists(scn, "speaker1_h")) speaker1.h = scn.speaker1_h;
            if (variable_struct_exists(scn, "speaker2_x")) speaker2.x = scn.speaker2_x;
            if (variable_struct_exists(scn, "speaker2_y")) speaker2.y = scn.speaker2_y;
            if (variable_struct_exists(scn, "speaker2_w")) speaker2.w = scn.speaker2_w;
            if (variable_struct_exists(scn, "speaker2_h")) speaker2.h = scn.speaker2_h;
            if (variable_struct_exists(scn, "obj1_x")) object1.x = scn.obj1_x;
            if (variable_struct_exists(scn, "obj1_y")) object1.y = scn.obj1_y;
            if (variable_struct_exists(scn, "obj1_w")) object1.w = scn.obj1_w;
            if (variable_struct_exists(scn, "obj1_h")) object1.h = scn.obj1_h;
            if (variable_struct_exists(scn, "obj2_x")) object2.x = scn.obj2_x;
            if (variable_struct_exists(scn, "obj2_y")) object2.y = scn.obj2_y;
            if (variable_struct_exists(scn, "obj2_w")) object2.w = scn.obj2_w;
            if (variable_struct_exists(scn, "obj2_h")) object2.h = scn.obj2_h;
            if (variable_struct_exists(scn, "textbox_x")) textbox.x = scn.textbox_x;
            if (variable_struct_exists(scn, "textbox_y")) textbox.y = scn.textbox_y;
            if (variable_struct_exists(scn, "portrait1_effect")) selected_effect_portrait1 = scn.portrait1_effect; else selected_effect_portrait1 = "Aucune";
            if (variable_struct_exists(scn, "portrait2_effect")) selected_effect_portrait2 = scn.portrait2_effect; else selected_effect_portrait2 = "Aucune";
            if (variable_struct_exists(scn, "obj1_effect")) selected_effect_obj1 = scn.obj1_effect; else selected_effect_obj1 = "Aucune";
            if (variable_struct_exists(scn, "obj2_effect")) selected_effect_obj2 = scn.obj2_effect; else selected_effect_obj2 = "Aucune";
            if (variable_struct_exists(scn, "text_effect")) selected_effect_text = scn.text_effect; else selected_effect_text = "Aucune";
            if (variable_struct_exists(scn, "duel_bot_id")) current.duel_bot_id = scn.duel_bot_id; else current.duel_bot_id = 0;
            if (variable_struct_exists(scn, "sp1_enabled")) sp1_enabled = scn.sp1_enabled; else sp1_enabled = true;
            if (variable_struct_exists(scn, "sp2_enabled")) sp2_enabled = scn.sp2_enabled; else sp2_enabled = true;
            if (variable_struct_exists(scn, "obj1_enabled")) obj1_enabled = scn.obj1_enabled; else obj1_enabled = true;
            if (variable_struct_exists(scn, "obj2_enabled")) obj2_enabled = scn.obj2_enabled; else obj2_enabled = true;
            if (variable_struct_exists(scn, "textbox_enabled")) textbox_enabled = scn.textbox_enabled; else textbox_enabled = true;
            timeline = is_array(scn.lines) ? scn.lines : [];
            if (array_length(scn.lines) > 0) {
                var ln3 = scn.lines[line_idx];
                current.speaker = ln3.speaker;
                current.text = ln3.text;
                current.portrait1_name = ln3.portrait1_name;
                current.portrait2_name = ln3.portrait2_name;
                if (variable_struct_exists(ln3, "portrait3_name")) current.portrait3_name = ln3.portrait3_name;
                current.obj1_name = ln3.obj1_name;
                current.obj2_name = ln3.obj2_name;
                if (variable_struct_exists(ln3, "wait_after_ms")) current.wait_after_ms = ln3.wait_after_ms; else if (variable_struct_exists(ln3, "wait_after")) current.wait_after_ms = ln3.wait_after; else current.wait_after_ms = 600;
                if (variable_struct_exists(ln3, "speaker1_x")) speaker1.x = ln3.speaker1_x;
                if (variable_struct_exists(ln3, "speaker1_y")) speaker1.y = ln3.speaker1_y;
                if (variable_struct_exists(ln3, "speaker1_w")) speaker1.w = ln3.speaker1_w;
                if (variable_struct_exists(ln3, "speaker1_h")) speaker1.h = ln3.speaker1_h;
                if (variable_struct_exists(ln3, "speaker2_x")) speaker2.x = ln3.speaker2_x;
                if (variable_struct_exists(ln3, "speaker2_y")) speaker2.y = ln3.speaker2_y;
                if (variable_struct_exists(ln3, "speaker2_w")) speaker2.w = ln3.speaker2_w;
                if (variable_struct_exists(ln3, "speaker2_h")) speaker2.h = ln3.speaker2_h;
                if (variable_struct_exists(ln3, "speaker3_x")) speaker3.x = ln3.speaker3_x;
                if (variable_struct_exists(ln3, "speaker3_y")) speaker3.y = ln3.speaker3_y;
                if (variable_struct_exists(ln3, "speaker3_w")) speaker3.w = ln3.speaker3_w;
                if (variable_struct_exists(ln3, "speaker3_h")) speaker3.h = ln3.speaker3_h;
                if (variable_struct_exists(ln3, "obj1_x")) object1.x = ln3.obj1_x;
                if (variable_struct_exists(ln3, "obj1_y")) object1.y = ln3.obj1_y;
                if (variable_struct_exists(ln3, "obj1_w")) object1.w = ln3.obj1_w;
                if (variable_struct_exists(ln3, "obj1_h")) object1.h = ln3.obj1_h;
                if (variable_struct_exists(ln3, "obj2_x")) object2.x = ln3.obj2_x;
                if (variable_struct_exists(ln3, "obj2_y")) object2.y = ln3.obj2_y;
                if (variable_struct_exists(ln3, "obj2_w")) object2.w = ln3.obj2_w;
                if (variable_struct_exists(ln3, "obj2_h")) object2.h = ln3.obj2_h;
                if (variable_struct_exists(ln3, "textbox_x")) textbox.x = ln3.textbox_x;
                if (variable_struct_exists(ln3, "textbox_y")) textbox.y = ln3.textbox_y;
            } else {
                current.text = "";
            }
        }
    } else if (point_in_rectangle(mx, my, btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2)) {
        room_goto(rAcceuil);
    } else if (point_in_rectangle(mx, my, btn_chap_minus_x1, btn_chap_minus_y1, btn_chap_minus_x2, btn_chap_minus_y2)) {
        global.current_chapter = max(1, global.current_chapter - 1);
        refresh_deck_options();
        load_current_act_data();
    } else if (point_in_rectangle(mx, my, btn_chap_plus_x1, btn_chap_plus_y1, btn_chap_plus_x2, btn_chap_plus_y2)) {
        global.current_chapter = global.current_chapter + 1;
        refresh_deck_options();
        load_current_act_data();
    } else if (point_in_rectangle(mx, my, btn_act_minus_x1, btn_act_minus_y1, btn_act_minus_x2, btn_act_minus_y2)) {
        global.current_act = max(1, global.current_act - 1);
        load_current_act_data();
    } else if (point_in_rectangle(mx, my, btn_act_plus_x1, btn_act_plus_y1, btn_act_plus_x2, btn_act_plus_y2)) {
        global.current_act = global.current_act + 1;
        load_current_act_data();
    } else if (point_in_rectangle(mx, my, btn_line_minus_x1, btn_line_minus_y1, btn_line_minus_x2, btn_line_minus_y2)) {
        if (array_length(timeline) == 0 && scene_idx >= 0 && is_array(editor_scenes[scene_idx].lines)) {
            timeline = editor_scenes[scene_idx].lines;
            line_idx = clamp(line_idx, 0, max(0, array_length(timeline) - 1));
        }
        if (array_length(timeline) > 0) {
            line_idx = max(0, line_idx - 1);
            var line_data_prev = timeline[line_idx];
            current.speaker = line_data_prev.speaker;
            current.text = line_data_prev.text;
            current.portrait1_name = line_data_prev.portrait1_name;
            current.portrait2_name = line_data_prev.portrait2_name;
            if (variable_struct_exists(line_data_prev, "portrait3_name")) current.portrait3_name = line_data_prev.portrait3_name;
            current.obj1_name = line_data_prev.obj1_name;
            current.obj2_name = line_data_prev.obj2_name;
            if (variable_struct_exists(line_data_prev, "wait_after_ms")) current.wait_after_ms = line_data_prev.wait_after_ms; else if (variable_struct_exists(line_data_prev, "wait_after")) current.wait_after_ms = line_data_prev.wait_after; else current.wait_after_ms = 600;
            if (variable_struct_exists(line_data_prev, "portrait1_effect")) selected_effect_portrait1 = line_data_prev.portrait1_effect; else selected_effect_portrait1 = "Aucune";
            if (variable_struct_exists(line_data_prev, "portrait2_effect")) selected_effect_portrait2 = line_data_prev.portrait2_effect; else selected_effect_portrait2 = "Aucune";
            if (variable_struct_exists(line_data_prev, "portrait3_effect")) selected_effect_portrait3 = line_data_prev.portrait3_effect; else selected_effect_portrait3 = "Aucune";
            if (variable_struct_exists(line_data_prev, "obj1_effect")) selected_effect_obj1 = line_data_prev.obj1_effect; else selected_effect_obj1 = "Aucune";
            if (variable_struct_exists(line_data_prev, "obj2_effect")) selected_effect_obj2 = line_data_prev.obj2_effect; else selected_effect_obj2 = "Aucune";
            if (variable_struct_exists(line_data_prev, "text_effect")) selected_effect_text = line_data_prev.text_effect; else selected_effect_text = "Aucune";
            if (variable_struct_exists(line_data_prev, "speaker1_x")) speaker1.x = line_data_prev.speaker1_x;
            if (variable_struct_exists(line_data_prev, "speaker1_y")) speaker1.y = line_data_prev.speaker1_y;
            if (variable_struct_exists(line_data_prev, "speaker1_w")) speaker1.w = line_data_prev.speaker1_w;
            if (variable_struct_exists(line_data_prev, "speaker1_h")) speaker1.h = line_data_prev.speaker1_h;
            if (variable_struct_exists(line_data_prev, "speaker2_x")) speaker2.x = line_data_prev.speaker2_x;
            if (variable_struct_exists(line_data_prev, "speaker2_y")) speaker2.y = line_data_prev.speaker2_y;
            if (variable_struct_exists(line_data_prev, "speaker2_w")) speaker2.w = line_data_prev.speaker2_w;
            if (variable_struct_exists(line_data_prev, "speaker2_h")) speaker2.h = line_data_prev.speaker2_h;
            if (variable_struct_exists(line_data_prev, "speaker3_x")) speaker3.x = line_data_prev.speaker3_x;
            if (variable_struct_exists(line_data_prev, "speaker3_y")) speaker3.y = line_data_prev.speaker3_y;
            if (variable_struct_exists(line_data_prev, "speaker3_w")) speaker3.w = line_data_prev.speaker3_w;
            if (variable_struct_exists(line_data_prev, "speaker3_h")) speaker3.h = line_data_prev.speaker3_h;
            if (variable_struct_exists(line_data_prev, "obj1_x")) object1.x = line_data_prev.obj1_x;
            if (variable_struct_exists(line_data_prev, "obj1_y")) object1.y = line_data_prev.obj1_y;
            if (variable_struct_exists(line_data_prev, "obj1_w")) object1.w = line_data_prev.obj1_w;
            if (variable_struct_exists(line_data_prev, "obj1_h")) object1.h = line_data_prev.obj1_h;
            if (variable_struct_exists(line_data_prev, "obj2_x")) object2.x = line_data_prev.obj2_x;
            if (variable_struct_exists(line_data_prev, "obj2_y")) object2.y = line_data_prev.obj2_y;
            if (variable_struct_exists(line_data_prev, "obj2_w")) object2.w = line_data_prev.obj2_w;
            if (variable_struct_exists(line_data_prev, "obj2_h")) object2.h = line_data_prev.obj2_h;
            if (variable_struct_exists(line_data_prev, "textbox_x")) textbox.x = line_data_prev.textbox_x;
            if (variable_struct_exists(line_data_prev, "textbox_y")) textbox.y = line_data_prev.textbox_y;
        }
    } else if (point_in_rectangle(mx, my, btn_line_plus_x1, btn_line_plus_y1, btn_line_plus_x2, btn_line_plus_y2)) {
        if (array_length(timeline) == 0 && scene_idx >= 0 && is_array(editor_scenes[scene_idx].lines)) {
            timeline = editor_scenes[scene_idx].lines;
            line_idx = clamp(line_idx, 0, max(0, array_length(timeline) - 1));
        }
        if (array_length(timeline) > 0) {
            line_idx = min(array_length(timeline) - 1, line_idx + 1);
            var ln0 = timeline[line_idx];
            current.speaker = ln0.speaker;
            current.text = ln0.text;
            current.portrait1_name = ln0.portrait1_name;
            current.portrait2_name = ln0.portrait2_name;
            if (variable_struct_exists(ln0, "portrait3_name")) current.portrait3_name = ln0.portrait3_name;
            current.obj1_name = ln0.obj1_name;
            current.obj2_name = ln0.obj2_name;
            if (variable_struct_exists(ln0, "wait_after_ms")) current.wait_after_ms = ln0.wait_after_ms; else if (variable_struct_exists(ln0, "wait_after")) current.wait_after_ms = ln0.wait_after; else current.wait_after_ms = 600;
            if (variable_struct_exists(ln0, "portrait1_effect")) selected_effect_portrait1 = ln0.portrait1_effect; else selected_effect_portrait1 = "Aucune";
            if (variable_struct_exists(ln0, "portrait2_effect")) selected_effect_portrait2 = ln0.portrait2_effect; else selected_effect_portrait2 = "Aucune";
            if (variable_struct_exists(ln0, "portrait3_effect")) selected_effect_portrait3 = ln0.portrait3_effect; else selected_effect_portrait3 = "Aucune";
            if (variable_struct_exists(ln0, "obj1_effect")) selected_effect_obj1 = ln0.obj1_effect; else selected_effect_obj1 = "Aucune";
            if (variable_struct_exists(ln0, "obj2_effect")) selected_effect_obj2 = ln0.obj2_effect; else selected_effect_obj2 = "Aucune";
            if (variable_struct_exists(ln0, "text_effect")) selected_effect_text = ln0.text_effect; else selected_effect_text = "Aucune";
            if (variable_struct_exists(ln0, "speaker1_x")) speaker1.x = ln0.speaker1_x;
            if (variable_struct_exists(ln0, "speaker1_y")) speaker1.y = ln0.speaker1_y;
            if (variable_struct_exists(ln0, "speaker1_w")) speaker1.w = ln0.speaker1_w;
            if (variable_struct_exists(ln0, "speaker1_h")) speaker1.h = ln0.speaker1_h;
            if (variable_struct_exists(ln0, "speaker2_x")) speaker2.x = ln0.speaker2_x;
            if (variable_struct_exists(ln0, "speaker2_y")) speaker2.y = ln0.speaker2_y;
            if (variable_struct_exists(ln0, "speaker2_w")) speaker2.w = ln0.speaker2_w;
            if (variable_struct_exists(ln0, "speaker2_h")) speaker2.h = ln0.speaker2_h;
            if (variable_struct_exists(ln0, "speaker3_x")) speaker3.x = ln0.speaker3_x;
            if (variable_struct_exists(ln0, "speaker3_y")) speaker3.y = ln0.speaker3_y;
            if (variable_struct_exists(ln0, "speaker3_w")) speaker3.w = ln0.speaker3_w;
            if (variable_struct_exists(ln0, "speaker3_h")) speaker3.h = ln0.speaker3_h;
            if (variable_struct_exists(ln0, "obj1_x")) object1.x = ln0.obj1_x;
            if (variable_struct_exists(ln0, "obj1_y")) object1.y = ln0.obj1_y;
            if (variable_struct_exists(ln0, "obj1_w")) object1.w = ln0.obj1_w;
            if (variable_struct_exists(ln0, "obj1_h")) object1.h = ln0.obj1_h;
            if (variable_struct_exists(ln0, "obj2_x")) object2.x = ln0.obj2_x;
            if (variable_struct_exists(ln0, "obj2_y")) object2.y = ln0.obj2_y;
            if (variable_struct_exists(ln0, "obj2_w")) object2.w = ln0.obj2_w;
            if (variable_struct_exists(ln0, "obj2_h")) object2.h = ln0.obj2_h;
            if (variable_struct_exists(ln0, "textbox_x")) textbox.x = ln0.textbox_x;
            if (variable_struct_exists(ln0, "textbox_y")) textbox.y = ln0.textbox_y;
        }
    } else if (point_in_rectangle(mx, my, btn_line_add_x1, btn_line_add_y1, btn_line_add_x2, btn_line_add_y2)) {
        var line_new = { speaker: current.speaker, text: string(current.text), portrait1_name: current.portrait1_name, portrait2_name: current.portrait2_name, portrait3_name: current.portrait3_name, obj1_name: current.obj1_name, obj2_name: current.obj2_name, wait_after_ms: current.wait_after_ms, portrait1_effect: selected_effect_portrait1, portrait2_effect: selected_effect_portrait2, portrait3_effect: selected_effect_portrait3, obj1_effect: selected_effect_obj1, obj2_effect: selected_effect_obj2, text_effect: selected_effect_text, speaker1_x: speaker1.x, speaker1_y: speaker1.y, speaker1_w: speaker1.w, speaker1_h: speaker1.h, speaker2_x: speaker2.x, speaker2_y: speaker2.y, speaker2_w: speaker2.w, speaker2_h: speaker2.h, speaker3_x: speaker3.x, speaker3_y: speaker3.y, speaker3_w: speaker3.w, speaker3_h: speaker3.h, obj1_x: object1.x, obj1_y: object1.y, obj1_w: object1.w, obj1_h: object1.h, obj2_x: object2.x, obj2_y: object2.y, obj2_w: object2.w, obj2_h: object2.h, textbox_x: textbox.x, textbox_y: textbox.y };
        array_push(timeline, line_new);
        line_idx = array_length(timeline) - 1;
        current.text = "";
        if (scene_idx >= 0) {
            editor_scenes[scene_idx].lines = timeline;
        }
    } else if (point_in_rectangle(mx, my, btn_line_del_x1, btn_line_del_y1, btn_line_del_x2, btn_line_del_y2)) {
        if (array_length(timeline) > 0 && line_idx >= 0 && line_idx < array_length(timeline)) {
            array_delete(timeline, line_idx, 1);
            if (array_length(timeline) == 0) {
                line_idx = -1;
                // Clear current
                current = { speaker: 1, text: "", bg_name: current.bg_name, portrait1_name: "", portrait2_name: "", portrait3_name: "", obj1_name: "", obj2_name: "", duel_bot_id: current.duel_bot_id, duel_player_deck: current.duel_player_deck, bg_sound: current.bg_sound, bg_sound2: current.bg_sound2, speaker1_flip: false, speaker2_flip: false, speaker3_flip: false, obj1_flip: false, obj2_flip: false, wait_after_ms: 600 };
            } else {
                line_idx = clamp(line_idx, 0, array_length(timeline) - 1);
                var ln_new = timeline[line_idx];
                current.speaker = ln_new.speaker;
                current.text = ln_new.text;
                current.portrait1_name = ln_new.portrait1_name;
                current.portrait2_name = ln_new.portrait2_name;
                if (variable_struct_exists(ln_new, "portrait3_name")) current.portrait3_name = ln_new.portrait3_name; else current.portrait3_name = "";
                current.obj1_name = ln_new.obj1_name;
                current.obj2_name = ln_new.obj2_name;
                if (variable_struct_exists(ln_new, "wait_after_ms")) current.wait_after_ms = ln_new.wait_after_ms; else if (variable_struct_exists(ln_new, "wait_after")) current.wait_after_ms = ln_new.wait_after; else current.wait_after_ms = 600;
                if (variable_struct_exists(ln_new, "portrait1_effect")) selected_effect_portrait1 = ln_new.portrait1_effect; else selected_effect_portrait1 = "Aucune";
                if (variable_struct_exists(ln_new, "portrait2_effect")) selected_effect_portrait2 = ln_new.portrait2_effect; else selected_effect_portrait2 = "Aucune";
                if (variable_struct_exists(ln_new, "portrait3_effect")) selected_effect_portrait3 = ln_new.portrait3_effect; else selected_effect_portrait3 = "Aucune";
                if (variable_struct_exists(ln_new, "obj1_effect")) selected_effect_obj1 = ln_new.obj1_effect; else selected_effect_obj1 = "Aucune";
                if (variable_struct_exists(ln_new, "obj2_effect")) selected_effect_obj2 = ln_new.obj2_effect; else selected_effect_obj2 = "Aucune";
                if (variable_struct_exists(ln_new, "text_effect")) selected_effect_text = ln_new.text_effect; else selected_effect_text = "Aucune";
                if (variable_struct_exists(ln_new, "speaker1_x")) speaker1.x = ln_new.speaker1_x;
                if (variable_struct_exists(ln_new, "speaker1_y")) speaker1.y = ln_new.speaker1_y;
                if (variable_struct_exists(ln_new, "speaker1_w")) speaker1.w = ln_new.speaker1_w;
                if (variable_struct_exists(ln_new, "speaker1_h")) speaker1.h = ln_new.speaker1_h;
                if (variable_struct_exists(ln_new, "speaker2_x")) speaker2.x = ln_new.speaker2_x;
                if (variable_struct_exists(ln_new, "speaker2_y")) speaker2.y = ln_new.speaker2_y;
                if (variable_struct_exists(ln_new, "speaker2_w")) speaker2.w = ln_new.speaker2_w;
                if (variable_struct_exists(ln_new, "speaker2_h")) speaker2.h = ln_new.speaker2_h;
                if (variable_struct_exists(ln_new, "speaker3_x")) speaker3.x = ln_new.speaker3_x;
                if (variable_struct_exists(ln_new, "speaker3_y")) speaker3.y = ln_new.speaker3_y;
                if (variable_struct_exists(ln_new, "speaker3_w")) speaker3.w = ln_new.speaker3_w;
                if (variable_struct_exists(ln_new, "speaker3_h")) speaker3.h = ln_new.speaker3_h;
                if (variable_struct_exists(ln_new, "obj1_x")) object1.x = ln_new.obj1_x;
                if (variable_struct_exists(ln_new, "obj1_y")) object1.y = ln_new.obj1_y;
                if (variable_struct_exists(ln_new, "obj1_w")) object1.w = ln_new.obj1_w;
                if (variable_struct_exists(ln_new, "obj1_h")) object1.h = ln_new.obj1_h;
                if (variable_struct_exists(ln_new, "obj2_x")) object2.x = ln_new.obj2_x;
                if (variable_struct_exists(ln_new, "obj2_y")) object2.y = ln_new.obj2_y;
                if (variable_struct_exists(ln_new, "obj2_w")) object2.w = ln_new.obj2_w;
                if (variable_struct_exists(ln_new, "obj2_h")) object2.h = ln_new.obj2_h;
                if (variable_struct_exists(ln_new, "textbox_x")) textbox.x = ln_new.textbox_x;
                if (variable_struct_exists(ln_new, "textbox_y")) textbox.y = ln_new.textbox_y;
            }
            if (scene_idx >= 0) {
                editor_scenes[scene_idx].lines = timeline;
            }
        }
    } else if (point_in_rectangle(mx, my, btn_addsound_x1, btn_addsound_y1, btn_addsound_x2, btn_addsound_y2)) {
        if (current.bg_sound == "") { field_focused = "bg_sound"; str_input = current.bg_sound; }
        else { field_focused = "bg_sound2"; str_input = current.bg_sound2; }
    }
}

if (mouse_check_button_pressed(mb_left)) {
    var mx2 = mouse_x; var my2 = mouse_y;
    if (sp1_enabled && point_in_rectangle(mx2, my2, sp1_eff_btn_x1, sp1_eff_btn_y1, sp1_eff_btn_x2, sp1_eff_btn_y2)) { dropdown_open_for = "portrait1"; }
    else if (sp2_enabled && point_in_rectangle(mx2, my2, sp2_eff_btn_x1, sp2_eff_btn_y1, sp2_eff_btn_x2, sp2_eff_btn_y2)) { dropdown_open_for = "portrait2"; }
    else if (sp3_enabled && point_in_rectangle(mx2, my2, sp3_eff_btn_x1, sp3_eff_btn_y1, sp3_eff_btn_x2, sp3_eff_btn_y2)) { dropdown_open_for = "portrait3"; }
    else if (obj1_enabled && point_in_rectangle(mx2, my2, obj1_eff_btn_x1, obj1_eff_btn_y1, obj1_eff_btn_x2, obj1_eff_btn_y2)) { dropdown_open_for = "obj1"; }
    else if (obj2_enabled && point_in_rectangle(mx2, my2, obj2_eff_btn_x1, obj2_eff_btn_y1, obj2_eff_btn_x2, obj2_eff_btn_y2)) { dropdown_open_for = "obj2"; }
    else if (textbox_enabled && point_in_rectangle(mx2, my2, text_eff_btn_x1, text_eff_btn_y1, text_eff_btn_x2, text_eff_btn_y2)) { dropdown_open_for = "text"; }
    else if (dropdown_open_for != "") {
        if (mx2 >= dd_x1 && mx2 <= dd_x2 && my2 >= dd_y1 && my2 <= dd_y2) {
            var idx = floor((my2 - dd_y1) / dd_item_h);
            if (idx >= 0 && idx < array_length(effect_options)) {
                var val = effect_options[idx];
                if (dropdown_open_for == "portrait1") selected_effect_portrait1 = val;
                else if (dropdown_open_for == "portrait2") selected_effect_portrait2 = val;
                else if (dropdown_open_for == "portrait3") selected_effect_portrait3 = val;
                else if (dropdown_open_for == "obj1") selected_effect_obj1 = val;
                else if (dropdown_open_for == "obj2") selected_effect_obj2 = val;
                else if (dropdown_open_for == "text") selected_effect_text = val;
            }
            dropdown_open_for = "";
        } else {
            dropdown_open_for = "";
        }
    }
}
