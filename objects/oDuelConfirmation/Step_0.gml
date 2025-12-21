if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    
    if (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height) {
        // Find scenario runner to get correct bot ID
        var sc = noone;
        if (instance_exists(oScenarioRunner)) {
            var runner = instance_find(oScenarioRunner, 0);
            if (variable_instance_exists(runner, "scenes") && variable_instance_exists(runner, "scene_index")) {
                 var scenes = runner.scenes;
                 var idx = runner.scene_index;
                 if (idx >= 0 && idx < array_length(scenes)) {
                     sc = scenes[idx];
                 }
            }
        }

        // Use ID from scenario or default
        if (sc != noone && variable_struct_exists(sc, "duel_bot_id") && sc.duel_bot_id > 0) {
            selected_bot_deck_id = sc.duel_bot_id;
        }

        // Set duel progression variables from scenario runner
        if (instance_exists(oScenarioRunner)) {
            var runner = instance_find(oScenarioRunner, 0);
            if (variable_instance_exists(runner, "scenes") && variable_instance_exists(runner, "scene_index")) {
                var scenes = runner.scenes;
                var idx = runner.scene_index;
                
                global.duel_resume_scene = idx;
                // If we lose, we restart the scene at the beginning (line 0)
                global.duel_resume_line = 0; 
                
                global.duel_next_scene = idx + 1;
                global.duel_is_last_scene = (idx >= array_length(scenes) - 1);
                
                show_debug_message("### Duel Progression Set: Resume=" + string(idx) + " Next=" + string(idx+1) + " IsLast=" + string(global.duel_is_last_scene));
            }
        }

        global.previous_room_before_duel = rScenario;
        global.selected_bot_deck_id = selected_bot_deck_id;
        
        // Ensure player deck is set
        var deck_invalid = (!variable_global_exists("selected_player_deck") || global.selected_player_deck == noone);
        
        // Check if it's the dummy empty deck from Scenario
        if (!deck_invalid && is_struct(global.selected_player_deck) && variable_struct_exists(global.selected_player_deck, "cards")) {
             if (array_length(global.selected_player_deck.cards) == 0 && variable_struct_exists(global.selected_player_deck, "name") && global.selected_player_deck.name == "Deck Scénario") {
                 deck_invalid = true;
                 show_debug_message("### Detected empty Scenario deck, forcing reload from saved decks.");
             }
        }

        if (deck_invalid) {
             var story_deck_found = false;
             
             // Check for Story Deck (Chapter 1)
             // We can check oScenarioRunner to be sure about the chapter
             var current_chapter = 1; // Default
             if (instance_exists(oScenarioRunner)) {
                 var runner = instance_find(oScenarioRunner, 0);
                 if (variable_instance_exists(runner, "chapter_id")) {
                     current_chapter = real(runner.chapter_id);
                 }
             } else if (variable_global_exists("current_chapter")) {
                 current_chapter = global.current_chapter;
             }
             
             if (current_chapter == 1) {
                 var chap1_decks = get_hero_decks_chap1();
                 for (var i = 0; i < array_length(chap1_decks); i++) {
                     if (variable_struct_exists(chap1_decks[i], "id") && chap1_decks[i].id == "rebellion_horde") {
                         global.selected_player_deck = chap1_decks[i];
                         show_debug_message("### Auto-selected Story Deck: " + string(global.selected_player_deck.name));
                         story_deck_found = true;
                         break;
                     }
                 }
                 // If not found, try the first one
                 if (!story_deck_found && array_length(chap1_decks) > 0) {
                     global.selected_player_deck = chap1_decks[0];
                     show_debug_message("### Auto-selected Story Deck (First): " + string(global.selected_player_deck.name));
                     story_deck_found = true;
                 }
             }
             
             if (!story_deck_found) {
                 // Try to load saved decks if not loaded
                 if (!variable_global_exists("saved_decks") || array_length(global.saved_decks) == 0) {
                     load_decks_from_file();
                 }
                 
                 // Pick the first available deck
                 if (variable_global_exists("saved_decks") && array_length(global.saved_decks) > 0) {
                     global.selected_player_deck = global.saved_decks[0];
                     show_debug_message("### Auto-selected deck: " + string(global.selected_player_deck.name));
                 } else {
                     // Fallback: empty deck
                     global.selected_player_deck = { name: "Deck Hero", cards: [] }; 
                     show_debug_message("### No saved decks found, using empty deck.");
                 }
             }
        }

        // Stop sounds
        audio_stop_all();

        room_goto(rDuel);
    }
}
