if (instance_exists(oPanelOptions)) exit;
if (array_length(scenes) == 0) exit;
if (scene_index > 0) {
    scene_index -= 1;
    line_index = 0;
    var sc2 = scenes[scene_index];
    current.bg_name = sc2.bg;
    if (variable_struct_exists(sc2, "bg_sound")) current.bg_sound = sc2.bg_sound; else current.bg_sound = "";
    if (variable_struct_exists(sc2, "bg_sound2")) current.bg_sound2 = sc2.bg_sound2; else current.bg_sound2 = "";
    if (variable_struct_exists(sc2, "portrait1_name")) current.portrait1_name = sc2.portrait1_name;
    if (variable_struct_exists(sc2, "portrait2_name")) current.portrait2_name = sc2.portrait2_name;
    if (variable_struct_exists(sc2, "obj1_name")) current.obj1_name = sc2.obj1_name;
    if (variable_struct_exists(sc2, "obj2_name")) current.obj2_name = sc2.obj2_name;
    prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
    prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
    prev_object1_x = object1.x;    prev_object1_y = object1.y;
    prev_object2_x = object2.x;    prev_object2_y = object2.y;
    current.duel_bot_id = variable_struct_exists(sc2, "duel_bot_id") ? sc2.duel_bot_id : 0;
    current.portrait1_effect = "Aucune";
    current.portrait2_effect = "Aucune";
    current.obj1_effect = "Aucune";
    current.obj2_effect = "Aucune";
    current.text_effect = "Aucune";
    fx_sp1_start_ms = current_time;
    fx_sp2_start_ms = current_time;
    fx_obj1_start_ms = current_time;
    fx_obj2_start_ms = current_time;
    fx_text_start_ms = current_time;
    await_scene_click = false;
    line_auto_target_ms = -1;
        if (is_array(sc2.lines) && array_length(sc2.lines) > 0) {
            var line_data2 = sc2.lines[line_index];
            current.speaker = line_data2.speaker;
            current.text = line_data2.text;
            if (variable_struct_exists(line_data2, "portrait1_name")) current.portrait1_name = line_data2.portrait1_name;
            if (variable_struct_exists(line_data2, "portrait2_name")) current.portrait2_name = line_data2.portrait2_name;
            if (variable_struct_exists(line_data2, "portrait3_name")) current.portrait3_name = line_data2.portrait3_name;
            if (variable_struct_exists(line_data2, "obj1_name")) current.obj1_name = line_data2.obj1_name;
            if (variable_struct_exists(line_data2, "obj2_name")) current.obj2_name = line_data2.obj2_name;

            var len2 = string_length(string(current.text));
            var cps2 = max(1, text_reveal_cps);
            var reveal_ms2 = ceil(len2 * 1000 / cps2);
            var wait_ms2 = wait_after_default_ms;
            var has_explicit_wait2 = false;
            if (variable_struct_exists(line_data2, "wait_after_ms")) { wait_ms2 = line_data2.wait_after_ms; has_explicit_wait2 = true; } else if (variable_struct_exists(line_data2, "wait_after")) { wait_ms2 = line_data2.wait_after; has_explicit_wait2 = true; }
            var anim_ms2 = 0;
            var dur_base2 = fx_duration_ms;
            if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d12 = dur_base2; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d12 *= fx_inverse_multiplier; anim_ms2 = max(anim_ms2, d12); }
            if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d22 = dur_base2; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d22 *= fx_inverse_multiplier; anim_ms2 = max(anim_ms2, d22); }
            if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d32 = dur_base2; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d32 *= fx_inverse_multiplier; anim_ms2 = max(anim_ms2, d32); }
            if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d42 = dur_base2; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d42 *= fx_inverse_multiplier; anim_ms2 = max(anim_ms2, d42); }
            if (current.text_effect != "Aucune" && current.text_effect != "") { var dt2 = dur_base2; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dt2 *= fx_inverse_multiplier; anim_ms2 = max(anim_ms2, dt2); }
            if (len2 == 0) line_auto_target_ms = current_time + anim_ms2 + wait_ms2; else line_auto_target_ms = current_time + reveal_ms2 + wait_ms2;
        } else {
            current.text = "";
        }
    if (variable_struct_exists(sc2, "speaker1_flip")) current.speaker1_flip = sc2.speaker1_flip; else current.speaker1_flip = false;
    if (variable_struct_exists(sc2, "speaker2_flip")) current.speaker2_flip = sc2.speaker2_flip; else current.speaker2_flip = false;
    if (variable_struct_exists(sc2, "speaker3_flip")) current.speaker3_flip = sc2.speaker3_flip; else current.speaker3_flip = false;
    if (variable_struct_exists(sc2, "obj1_flip")) current.obj1_flip = sc2.obj1_flip; else current.obj1_flip = false;
    if (variable_struct_exists(sc2, "obj2_flip")) current.obj2_flip = sc2.obj2_flip; else current.obj2_flip = false;

    var new_bg_asset = asset_get_index(current.bg_sound);
    if (new_bg_asset == bg_sound_asset_current) {
    } else if (new_bg_asset != -1) {
        if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); }
        audio_play_sound(new_bg_asset, 0, true);
        bg_sound_asset_current = new_bg_asset;
    } else {
        if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); bg_sound_asset_current = -1; }
    }
    var new_bg2_asset = asset_get_index(current.bg_sound2);
    if (new_bg2_asset == bg2_sound_asset_current) {
    } else if (new_bg2_asset != -1) {
        if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); }
        audio_play_sound(new_bg2_asset, 0, true);
        bg2_sound_asset_current = new_bg2_asset;
    } else {
        if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); bg2_sound_asset_current = -1; }
    }
    story_progress_write_last_scene(chapter_id, scene_index, act_num);
} else {
    story_progress_write_last_scene(chapter_id, scene_index, act_num);
    if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); bg_sound_asset_current = -1; }
    if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); bg2_sound_asset_current = -1; }
    room_goto(rHistoire);
}
