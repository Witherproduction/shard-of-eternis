function sEntrave(card, effect, context) {
    var target = variable_struct_exists(context, "target") ? context.target : noone;
    var scopeB = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
    var ownerB = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "enemy";
    var appliedOk = false;
    // Politique globale: Entrave bloque l'attaque uniquement (changement de position retiré du système)
    var blockAtk = true;
    // blockPos removed as per user instruction

    // Durée par défaut: jusqu'au début du prochain tour du propriétaire de la cible
    // Implémentation approximée via décrément à END_TURN: 1 si appliqué pendant le tour adverse, 2 si pendant le tour du propriétaire
    var activeIsHero = instance_exists(game) ? (game.player_current == 0) : true;
    var baseDur = 1;
    var isHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    
    // Déterminer les champs cibles dynamiquement
    var fieldAlly = isHero ? fieldMonsterHero : fieldMonsterEnemy;
    var fieldEnemy = isHero ? fieldMonsterEnemy : fieldMonsterHero;
    var frontLineOnly = (variable_struct_exists(effect, "front_line_only") && effect.front_line_only);
    var backLineOnly = (variable_struct_exists(effect, "back_line_only") && effect.back_line_only);

    if (scopeB == "single") {
        var tgtA = target;
        // Fallback to self only if not explicitly targeting enemy
        if (tgtA == noone && ownerB != "enemy") {
            tgtA = card;
        }

        if (tgtA != noone && instance_exists(tgtA)) {
            if (frontLineOnly || backLineOnly) {
                if (!variable_instance_exists(tgtA, "fieldPosition")) { return false; }
                if (frontLineOnly && (tgtA.fieldPosition < 0 || tgtA.fieldPosition > 3)) { return false; }
                if (backLineOnly && (tgtA.fieldPosition < 4 || tgtA.fieldPosition > 7)) { return false; }
            }
            var ownerT = (variable_instance_exists(tgtA, "isHeroOwner") ? tgtA.isHeroOwner : activeIsHero);
            var durA = baseDur + ((ownerT == activeIsHero) ? 1 : 0);
            tgtA.entrave_block_attack = true;
            tgtA.entrave_block_position = true;
            var remA = variable_instance_exists(tgtA, "entrave_turns_remaining") ? tgtA.entrave_turns_remaining : 0;
            tgtA.entrave_turns_remaining = max(remA, durA);
            appliedOk = true;
        }
    } else {
        if (ownerB == "ally" || ownerB == "both") {
            var arrH = fieldAlly.cards;
            for (var hi = 0; hi < array_length(arrH); hi++) {
                var ch = arrH[hi];
                if (ch != 0 && instance_exists(ch) && (variable_instance_exists(ch, "zone") && (ch.zone == "Field" || ch.zone == "FieldSelected"))) {
                    if (frontLineOnly || backLineOnly) {
                        if (!variable_instance_exists(ch, "fieldPosition")) continue;
                        if (frontLineOnly && (ch.fieldPosition < 0 || ch.fieldPosition > 3)) continue;
                        if (backLineOnly && (ch.fieldPosition < 4 || ch.fieldPosition > 7)) continue;
                    }
                    var ownerH = (variable_instance_exists(ch, "isHeroOwner") ? ch.isHeroOwner : activeIsHero);
                    var durH = baseDur + ((ownerH == activeIsHero) ? 1 : 0);
                    ch.entrave_block_attack = true;
                    ch.entrave_block_position = true;
                    var remH = variable_instance_exists(ch, "entrave_turns_remaining") ? ch.entrave_turns_remaining : 0;
                    ch.entrave_turns_remaining = max(remH, durH);
                    appliedOk = true;
                }
            }
        }
        if (ownerB == "enemy" || ownerB == "both") {
            var arrE = fieldEnemy.cards;
            for (var ei = 0; ei < array_length(arrE); ei++) {
                var ce = arrE[ei];
                if (ce != 0 && instance_exists(ce) && (variable_instance_exists(ce, "zone") && (ce.zone == "Field" || ce.zone == "FieldSelected"))) {
                    if (frontLineOnly || backLineOnly) {
                        if (!variable_instance_exists(ce, "fieldPosition")) continue;
                        if (frontLineOnly && (ce.fieldPosition < 0 || ce.fieldPosition > 3)) continue;
                        if (backLineOnly && (ce.fieldPosition < 4 || ce.fieldPosition > 7)) continue;
                    }
                    var ownerE = (variable_instance_exists(ce, "isHeroOwner") ? ce.isHeroOwner : !activeIsHero);
                    var durE = baseDur + ((ownerE == activeIsHero) ? 1 : 0);
                    ce.entrave_block_attack = true;
                    // ce.entrave_block_position = true; // Removed
                    var remE = variable_instance_exists(ce, "entrave_turns_remaining") ? ce.entrave_turns_remaining : 0;
                    ce.entrave_turns_remaining = max(remE, durE);
                    appliedOk = true;
                }
            }
        }
    }
    if (appliedOk) {
        var sndE = asset_get_index("entrave");
        if (sndE == -1) sndE = asset_get_index("Entrave");
        if (sndE != -1) { audio_play_sound(sndE, 0, false); }
        
        // Quest System Notification
        if (instance_exists(oQuestManager)) {
            oQuestManager.notify_event("apply_effect", 1, { effect: "Entrave", source: card, target: (scopeB == "single" ? target : undefined) });
        }
    }
    return appliedOk;
}
