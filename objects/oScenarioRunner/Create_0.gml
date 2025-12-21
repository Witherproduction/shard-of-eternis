var k = 1;
randomize(); // Assurer que l'aléatoire est bien différent à chaque lancement
speaker1 = { x: room_width * 0.25, y: room_height * 0.55, w: 420 * k, h: 640 * k };
speaker2 = { x: room_width * 0.75, y: room_height * 0.55, w: 420 * k, h: 640 * k };
speaker3 = { x: room_width * 0.50, y: room_height * 0.55, w: 420 * k, h: 640 * k };
textbox  = { x: room_width * 0.5,  y: room_height * 0.88, w: 1200 * k, h: 220 * k, margin: 24 * k };
object1  = { x: room_width * 0.35, y: room_height * 0.30, w: 300 * k, h: 300 * k };
object2  = { x: room_width * 0.65, y: room_height * 0.30, w: 300 * k, h: 300 * k };

btn_prev_x1 = 0; btn_prev_y1 = 0; btn_prev_x2 = 0; btn_prev_y2 = 0;
// Boutons de navigation (Dimensions standard et alignés verticalement à droite du textbox)
var bw = 120; 
var bh = 50;
var gap = 10;
var bx = textbox.x + textbox.w * 0.5 + bw * 0.5 + 10; // 10px padding à droite du cadre

// Auto (en bas, aligné avec le bas du cadre)
btn_auto_x1 = bx - bw/2;
btn_auto_y2 = textbox.y + textbox.h * 0.5;
btn_auto_y1 = btn_auto_y2 - bh;
btn_auto_x2 = bx + bw/2;

// Suivant (au-dessus de Auto)
btn_next_x1 = bx - bw/2;
btn_next_y2 = btn_auto_y1 - gap;
btn_next_y1 = btn_next_y2 - bh;
btn_next_x2 = bx + bw/2;

btn_quit_x1 = 0; btn_quit_y1 = 0; btn_quit_x2 = 0; btn_quit_y2 = 0;

auto_mode = true; // Par défaut activé


chapter_id = variable_global_exists("current_chapter") ? global.current_chapter : 1;
act_num = variable_global_exists("current_act") ? global.current_act : 1;
scene_index = variable_global_exists("current_scene_index") ? global.current_scene_index : 0;

current = { speaker: 1, text: "", bg_name: "", portrait1_name: "", portrait2_name: "", portrait3_name: "", obj1_name: "", obj2_name: "", duel_bot_id: 0, bg_sound: "", bg_sound2: "", portrait1_effect: "Aucune", portrait2_effect: "Aucune", portrait3_effect: "Aucune", obj1_effect: "Aucune", obj2_effect: "Aucune", text_effect: "Aucune" };
scenes = [];
debug_auto_log = true;
auto_dbg_target_logged = -1;
auto_dbg_last_advance_line = -1;
auto_dbg_probe_interval = 200;
auto_dbg_next_probe_ms = current_time;
if (variable_global_exists("scenario_loaded_data") && is_struct(global.scenario_loaded_data)) {
    var data = global.scenario_loaded_data;
    if (variable_struct_exists(data, "scenes")) {
        scenes = data.scenes;
        scene_index = variable_global_exists("scenario_loaded_index") ? global.scenario_loaded_index : scene_index;
        scene_index = clamp(scene_index, 0, max(0, array_length(scenes)-1));
    }
} else {
    var path = "scenario_chapter_" + string(chapter_id) + "_act_" + string(act_num) + ".json";
    if (file_exists(path)) {
        var fr = file_text_open_read(path);
        var s = "";
        while (!file_text_eof(fr)) { s += file_text_read_string(fr); }
        file_text_close(fr);
        var data2 = json_parse(s);
        if (is_struct(data2) && variable_struct_exists(data2, "scenes")) {
            scenes = data2.scenes;
            scene_index = clamp(scene_index, 0, max(0, array_length(scenes)-1));
        }
    }
}

if (false) {
    var merged_lines = [];
    var mcount = 0;
    var first_bg = "";
    var first_bg_sound = "";
    var first_bg_sound2 = "";
    for (var si = 0; si < array_length(scenes); si++) {
        var scx = scenes[si];
        if (si == 0) {
            if (variable_struct_exists(scx, "bg")) first_bg = scx.bg;
            if (variable_struct_exists(scx, "bg_sound")) first_bg_sound = scx.bg_sound;
            if (variable_struct_exists(scx, "bg_sound2")) first_bg_sound2 = scx.bg_sound2;
        }
        if (is_array(scx.lines)) {
            for (var li = 0; li < array_length(scx.lines); li++) {
                var ld = scx.lines[li];
                var new_ld = { speaker: ld.speaker, text: ld.text };
                if (variable_struct_exists(ld, "portrait1_name")) new_ld.portrait1_name = ld.portrait1_name;
                if (variable_struct_exists(ld, "portrait2_name")) new_ld.portrait2_name = ld.portrait2_name;
                if (variable_struct_exists(ld, "portrait3_name")) new_ld.portrait3_name = ld.portrait3_name;
                if (variable_struct_exists(ld, "obj1_name")) new_ld.obj1_name = ld.obj1_name;
                if (variable_struct_exists(ld, "obj2_name")) new_ld.obj2_name = ld.obj2_name;
                if (variable_struct_exists(ld, "wait_after_ms")) new_ld.wait_after_ms = ld.wait_after_ms;
                else if (variable_struct_exists(ld, "wait_after")) new_ld.wait_after_ms = ld.wait_after;
                if (variable_struct_exists(scx, "bg")) new_ld.bg = scx.bg;
                if (variable_struct_exists(scx, "bg_sound")) new_ld.bg_sound = scx.bg_sound;
                if (variable_struct_exists(scx, "bg_sound2")) new_ld.bg_sound2 = scx.bg_sound2;
                if (variable_struct_exists(scx, "portrait1_effect")) new_ld.portrait1_effect = scx.portrait1_effect;
                if (variable_struct_exists(scx, "portrait2_effect")) new_ld.portrait2_effect = scx.portrait2_effect;
                if (variable_struct_exists(scx, "obj1_effect")) new_ld.obj1_effect = scx.obj1_effect;
                if (variable_struct_exists(scx, "obj2_effect")) new_ld.obj2_effect = scx.obj2_effect;
                if (variable_struct_exists(scx, "text_effect")) new_ld.text_effect = scx.text_effect;
                if (variable_struct_exists(scx, "speaker1_x")) new_ld.speaker1_x = scx.speaker1_x;
                if (variable_struct_exists(scx, "speaker1_y")) new_ld.speaker1_y = scx.speaker1_y;
                if (variable_struct_exists(scx, "speaker1_w")) new_ld.speaker1_w = scx.speaker1_w;
                if (variable_struct_exists(scx, "speaker1_h")) new_ld.speaker1_h = scx.speaker1_h;
                if (variable_struct_exists(scx, "speaker2_x")) new_ld.speaker2_x = scx.speaker2_x;
                if (variable_struct_exists(scx, "speaker2_y")) new_ld.speaker2_y = scx.speaker2_y;
                if (variable_struct_exists(scx, "speaker2_w")) new_ld.speaker2_w = scx.speaker2_w;
                if (variable_struct_exists(scx, "speaker2_h")) new_ld.speaker2_h = scx.speaker2_h;
                if (variable_struct_exists(scx, "obj1_x")) new_ld.obj1_x = scx.obj1_x;
                if (variable_struct_exists(scx, "obj1_y")) new_ld.obj1_y = scx.obj1_y;
                if (variable_struct_exists(scx, "obj1_w")) new_ld.obj1_w = scx.obj1_w;
                if (variable_struct_exists(scx, "obj1_h")) new_ld.obj1_h = scx.obj1_h;
                if (variable_struct_exists(scx, "obj2_x")) new_ld.obj2_x = scx.obj2_x;
                if (variable_struct_exists(scx, "obj2_y")) new_ld.obj2_y = scx.obj2_y;
                if (variable_struct_exists(scx, "obj2_w")) new_ld.obj2_w = scx.obj2_w;
                if (variable_struct_exists(scx, "obj2_h")) new_ld.obj2_h = scx.obj2_h;
                if (variable_struct_exists(scx, "textbox_x")) new_ld.textbox_x = scx.textbox_x;
                if (variable_struct_exists(scx, "textbox_y")) new_ld.textbox_y = scx.textbox_y;
                if (variable_struct_exists(scx, "speaker1_flip")) new_ld.speaker1_flip = scx.speaker1_flip;
                if (variable_struct_exists(scx, "speaker2_flip")) new_ld.speaker2_flip = scx.speaker2_flip;
                if (variable_struct_exists(scx, "speaker3_flip")) new_ld.speaker3_flip = scx.speaker3_flip;
                if (variable_struct_exists(scx, "obj1_flip")) new_ld.obj1_flip = scx.obj1_flip;
                if (variable_struct_exists(scx, "obj2_flip")) new_ld.obj2_flip = scx.obj2_flip;
                merged_lines[mcount] = new_ld;
                mcount += 1;
            }
        }
    }
    var merged_scene = { bg: first_bg, bg_sound: first_bg_sound, bg_sound2: first_bg_sound2, lines: merged_lines };
    scenes = [merged_scene];
    scene_index = 0;
}

line_index = 0;
// OVERRIDE: Si une variable globale de reprise existe, l'utiliser
if (variable_global_exists("sc_load_line_index") && global.sc_load_line_index >= 0) {
    line_index = global.sc_load_line_index;
    global.sc_load_line_index = -1; // Reset
    show_debug_message("### oScenarioRunner: Reprise à la ligne " + string(line_index));
}
if (array_length(scenes) > 0) {
    var sc = scenes[scene_index];
    var kref = 1;
    if (variable_struct_exists(sc, "bg")) current.bg_name = sc.bg;
    if (variable_struct_exists(sc, "bg_sound")) current.bg_sound = sc.bg_sound;
    if (variable_struct_exists(sc, "bg_sound2")) current.bg_sound2 = sc.bg_sound2;
    // scene-level only: background and ambient sounds
    if (variable_struct_exists(sc, "duel_bot_id")) current.duel_bot_id = sc.duel_bot_id;
    if (variable_struct_exists(sc, "portrait1_effect")) current.portrait1_effect = sc.portrait1_effect;
    if (variable_struct_exists(sc, "portrait2_effect")) current.portrait2_effect = sc.portrait2_effect;
    if (variable_struct_exists(sc, "portrait3_effect")) current.portrait3_effect = sc.portrait3_effect;
    if (variable_struct_exists(sc, "obj1_effect")) current.obj1_effect = sc.obj1_effect;
    if (variable_struct_exists(sc, "obj2_effect")) current.obj2_effect = sc.obj2_effect;
    if (variable_struct_exists(sc, "text_effect")) current.text_effect = sc.text_effect;
    if (is_array(sc.lines) && array_length(sc.lines) > 0) {
        var line_data = sc.lines[line_index];
        current.speaker = line_data.speaker;
        current.text = line_data.text;
        if (variable_struct_exists(line_data, "portrait1_name")) current.portrait1_name = line_data.portrait1_name;
        if (variable_struct_exists(line_data, "portrait2_name")) current.portrait2_name = line_data.portrait2_name;
        if (variable_struct_exists(line_data, "portrait3_name")) current.portrait3_name = line_data.portrait3_name;
        if (variable_struct_exists(line_data, "obj1_name")) current.obj1_name = line_data.obj1_name;
        if (variable_struct_exists(line_data, "obj2_name")) current.obj2_name = line_data.obj2_name;

        if (variable_struct_exists(line_data, "bg")) current.bg_name = line_data.bg;
        if (variable_struct_exists(line_data, "bg_sound")) current.bg_sound = line_data.bg_sound;
        if (variable_struct_exists(line_data, "bg_sound2")) current.bg_sound2 = line_data.bg_sound2;
        if (variable_struct_exists(line_data, "portrait1_effect")) current.portrait1_effect = line_data.portrait1_effect;
        if (variable_struct_exists(line_data, "portrait2_effect")) current.portrait2_effect = line_data.portrait2_effect;
        if (variable_struct_exists(line_data, "portrait3_effect")) current.portrait3_effect = line_data.portrait3_effect;
    if (variable_struct_exists(line_data, "obj1_effect")) current.obj1_effect = line_data.obj1_effect;
    if (variable_struct_exists(line_data, "obj2_effect")) current.obj2_effect = line_data.obj2_effect;
    if (variable_struct_exists(line_data, "text_effect")) current.text_effect = line_data.text_effect;
    if (variable_struct_exists(line_data, "speaker1_x")) speaker1.x = line_data.speaker1_x * kref;
    if (variable_struct_exists(line_data, "speaker1_y")) speaker1.y = line_data.speaker1_y * kref;
    if (variable_struct_exists(line_data, "speaker1_w")) speaker1.w = line_data.speaker1_w * kref;
    if (variable_struct_exists(line_data, "speaker1_h")) speaker1.h = line_data.speaker1_h * kref;
    if (variable_struct_exists(line_data, "speaker2_x")) speaker2.x = line_data.speaker2_x * kref;
    if (variable_struct_exists(line_data, "speaker2_y")) speaker2.y = line_data.speaker2_y * kref;
    if (variable_struct_exists(line_data, "speaker2_w")) speaker2.w = line_data.speaker2_w * kref;
    if (variable_struct_exists(line_data, "speaker2_h")) speaker2.h = line_data.speaker2_h * kref;
    if (variable_struct_exists(line_data, "speaker3_x")) speaker3.x = line_data.speaker3_x * kref;
    if (variable_struct_exists(line_data, "speaker3_y")) speaker3.y = line_data.speaker3_y * kref;
    if (variable_struct_exists(line_data, "speaker3_w")) speaker3.w = line_data.speaker3_w * kref;
    if (variable_struct_exists(line_data, "speaker3_h")) speaker3.h = line_data.speaker3_h * kref;
    if (variable_struct_exists(line_data, "obj1_x")) object1.x = line_data.obj1_x * kref;
    if (variable_struct_exists(line_data, "obj1_y")) object1.y = line_data.obj1_y * kref;
    if (variable_struct_exists(line_data, "obj1_w")) object1.w = line_data.obj1_w * kref;
    if (variable_struct_exists(line_data, "obj1_h")) object1.h = line_data.obj1_h * kref;
    if (variable_struct_exists(line_data, "obj2_x")) object2.x = line_data.obj2_x * kref;
    if (variable_struct_exists(line_data, "obj2_y")) object2.y = line_data.obj2_y * kref;
    if (variable_struct_exists(line_data, "obj2_w")) object2.w = line_data.obj2_w * kref;
    if (variable_struct_exists(line_data, "obj2_h")) object2.h = line_data.obj2_h * kref;
    if (variable_struct_exists(line_data, "textbox_x")) textbox.x = line_data.textbox_x * kref;
    if (variable_struct_exists(line_data, "textbox_y")) textbox.y = line_data.textbox_y * kref;
        if (debug_auto_log) {
            var la0 = variable_struct_exists(line_data, "wait_after_ms") ? line_data.wait_after_ms : (variable_struct_exists(line_data, "wait_after") ? line_data.wait_after : -1);
            show_debug_message("### Runner.InitLine0: scenes=" + string(array_length(scenes)) + " scene_index=" + string(scene_index) + " lines=" + string(array_length(sc.lines)) + " wait_after_ms=" + string(la0) + " obj1_effect=" + string(current.obj1_effect) + " obj1_name=" + string(current.obj1_name));
        }
    }
if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
} else {
    current.text = "Aucune scène disponible";
}

bg_sound_asset_current = -1;
bg2_sound_asset_current = -1;
bg_sound_inst_current = -1;
bg2_sound_inst_current = -1;
bg_seq_active = false;
bg_seq_state = 0;

update_bg_audio = function() {
    var new_bg = asset_get_index(current.bg_sound);
    var new_bg2 = asset_get_index(current.bg_sound2);
    var want_seq = (new_bg != -1 && new_bg2 != -1);

    if (want_seq) {
        // Sequence Mode (Looping between Sound 1 and Sound 2)
        if (!bg_seq_active || bg_sound_asset_current != new_bg || bg2_sound_asset_current != new_bg2) {
            // Stop everything
            if (bg_sound_asset_current != -1) audio_stop_sound(bg_sound_asset_current);
            if (bg2_sound_asset_current != -1) audio_stop_sound(bg2_sound_asset_current);
            
            bg_seq_active = true;
            bg_seq_state = irandom(1);
            bg_sound_asset_current = new_bg;
            bg2_sound_asset_current = new_bg2;
            
            if (bg_seq_state == 0) {
                // Start with Sound 1
                bg_sound_inst_current = audio_play_sound(new_bg, 0, false);
                bg2_sound_inst_current = -1;
            } else {
                // Start with Sound 2
                bg_sound_inst_current = -1;
                bg2_sound_inst_current = audio_play_sound(new_bg2, 0, false);
            }
        }
    } else {
        // Normal Mode (Independent looping)
        bg_seq_active = false;
        
        // Handle Sound 1
        if (new_bg != bg_sound_asset_current) {
            if (bg_sound_asset_current != -1) audio_stop_sound(bg_sound_asset_current);
            bg_sound_asset_current = new_bg;
            if (new_bg != -1) bg_sound_inst_current = audio_play_sound(new_bg, 0, true); else bg_sound_inst_current = -1;
        }
        
        // Handle Sound 2
        if (new_bg2 != bg2_sound_asset_current) {
            if (bg2_sound_asset_current != -1) audio_stop_sound(bg2_sound_asset_current);
            bg2_sound_asset_current = new_bg2;
            if (new_bg2 != -1) bg2_sound_inst_current = audio_play_sound(new_bg2, 0, true); else bg2_sound_inst_current = -1;
        }
    }
};

// Initial Audio Setup
update_bg_audio();
prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
prev_object1_x = object1.x;    prev_object1_y = object1.y;
prev_object2_x = object2.x;    prev_object2_y = object2.y;

// Consommation d'entrée par frame pour éviter doubles déclenchements
input_consumed = false;
input_block_frames = 4;

fx_duration_ms = 400;
fx_inverse_multiplier = 2.0;
fx_sp1_start_ms = current_time;
fx_sp2_start_ms = current_time;
fx_sp3_start_ms = current_time;
fx_obj1_start_ms = current_time;
fx_obj2_start_ms = current_time;
fx_text_start_ms = current_time;
text_reveal_cps = 40;
// auto_mode = true; // Supprimé car défini plus haut à false
await_scene_click = false;
wait_after_default_ms = 600;
line_auto_target_ms = -1;
var tx0 = string(current.text);
var len0_raw = string_length(tx0);
var tx0_trim = string_replace_all(string_replace_all(string_replace_all(tx0, " ", ""), "\n", ""), "\r", "");
var len0 = string_length(tx0_trim);
var cps0 = max(1, text_reveal_cps);
var reveal_ms0 = ceil(len0_raw * 1000 / cps0);
var wait_ms0 = wait_after_default_ms;
if (array_length(scenes) > 0) {
    var sc0 = scenes[scene_index];
    if (is_array(sc0.lines) && array_length(sc0.lines) > 0) {
        var line0 = sc0.lines[line_index];
        if (variable_struct_exists(line0, "wait_after_ms")) wait_ms0 = line0.wait_after_ms;
        else if (variable_struct_exists(line0, "wait_after")) wait_ms0 = line0.wait_after;
    }
}
var anim_ms0 = 0;
var dur_base0 = fx_duration_ms;
if (current.portrait1_effect != "Aucune" && current.portrait1_effect != "") { var d10 = dur_base0; if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") d10 *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, d10); }
if (current.portrait2_effect != "Aucune" && current.portrait2_effect != "") { var d20 = dur_base0; if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") d20 *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, d20); }
if (current.portrait3_effect != "Aucune" && current.portrait3_effect != "") { var d30p = dur_base0; if (current.portrait3_effect == "SlideGaucheInverse" || current.portrait3_effect == "Slide gauche inversé" || current.portrait3_effect == "SlideDroiteInverse" || current.portrait3_effect == "Slide droite inversé" || current.portrait3_effect == "SlideHautInverse" || current.portrait3_effect == "Slide haut inversé" || current.portrait3_effect == "SlideBasInverse" || current.portrait3_effect == "Slide bas inversé") d30p *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, d30p); }
if (current.obj1_effect != "Aucune" && current.obj1_effect != "") { var d30 = dur_base0; if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") d30 *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, d30); }
if (current.obj2_effect != "Aucune" && current.obj2_effect != "") { var d40 = dur_base0; if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") d40 *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, d40); }
if (current.text_effect != "Aucune" && current.text_effect != "") { var dt0 = dur_base0; if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") dt0 *= fx_inverse_multiplier; anim_ms0 = max(anim_ms0, dt0); }
var has_explicit_wait0 = false;
if (array_length(scenes) > 0) {
    var sc0b = scenes[scene_index];
    if (is_array(sc0b.lines) && array_length(sc0b.lines) > 0) {
        var line0b = sc0b.lines[line_index];
        if (variable_struct_exists(line0b, "wait_after_ms") || variable_struct_exists(line0b, "wait_after")) has_explicit_wait0 = true;
    }
}
if (len0 == 0) line_auto_target_ms = current_time + anim_ms0 + wait_ms0; else line_auto_target_ms = current_time + reveal_ms0 + wait_ms0;
if (debug_auto_log) {
    show_debug_message("### Runner.InitTarget0: len0=" + string(len0) + " anim_ms0=" + string(anim_ms0) + " wait_ms0=" + string(wait_ms0) + " has_wait0=" + string(has_explicit_wait0) + " target0=" + string(line_auto_target_ms));
}
