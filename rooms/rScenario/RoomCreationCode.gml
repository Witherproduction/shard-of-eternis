if (variable_global_exists("story_resume_info")) {
    var info = global.story_resume_info;
    global.current_chapter = info.chapter_id;
    global.current_act = info.act;
    global.current_scene_index = info.scene_index;
    // Consume the resume info so it doesn't override future room entries
    if (variable_struct_exists(global, "story_resume_info")) {
        variable_struct_remove(global, "story_resume_info");
    }
} else {
    // If no resume info, check if we already have global state (e.g. returning from duel)
    if (!variable_global_exists("current_chapter")) global.current_chapter = 1;
    if (!variable_global_exists("current_act")) global.current_act = 1;
    if (!variable_global_exists("current_scene_index")) global.current_scene_index = 0;
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
            
            // Si on reprend après une défaite (ou chargement), on ne lance pas le duel tout de suite
            // On vérifie si sc_load_line_index est défini (il vaut 0 après une défaite avec notre modif)
            var is_resuming = (variable_global_exists("sc_load_line_index") && global.sc_load_line_index >= 0);
            
            if (!is_resuming && variable_struct_exists(sc, "duel_bot_id") && sc.duel_bot_id > 0) {
                global.previous_room_before_duel = rScenario;
                global.selected_bot_deck_id = sc.duel_bot_id;
                
                // Set duel progression variables
                global.duel_resume_scene = idx;
                global.duel_resume_line = 0;
                global.duel_next_scene = idx + 1;
                global.duel_is_last_scene = (idx >= array_length(scenes) - 1);
                show_debug_message("### rScenario Direct Duel: Resume=" + string(idx) + " Next=" + string(idx+1) + " IsLast=" + string(global.duel_is_last_scene));

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
