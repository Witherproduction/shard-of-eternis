if (variable_global_exists("story_resume_info")) {
    var info = global.story_resume_info;
    global.current_chapter = info.chapter_id;
    global.current_act = info.act;
    global.current_scene_index = info.scene_index;
} else {
    global.current_chapter = 1;
    global.current_act = 1;
    global.current_scene_index = 0;
}

var chap = global.current_chapter;
var actn = global.current_act;
var sceneIndex = global.current_scene_index;
var path = "scenario_chapter_" + string(chap) + "_act_" + string(actn) + ".json";
if (!file_exists(path)) {
    for (var a = 1; a <= 3; a++) {
        var p2 = "scenario_chapter_" + string(chap) + "_act_" + string(a) + ".json";
        if (file_exists(p2)) { actn = a; path = p2; global.current_act = actn; break; }
    }
}
if (file_exists(path)) {
    var fr = file_text_open_read(path);
    var s = "";
    while (!file_text_eof(fr)) { s += file_text_read_string(fr); }
    file_text_close(fr);
    var data = json_parse(s);
    if (is_struct(data) && variable_struct_exists(data, "scenes")) {
        var scenes = data.scenes;
        var idx = 0;
        if (is_array(scenes) && array_length(scenes) > 0) {
            idx = clamp(sceneIndex, 0, array_length(scenes)-1);
            var sc = scenes[idx];
            if (variable_struct_exists(sc, "duel_bot_id") && sc.duel_bot_id > 0) {
                global.previous_room_before_duel = rScenario;
                global.selected_bot_deck_id = sc.duel_bot_id;
                if (!variable_global_exists("selected_player_deck") || global.selected_player_deck == noone) {
                    global.selected_player_deck = { name: "Deck Scénario", cards: [] };
                }
                room_goto(rDuel);
                exit;
            }
        }
        global.scenario_loaded_data = data;
        global.scenario_loaded_index = idx;
        var runner_obj = asset_get_index("oScenarioRunner");
        if (runner_obj != -1) {
            instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", runner_obj);
        } else {
            show_debug_message("### rScenario: oScenarioRunner introuvable");
        }
    }
}
