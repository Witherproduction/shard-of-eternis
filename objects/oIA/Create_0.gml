if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.create")

// --- FIX: Initialisation des références manquantes (oHandEnemy) ---
// Résout le crash "Variable oIA.oHandEnemy not set"
if (!variable_instance_exists(id, "oHandEnemy")) {
    oHandEnemy = noone;
    // Tenter de trouver la main adverse dans la room
    if (asset_get_index("oHand") > -1) {
        with (oHand) {
            if (variable_instance_exists(id, "isHeroOwner") && !isHeroOwner) {
                other.oHandEnemy = id;
                break;
            }
        }
    }
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
        show_debug_message("### oIA (Auto-Fix) - oHandEnemy assigned: " + string(oHandEnemy));
    }
}

// Initialisation du profil de comportement IA selon le deck choisi
if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) {
    // Récupère le nom de profil associé au deck (ex: "aggro", "control", etc.)
    var profileName = get_bot_deck_profile(global.selected_bot_deck_id);
    if (profileName != "") {
        AI_Config_SetBotProfile(1, profileName);
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
            show_debug_message("### oIA - Profil IA activé: " + profileName);
        }
    } else {
        AI_Config_SetBotProfile(1, "balanced");
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
            show_debug_message("### oIA - Pas de profil spécifique, utilisation de 'balanced'");
        }
    }
} else {
    // Sécurité si aucun ID de deck n'est défini
    AI_Config_SetBotProfile(1, "balanced");
}

///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

if (!variable_global_exists("IA_ACTION_DELAY_FRAMES")) global.IA_ACTION_DELAY_FRAMES = 1 * room_speed;
if (!variable_instance_exists(id, "iaDelayFrames")) iaDelayFrames = 0;
if (!variable_instance_exists(id, "iaNextPhasePending")) iaNextPhasePending = false;
// File des actions manuelles (effets, sorts) et état de traitement
if (!variable_instance_exists(id, "manualEffectsQueue")) manualEffectsQueue = [];
if (!variable_instance_exists(id, "manualEffectProcessing")) manualEffectProcessing = false;
scheduleNextPhase = function() { iaNextPhasePending = true; iaDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : room_speed); };
#region Function manageOrientation
manageOrientation = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.manageOrientation")
    
    var dif = (variable_global_exists("IA_DIFFICULTY") ? global.IA_DIFFICULTY : 0);
    
    // Récupération du profil IA
    var profile = AI_Config_GetBotProfile(1);
    var p_def_bias = (profile != undefined) ? profile.defense_bias : 50;
    var p_risk = (profile != undefined) ? profile.risk_tolerance : 50;

    // Parcourt les monstres de l'IA pour optimiser leur orientation
    for (var i = 0; i < 5; i++) {
        var cardEnemy = fieldMonsterEnemy.cards[i];
        var shouldDefend = false;

        // Nettoyage des références invalides
        if (cardEnemy != 0 && !instance_exists(cardEnemy)) {
            fieldMonsterEnemy.cards[i] = 0;
            continue;
        }

        if (cardEnemy != 0 && instance_exists(cardEnemy) && !cardEnemy.orientationChangedThisTurn) {
            if (variable_instance_exists(cardEnemy, "entrave_turns_remaining") && cardEnemy.entrave_turns_remaining > 0 && variable_instance_exists(cardEnemy, "entrave_block_position") && cardEnemy.entrave_block_position) {
                continue;
            }
            if (cardEnemy.isFaceDown) { continue; }
            
            var eAtkE = (variable_struct_exists(cardEnemy, "effective_attack") ? cardEnemy.effective_attack : (variable_instance_exists(cardEnemy, "attack") ? cardEnemy.attack : 0));
            var eDefE = (variable_struct_exists(cardEnemy, "effective_defense") ? cardEnemy.effective_defense : (variable_instance_exists(cardEnemy, "defense") ? cardEnemy.defense : 0));

            // Logique de base : Si DEF >> ATK, on défend
            // Modifié par le profil : Si defense_bias est haut (ex: 80), on défend même si DEF est juste un peu mieux ou égal
            if (eDefE > eAtkE + (50 - p_def_bias)) { 
                shouldDefend = true; 
            }

            // Analyser les menaces du héros
            for (var j = 0; j < array_length(fieldMonsterHero.cards); j++) {
                var cardHero = fieldMonsterHero.cards[j];
                if (cardHero != 0 && instance_exists(cardHero) && instance_exists(cardEnemy)) {
                    var eAtkH = (variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : (variable_instance_exists(cardHero, "attack") ? cardHero.attack : 0));
                    var eDefH = (variable_struct_exists(cardHero, "effective_defense") ? cardHero.effective_defense : (variable_instance_exists(cardHero, "defense") ? cardHero.defense : 0));
                    var heroInAttack = (variable_instance_exists(cardHero, "orientation") && cardHero.orientation == "Attack");
                    
                    // Si on risque de mourir en Attaque
                    if (heroInAttack && eAtkH > eAtkE) { 
                        // Si on est "Aggro" (risk_tolerance élevé), on accepte le risque si on peut aussi tuer ou faire mal
                        // Si risk_tolerance < 50, on a peur -> Defend
                        if (p_risk < 60) shouldDefend = true; 
                    }
                    
                    // Si on survit mieux en Défense
                    if (eAtkH < eDefE && eAtkH >= eAtkE) {
                        shouldDefend = true;
                    }
                }
            }

            // Changer l'orientation si nécessaire
            if (instance_exists(cardEnemy)) {
                if (shouldDefend && cardEnemy.orientation == "Attack") {
                    cardEnemy.orientation = "DefenseVisible";
                    cardEnemy.position_anim_active = true;
                    cardEnemy.anim_rotate_speed = (variable_global_exists("ANIM_ROTATE_SPEED") ? global.ANIM_ROTATE_SPEED : 6);
                    cardEnemy.anim_flip_speed = (variable_global_exists("ANIM_FLIP_SPEED") ? global.ANIM_FLIP_SPEED : 0.03);
                    cardEnemy.anim_flip_orig_scale = cardEnemy.image_xscale;
                    cardEnemy.anim_pre_delay_frames = (variable_global_exists("ANIM_ROTATE_PRE_DELAY_FRAMES") ? global.ANIM_ROTATE_PRE_DELAY_FRAMES : 6);
                    cardEnemy.anim_phase = "rotate";
                    cardEnemy.target_angle = 270;
                    cardEnemy.target_orientation = "DefenseVisible";
                    cardEnemy.image_index = 0;
                    if (variable_instance_exists(cardEnemy.id, "isFaceDown")) cardEnemy.isFaceDown = false;
                    cardEnemy.orientationChangedThisTurn = true;
                    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("IA change monstre en défense visible (anim)");
                    continue;
                } else if (!shouldDefend && (cardEnemy.orientation == "Defense" || cardEnemy.orientation == "DefenseVisible")) {
                    cardEnemy.orientation = "Attack";
                    cardEnemy.position_anim_active = true;
                    cardEnemy.anim_rotate_speed = (variable_global_exists("ANIM_ROTATE_SPEED") ? global.ANIM_ROTATE_SPEED : 6);
                    cardEnemy.anim_flip_speed = (variable_global_exists("ANIM_FLIP_SPEED") ? global.ANIM_FLIP_SPEED : 0.03);
                    cardEnemy.anim_flip_orig_scale = cardEnemy.image_xscale;
                    cardEnemy.anim_pre_delay_frames = (variable_global_exists("ANIM_ROTATE_PRE_DELAY_FRAMES") ? global.ANIM_ROTATE_PRE_DELAY_FRAMES : 6);
                    cardEnemy.anim_phase = "rotate";
                    cardEnemy.target_angle = 180;
                    cardEnemy.target_orientation = "Attack";
                    cardEnemy.image_index = 0;
                    cardEnemy.orientationChangedThisTurn = true;
                    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("IA change monstre en attaque (anim)");
                    continue;
                }
            }
        }
    }
}
#endregion



#region Function pick
pick = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.pick")
    deckEnemy.pick();
    if (instance_exists(game) && !game.timerEnabledPick) { scheduleNextPhase(); }
}
#endregion

#region Function summon
summon = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.summon (Refactored)");
    
    // Fix tardif si oHandEnemy manquant (cas où oIA créé avant oHand)
    if (!instance_exists(oHandEnemy) && asset_get_index("oHand") > -1) {
         with (oHand) {
             if (variable_instance_exists(id, "isHeroOwner") && !isHeroOwner) {
                 other.oHandEnemy = id;
                 break;
             }
         }
    }

    // Initialisation flag boucle
    if (!variable_instance_exists(id, "aiMainPhaseActive")) aiMainPhaseActive = false;

    var moves = AI_GetLegalMoves_Summon();
    var bestMove = AI_SelectBestMove(moves);
    
    if (bestMove != noone) {
        var success = AI_ExecuteMove(bestMove);
        if (success) {
            iaDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : room_speed);
            aiMainPhaseActive = true; // On continue la boucle au prochain Step
        } else {
            // Echec execution
            aiMainPhaseActive = false;
            scheduleNextPhase();
        }
    } else {
        // Plus rien à faire
        manageOrientation();
        aiMainPhaseActive = false;
        scheduleNextPhase();
    }
}
#endregion

// === Helpers pour attaque séquentielle ===
iaAttackResetEngagement = function() {
    for (var k = 0; k < array_length(fieldMonsterHero.cards); k++) {
        var ch0 = fieldMonsterHero.cards[k];
        if (ch0 != 0 && instance_exists(ch0)) { ch0.engagedThisPhase = false; }
    }
}

iaAttackTryLaunchNext = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.iaAttackTryLaunchNext (Refactored)");
    
    var moves = AI_GetLegalMoves_Attack();
    var bestMove = AI_SelectBestMove(moves);
    
    if (bestMove != noone) {
        var success = AI_ExecuteMove(bestMove);
        if (success) return true;
    }
    
    return false;
}


#region Function attack
attack = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.attack");

    // Orientation et effets rapides
    manageOrientation();
    // useQuickEffectsBeforeAttack(); // Ancienne logique retirée

    // Règle: pas d'attaque au tour 1
    if (game.nbTurn == 1) { if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.attack: Attaque interdite au tour 1 du duel"); game.nextPhase(); return; }

    iaAttackResetEngagement();
    if (variable_instance_exists(id, "attackProcessing") == false) attackProcessing = false;
    if (variable_instance_exists(id, "attackDelayFrames") == false) attackDelayFrames = 0;

    var launched = iaAttackTryLaunchNext();
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.attack: launched=" + string(launched));
    
    // Toujours dépiler via Step, avec délai configurable, que les FX soient activés ou non
    attackProcessing = launched;
    if (!launched) { game.nextPhase(); return; }

    // Initialiser un délai entre la première attaque et la suivante
    attackDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : 30);

    // Avec FX: le Step d'oIA dépilera au fur et à mesure
    // Sans FX: idem, le Step s'occupe du séquencement lent
}
#endregion

