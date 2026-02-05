show_debug_message("### oFieldManagerEnemey.create - before event_inherited")
event_inherited();
show_debug_message("### oFieldManagerEnemey.create - after event_inherited")


///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

#region Function getCardPositionAvailableIA
getCardPositionAvailableIA = function(card) {show_debug_message("### oFieldMonster.getCardPositionAvailableIA");

	// Récupère la liste des positions disponibles
	var positionAvailable = ds_list_create();
    // Sécuriser l'accès à la carte avant toute utilisation
    if (card == noone || !instance_exists(card)) {
        show_debug_message("### ERREUR: getCardPositionAvailableIA: carte invalide ou inexistante");
        ds_list_destroy(positionAvailable);
        return -1;
    }

    // [HEARTHSTONE] Magic/Trap cards do not need a slot
    if (card.type != "Monster") {
        ds_list_destroy(positionAvailable);
        // Return dummy coordinates with index -1 to signal "no slot needed"
        return [0, 0, -1]; 
    }

    var field = getField(card.type);
    if (field == noone || !instance_exists(field)) {
        show_debug_message("### ERREUR: getCardPositionAvailableIA: terrain introuvable pour type=" + string(card.type));
        ds_list_destroy(positionAvailable);
        return -1;
    }
	for(var i = 0; i < 8; i++) {
		if(field.cards[i] == 0)
			ds_list_add(positionAvailable, i);
	}
	
	// Si on a au moins une position disponible
	if(ds_list_size(positionAvailable) > 0) {
        
        // --- CUSTOM PLACEMENT STRATEGY ---
        var botID = (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) ? global.selected_bot_deck_id : "Invasion_Gueule_Roche";
        var profile = AI_Config_GetBotProfile(botID);
        var strategy = (profile != undefined && variable_struct_exists(profile, "custom_rules") && variable_struct_exists(profile.custom_rules, "placement_strategy")) ? profile.custom_rules.placement_strategy : "random";
        
        var preferredPosition = -1;
        
        // --- NAMED CARD PLACEMENT PRIORITY (Rules > Strategy) ---
        var placementRules = (profile != undefined && variable_struct_exists(profile, "custom_rules") && variable_struct_exists(profile.custom_rules, "placement_priority")) ? profile.custom_rules.placement_priority : undefined;
        
        if (placementRules != undefined) {
             var cName = variable_instance_exists(card, "name") ? card.name : "";
             var cObj = object_get_name(card.object_index);
             var rule = undefined;
             
             if (variable_struct_exists(placementRules, cName)) rule = variable_struct_get(placementRules, cName);
             else if (variable_struct_exists(placementRules, cObj)) rule = variable_struct_get(placementRules, cObj);
             
             if (rule != undefined) {
                 var wantsFront = (rule == "front");
                 var wantsBack = (rule == "back");
                 
                 if (wantsFront) {
                    for (var k=0; k<ds_list_size(positionAvailable); k++) {
                        var val = ds_list_find_value(positionAvailable, k);
                        if (val <= 3) { preferredPosition = val; break; }
                    }
                    if (preferredPosition == -1) { // Fallback
                         for (var k=0; k<ds_list_size(positionAvailable); k++) {
                            var val = ds_list_find_value(positionAvailable, k);
                            if (val > 3) { preferredPosition = val; break; }
                        }
                    }
                 } else if (wantsBack) {
                    for (var k=0; k<ds_list_size(positionAvailable); k++) {
                        var val = ds_list_find_value(positionAvailable, k);
                        if (val > 3) { preferredPosition = val; break; }
                    }
                    if (preferredPosition == -1) { // Fallback
                         for (var k=0; k<ds_list_size(positionAvailable); k++) {
                            var val = ds_list_find_value(positionAvailable, k);
                            if (val <= 3) { preferredPosition = val; break; }
                        }
                    }
                 }
             }
        }

        // --- TUTORIAL OVERRIDE : Force Tortue on Frontline ---
        if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
            var cObj = object_get_name(card.object_index);
            if (cObj == "oTortueVagabonde") {
                // Force Frontline (0-3)
                preferredPosition = -1; // Reset to ensure we force it
                for (var k=0; k<ds_list_size(positionAvailable); k++) {
                    var val = ds_list_find_value(positionAvailable, k);
                    if (val <= 3) { preferredPosition = val; break; }
                }
            }
        }

        if (preferredPosition == -1 && strategy == "tank_front_dps_back") {
            // FIX: Use effective stats if available (consistent with AI Scoring), fallback to PV/attack
            var hp = variable_instance_exists(card, "effective_defense") ? card.effective_defense : (variable_instance_exists(card, "PV") ? card.PV : 0);
            var atk = variable_instance_exists(card, "effective_attack") ? card.effective_attack : (variable_instance_exists(card, "attack") ? card.attack : 0);
            
            var wantsFront = (hp > atk); // Tank -> Front (0-3)
            var wantsBack = (atk >= hp); // DPS -> Back (4-7)
            
            if (wantsFront) {
                // Try to find empty slot in 0-3
                for (var k=0; k<ds_list_size(positionAvailable); k++) {
                    var val = ds_list_find_value(positionAvailable, k);
                    if (val <= 3) {
                        preferredPosition = val;
                        break;
                    }
                }
                // Fallback to back row if front full
                if (preferredPosition == -1) {
                     for (var k=0; k<ds_list_size(positionAvailable); k++) {
                        var val = ds_list_find_value(positionAvailable, k);
                        if (val > 3) {
                            preferredPosition = val;
                            break;
                        }
                    }
                }
            } else {
                // Wants Back (4-7)
                for (var k=0; k<ds_list_size(positionAvailable); k++) {
                    var val = ds_list_find_value(positionAvailable, k);
                    if (val > 3) {
                        preferredPosition = val;
                        break;
                    }
                }
                // Fallback to front row if back full
                if (preferredPosition == -1) {
                     for (var k=0; k<ds_list_size(positionAvailable); k++) {
                        var val = ds_list_find_value(positionAvailable, k);
                        if (val <= 3) {
                            preferredPosition = val;
                            break;
                        }
                    }
                }
            }
        }
        
        var position = -1;
        if (preferredPosition != -1) {
            position = preferredPosition;
        } else {
            // Default Random
		    ds_list_shuffle(positionAvailable);
		    position = ds_list_find_value(positionAvailable, 0);
        }

		var location = getPosLocation(card.type, position);
		ds_list_destroy(positionAvailable);
		return [location[0], location[1], position];
	}
    ds_list_destroy(positionAvailable);
	return -1;
}
#endregion
