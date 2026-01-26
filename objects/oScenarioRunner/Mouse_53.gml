if (instance_exists(oPanelOptions)) exit;

// Gestion du bouton Auto
if (point_in_rectangle(mouse_x, mouse_y, btn_auto_x1, btn_auto_y1, btn_auto_x2, btn_auto_y2)) {
    auto_mode = !auto_mode;
    exit;
}

// Gestion du bouton Suivant
if (point_in_rectangle(mouse_x, mouse_y, btn_next_x1, btn_next_y1, btn_next_x2, btn_next_y2)) {
    if (array_length(scenes) == 0) exit;
    
    // Si le texte est en train de s'afficher, on l'affiche d'un coup
    var txs_cur = string(current.text);
    var len_cur = string_length(txs_cur);
    var cps_cur = max(1, text_reveal_cps);
    var elapsed_ms_cur = current_time - fx_text_start_ms;
    var reveal_ms_cur = ceil(len_cur * 1000 / cps_cur);
    
    if (elapsed_ms_cur < reveal_ms_cur) {
        fx_text_start_ms = current_time - reveal_ms_cur - 100;
        exit;
    }

    var sc = scenes[scene_index];
    var has_lines = is_array(sc.lines) && array_length(sc.lines) > 0;
    
    if (has_lines && line_index + 1 < array_length(sc.lines)) {
        // Passage à la ligne suivante (Logique reprise de Step_0)
        line_index += 1;
        var line_data_k = sc.lines[line_index];
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
        if (variable_struct_exists(line_data_k, "portrait3_effect")) current.portrait3_effect = line_data_k.portrait3_effect; else if (variable_struct_exists(sc, "portrait3_effect")) current.portrait3_effect = sc.portrait3_effect; else current.portrait3_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "obj1_effect")) current.obj1_effect = line_data_k.obj1_effect; else current.obj1_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "obj2_effect")) current.obj2_effect = line_data_k.obj2_effect; else current.obj2_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "text_effect")) current.text_effect = line_data_k.text_effect; else current.text_effect = "Aucune";
        if (variable_struct_exists(line_data_k, "speaker1_flip")) current.speaker1_flip = line_data_k.speaker1_flip; else if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
        if (variable_struct_exists(line_data_k, "speaker2_flip")) current.speaker2_flip = line_data_k.speaker2_flip; else if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
        if (variable_struct_exists(line_data_k, "speaker3_flip")) current.speaker3_flip = line_data_k.speaker3_flip; else if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
        if (variable_struct_exists(line_data_k, "obj1_flip")) current.obj1_flip = line_data_k.obj1_flip; else if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
        if (variable_struct_exists(line_data_k, "obj2_flip")) current.obj2_flip = line_data_k.obj2_flip; else if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
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

    } else {
        // Fin des lignes de la scène actuelle
        
        // --- CHECK DUEL ---
        var sc_curr = scenes[scene_index];
        var bot_id = 0;
        if (variable_struct_exists(sc_curr, "duel_bot_id")) bot_id = sc_curr.duel_bot_id;
        
        var is_last_scene = (scene_index + 1 >= array_length(scenes));

        // Patch: Empêcher un deuxième duel accidentel à la toute dernière scène du Chapitre 1 Acte 1
        // Le joueur a déjà combattu avant cette scène finale
        if (is_last_scene && bot_id != 0 && bot_id != noone) {
            // Check broadly for Chapter 1 Act 1
            if (real(chapter_id) == 1 && real(act_num) == 1) {
                 show_debug_message("### PATCH: Blocage du duel accidentel en fin de Ch1 Act1 (Scene " + string(scene_index) + ")");
                 bot_id = 0;
            }
        }

        if (bot_id != 0 && bot_id != noone) {
             if (!instance_exists(oDuelConfirmation)) {
                var inst = instance_create_depth(0, 0, -9999, oDuelConfirmation);
                inst.selected_bot_deck_id = bot_id;
                
                // Save state for Duel Outcome
                global.duel_resume_scene = scene_index;
                global.duel_resume_line = line_index; 
                global.duel_next_scene = scene_index + 1;
                global.duel_is_last_scene = is_last_scene;
             }
             await_scene_click = true;
             exit; 
        }
        
        // Passage à la scène suivante
        if (scene_index + 1 < array_length(scenes)) {
            scene_index += 1;
            line_index = 0;
            var sc2 = scenes[scene_index];
            current.bg_name = sc2.bg;
            if (variable_struct_exists(sc2, "bg_sound")) current.bg_sound = sc2.bg_sound; else current.bg_sound = "";
            if (variable_struct_exists(sc2, "bg_sound2")) current.bg_sound2 = sc2.bg_sound2; else current.bg_sound2 = "";
            prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
            prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
            prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
            prev_object1_x = object1.x;    prev_object1_y = object1.y;
            prev_object2_x = object2.x;    prev_object2_y = object2.y;
            current.portrait1_effect = "Aucune";
            current.portrait2_effect = "Aucune";
            current.portrait3_effect = "Aucune";
            current.obj1_effect = "Aucune";
            current.obj2_effect = "Aucune";
            current.text_effect = "Aucune";
            fx_sp1_start_ms = current_time;
            fx_sp2_start_ms = current_time;
            fx_sp3_start_ms = current_time;
            fx_obj1_start_ms = current_time;
            fx_obj2_start_ms = current_time;
            fx_text_start_ms = current_time;
            await_scene_click = false;
            line_auto_target_ms = -1;
            current.duel_bot_id = variable_struct_exists(sc2, "duel_bot_id") ? sc2.duel_bot_id : 0;
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

            update_bg_audio();

        } else {
            // End of scenario
            
            // Integrer la progression
            unlock_act_complete(chapter_id, act_num);
            story_progress_unlock_reward("act_" + string(chapter_id) + "_" + string(act_num));
            
            var next_act = act_num + 1;
            var next_scene = 0;
            
            if (act_num >= 4) {
                unlock_chapter_access(chapter_id + 1);
                // Fin de chapitre : on reste sur le dernier acte pour ce chapitre
                next_act = act_num;
                next_scene = scene_index;
            }

            story_progress_write_last_scene(chapter_id, next_scene, next_act);
            if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); bg_sound_asset_current = -1; }
            if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); bg2_sound_asset_current = -1; }
            room_goto(rHistoire);
        }
    }
}
