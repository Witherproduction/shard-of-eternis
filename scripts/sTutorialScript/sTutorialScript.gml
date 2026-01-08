/// @function AI_GetTutorialMove(turn, phase)
/// @description Retourne un coup scripté pour le tutoriel (Chapitre 0)
/// @param {real} turn Numéro du tour
/// @param {string} phase Phase de jeu ("Summon", "Attack")
function AI_GetTutorialMove(turn, phase) {
    if (!variable_global_exists("current_chapter") || global.current_chapter != 0) return noone;
    
    show_debug_message("### AI_GetTutorialMove called: Turn " + string(turn) + ", Phase " + phase);

    var move = noone;
    
    if (phase == "Summon") {
        var moves = AI_GetLegalMoves_Summon();
        show_debug_message("### AI_GetTutorialMove: Summon moves count: " + string(array_length(moves)));
        
        // DEBUG: List available moves
        for (var i = 0; i < array_length(moves); i++) {
             var m = moves[i];
             if (m.type == "summon") {
                 show_debug_message("### Available Move: " + object_get_name(m.card.object_index));
             }
        }
        
        // Tour 2 : Invoquer Araignée (Attaque)
        if (turn == 2) {
            move = AI_FindMove_Summon(moves, "oAraigneeForestiere", "Attack");
            if (move == noone) show_debug_message("### AI_GetTutorialMove: Failed to find oAraigneeForestiere in moves!");
            else show_debug_message("### AI_GetTutorialMove: Found oAraigneeForestiere move!");
        } 
        // Tour 4 : Poser Tortue (Défense)
        else if (turn == 4) {
            move = AI_FindMove_Summon(moves, "oTortueVagabonde", "Defense");
        }
        // Tour 6 : Invoquer Araignée (Attaque)
        else if (turn == 6) {
             move = AI_FindMove_Summon(moves, "oAraigneeForestiere", "Attack");
        }
        // Tour 8 : Invoquer Araignée (Attaque)
        else if (turn == 8) {
             move = AI_FindMove_Summon(moves, "oAraigneeForestiere", "Attack");
        }
        // Tour 10 : Poser Araignée (Défense)
        else if (turn == 10) {
             move = AI_FindMove_Summon(moves, "oAraigneeForestiere", "Defense");
        }
    } 
    // Phase d'Attaque
    else if (phase == "Attack") {
        var moves = AI_GetLegalMoves_Attack();
        
        // Tour 8 : Attaquer le Maître des Passes avec une Araignée
        if (turn == 8) {
             move = AI_FindMove_Attack(moves, "oAraigneeForestiere", "oMaitrePasse");
        }
    }
    
    return move;
}

/// @function AI_FindMove_Summon(moves, cardObjName, orientation)
/// @description Trouve un move d'invocation pour une carte spécifique
function AI_FindMove_Summon(moves, cardObjName, orientation) {
    for (var i = 0; i < array_length(moves); i++) {
        var m = moves[i];
        if (m.type == "summon") {
            var cardName = object_get_name(m.card.object_index);
            if (cardName == cardObjName) {
                // On clone le move ou on ajoute la propriété
                m.force_orientation = orientation;
                return m;
            }
        }
    }
    return noone;
}

/// @function AI_FindMove_Attack(moves, attackerObjName, targetObjName)
/// @description Trouve un move d'attaque spécifique
function AI_FindMove_Attack(moves, attackerObjName, targetObjName) {
    for (var i = 0; i < array_length(moves); i++) {
        var m = moves[i];
        // Vérifier le type si nécessaire, mais supposons que moves contient des attaques
        if (variable_struct_exists(m, "attacker") && variable_struct_exists(m, "target")) {
            var attName = object_get_name(m.attacker.object_index);
            var tgtName = object_get_name(m.target.object_index);
            
            if (attName == attackerObjName && tgtName == targetObjName) {
                return m;
            }
        }
    }
    return noone;
}
