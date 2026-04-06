var panel_open = instance_exists(oPanelOptions);
update_nav_buttons();
if (input_block_frames > 0) { input_block_frames -= 1; exit; }
var sc_k = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
if (!panel_open && keyboard_check_pressed(vk_right) && sc_k != noone) {
    var has_lines_k = is_array(sc_k.lines) && array_length(sc_k.lines) > 0;
    if (has_lines_k && line_index + 1 < array_length(sc_k.lines)) {
        line_index += 1;
        var line_data_k = sc_k.lines[line_index];
        current.speaker = line_data_k.speaker;
        current.text = line_data_k.text;
        if (variable_struct_exists(line_data_k, "portrait1_name")) current.portrait1_name = line_data_k.portrait1_name;
        if (variable_struct_exists(line_data_k, "portrait2_name")) current.portrait2_name = line_data_k.portrait2_name;
        if (variable_struct_exists(line_data_k, "portrait3_name")) current.portrait3_name = line_data_k.portrait3_name;
        if (variable_struct_exists(line_data_k, "obj1_name")) current.obj1_name = line_data_k.obj1_name;
        if (variable_struct_exists(line_data_k, "obj2_name")) current.obj2_name = line_data_k.obj2_name;
        fx_text_start_ms = current_time;
        if (variable_struct_exists(line_data_k, "bg")) current.bg_name = line_data_k.bg;
        if (variable_struct_exists(line_data_k, "bg_sound")) current.bg_sound = line_data_k.bg_sound;
        if (variable_struct_exists(line_data_k, "bg_sound2")) current.bg_sound2 = line_data_k.bg_sound2;
        prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
        prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
        prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
        prev_object1_x = object1.x;    prev_object1_y = object1.y;
        prev_object2_x = object2.x;    prev_object2_y = object2.y;
        var kref_k = 1;
        if (variable_struct_exists(line_data_k, "speaker1_x")) speaker1.x = line_data_k.speaker1_x * kref_k;
        if (variable_struct_exists(line_data_k, "speaker1_y")) speaker1.y = line_data_k.speaker1_y * kref_k;
        if (variable_struct_exists(line_data_k, "speaker1_w")) speaker1.w = line_data_k.speaker1_w * kref_k;
        if (variable_struct_exists(line_data_k, "speaker1_h")) speaker1.h = line_data_k.speaker1_h * kref_k;
        if (variable_struct_exists(line_data_k, "speaker2_x")) speaker2.x = line_data_k.speaker2_x * kref_k;
        if (variable_struct_exists(line_data_k, "speaker2_y")) speaker2.y = line_data_k.speaker2_y * kref_k;
        if (variable_struct_exists(line_data_k, "speaker2_w")) speaker2.w = line_data_k.speaker2_w * kref_k;
        if (variable_struct_exists(line_data_k, "speaker2_h")) speaker2.h = line_data_k.speaker2_h * kref_k;
        if (variable_struct_exists(line_data_k, "speaker3_x")) speaker3.x = line_data_k.speaker3_x * kref_k;
        if (variable_struct_exists(line_data_k, "speaker3_y")) speaker3.y = line_data_k.speaker3_y * kref_k;
        if (variable_struct_exists(line_data_k, "speaker3_w")) speaker3.w = line_data_k.speaker3_w * kref_k;
        if (variable_struct_exists(line_data_k, "speaker3_h")) speaker3.h = line_data_k.speaker3_h * kref_k;
        if (variable_struct_exists(line_data_k, "obj1_x")) object1.x = line_data_k.obj1_x * kref_k;
        if (variable_struct_exists(line_data_k, "obj1_y")) object1.y = line_data_k.obj1_y * kref_k;
        if (variable_struct_exists(line_data_k, "obj1_w")) object1.w = line_data_k.obj1_w * kref_k;
        if (variable_struct_exists(line_data_k, "obj1_h")) object1.h = line_data_k.obj1_h * kref_k;
        if (variable_struct_exists(line_data_k, "obj2_x")) object2.x = line_data_k.obj2_x * kref_k;
        if (variable_struct_exists(line_data_k, "obj2_y")) object2.y = line_data_k.obj2_y * kref_k;
        if (variable_struct_exists(line_data_k, "obj2_w")) object2.w = line_data_k.obj2_w * kref_k;
        if (variable_struct_exists(line_data_k, "obj2_h")) object2.h = line_data_k.obj2_h * kref_k;
        if (variable_struct_exists(line_data_k, "textbox_x")) textbox.x = line_data_k.textbox_x * kref_k;
        if (variable_struct_exists(line_data_k, "textbox_y")) textbox.y = line_data_k.textbox_y * kref_k;
        if (variable_struct_exists(line_data_k, "portrait1_effect")) current.portrait1_effect = line_data_k.portrait1_effect; else current.portrait1_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "portrait2_effect")) current.portrait2_effect = line_data_k.portrait2_effect; else current.portrait2_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "portrait3_effect")) current.portrait3_effect = line_data_k.portrait3_effect; else if (variable_struct_exists(sc_k, "portrait3_effect")) current.portrait3_effect = sc_k.portrait3_effect; else current.portrait3_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "obj1_effect")) current.obj1_effect = line_data_k.obj1_effect; else current.obj1_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "obj2_effect")) current.obj2_effect = line_data_k.obj2_effect; else current.obj2_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "text_effect")) current.text_effect = line_data_k.text_effect; else current.text_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "speaker1_flip")) current.speaker1_flip = line_data_k.speaker1_flip; else if (variable_struct_exists(sc_k, "speaker1_flip")) current.speaker1_flip = sc_k.speaker1_flip; else current.speaker1_flip = false;
        if (variable_struct_exists(line_data_k, "speaker2_flip")) current.speaker2_flip = line_data_k.speaker2_flip; else if (variable_struct_exists(sc_k, "speaker2_flip")) current.speaker2_flip = sc_k.speaker2_flip; else current.speaker2_flip = false;
        if (variable_struct_exists(line_data_k, "speaker3_flip")) current.speaker3_flip = line_data_k.speaker3_flip; else if (variable_struct_exists(sc_k, "speaker3_flip")) current.speaker3_flip = sc_k.speaker3_flip; else current.speaker3_flip = false;
        if (variable_struct_exists(line_data_k, "obj1_flip")) current.obj1_flip = line_data_k.obj1_flip; else if (variable_struct_exists(sc_k, "obj1_flip")) current.obj1_flip = sc_k.obj1_flip; else current.obj1_flip = false;
        if (variable_struct_exists(line_data_k, "obj2_flip")) current.obj2_flip = line_data_k.obj2_flip; else if (variable_struct_exists(sc_k, "obj2_flip")) current.obj2_flip = sc_k.obj2_flip; else current.obj2_flip = false;
        fx_sp1_start_ms = current_time;
        fx_sp2_start_ms = current_time;
        fx_sp3_start_ms = current_time;
        fx_obj1_start_ms = current_time;
        fx_obj2_start_ms = current_time;
update_bg_audio();
        var lenk = string_length(string(current.text));
        var cpsk = max(1, text_reveal_cps);
        var reveal_msk = ceil(lenk * 1000 / cpsk);
        var wait_msk = wait_after_default_ms;
        var has_explicit_wait_k = false;
        if (variable_struct_exists(line_data_k, "wait_after_ms")) { wait_msk = line_data_k.wait_after_ms; has_explicit_wait_k = true; } else if (variable_struct_exists(line_data_k, "wait_after")) { wait_msk = line_data_k.wait_after; has_explicit_wait_k = true; }
        var anim_ms_k = 0;
        var dur_base_k = fx_duration_ms;
        if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1k = dur_base_k; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1k *= fx_inverse_multiplier; anim_ms_k = max(anim_ms_k, d1k); }
        if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2k = dur_base_k; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2k *= fx_inverse_multiplier; anim_ms_k = max(anim_ms_k, d2k); }
        if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3k = dur_base_k; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3k *= fx_inverse_multiplier; anim_ms_k = max(anim_ms_k, d3k); }
        if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4k = dur_base_k; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4k *= fx_inverse_multiplier; anim_ms_k = max(anim_ms_k, d4k); }
        if (current.text_effect != "Aucune" && current.text_effect != "") { var dtk = dur_base_k; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtk *= fx_inverse_multiplier; anim_ms_k = max(anim_ms_k, dtk); }
        if (lenk == 0) line_auto_target_ms = current_time + anim_ms_k + wait_msk; else line_auto_target_ms = current_time + reveal_msk + wait_msk;
        input_block_frames = 4;
    }
}
{
    if (debug_auto_log) {
        if (current_time >= auto_dbg_next_probe_ms) {
            auto_dbg_next_probe_ms = current_time + auto_dbg_probe_interval;
            var scp = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
            if (scp != noone && is_array(scp.lines) && array_length(scp.lines) > 0) {
                var ldp = scp.lines[line_index];
                var txp = string(current.text);
                var txp_trim = string_replace_all(string_replace_all(string_replace_all(txp, " ", ""), "\n", ""), "\r", "");
                var lenp_trim2 = string_length(txp_trim);
                var cpsp2 = max(1, text_reveal_cps);
                var revealp_ms2 = ceil(string_length(txp) * 1000 / cpsp2);
                var waitp_ms2 = wait_after_default_ms;
                if (variable_struct_exists(ldp, "wait_after_ms")) waitp_ms2 = ldp.wait_after_ms;
                else if (variable_struct_exists(ldp, "wait_after")) waitp_ms2 = ldp.wait_after;
                var endp = fx_text_start_ms;
                var durp2 = fx_duration_ms;
                if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1p2 = durp2; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1p2 *= fx_inverse_multiplier; endp = max(endp, fx_sp1_start_ms + d1p2); }
                if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2p2 = durp2; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2p2 *= fx_inverse_multiplier; endp = max(endp, fx_sp2_start_ms + d2p2); }
                if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3p2 = durp2; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3p2 *= fx_inverse_multiplier; endp = max(endp, fx_sp3_start_ms + d3p2); }
                if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3p2 = durp2; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3p2 *= fx_inverse_multiplier; endp = max(endp, fx_obj1_start_ms + d3p2); }
                if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4p2 = durp2; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4p2 *= fx_inverse_multiplier; endp = max(endp, fx_obj2_start_ms + d4p2); }
                if (current.text_effect != "Aucune" && current.text_effect != "") { var dtp2 = durp2; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtp2 *= fx_inverse_multiplier; endp = max(endp, fx_text_start_ms + dtp2); }
                var targetp = (lenp_trim2 == 0) ? (endp + waitp_ms2) : (fx_text_start_ms + revealp_ms2 + waitp_ms2);
                show_debug_message("### Runner.Probe line=" + string(line_index) + " await=" + string(await_scene_click) + " len=" + string(lenp_trim2) + " end=" + string(endp) + " wait=" + string(waitp_ms2) + " target=" + string(targetp) + " now=" + string(current_time));
            }
        }
    }
{
    var scfb = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
    if (auto_mode && line_auto_target_ms != -1 && scfb != noone) {
        if (is_array(scfb.lines) && array_length(scfb.lines) > 0) {
            if (current_time >= line_auto_target_ms && line_index + 1 < array_length(scfb.lines)) {
                line_index += 1;
                var ldfb = scfb.lines[line_index];
                current.speaker = ldfb.speaker;
                current.text = ldfb.text;
                if (variable_struct_exists(ldfb, "portrait1_name")) current.portrait1_name = ldfb.portrait1_name;
                if (variable_struct_exists(ldfb, "portrait2_name")) current.portrait2_name = ldfb.portrait2_name;
                if (variable_struct_exists(ldfb, "portrait3_name")) current.portrait3_name = ldfb.portrait3_name;
                if (variable_struct_exists(ldfb, "obj1_name")) current.obj1_name = ldfb.obj1_name;
                if (variable_struct_exists(ldfb, "obj2_name")) current.obj2_name = ldfb.obj2_name;
                fx_text_start_ms = current_time;
                if (variable_struct_exists(ldfb, "bg")) current.bg_name = ldfb.bg;
                if (variable_struct_exists(ldfb, "bg_sound")) current.bg_sound = ldfb.bg_sound;
                if (variable_struct_exists(ldfb, "bg_sound2")) current.bg_sound2 = ldfb.bg_sound2;
                prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
                prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
                prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
                prev_object1_x = object1.x;    prev_object1_y = object1.y;
                prev_object2_x = object2.x;    prev_object2_y = object2.y;
                var krefb = 1;
                if (variable_struct_exists(ldfb, "speaker1_x")) speaker1.x = ldfb.speaker1_x * krefb;
                if (variable_struct_exists(ldfb, "speaker1_y")) speaker1.y = ldfb.speaker1_y * krefb;
                if (variable_struct_exists(ldfb, "speaker1_w")) speaker1.w = ldfb.speaker1_w * krefb;
                if (variable_struct_exists(ldfb, "speaker1_h")) speaker1.h = ldfb.speaker1_h * krefb;
                if (variable_struct_exists(ldfb, "speaker2_x")) speaker2.x = ldfb.speaker2_x * krefb;
                if (variable_struct_exists(ldfb, "speaker2_y")) speaker2.y = ldfb.speaker2_y * krefb;
                if (variable_struct_exists(ldfb, "speaker2_w")) speaker2.w = ldfb.speaker2_w * krefb;
                if (variable_struct_exists(ldfb, "speaker2_h")) speaker2.h = ldfb.speaker2_h * krefb;
                if (variable_struct_exists(ldfb, "speaker3_x")) speaker3.x = ldfb.speaker3_x * krefb;
                if (variable_struct_exists(ldfb, "speaker3_y")) speaker3.y = ldfb.speaker3_y * krefb;
                if (variable_struct_exists(ldfb, "speaker3_w")) speaker3.w = ldfb.speaker3_w * krefb;
                if (variable_struct_exists(ldfb, "speaker3_h")) speaker3.h = ldfb.speaker3_h * krefb;
                if (variable_struct_exists(ldfb, "obj1_x")) object1.x = ldfb.obj1_x * krefb;
                if (variable_struct_exists(ldfb, "obj1_y")) object1.y = ldfb.obj1_y * krefb;
                if (variable_struct_exists(ldfb, "obj1_w")) object1.w = ldfb.obj1_w * krefb;
                if (variable_struct_exists(ldfb, "obj1_h")) object1.h = ldfb.obj1_h * krefb;
                if (variable_struct_exists(ldfb, "obj2_x")) object2.x = ldfb.obj2_x * krefb;
                if (variable_struct_exists(ldfb, "obj2_y")) object2.y = ldfb.obj2_y * krefb;
                if (variable_struct_exists(ldfb, "obj2_w")) object2.w = ldfb.obj2_w * krefb;
                if (variable_struct_exists(ldfb, "obj2_h")) object2.h = ldfb.obj2_h * krefb;
                if (variable_struct_exists(ldfb, "textbox_x")) textbox.x = ldfb.textbox_x * krefb;
                if (variable_struct_exists(ldfb, "textbox_y")) textbox.y = ldfb.textbox_y * krefb;
                if (variable_struct_exists(ldfb, "portrait1_effect")) current.portrait1_effect = ldfb.portrait1_effect; else current.portrait1_effect = "Aucune";
                if (variable_struct_exists(ldfb, "portrait2_effect")) current.portrait2_effect = ldfb.portrait2_effect; else current.portrait2_effect = "Aucune";
                if (variable_struct_exists(ldfb, "obj1_effect")) current.obj1_effect = ldfb.obj1_effect; else current.obj1_effect = "Aucune";
                if (variable_struct_exists(ldfb, "obj2_effect")) current.obj2_effect = ldfb.obj2_effect; else current.obj2_effect = "Aucune";
                if (variable_struct_exists(ldfb, "text_effect")) current.text_effect = ldfb.text_effect; else current.text_effect = "Aucune";
                if (variable_struct_exists(ldfb, "portrait3_effect")) current.portrait3_effect = ldfb.portrait3_effect; else if (variable_struct_exists(scfb, "portrait3_effect")) current.portrait3_effect = scfb.portrait3_effect; else current.portrait3_effect = "Aucune";
                if (variable_struct_exists(ldfb, "speaker1_flip")) current.speaker1_flip = ldfb.speaker1_flip; else if (variable_struct_exists(scfb, "speaker1_flip")) current.speaker1_flip = scfb.speaker1_flip; else current.speaker1_flip = false;
                if (variable_struct_exists(ldfb, "speaker2_flip")) current.speaker2_flip = ldfb.speaker2_flip; else if (variable_struct_exists(scfb, "speaker2_flip")) current.speaker2_flip = scfb.speaker2_flip; else current.speaker2_flip = false;
                if (variable_struct_exists(ldfb, "speaker3_flip")) current.speaker3_flip = ldfb.speaker3_flip; else if (variable_struct_exists(scfb, "speaker3_flip")) current.speaker3_flip = scfb.speaker3_flip; else current.speaker3_flip = false;
                if (variable_struct_exists(ldfb, "obj1_flip")) current.obj1_flip = ldfb.obj1_flip; else if (variable_struct_exists(scfb, "obj1_flip")) current.obj1_flip = scfb.obj1_flip; else current.obj1_flip = false;
                if (variable_struct_exists(ldfb, "obj2_flip")) current.obj2_flip = ldfb.obj2_flip; else if (variable_struct_exists(scfb, "obj2_flip")) current.obj2_flip = scfb.obj2_flip; else current.obj2_flip = false;
                await_scene_click = false;
                fx_sp1_start_ms = current_time;
                fx_sp2_start_ms = current_time;
                fx_sp3_start_ms = current_time;
                fx_obj1_start_ms = current_time;
                fx_obj2_start_ms = current_time;

            }
        }
    }
}
{
    var scx = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
    if (scx != noone && is_array(scx.lines) && array_length(scx.lines) > 0) {
        var txfb = string(current.text);
        var txfb_trim = string_replace_all(string_replace_all(string_replace_all(txfb, " ", ""), "\n", ""), "\r", "");
        var lenfb_trim = string_length(txfb_trim);
        var cpsfb = max(1, text_reveal_cps);
        var revealfb_ms = ceil(string_length(txfb) * 1000 / cpsfb);
        var waitfb_ms = wait_after_default_ms;
        var has_waitfb = false;
        var ldfb2 = scx.lines[line_index];
        if (variable_struct_exists(ldfb2, "wait_after_ms")) { waitfb_ms = ldfb2.wait_after_ms; has_waitfb = true; }
        else if (variable_struct_exists(ldfb2, "wait_after")) { waitfb_ms = ldfb2.wait_after; has_waitfb = true; }
        var endfb = fx_text_start_ms;
        var durfb = fx_duration_ms;
        if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1fb = durfb; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1fb *= fx_inverse_multiplier; endfb = max(endfb, fx_sp1_start_ms + d1fb); }
        if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2fb = durfb; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2fb *= fx_inverse_multiplier; endfb = max(endfb, fx_sp2_start_ms + d2fb); }
        if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3fb = durfb; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3fb *= fx_inverse_multiplier; endfb = max(endfb, fx_sp3_start_ms + d3fb); }
        if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3fb = durfb; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3fb *= fx_inverse_multiplier; endfb = max(endfb, fx_obj1_start_ms + d3fb); }
        if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4fb = durfb; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4fb *= fx_inverse_multiplier; endfb = max(endfb, fx_obj2_start_ms + d4fb); }
        if (current.text_effect != "Aucune" && current.text_effect != "") { var dtfb = durfb; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtfb *= fx_inverse_multiplier; endfb = max(endfb, fx_text_start_ms + dtfb); }
        var targetfb;
        if (lenfb_trim == 0) {
            targetfb = endfb + waitfb_ms;
        } else {
            targetfb = fx_text_start_ms + revealfb_ms + waitfb_ms;
        }
        if (auto_mode && current_time >= targetfb && line_index + 1 < array_length(scx.lines)) {
            if (debug_auto_log) { show_debug_message("### Runner: fb advance from line " + string(line_index) + " at t=" + string(current_time)); }
            line_index += 1;
            var ldn = scx.lines[line_index];
            current.speaker = ldn.speaker;
            current.text = ldn.text;
            if (variable_struct_exists(ldn, "portrait1_name")) current.portrait1_name = ldn.portrait1_name;
            if (variable_struct_exists(ldn, "portrait2_name")) current.portrait2_name = ldn.portrait2_name;
            if (variable_struct_exists(ldn, "portrait3_name")) current.portrait3_name = ldn.portrait3_name;
            if (variable_struct_exists(ldn, "obj1_name")) current.obj1_name = ldn.obj1_name;
            if (variable_struct_exists(ldn, "obj2_name")) current.obj2_name = ldn.obj2_name;

            fx_text_start_ms = current_time;
            if (variable_struct_exists(ldn, "bg")) current.bg_name = ldn.bg;
            if (variable_struct_exists(ldn, "bg_sound")) current.bg_sound = ldn.bg_sound; else current.bg_sound = "";
            if (variable_struct_exists(ldn, "bg_sound2")) current.bg_sound2 = ldn.bg_sound2; else current.bg_sound2 = "";
            prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
            prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
            prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
            prev_object1_x = object1.x;    prev_object1_y = object1.y;
            prev_object2_x = object2.x;    prev_object2_y = object2.y;
            var krefn = 1;
            if (variable_struct_exists(ldn, "speaker1_x")) speaker1.x = ldn.speaker1_x * krefn;
            if (variable_struct_exists(ldn, "speaker1_y")) speaker1.y = ldn.speaker1_y * krefn;
            if (variable_struct_exists(ldn, "speaker1_w")) speaker1.w = ldn.speaker1_w * krefn;
            if (variable_struct_exists(ldn, "speaker1_h")) speaker1.h = ldn.speaker1_h * krefn;
            if (variable_struct_exists(ldn, "speaker2_x")) speaker2.x = ldn.speaker2_x * krefn;
            if (variable_struct_exists(ldn, "speaker2_y")) speaker2.y = ldn.speaker2_y * krefn;
            if (variable_struct_exists(ldn, "speaker2_w")) speaker2.w = ldn.speaker2_w * krefn;
            if (variable_struct_exists(ldn, "speaker2_h")) speaker2.h = ldn.speaker2_h * krefn;
            if (variable_struct_exists(ldn, "speaker3_x")) speaker3.x = ldn.speaker3_x * krefn;
            if (variable_struct_exists(ldn, "speaker3_y")) speaker3.y = ldn.speaker3_y * krefn;
            if (variable_struct_exists(ldn, "speaker3_w")) speaker3.w = ldn.speaker3_w * krefn;
            if (variable_struct_exists(ldn, "speaker3_h")) speaker3.h = ldn.speaker3_h * krefn;
            if (variable_struct_exists(ldn, "obj1_x")) object1.x = ldn.obj1_x * krefn;
            if (variable_struct_exists(ldn, "obj1_y")) object1.y = ldn.obj1_y * krefn;
            if (variable_struct_exists(ldn, "obj1_w")) object1.w = ldn.obj1_w * krefn;
            if (variable_struct_exists(ldn, "obj1_h")) object1.h = ldn.obj1_h * krefn;
            if (variable_struct_exists(ldn, "obj2_x")) object2.x = ldn.obj2_x * krefn;
            if (variable_struct_exists(ldn, "obj2_y")) object2.y = ldn.obj2_y * krefn;
            if (variable_struct_exists(ldn, "obj2_w")) object2.w = ldn.obj2_w * krefn;
            if (variable_struct_exists(ldn, "obj2_h")) object2.h = ldn.obj2_h * krefn;
            if (variable_struct_exists(ldn, "textbox_x")) textbox.x = ldn.textbox_x * krefn;
            if (variable_struct_exists(ldn, "textbox_y")) textbox.y = ldn.textbox_y * krefn;
            if (variable_struct_exists(ldn, "portrait1_effect")) current.portrait1_effect = ldn.portrait1_effect; else current.portrait1_effect = "Aucune";
            if (variable_struct_exists(ldn, "portrait2_effect")) current.portrait2_effect = ldn.portrait2_effect; else current.portrait2_effect = "Aucune";
            if (variable_struct_exists(ldn, "portrait3_effect")) current.portrait3_effect = ldn.portrait3_effect; else if (variable_struct_exists(scx, "portrait3_effect")) current.portrait3_effect = scx.portrait3_effect; else current.portrait3_effect = "Aucune";
            if (variable_struct_exists(ldn, "obj1_effect")) current.obj1_effect = ldn.obj1_effect; else current.obj1_effect = "Aucune";
            if (variable_struct_exists(ldn, "obj2_effect")) current.obj2_effect = ldn.obj2_effect; else current.obj2_effect = "Aucune";
            if (variable_struct_exists(ldn, "text_effect")) current.text_effect = ldn.text_effect; else current.text_effect = "Aucune";
            if (variable_struct_exists(ldn, "speaker1_flip")) current.speaker1_flip = ldn.speaker1_flip; else if (variable_struct_exists(scx, "speaker1_flip")) current.speaker1_flip = scx.speaker1_flip; else current.speaker1_flip = false;
            if (variable_struct_exists(ldn, "speaker2_flip")) current.speaker2_flip = ldn.speaker2_flip; else if (variable_struct_exists(scx, "speaker2_flip")) current.speaker2_flip = scx.speaker2_flip; else current.speaker2_flip = false;
            if (variable_struct_exists(ldn, "speaker3_flip")) current.speaker3_flip = ldn.speaker3_flip; else if (variable_struct_exists(scx, "speaker3_flip")) current.speaker3_flip = scx.speaker3_flip; else current.speaker3_flip = false;
            if (variable_struct_exists(ldn, "obj1_flip")) current.obj1_flip = ldn.obj1_flip; else if (variable_struct_exists(scx, "obj1_flip")) current.obj1_flip = scx.obj1_flip; else current.obj1_flip = false;
            if (variable_struct_exists(ldn, "obj2_flip")) current.obj2_flip = ldn.obj2_flip; else if (variable_struct_exists(scx, "obj2_flip")) current.obj2_flip = scx.obj2_flip; else current.obj2_flip = false;
            await_scene_click = false;
            fx_sp1_start_ms = current_time;
            fx_sp2_start_ms = current_time;
            fx_sp3_start_ms = current_time;
            fx_obj1_start_ms = current_time;
            fx_obj2_start_ms = current_time;
            update_bg_audio();
        }
    }
}
{
    var scn = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
    if (scn != noone && is_array(scn.lines) && array_length(scn.lines) > 0) {
        var ldnorm = scn.lines[line_index];
        var txn = string(current.text);
        var txn_trim = string_replace_all(string_replace_all(string_replace_all(txn, " ", ""), "\n", ""), "\r", "");
        var lenn = string_length(txn_trim);
        var waitn = wait_after_default_ms;
        var has_waitn = false;
        if (variable_struct_exists(ldnorm, "wait_after_ms")) { waitn = ldnorm.wait_after_ms; has_waitn = true; }
        else if (variable_struct_exists(ldnorm, "wait_after")) { waitn = ldnorm.wait_after; has_waitn = true; }
        if (has_waitn || lenn == 0) {
            await_scene_click = false;
        }
    }
}
    if (!panel_open && keyboard_check_pressed(vk_left) && sc_k != noone) {
        var has_lines_k2 = is_array(sc_k.lines) && array_length(sc_k.lines) > 0;
        if (has_lines_k2 && line_index > 0) {
            line_index -= 1;
            var ld_prev = sc_k.lines[line_index];
            current.speaker = ld_prev.speaker;
            current.text = ld_prev.text;
            if (variable_struct_exists(ld_prev, "portrait1_name")) current.portrait1_name = ld_prev.portrait1_name;
            if (variable_struct_exists(ld_prev, "portrait2_name")) current.portrait2_name = ld_prev.portrait2_name;
            if (variable_struct_exists(ld_prev, "portrait3_name")) current.portrait3_name = ld_prev.portrait3_name;
            if (variable_struct_exists(ld_prev, "obj1_name")) current.obj1_name = ld_prev.obj1_name;
            if (variable_struct_exists(ld_prev, "obj2_name")) current.obj2_name = ld_prev.obj2_name;

            fx_text_start_ms = current_time;
            if (variable_struct_exists(ld_prev, "bg")) current.bg_name = ld_prev.bg;
            if (variable_struct_exists(ld_prev, "bg_sound")) current.bg_sound = ld_prev.bg_sound;
            if (variable_struct_exists(ld_prev, "bg_sound2")) current.bg_sound2 = ld_prev.bg_sound2;
            prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
            prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
            prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
            prev_object1_x = object1.x;    prev_object1_y = object1.y;
            prev_object2_x = object2.x;    prev_object2_y = object2.y;
            var krefp = 1;
            if (variable_struct_exists(ld_prev, "speaker1_x")) speaker1.x = ld_prev.speaker1_x * krefp;
            if (variable_struct_exists(ld_prev, "speaker1_y")) speaker1.y = ld_prev.speaker1_y * krefp;
            if (variable_struct_exists(ld_prev, "speaker1_w")) speaker1.w = ld_prev.speaker1_w * krefp;
            if (variable_struct_exists(ld_prev, "speaker1_h")) speaker1.h = ld_prev.speaker1_h * krefp;
            if (variable_struct_exists(ld_prev, "speaker2_x")) speaker2.x = ld_prev.speaker2_x * krefp;
            if (variable_struct_exists(ld_prev, "speaker2_y")) speaker2.y = ld_prev.speaker2_y * krefp;
            if (variable_struct_exists(ld_prev, "speaker2_w")) speaker2.w = ld_prev.speaker2_w * krefp;
            if (variable_struct_exists(ld_prev, "speaker2_h")) speaker2.h = ld_prev.speaker2_h * krefp;
            if (variable_struct_exists(ld_prev, "speaker3_x")) speaker3.x = ld_prev.speaker3_x * krefp;
            if (variable_struct_exists(ld_prev, "speaker3_y")) speaker3.y = ld_prev.speaker3_y * krefp;
            if (variable_struct_exists(ld_prev, "speaker3_w")) speaker3.w = ld_prev.speaker3_w * krefp;
            if (variable_struct_exists(ld_prev, "speaker3_h")) speaker3.h = ld_prev.speaker3_h * krefp;
            if (variable_struct_exists(ld_prev, "obj1_x")) object1.x = ld_prev.obj1_x * krefp;
            if (variable_struct_exists(ld_prev, "obj1_y")) object1.y = ld_prev.obj1_y * krefp;
            if (variable_struct_exists(ld_prev, "obj1_w")) object1.w = ld_prev.obj1_w * krefp;
            if (variable_struct_exists(ld_prev, "obj1_h")) object1.h = ld_prev.obj1_h * krefp;
            if (variable_struct_exists(ld_prev, "obj2_x")) object2.x = ld_prev.obj2_x * krefp;
            if (variable_struct_exists(ld_prev, "obj2_y")) object2.y = ld_prev.obj2_y * krefp;
            if (variable_struct_exists(ld_prev, "obj2_w")) object2.w = ld_prev.obj2_w * krefp;
            if (variable_struct_exists(ld_prev, "obj2_h")) object2.h = ld_prev.obj2_h * krefp;
            if (variable_struct_exists(ld_prev, "textbox_x")) textbox.x = ld_prev.textbox_x * krefp;
            if (variable_struct_exists(ld_prev, "textbox_y")) textbox.y = ld_prev.textbox_y * krefp;
            if (variable_struct_exists(ld_prev, "portrait1_effect")) current.portrait1_effect = ld_prev.portrait1_effect; else current.portrait1_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "portrait2_effect")) current.portrait2_effect = ld_prev.portrait2_effect; else current.portrait2_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "portrait3_effect")) current.portrait3_effect = ld_prev.portrait3_effect; else if (variable_struct_exists(sc_k, "portrait3_effect")) current.portrait3_effect = sc_k.portrait3_effect; else current.portrait3_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "obj1_effect")) current.obj1_effect = ld_prev.obj1_effect; else current.obj1_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "obj2_effect")) current.obj2_effect = ld_prev.obj2_effect; else current.obj2_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "text_effect")) current.text_effect = ld_prev.text_effect; else current.text_effect = "Aucune";
            if (variable_struct_exists(ld_prev, "speaker1_flip")) current.speaker1_flip = ld_prev.speaker1_flip; else if (variable_struct_exists(sc_k, "speaker1_flip")) current.speaker1_flip = sc_k.speaker1_flip; else current.speaker1_flip = false;
            if (variable_struct_exists(ld_prev, "speaker2_flip")) current.speaker2_flip = ld_prev.speaker2_flip; else if (variable_struct_exists(sc_k, "speaker2_flip")) current.speaker2_flip = sc_k.speaker2_flip; else current.speaker2_flip = false;
            if (variable_struct_exists(ld_prev, "speaker3_flip")) current.speaker3_flip = ld_prev.speaker3_flip; else if (variable_struct_exists(sc_k, "speaker3_flip")) current.speaker3_flip = sc_k.speaker3_flip; else current.speaker3_flip = false;
            if (variable_struct_exists(ld_prev, "obj1_flip")) current.obj1_flip = ld_prev.obj1_flip; else if (variable_struct_exists(sc_k, "obj1_flip")) current.obj1_flip = sc_k.obj1_flip; else current.obj1_flip = false;
            if (variable_struct_exists(ld_prev, "obj2_flip")) current.obj2_flip = ld_prev.obj2_flip; else if (variable_struct_exists(sc_k, "obj2_flip")) current.obj2_flip = sc_k.obj2_flip; else current.obj2_flip = false;
            fx_sp1_start_ms = current_time;
            fx_sp2_start_ms = current_time;
            fx_sp3_start_ms = current_time;
            fx_obj1_start_ms = current_time;
            fx_obj2_start_ms = current_time;
            var lenp = string_length(string(current.text));
            var cpsp = max(1, text_reveal_cps);
        var reveal_msp = ceil(lenp * 1000 / cpsp);
        var wait_msp = wait_after_default_ms;
        var has_explicit_wait_prev = false;
        if (variable_struct_exists(ld_prev, "wait_after_ms")) { wait_msp = ld_prev.wait_after_ms; has_explicit_wait_prev = true; } else if (variable_struct_exists(ld_prev, "wait_after")) { wait_msp = ld_prev.wait_after; has_explicit_wait_prev = true; }
            var anim_ms_p = 0;
            var dur_base_p = fx_duration_ms;
            if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1p = dur_base_p; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1p *= fx_inverse_multiplier; anim_ms_p = max(anim_ms_p, d1p); }
            if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2p = dur_base_p; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2p *= fx_inverse_multiplier; anim_ms_p = max(anim_ms_p, d2p); }
            if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3p = dur_base_p; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3p *= fx_inverse_multiplier; anim_ms_p = max(anim_ms_p, d3p); }
            if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4p = dur_base_p; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4p *= fx_inverse_multiplier; anim_ms_p = max(anim_ms_p, d4p); }
            if (current.text_effect != "Aucune" && current.text_effect != "") { var dtp = dur_base_p; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtp *= fx_inverse_multiplier; anim_ms_p = max(anim_ms_p, dtp); }
            if (lenp == 0) {
                line_auto_target_ms = current_time + anim_ms_p + wait_msp;
            } else {
                line_auto_target_ms = current_time + reveal_msp + wait_msp;
            }
            input_block_frames = 4;
            }
        }
if (auto_mode && !await_scene_click) {
    if (array_length(scenes) == 0) exit;
    var sc = scenes[scene_index];
    var has_lines = is_array(sc.lines) && array_length(sc.lines) > 0;
    var txs_cur = string(current.text);
    var len_cur_raw = string_length(txs_cur);
    var txs_cur_trim = string_replace_all(string_replace_all(string_replace_all(txs_cur, " ", ""), "\n", ""), "\r", "");
    var len_cur = string_length(txs_cur_trim);
    var cps_cur = max(1, text_reveal_cps);
    var elapsed_ms_cur = current_time - fx_text_start_ms;
    var shown_cur = clamp(floor(elapsed_ms_cur * cps_cur / 1000), 0, len_cur);
    var wait_ms_cur = wait_after_default_ms;
    var has_explicit_wait = false;
    if (has_lines) {
        var ldcur = sc.lines[line_index];
        if (variable_struct_exists(ldcur, "wait_after_ms")) { wait_ms_cur = ldcur.wait_after_ms; has_explicit_wait = true; }
        else if (variable_struct_exists(ldcur, "wait_after")) { wait_ms_cur = ldcur.wait_after; has_explicit_wait = true; }
    }
    var reveal_ms_cur = ceil(len_cur_raw * 1000 / cps_cur);
    var dur_base_cur = fx_duration_ms;
    var end_anim_at = fx_text_start_ms;
    if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1c = dur_base_cur; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1c *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_sp1_start_ms + d1c); }
    if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2c = dur_base_cur; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2c *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_sp2_start_ms + d2c); }
    if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3c = dur_base_cur; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3c *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_sp3_start_ms + d3c); }
    if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3c = dur_base_cur; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3c *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_obj1_start_ms + d3c); }
    if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4c = dur_base_cur; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4c *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_obj2_start_ms + d4c); }
    if (current.text_effect != "Aucune" && current.text_effect != "") { var dtc = dur_base_cur; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtc *= fx_inverse_multiplier; end_anim_at = max(end_anim_at, fx_text_start_ms + dtc); }
    var target_now;
    if (len_cur == 0) {
        target_now = end_anim_at + wait_ms_cur;
    } else {
        target_now = fx_text_start_ms + reveal_ms_cur + wait_ms_cur;
    }
    line_auto_target_ms = target_now;
    if (debug_auto_log) {
        if (line_auto_target_ms != auto_dbg_target_logged) {
            auto_dbg_target_logged = line_auto_target_ms;
            show_debug_message("### Runner: line=" + string(line_index) + " has_wait=" + string(has_explicit_wait) + " len=" + string(len_cur) + " end_anim_at=" + string(end_anim_at) + " wait=" + string(wait_ms_cur) + " target=" + string(target_now));
        }
    }
    if (current_time >= target_now) {
            if (debug_auto_log && auto_dbg_last_advance_line != line_index) {
                auto_dbg_last_advance_line = line_index;
                show_debug_message("### Runner: advance from line " + string(line_index) + " at t=" + string(current_time));
            }
            if (has_lines && line_index + 1 < array_length(sc.lines)) {
                line_index += 1;
                var line_data = sc.lines[line_index];
                current.speaker = line_data.speaker;
                current.text = line_data.text;
                    if (variable_struct_exists(line_data, "portrait1_name")) current.portrait1_name = line_data.portrait1_name;
                    if (variable_struct_exists(line_data, "portrait2_name")) current.portrait2_name = line_data.portrait2_name;
                    if (variable_struct_exists(line_data, "portrait3_name")) current.portrait3_name = line_data.portrait3_name;
                    if (variable_struct_exists(line_data, "obj1_name")) current.obj1_name = line_data.obj1_name;
                    if (variable_struct_exists(line_data, "obj2_name")) current.obj2_name = line_data.obj2_name;

                    fx_text_start_ms = current_time;
                    if (variable_struct_exists(line_data, "bg")) current.bg_name = line_data.bg;
                    if (variable_struct_exists(line_data, "bg_sound")) current.bg_sound = line_data.bg_sound;
                    if (variable_struct_exists(line_data, "bg_sound2")) current.bg_sound2 = line_data.bg_sound2;
                    prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
                prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
                prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
                prev_object1_x = object1.x;    prev_object1_y = object1.y;
                prev_object2_x = object2.x;    prev_object2_y = object2.y;
                var krefl = 1;
                if (variable_struct_exists(line_data, "speaker1_x")) speaker1.x = line_data.speaker1_x * krefl;
                if (variable_struct_exists(line_data, "speaker1_y")) speaker1.y = line_data.speaker1_y * krefl;
                if (variable_struct_exists(line_data, "speaker1_w")) speaker1.w = line_data.speaker1_w * krefl;
                if (variable_struct_exists(line_data, "speaker1_h")) speaker1.h = line_data.speaker1_h * krefl;
                if (variable_struct_exists(line_data, "speaker2_x")) speaker2.x = line_data.speaker2_x * krefl;
                if (variable_struct_exists(line_data, "speaker2_y")) speaker2.y = line_data.speaker2_y * krefl;
                if (variable_struct_exists(line_data, "speaker2_w")) speaker2.w = line_data.speaker2_w * krefl;
                if (variable_struct_exists(line_data, "speaker2_h")) speaker2.h = line_data.speaker2_h * krefl;
                if (variable_struct_exists(line_data, "speaker3_x")) speaker3.x = line_data.speaker3_x * krefl;
                if (variable_struct_exists(line_data, "speaker3_y")) speaker3.y = line_data.speaker3_y * krefl;
                if (variable_struct_exists(line_data, "speaker3_w")) speaker3.w = line_data.speaker3_w * krefl;
                if (variable_struct_exists(line_data, "speaker3_h")) speaker3.h = line_data.speaker3_h * krefl;
                if (variable_struct_exists(line_data, "obj1_x")) object1.x = line_data.obj1_x * krefl;
                if (variable_struct_exists(line_data, "obj1_y")) object1.y = line_data.obj1_y * krefl;
                if (variable_struct_exists(line_data, "obj1_w")) object1.w = line_data.obj1_w * krefl;
                if (variable_struct_exists(line_data, "obj1_h")) object1.h = line_data.obj1_h * krefl;
                if (variable_struct_exists(line_data, "obj2_x")) object2.x = line_data.obj2_x * krefl;
                if (variable_struct_exists(line_data, "obj2_y")) object2.y = line_data.obj2_y * krefl;
                if (variable_struct_exists(line_data, "obj2_w")) object2.w = line_data.obj2_w * krefl;
                if (variable_struct_exists(line_data, "obj2_h")) object2.h = line_data.obj2_h * krefl;
                if (variable_struct_exists(line_data, "textbox_x")) textbox.x = line_data.textbox_x * krefl;
                if (variable_struct_exists(line_data, "textbox_y")) textbox.y = line_data.textbox_y * krefl;
                if (variable_struct_exists(line_data, "portrait1_effect")) current.portrait1_effect = line_data.portrait1_effect; else current.portrait1_effect = "Aucune";
                if (variable_struct_exists(line_data, "portrait2_effect")) current.portrait2_effect = line_data.portrait2_effect; else current.portrait2_effect = "Aucune";
                    if (variable_struct_exists(line_data, "portrait3_effect")) current.portrait3_effect = line_data.portrait3_effect; else if (variable_struct_exists(sc, "portrait3_effect")) current.portrait3_effect = sc.portrait3_effect; else current.portrait3_effect = "Aucune";
                if (variable_struct_exists(line_data, "obj1_effect")) current.obj1_effect = line_data.obj1_effect; else current.obj1_effect = "Aucune";
                if (variable_struct_exists(line_data, "obj2_effect")) current.obj2_effect = line_data.obj2_effect; else current.obj2_effect = "Aucune";
                if (variable_struct_exists(line_data, "text_effect")) current.text_effect = line_data.text_effect; else current.text_effect = "Aucune";
                if (variable_struct_exists(line_data, "speaker1_flip")) current.speaker1_flip = line_data.speaker1_flip; else if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
                if (variable_struct_exists(line_data, "speaker2_flip")) current.speaker2_flip = line_data.speaker2_flip; else if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
                if (variable_struct_exists(line_data, "speaker3_flip")) current.speaker3_flip = line_data.speaker3_flip; else if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
                if (variable_struct_exists(line_data, "obj1_flip")) current.obj1_flip = line_data.obj1_flip; else if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
                if (variable_struct_exists(line_data, "obj2_flip")) current.obj2_flip = line_data.obj2_flip; else if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
                await_scene_click = false;
                fx_sp1_start_ms = current_time;
                fx_sp2_start_ms = current_time;
                fx_sp3_start_ms = current_time;
                fx_obj1_start_ms = current_time;
                fx_obj2_start_ms = current_time;
                line_auto_target_ms = -1;
                var new_bg_asset_l = asset_get_index(current.bg_sound);
                if (new_bg_asset_l == bg_sound_asset_current) {
                } else if (new_bg_asset_l != -1) {
                    if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); }
                    audio_play_sound(new_bg_asset_l, 0, true);
                    bg_sound_asset_current = new_bg_asset_l;
                } else {
                    if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); bg_sound_asset_current = -1; }
                }
                var new_bg2_asset_l = asset_get_index(current.bg_sound2);
                if (new_bg2_asset_l == bg2_sound_asset_current) {
                } else if (new_bg2_asset_l != -1) {
                    if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); }
                    audio_play_sound(new_bg2_asset_l, 0, true);
                    bg2_sound_asset_current = new_bg2_asset_l;
                } else {
                    if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); bg2_sound_asset_current = -1; }
                }

                var lenl = string_length(string(current.text));
                var cpsl = max(1, text_reveal_cps);
                var reveal_msl = ceil(lenl * 1000 / cpsl);
                var wait_msl = wait_after_default_ms;
                var has_explicit_wait_l = false;
                if (variable_struct_exists(line_data, "wait_after_ms")) { wait_msl = line_data.wait_after_ms; has_explicit_wait_l = true; } else if (variable_struct_exists(line_data, "wait_after")) { wait_msl = line_data.wait_after; has_explicit_wait_l = true; }
                var anim_ms_l = 0;
                var dur_base_l = fx_duration_ms;
                if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1l = dur_base_l; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1l *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, d1l); }
                if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2l = dur_base_l; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2l *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, d2l); }
                if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3l = dur_base_l; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3l *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, d3l); }
                if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3l = dur_base_l; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3l *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, d3l); }
                if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4l = dur_base_l; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4l *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, d4l); }
                if (current.text_effect != "Aucune" && current.text_effect != "") { var dtl = dur_base_l; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtl *= fx_inverse_multiplier; anim_ms_l = max(anim_ms_l, dtl); }
                if (lenl == 0) line_auto_target_ms = current_time + anim_ms_l + wait_msl; else line_auto_target_ms = current_time + reveal_msl + wait_msl;
            } else {
                // --- MODIFIED DUEL TRIGGER LOGIC ---
                var trigger_duel = false;
                var is_last_line = (line_index == array_length(sc.lines) - 1);
                
                if (variable_struct_exists(sc, "duel_bot_id") && is_last_line) {
                    var bid = sc.duel_bot_id;
                    var is_valid = (bid != 0 && string(bid) != "0" && bid != noone);
                    
                    // HOTFIX: Handle numeric IDs (Legacy)
                    if (is_real(bid)) {
                        if (bid == 1) {
                            if (scene_index > 0) {
                                show_debug_message("### Step_0 V2: Legacy ID 1 detected at scene " + string(scene_index) + ". Converting to Invasion_Gueule_Roche.");
                                sc.duel_bot_id = "Invasion_Gueule_Roche";
                                bid = "Invasion_Gueule_Roche";
                                is_valid = true;
                            } else {
                                show_debug_message("### Step_0 V2: BLOCKED LEGACY duel_bot_id: 1 at Scene 0");
                                is_valid = false;
                            }
                        }
                        else if (bid == 2) {
                            show_debug_message("### Step_0 V2: Legacy ID 2 detected. Converting to Essaim_Abyssien.");
                            sc.duel_bot_id = "Essaim_Abyssien";
                            bid = "Essaim_Abyssien";
                            is_valid = true;
                        }
                        else if (bid == 3) {
                            show_debug_message("### Step_0 V2: Legacy ID 3 detected. Converting to Bandit_Grand_Chemin.");
                            sc.duel_bot_id = "Bandit_Grand_Chemin";
                            bid = "Bandit_Grand_Chemin";
                            is_valid = true;
                        }
                    }

            if (is_valid) {
                 trigger_duel = true;
                 show_debug_message("### Step_0 V2: Duel Trigger VALIDATED for ID: " + string(bid));
            }
                }

                if (trigger_duel) {
                    if (!instance_exists(oDuelConfirmation)) {
                        var inst = instance_create_depth(0, 0, -9999, oDuelConfirmation);
                        inst.selected_bot_deck_id = sc.duel_bot_id;
                        
                        // IMPORTANT: Set global variable for display
                        global.selected_bot_deck_id = sc.duel_bot_id;
                        
                        show_debug_message("### Step_0: Created oDuelConfirmation with ID: " + string(sc.duel_bot_id));
                    }
                    await_scene_click = true;
                } else {
                    await_scene_click = true;
                }
            }
        }
    }
}
{
    if (array_length(scenes) > 0) {
        var sca = scenes[scene_index];
        if (is_array(sca.lines) && array_length(sca.lines) > 0) {
            var lda = sca.lines[line_index];
            var txa = string(current.text);
            var lena = string_length(txa);
            var wait_a = wait_after_default_ms;
            var has_wait_a = false;
            if (variable_struct_exists(lda, "wait_after_ms")) { wait_a = lda.wait_after_ms; has_wait_a = true; }
            else if (variable_struct_exists(lda, "wait_after")) { wait_a = lda.wait_after; has_wait_a = true; }
            var end_anim_a = fx_text_start_ms;
            var durb = fx_duration_ms;
            if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1a = durb; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1a *= fx_inverse_multiplier; end_anim_a = max(end_anim_a, fx_sp1_start_ms + d1a); }
            if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2a = durb; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2a *= fx_inverse_multiplier; end_anim_a = max(end_anim_a, fx_sp2_start_ms + d2a); }
            if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3a = durb; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3a *= fx_inverse_multiplier; end_anim_a = max(end_anim_a, fx_obj1_start_ms + d3a); }
            if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4a = durb; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4a *= fx_inverse_multiplier; end_anim_a = max(end_anim_a, fx_obj2_start_ms + d4a); }
            if (current.text_effect != "Aucune" && current.text_effect != "") { var dta = durb; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dta *= fx_inverse_multiplier; end_anim_a = max(end_anim_a, fx_text_start_ms + dta); }
            var trig_a = (has_wait_a && lena == 0 && current_time >= end_anim_a + wait_a);
            if (trig_a && line_index + 1 < array_length(sca.lines)) {
                if (debug_auto_log) { show_debug_message("### Runner: unconditional advance from line " + string(line_index) + " at t=" + string(current_time)); }
                line_index += 1;
                var line_adv = sca.lines[line_index];
                current.speaker = line_adv.speaker;
                current.text = line_adv.text;
                if (variable_struct_exists(line_adv, "portrait1_name")) current.portrait1_name = line_adv.portrait1_name;
                if (variable_struct_exists(line_adv, "portrait2_name")) current.portrait2_name = line_adv.portrait2_name;
                if (variable_struct_exists(line_adv, "portrait3_name")) current.portrait3_name = line_adv.portrait3_name;
                if (variable_struct_exists(line_adv, "obj1_name")) current.obj1_name = line_adv.obj1_name;
                if (variable_struct_exists(line_adv, "obj2_name")) current.obj2_name = line_adv.obj2_name;

                fx_text_start_ms = current_time;
                prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
                prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
                prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
                prev_object1_x = object1.x;    prev_object1_y = object1.y;
                prev_object2_x = object2.x;    prev_object2_y = object2.y;
                var krefa = 1;
                if (variable_struct_exists(line_adv, "speaker1_x")) speaker1.x = line_adv.speaker1_x * krefa;
                if (variable_struct_exists(line_adv, "speaker1_y")) speaker1.y = line_adv.speaker1_y * krefa;
                if (variable_struct_exists(line_adv, "speaker1_w")) speaker1.w = line_adv.speaker1_w * krefa;
                if (variable_struct_exists(line_adv, "speaker1_h")) speaker1.h = line_adv.speaker1_h * krefa;
                if (variable_struct_exists(line_adv, "speaker2_x")) speaker2.x = line_adv.speaker2_x * krefa;
                if (variable_struct_exists(line_adv, "speaker2_y")) speaker2.y = line_adv.speaker2_y * krefa;
                if (variable_struct_exists(line_adv, "speaker2_w")) speaker2.w = line_adv.speaker2_w * krefa;
                if (variable_struct_exists(line_adv, "speaker2_h")) speaker2.h = line_adv.speaker2_h * krefa;
                if (variable_struct_exists(line_adv, "speaker3_x")) speaker3.x = line_adv.speaker3_x * krefa;
                if (variable_struct_exists(line_adv, "speaker3_y")) speaker3.y = line_adv.speaker3_y * krefa;
                if (variable_struct_exists(line_adv, "speaker3_w")) speaker3.w = line_adv.speaker3_w * krefa;
                if (variable_struct_exists(line_adv, "speaker3_h")) speaker3.h = line_adv.speaker3_h * krefa;
                if (variable_struct_exists(line_adv, "obj1_x")) object1.x = line_adv.obj1_x * krefa;
                if (variable_struct_exists(line_adv, "obj1_y")) object1.y = line_adv.obj1_y * krefa;
                if (variable_struct_exists(line_adv, "obj1_w")) object1.w = line_adv.obj1_w * krefa;
                if (variable_struct_exists(line_adv, "obj1_h")) object1.h = line_adv.obj1_h * krefa;
                if (variable_struct_exists(line_adv, "obj2_x")) object2.x = line_adv.obj2_x * krefa;
                if (variable_struct_exists(line_adv, "obj2_y")) object2.y = line_adv.obj2_y * krefa;
                if (variable_struct_exists(line_adv, "obj2_w")) object2.w = line_adv.obj2_w * krefa;
                if (variable_struct_exists(line_adv, "obj2_h")) object2.h = line_adv.obj2_h * krefa;
                if (variable_struct_exists(line_adv, "textbox_x")) textbox.x = line_adv.textbox_x * krefa;
                if (variable_struct_exists(line_adv, "textbox_y")) textbox.y = line_adv.textbox_y * krefa;
                if (variable_struct_exists(line_adv, "portrait1_effect")) current.portrait1_effect = line_adv.portrait1_effect; else current.portrait1_effect = "Aucune";
                if (variable_struct_exists(line_adv, "portrait2_effect")) current.portrait2_effect = line_adv.portrait2_effect; else current.portrait2_effect = "Aucune";
                if (variable_struct_exists(line_adv, "portrait3_effect")) current.portrait3_effect = line_adv.portrait3_effect; else if (variable_struct_exists(sca, "portrait3_effect")) current.portrait3_effect = sca.portrait3_effect; else current.portrait3_effect = "Aucune";
                if (variable_struct_exists(line_adv, "obj1_effect")) current.obj1_effect = line_adv.obj1_effect; else current.obj1_effect = "Aucune";
                if (variable_struct_exists(line_adv, "obj2_effect")) current.obj2_effect = line_adv.obj2_effect; else current.obj2_effect = "Aucune";
                if (variable_struct_exists(line_adv, "text_effect")) current.text_effect = line_adv.text_effect; else current.text_effect = "Aucune";
                if (variable_struct_exists(line_adv, "speaker1_flip")) current.speaker1_flip = line_adv.speaker1_flip; else if (variable_struct_exists(sca, "speaker1_flip")) current.speaker1_flip = sca.speaker1_flip; else current.speaker1_flip = false;
                if (variable_struct_exists(line_adv, "speaker2_flip")) current.speaker2_flip = line_adv.speaker2_flip; else if (variable_struct_exists(sca, "speaker2_flip")) current.speaker2_flip = sca.speaker2_flip; else current.speaker2_flip = false;
                if (variable_struct_exists(line_adv, "speaker3_flip")) current.speaker3_flip = line_adv.speaker3_flip; else if (variable_struct_exists(sca, "speaker3_flip")) current.speaker3_flip = sca.speaker3_flip; else current.speaker3_flip = false;
                if (variable_struct_exists(line_adv, "obj1_flip")) current.obj1_flip = line_adv.obj1_flip; else if (variable_struct_exists(sca, "obj1_flip")) current.obj1_flip = sca.obj1_flip; else current.obj1_flip = false;
                if (variable_struct_exists(line_adv, "obj2_flip")) current.obj2_flip = line_adv.obj2_flip; else if (variable_struct_exists(sca, "obj2_flip")) current.obj2_flip = sca.obj2_flip; else current.obj2_flip = false;
                await_scene_click = false;
                fx_sp1_start_ms = current_time;
                fx_sp2_start_ms = current_time;
                fx_sp3_start_ms = current_time;
                fx_obj1_start_ms = current_time;
                fx_obj2_start_ms = current_time;

            }
        }
    }
}
if (auto_mode && await_scene_click) {
    if (array_length(scenes) == 0) exit;
    var scf = scenes[scene_index];
    var has_lines_f = is_array(scf.lines) && array_length(scf.lines) > 0;
    var txs_f = string(current.text);
    var txs_f_trim = string_replace_all(string_replace_all(string_replace_all(txs_f, " ", ""), "\n", ""), "\r", "");
    var len_f = string_length(txs_f_trim);
    var cps_f = max(1, text_reveal_cps);
    var wait_ms_f = wait_after_default_ms;
    var has_wait_f = false;
    if (has_lines_f) {
        var ldf = scf.lines[line_index];
        if (variable_struct_exists(ldf, "wait_after_ms")) { wait_ms_f = ldf.wait_after_ms; has_wait_f = true; }
        else if (variable_struct_exists(ldf, "wait_after")) { wait_ms_f = ldf.wait_after; has_wait_f = true; }
    }
    var dur_base_f = fx_duration_ms;
    var end_anim_f = fx_text_start_ms;
    if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1f = dur_base_f; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1f *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_sp1_start_ms + d1f); }
    if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2f = dur_base_f; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2f *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_sp2_start_ms + d2f); }
    if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3f = dur_base_f; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3f *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_sp3_start_ms + d3f); }
    if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3f = dur_base_f; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3f *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_obj1_start_ms + d3f); }
    if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4f = dur_base_f; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4f *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_obj2_start_ms + d4f); }
    if (current.text_effect != "Aucune" && current.text_effect != "") { var dtf = dur_base_f; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtf *= fx_inverse_multiplier; end_anim_f = max(end_anim_f, fx_text_start_ms + dtf); }
    var trigger_f = (has_wait_f && len_f == 0 && current_time >= end_anim_f + wait_ms_f);
    if (trigger_f && has_lines_f && line_index + 1 < array_length(scf.lines)) {
        if (debug_auto_log) { show_debug_message("### Runner: force advance from line " + string(line_index) + " at t=" + string(current_time)); }
        line_index += 1;
        var line_data_f = scf.lines[line_index];
        current.speaker = line_data_f.speaker;
        current.text = line_data_f.text;
        if (variable_struct_exists(line_data_f, "portrait1_name")) current.portrait1_name = line_data_f.portrait1_name;
        if (variable_struct_exists(line_data_f, "portrait2_name")) current.portrait2_name = line_data_f.portrait2_name;
        if (variable_struct_exists(line_data_f, "portrait3_name")) current.portrait3_name = line_data_f.portrait3_name;
        if (variable_struct_exists(line_data_f, "obj1_name")) current.obj1_name = line_data_f.obj1_name;
        if (variable_struct_exists(line_data_f, "obj2_name")) current.obj2_name = line_data_f.obj2_name;

        fx_text_start_ms = current_time;
        if (variable_struct_exists(line_data_f, "bg")) current.bg_name = line_data_f.bg;
        if (variable_struct_exists(line_data_f, "bg_sound")) current.bg_sound = line_data_f.bg_sound; else if (!variable_struct_exists(scf, "bg_sound")) current.bg_sound = "";
        if (variable_struct_exists(line_data_f, "bg_sound2")) current.bg_sound2 = line_data_f.bg_sound2; else if (!variable_struct_exists(scf, "bg_sound2")) current.bg_sound2 = "";
        prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
        prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
        prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
        prev_object1_x = object1.x;    prev_object1_y = object1.y;
        prev_object2_x = object2.x;    prev_object2_y = object2.y;
        var kref_f = 1;
        if (variable_struct_exists(line_data_f, "speaker1_x")) speaker1.x = line_data_f.speaker1_x * kref_f;
        if (variable_struct_exists(line_data_f, "speaker1_y")) speaker1.y = line_data_f.speaker1_y * kref_f;
        if (variable_struct_exists(line_data_f, "speaker1_w")) speaker1.w = line_data_f.speaker1_w * kref_f;
        if (variable_struct_exists(line_data_f, "speaker1_h")) speaker1.h = line_data_f.speaker1_h * kref_f;
        if (variable_struct_exists(line_data_f, "speaker2_x")) speaker2.x = line_data_f.speaker2_x * kref_f;
        if (variable_struct_exists(line_data_f, "speaker2_y")) speaker2.y = line_data_f.speaker2_y * kref_f;
        if (variable_struct_exists(line_data_f, "speaker2_w")) speaker2.w = line_data_f.speaker2_w * kref_f;
        if (variable_struct_exists(line_data_f, "speaker2_h")) speaker2.h = line_data_f.speaker2_h * kref_f;
        if (variable_struct_exists(line_data_f, "speaker3_x")) speaker3.x = line_data_f.speaker3_x * kref_f;
        if (variable_struct_exists(line_data_f, "speaker3_y")) speaker3.y = line_data_f.speaker3_y * kref_f;
        if (variable_struct_exists(line_data_f, "speaker3_w")) speaker3.w = line_data_f.speaker3_w * kref_f;
        if (variable_struct_exists(line_data_f, "speaker3_h")) speaker3.h = line_data_f.speaker3_h * kref_f;
        if (variable_struct_exists(line_data_f, "obj1_x")) object1.x = line_data_f.obj1_x * kref_f;
        if (variable_struct_exists(line_data_f, "obj1_y")) object1.y = line_data_f.obj1_y * kref_f;
        if (variable_struct_exists(line_data_f, "obj1_w")) object1.w = line_data_f.obj1_w * kref_f;
        if (variable_struct_exists(line_data_f, "obj1_h")) object1.h = line_data_f.obj1_h * kref_f;
        if (variable_struct_exists(line_data_f, "obj2_x")) object2.x = line_data_f.obj2_x * kref_f;
        if (variable_struct_exists(line_data_f, "obj2_y")) object2.y = line_data_f.obj2_y * kref_f;
        if (variable_struct_exists(line_data_f, "obj2_w")) object2.w = line_data_f.obj2_w * kref_f;
        if (variable_struct_exists(line_data_f, "obj2_h")) object2.h = line_data_f.obj2_h * kref_f;
        if (variable_struct_exists(line_data_f, "textbox_x")) textbox.x = line_data_f.textbox_x * kref_f;
        if (variable_struct_exists(line_data_f, "textbox_y")) textbox.y = line_data_f.textbox_y * kref_f;
        if (variable_struct_exists(line_data_f, "portrait1_effect")) current.portrait1_effect = line_data_f.portrait1_effect; else current.portrait1_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "portrait2_effect")) current.portrait2_effect = line_data_f.portrait2_effect; else current.portrait2_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "portrait3_effect")) current.portrait3_effect = line_data_f.portrait3_effect; else if (variable_struct_exists(scf, "portrait3_effect")) current.portrait3_effect = scf.portrait3_effect; else current.portrait3_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "obj1_effect")) current.obj1_effect = line_data_f.obj1_effect; else current.obj1_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "obj2_effect")) current.obj2_effect = line_data_f.obj2_effect; else current.obj2_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "text_effect")) current.text_effect = line_data_f.text_effect; else current.text_effect = "Aucune";
        if (variable_struct_exists(line_data_f, "speaker1_flip")) current.speaker1_flip = line_data_f.speaker1_flip; else if (variable_struct_exists(scf, "speaker1_flip")) current.speaker1_flip = scf.speaker1_flip; else current.speaker1_flip = false;
        if (variable_struct_exists(line_data_f, "speaker2_flip")) current.speaker2_flip = line_data_f.speaker2_flip; else if (variable_struct_exists(scf, "speaker2_flip")) current.speaker2_flip = scf.speaker2_flip; else current.speaker2_flip = false;
        if (variable_struct_exists(line_data_f, "speaker3_flip")) current.speaker3_flip = line_data_f.speaker3_flip; else if (variable_struct_exists(scf, "speaker3_flip")) current.speaker3_flip = scf.speaker3_flip; else current.speaker3_flip = false;
        if (variable_struct_exists(line_data_f, "obj1_flip")) current.obj1_flip = line_data_f.obj1_flip; else if (variable_struct_exists(scf, "obj1_flip")) current.obj1_flip = scf.obj1_flip; else current.obj1_flip = false;
        if (variable_struct_exists(line_data_f, "obj2_flip")) current.obj2_flip = line_data_f.obj2_flip; else if (variable_struct_exists(scf, "obj2_flip")) current.obj2_flip = scf.obj2_flip; else current.obj2_flip = false;
        await_scene_click = false;
        fx_sp1_start_ms = current_time;
        fx_sp2_start_ms = current_time;
        fx_sp3_start_ms = current_time;
        fx_obj1_start_ms = current_time;
        fx_obj2_start_ms = current_time;
    }
}
{
    var scz = (array_length(scenes) > 0) ? scenes[scene_index] : noone;
    if (scz != noone && is_array(scz.lines) && array_length(scz.lines) > 0) {
        var txz = string(current.text);
        var txz_trim = string_replace_all(string_replace_all(string_replace_all(txz, " ", ""), "\n", ""), "\r", "");
        var lenz_trim = string_length(txz_trim);
        var cpsz = max(1, text_reveal_cps);
        var revealz_ms = ceil(string_length(txz) * 1000 / cpsz);
        var waitz_ms = wait_after_default_ms;
        var has_waitz = false;
        var ldz = scz.lines[line_index];
        if (variable_struct_exists(ldz, "wait_after_ms")) { waitz_ms = ldz.wait_after_ms; has_waitz = true; }
        else if (variable_struct_exists(ldz, "wait_after")) { waitz_ms = ldz.wait_after; has_waitz = true; }
        var endz = fx_text_start_ms;
        var durz = fx_duration_ms;
        if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d1z = durz; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d1z *= fx_inverse_multiplier; endz = max(endz, fx_sp1_start_ms + d1z); }
        if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d2z = durz; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d2z *= fx_inverse_multiplier; endz = max(endz, fx_sp2_start_ms + d2z); }
        if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d3z = durz; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d3z *= fx_inverse_multiplier; endz = max(endz, fx_sp3_start_ms + d3z); }
        if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d3z = durz; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d3z *= fx_inverse_multiplier; endz = max(endz, fx_obj1_start_ms + d3z); }
        if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d4z = durz; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d4z *= fx_inverse_multiplier; endz = max(endz, fx_obj2_start_ms + d4z); }
        if (current.text_effect != "Aucune" && current.text_effect != "") { var dtz = durz; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dtz *= fx_inverse_multiplier; endz = max(endz, fx_text_start_ms + dtz); }
        var targetz;
        if (lenz_trim == 0) {
            targetz = endz + waitz_ms;
        } else {
            targetz = fx_text_start_ms + revealz_ms + waitz_ms;
        }
        if (auto_mode && current_time >= targetz && line_index + 1 < array_length(scz.lines)) {
            if (debug_auto_log) { show_debug_message("### Runner: final fallback advance from line " + string(line_index) + " at t=" + string(current_time)); }
            line_index += 1;
            var ldnz = scz.lines[line_index];
            current.speaker = ldnz.speaker;
            current.text = ldnz.text;
            if (variable_struct_exists(ldnz, "portrait1_name")) current.portrait1_name = ldnz.portrait1_name;
            if (variable_struct_exists(ldnz, "portrait2_name")) current.portrait2_name = ldnz.portrait2_name;
            if (variable_struct_exists(ldnz, "portrait3_name")) current.portrait3_name = ldnz.portrait3_name;
            if (variable_struct_exists(ldnz, "obj1_name")) current.obj1_name = ldnz.obj1_name;
            if (variable_struct_exists(ldnz, "obj2_name")) current.obj2_name = ldnz.obj2_name;

            fx_text_start_ms = current_time;
            if (variable_struct_exists(ldnz, "bg")) current.bg_name = ldnz.bg;
            if (variable_struct_exists(ldnz, "bg_sound")) current.bg_sound = ldnz.bg_sound; else current.bg_sound = "";
            if (variable_struct_exists(ldnz, "bg_sound2")) current.bg_sound2 = ldnz.bg_sound2; else current.bg_sound2 = "";
            prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
            prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
            prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
            prev_object1_x = object1.x;    prev_object1_y = object1.y;
            prev_object2_x = object2.x;    prev_object2_y = object2.y;
            var krefz = 1;
            if (variable_struct_exists(ldnz, "speaker1_x")) speaker1.x = ldnz.speaker1_x * krefz;
            if (variable_struct_exists(ldnz, "speaker1_y")) speaker1.y = ldnz.speaker1_y * krefz;
            if (variable_struct_exists(ldnz, "speaker1_w")) speaker1.w = ldnz.speaker1_w * krefz;
            if (variable_struct_exists(ldnz, "speaker1_h")) speaker1.h = ldnz.speaker1_h * krefz;
            if (variable_struct_exists(ldnz, "speaker2_x")) speaker2.x = ldnz.speaker2_x * krefz;
            if (variable_struct_exists(ldnz, "speaker2_y")) speaker2.y = ldnz.speaker2_y * krefz;
            if (variable_struct_exists(ldnz, "speaker2_w")) speaker2.w = ldnz.speaker2_w * krefz;
            if (variable_struct_exists(ldnz, "speaker2_h")) speaker2.h = ldnz.speaker2_h * krefz;
            if (variable_struct_exists(ldnz, "speaker3_x")) speaker3.x = ldnz.speaker3_x * krefz;
            if (variable_struct_exists(ldnz, "speaker3_y")) speaker3.y = ldnz.speaker3_y * krefz;
            if (variable_struct_exists(ldnz, "speaker3_w")) speaker3.w = ldnz.speaker3_w * krefz;
            if (variable_struct_exists(ldnz, "speaker3_h")) speaker3.h = ldnz.speaker3_h * krefz;
            if (variable_struct_exists(ldnz, "obj1_x")) object1.x = ldnz.obj1_x * krefz;
            if (variable_struct_exists(ldnz, "obj1_y")) object1.y = ldnz.obj1_y * krefz;
            if (variable_struct_exists(ldnz, "obj1_w")) object1.w = ldnz.obj1_w * krefz;
            if (variable_struct_exists(ldnz, "obj1_h")) object1.h = ldnz.obj1_h * krefz;
            if (variable_struct_exists(ldnz, "obj2_x")) object2.x = ldnz.obj2_x * krefz;
            if (variable_struct_exists(ldnz, "obj2_y")) object2.y = ldnz.obj2_y * krefz;
            if (variable_struct_exists(ldnz, "obj2_w")) object2.w = ldnz.obj2_w * krefz;
            if (variable_struct_exists(ldnz, "obj2_h")) object2.h = ldnz.obj2_h * krefz;
            if (variable_struct_exists(ldnz, "textbox_x")) textbox.x = ldnz.textbox_x * krefz;
            if (variable_struct_exists(ldnz, "textbox_y")) textbox.y = ldnz.textbox_y * krefz;
            if (variable_struct_exists(ldnz, "portrait1_effect")) current.portrait1_effect = ldnz.portrait1_effect; else current.portrait1_effect = "Aucune";
            if (variable_struct_exists(ldnz, "portrait2_effect")) current.portrait2_effect = ldnz.portrait2_effect; else current.portrait2_effect = "Aucune";
            if (variable_struct_exists(ldnz, "portrait3_effect")) current.portrait3_effect = ldnz.portrait3_effect; else if (variable_struct_exists(scz, "portrait3_effect")) current.portrait3_effect = scz.portrait3_effect; else current.portrait3_effect = "Aucune";
            if (variable_struct_exists(ldnz, "obj1_effect")) current.obj1_effect = ldnz.obj1_effect; else current.obj1_effect = "Aucune";
            if (variable_struct_exists(ldnz, "obj2_effect")) current.obj2_effect = ldnz.obj2_effect; else current.obj2_effect = "Aucune";
            if (variable_struct_exists(ldnz, "text_effect")) current.text_effect = ldnz.text_effect; else current.text_effect = "Aucune";
            if (variable_struct_exists(ldnz, "speaker1_flip")) current.speaker1_flip = ldnz.speaker1_flip; else if (variable_struct_exists(scz, "speaker1_flip")) current.speaker1_flip = scz.speaker1_flip; else current.speaker1_flip = false;
            if (variable_struct_exists(ldnz, "speaker2_flip")) current.speaker2_flip = ldnz.speaker2_flip; else if (variable_struct_exists(scz, "speaker2_flip")) current.speaker2_flip = scz.speaker2_flip; else current.speaker2_flip = false;
            if (variable_struct_exists(ldnz, "speaker3_flip")) current.speaker3_flip = ldnz.speaker3_flip; else if (variable_struct_exists(scz, "speaker3_flip")) current.speaker3_flip = scz.speaker3_flip; else current.speaker3_flip = false;
            if (variable_struct_exists(ldnz, "obj1_flip")) current.obj1_flip = ldnz.obj1_flip; else if (variable_struct_exists(scz, "obj1_flip")) current.obj1_flip = scz.obj1_flip; else current.obj1_flip = false;
            if (variable_struct_exists(ldnz, "obj2_flip")) current.obj2_flip = ldnz.obj2_flip; else if (variable_struct_exists(scz, "obj2_flip")) current.obj2_flip = scz.obj2_flip; else current.obj2_flip = false;
            await_scene_click = false;
            fx_sp1_start_ms = current_time;
            fx_sp2_start_ms = current_time;
            fx_sp3_start_ms = current_time;
            fx_obj1_start_ms = current_time;
            fx_obj2_start_ms = current_time;

        }
    }
}

// Logic for Audio Sequence (switching between Sound 1 and Sound 2)
if (variable_instance_exists(id, "bg_seq_active") && bg_seq_active) {
    if (bg_seq_state == 0) {
        if (!audio_is_playing(bg_sound_inst_current)) {
            // Sound 1 finished, switch to Sound 2
            bg_seq_state = 1;
            bg_sound_inst_current = -1;
            var new_bg2 = asset_get_index(current.bg_sound2);
            if (new_bg2 != -1) bg2_sound_inst_current = audio_play_sound(new_bg2, 0, false);
        }
    } else {
        if (!audio_is_playing(bg2_sound_inst_current)) {
            // Sound 2 finished, switch to Sound 1
            bg_seq_state = 0;
            bg2_sound_inst_current = -1;
            var new_bg = asset_get_index(current.bg_sound);
            if (new_bg != -1) bg_sound_inst_current = audio_play_sound(new_bg, 0, false);
        }
    }
}
