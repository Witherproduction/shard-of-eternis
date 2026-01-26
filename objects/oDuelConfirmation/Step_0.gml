// --- INITIALIZATION (Run once) ---
if (!variable_instance_exists(id, "setup_done")) {
    show_debug_message("### oDuelConfirmation - Initializing Duel Setup...");
    
    // --- 1. Determine Context (Story Mode / Chapter) ---
    var is_story_mode = false;
    var current_chapter = -1;
    
    show_debug_message("### oDuelConfirmation - Checking Story Mode status...");
    
    if (instance_exists(oScenarioRunner)) {
         var runner = instance_find(oScenarioRunner, 0);
         show_debug_message("### oDuelConfirmation - Found oScenarioRunner");
         
         if (variable_instance_exists(runner, "chapter_id")) {
             current_chapter = real(runner.chapter_id);
             show_debug_message("### oDuelConfirmation - Runner chapter_id: " + string(current_chapter));
             // If we are in Scenario Runner with valid chapter, we assume we are playing story
             if (current_chapter >= 0) is_story_mode = true;
         } else {
             show_debug_message("### oDuelConfirmation - Runner has no chapter_id, defaulting to 1");
             current_chapter = 1;
             is_story_mode = true; // Default to story mode if runner exists
         }
    } else if (variable_global_exists("current_chapter")) {
         // Fallback if global variable is used
         show_debug_message("### oDuelConfirmation - Checking global.current_chapter: " + string(global.current_chapter));
         if (global.current_chapter >= 0) {
             current_chapter = global.current_chapter;
             is_story_mode = true; // Assuming we are entering story duel
         }
    } else {
         show_debug_message("### oDuelConfirmation - No runner and no global chapter, defaulting to saved decks logic");
    }
    
    show_debug_message("### oDuelConfirmation - is_story_mode: " + string(is_story_mode));

    // --- 2. Determine Bot Deck ID ---
    // Find scenario runner to get correct bot ID from current scene
    var sc = noone;
    if (instance_exists(oScenarioRunner)) {
        var runner = instance_find(oScenarioRunner, 0);
        if (variable_instance_exists(runner, "scenes") && variable_instance_exists(runner, "scene_index")) {
             var scenes = runner.scenes;
             var idx = runner.scene_index;
             show_debug_message("### oDuelConfirmation - Runner Scene Index: " + string(idx) + " / Scenes count: " + string(array_length(scenes)));
             if (idx >= 0 && idx < array_length(scenes)) {
                 sc = scenes[idx];
                 show_debug_message("### oDuelConfirmation - Scene Object Found: " + string(sc));
                 if (variable_struct_exists(sc, "duel_bot_id")) {
                     show_debug_message("### oDuelConfirmation - Scene duel_bot_id: " + string(sc.duel_bot_id));
                 } else {
                     show_debug_message("### oDuelConfirmation - Scene HAS NO duel_bot_id field");
                 }
             } else {
                 show_debug_message("### oDuelConfirmation - Scene Index out of bounds!");
             }
        } else {
             show_debug_message("### oDuelConfirmation - Runner missing scenes or scene_index");
        }
    } else {
        show_debug_message("### oDuelConfirmation - No oScenarioRunner for bot ID lookup");
    }

    // Use ID from scenario or default
    if (sc != noone && variable_struct_exists(sc, "duel_bot_id") && sc.duel_bot_id != 0 && sc.duel_bot_id != noone) {
        selected_bot_deck_id = sc.duel_bot_id;
        show_debug_message("### oDuelConfirmation - Selected Bot Deck ID from Scenario: " + string(selected_bot_deck_id));
    } 
    // Fallback for Chapter 0 (Tutorial) if no specific bot is set
    else if (is_story_mode && current_chapter == 0) {
        selected_bot_deck_id = "tuto_deck_bot"; // Updated to string ID
        show_debug_message("### oDuelConfirmation - Auto-selected Tutorial Bot Deck: " + string(selected_bot_deck_id));
    } else {
        show_debug_message("### oDuelConfirmation - Fallback condition hit. is_story_mode=" + string(is_story_mode) + " current_chapter=" + string(current_chapter) + " current ID=" + string(selected_bot_deck_id));
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
    // Moved global.selected_bot_deck_id assignment to end of block
    
    // --- 3. Determine Player Deck ---
    // Ensure player deck is set
    var deck_invalid = (!variable_global_exists("selected_player_deck") || global.selected_player_deck == noone);
    
    // Check if it's the dummy empty deck from Scenario
    if (!deck_invalid && is_struct(global.selected_player_deck) && variable_struct_exists(global.selected_player_deck, "cards")) {
         if (array_length(global.selected_player_deck.cards) == 0 && variable_struct_exists(global.selected_player_deck, "name") && global.selected_player_deck.name == "Deck Scénario") {
             deck_invalid = true;
             show_debug_message("### Detected empty Scenario deck, forcing reload from saved decks.");
         }
    }

    show_debug_message("### oDuelConfirmation - deck_invalid: " + string(deck_invalid));

    if (deck_invalid || is_story_mode) {
         var story_deck_found = false;
         
         // Check for Story Decks
        if (is_story_mode) {
            show_debug_message("### oDuelConfirmation - Searching for Story decks for chapter " + string(current_chapter));
            var story_decks = get_story_hero_decks(current_chapter);
            
            // Specific logic for preferred deck per chapter
            var preferred_deck_id = "";
            
            // Check if scenario has a specific player deck assigned
            if (sc != noone && variable_struct_exists(sc, "duel_player_deck") && is_string(sc.duel_player_deck) && sc.duel_player_deck != "") {
                preferred_deck_id = sc.duel_player_deck;
                show_debug_message("### oDuelConfirmation - Found specific player deck in scenario: " + preferred_deck_id);
            }
            else if (current_chapter == 0) {
                preferred_deck_id = "tuto_deck_hero";
            } else if (current_chapter == 1) {
                // Si on affronte James la Calamité (Bot 3), on utilise le deck Alliance des Bois
                if (selected_bot_deck_id == "Bandit_Grand_Chemin") {
                    preferred_deck_id = "alliance_bois";
                } 
                // Condition spécifique pour le 2ème duel de l'acte 2
                else if (variable_global_exists("current_act") && global.current_act == 2) {
                    // Correctif : Le joueur doit avoir le deck Alliance des Bois pour ce duel (contre James/Bot 3)
                    preferred_deck_id = "alliance_bois"; 
                } else {
                    preferred_deck_id = "rebellion_horde";
                }
            }
            
            for (var i = 0; i < array_length(story_decks); i++) {
                if (variable_struct_exists(story_decks[i], "id") && story_decks[i].id == preferred_deck_id) {
                    global.selected_player_deck = story_decks[i];
                    show_debug_message("### Auto-selected Story Deck: " + string(global.selected_player_deck.name));
                    story_deck_found = true;
                    break;
                }
            }
            // If not found, try the first one
            if (!story_deck_found && array_length(story_decks) > 0) {
                global.selected_player_deck = story_decks[0];
                show_debug_message("### Auto-selected Story Deck (First): " + string(global.selected_player_deck.name));
                story_deck_found = true;
            }

            // --- BOT DECK SELECTION ---
            // Priority to Tutorial Deck for Chapter 0
            if (current_chapter == 0) {
                selected_bot_deck_id = "tuto_deck_bot";
                show_debug_message("### oDuelConfirmation - Forced Tutorial Bot Deck: " + string(selected_bot_deck_id));
            }
            // Then Scenario specific deck
            else if (sc != noone && variable_struct_exists(sc, "duel_bot_id") && sc.duel_bot_id != 0 && sc.duel_bot_id != noone) {
                selected_bot_deck_id = sc.duel_bot_id;
                show_debug_message("### oDuelConfirmation - Scenario Bot Deck: " + string(selected_bot_deck_id));
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
    
    // --- LEGACY ID REMAPPING (Fix for old saves/cache) ---
    var check_id = selected_bot_deck_id;
    
    // Convert string numbers to reals for checking
    if (is_string(check_id)) {
        if (check_id == "1") check_id = 1;
        else if (check_id == "2") check_id = 2;
        else if (check_id == "3") check_id = 3;
    }
    
    if (current_chapter == 1 || (variable_global_exists("current_chapter") && global.current_chapter == 1)) {
        if (check_id == 1) selected_bot_deck_id = "Invasion_Geule_Roche";
        if (check_id == 2) selected_bot_deck_id = "Essaim_Abyssien";
        if (check_id == 3) selected_bot_deck_id = "Bandit_Grand_Chemin";
    }
    
    // Final Assignment of Bot Deck ID to global
    global.selected_bot_deck_id = selected_bot_deck_id;
    show_debug_message("### oDuelConfirmation - Final Global Bot Deck ID: " + string(global.selected_bot_deck_id));

    setup_done = true;
}

if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    
    if (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height) {
        
        // Stop sounds
        audio_stop_all();

        room_goto(rDuel);
    }
}
