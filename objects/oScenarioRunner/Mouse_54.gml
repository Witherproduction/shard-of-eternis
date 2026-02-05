if (instance_exists(oPanelOptions)) exit;
if (array_length(scenes) == 0) exit;

var target_scene = scene_index;
var target_line = line_index - 1;

// Navigation logic: Previous Line OR Previous Scene (Last Line)
if (target_line < 0) {
    if (target_scene > 0) {
        target_scene -= 1;
        var sc_prev = scenes[target_scene];
        if (is_array(sc_prev.lines)) {
            target_line = array_length(sc_prev.lines) - 1;
            if (target_line < 0) target_line = 0;
        } else {
            target_line = 0;
        }
    } else {
        // Start of story -> Exit to menu
        story_progress_write_last_scene(chapter_id, scene_index, act_num);
        if (bg_sound_asset_current != -1) { audio_stop_sound(bg_sound_asset_current); bg_sound_asset_current = -1; }
        if (bg2_sound_asset_current != -1) { audio_stop_sound(bg2_sound_asset_current); bg2_sound_asset_current = -1; }
        room_goto(rHistoire);
        exit;
    }
}

// Apply Target Indices
scene_index = target_scene;
line_index = target_line;
var sc = scenes[scene_index];

// --- 1. Reset State to Scene Defaults ---
current.bg_name = variable_struct_exists(sc, "bg") ? sc.bg : "";
current.bg_sound = variable_struct_exists(sc, "bg_sound") ? sc.bg_sound : "";
current.bg_sound2 = variable_struct_exists(sc, "bg_sound2") ? sc.bg_sound2 : "";
current.portrait1_name = variable_struct_exists(sc, "portrait1_name") ? sc.portrait1_name : "";
current.portrait2_name = variable_struct_exists(sc, "portrait2_name") ? sc.portrait2_name : "";
current.portrait3_name = variable_struct_exists(sc, "portrait3_name") ? sc.portrait3_name : "";
current.obj1_name = variable_struct_exists(sc, "obj1_name") ? sc.obj1_name : "";
current.obj2_name = variable_struct_exists(sc, "obj2_name") ? sc.obj2_name : "";
current.speaker1_flip = variable_struct_exists(sc, "speaker1_flip") ? sc.speaker1_flip : false;
current.speaker2_flip = variable_struct_exists(sc, "speaker2_flip") ? sc.speaker2_flip : false;
current.speaker3_flip = variable_struct_exists(sc, "speaker3_flip") ? sc.speaker3_flip : false;
current.obj1_flip = variable_struct_exists(sc, "obj1_flip") ? sc.obj1_flip : false;
current.obj2_flip = variable_struct_exists(sc, "obj2_flip") ? sc.obj2_flip : false;
current.duel_bot_id = variable_struct_exists(sc, "duel_bot_id") ? sc.duel_bot_id : 0;

// Reset Effects
current.portrait1_effect = "Aucune";
current.portrait2_effect = "Aucune";
current.portrait3_effect = "Aucune";
current.obj1_effect = "Aucune";
current.obj2_effect = "Aucune";
current.text_effect = "Aucune";

// --- 2. Replay History (Lines 0 to current line_index) ---
// We must simulate the cumulative effect of all lines up to the target line.
if (is_array(sc.lines)) {
    for (var i = 0; i <= line_index; i++) {
        if (i >= array_length(sc.lines)) break;
        var line_data = sc.lines[i];
        
        // Capture 'Previous' state just like Mouse_53 (for the FINAL line only, ideally, 
        // but doing it every loop ensures the final 'prev' is correct for the transition)
        prev_speaker1_x = speaker1.x; prev_speaker1_y = speaker1.y;
        prev_speaker2_x = speaker2.x; prev_speaker2_y = speaker2.y;
        prev_speaker3_x = speaker3.x; prev_speaker3_y = speaker3.y;
        prev_object1_x = object1.x;    prev_object1_y = object1.y;
        prev_object2_x = object2.x;    prev_object2_y = object2.y;

        // Apply Data
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
        
        if (variable_struct_exists(line_data, "speaker1_flip")) current.speaker1_flip = line_data.speaker1_flip;
        if (variable_struct_exists(line_data, "speaker2_flip")) current.speaker2_flip = line_data.speaker2_flip;
        if (variable_struct_exists(line_data, "speaker3_flip")) current.speaker3_flip = line_data.speaker3_flip;
        if (variable_struct_exists(line_data, "obj1_flip")) current.obj1_flip = line_data.obj1_flip;
        if (variable_struct_exists(line_data, "obj2_flip")) current.obj2_flip = line_data.obj2_flip;

        // Apply Coordinates
        var kref = 1;
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
    }
}

// --- 3. Refresh System State ---
fx_sp1_start_ms = current_time;
fx_sp2_start_ms = current_time;
fx_sp3_start_ms = current_time;
fx_obj1_start_ms = current_time;
fx_obj2_start_ms = current_time;
fx_text_start_ms = current_time;
await_scene_click = false;
line_auto_target_ms = -1;

// Text Reveal Config
var len = string_length(string(current.text));
var cps = max(1, text_reveal_cps);
var reveal_ms = ceil(len * 1000 / cps);
var wait_ms = wait_after_default_ms;

// Audio Sync
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
