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
var botID = (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) ? global.selected_bot_deck_id : "Invasion_Gueule_Roche";

if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) {
    // Récupère le nom de profil associé au deck (ex: "aggro", "control", etc.) ou une struct de directives
    // FIX: Utiliser get_bot_deck_by_id_new pour récupérer l'objet deck complet, 
    // car get_bot_deck_profile retourne une string "Personnalisé" pour les structs, ce qui casse la logique.
    var deckData = get_bot_deck_by_id_new(global.selected_bot_deck_id);
    var profileData = undefined;
    
    if (!is_undefined(deckData) && variable_struct_exists(deckData, "profile")) {
        profileData = deckData.profile;
    }
    
    var isValidProfile = false;
    if (is_string(profileData) && profileData != "") isValidProfile = true;
    if (is_struct(profileData)) isValidProfile = true;

    if (isValidProfile) {
        AI_Config_SetBotProfile(botID, profileData);
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
            var pName = is_string(profileData) ? profileData : "Custom Directives (Struct)";
            show_debug_message("### oIA - Profil IA activé pour Bot " + string(botID) + ": " + pName);
        }
    } else {
        AI_Config_SetBotProfile(botID, "balanced");
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
            show_debug_message("### oIA - Pas de profil spécifique, utilisation de 'balanced' pour Bot " + string(botID));
        }
    }
} else {
    // Sécurité si aucun ID de deck n'est défini
    AI_Config_SetBotProfile(botID, "balanced");
}

///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////
var ia_fps = game_get_speed(gamespeed_fps);

if (!variable_global_exists("IA_ACTION_DELAY_FRAMES")) global.IA_ACTION_DELAY_FRAMES = 1.5 * ia_fps;
if (!variable_instance_exists(id, "iaDelayFrames")) iaDelayFrames = 0;
if (!variable_instance_exists(id, "iaNextPhasePending")) iaNextPhasePending = false;
// File des actions manuelles (effets, sorts) et état de traitement
if (!variable_instance_exists(id, "manualEffectsQueue")) manualEffectsQueue = [];
if (!variable_instance_exists(id, "manualEffectProcessing")) manualEffectProcessing = false;
if (!variable_instance_exists(id, "aiTurnState")) aiTurnState = "Idle"; // Idle, Summoning, Attacking

scheduleNextPhase = function() { iaNextPhasePending = true; iaDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : game_get_speed(gamespeed_fps)); };

startTurnLogic = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.startTurnLogic");
    aiTurnState = "Summoning";
    aiMainPhaseActive = true;
    summon();
}

#region Function manageOrientation
manageOrientation = function() {
    // HEARTHSTONE MODE: No orientation management.
    // All minions are always in Attack mode.
    // This function is kept empty to prevent legacy calls from crashing.
}
#endregion



#region Function pick
pick = function() {
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA.pick")
    deckEnemy.pick();
    if (instance_exists(game) && !game.timerEnabledMulligan) { scheduleNextPhase(); }
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

    // --- TUTORIAL OVERRIDE ---
    if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
        var tutoMove = AI_GetTutorialMove(game.nbTurn, "Summon");
        if (tutoMove != noone) {
             var success = AI_ExecuteMove(tutoMove);
             if (success) {
                 iaDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : game_get_speed(gamespeed_fps));
                 aiMainPhaseActive = true; 
             } else {
                 aiMainPhaseActive = false;
                 scheduleNextPhase();
             }
             return;
        } else {
             aiMainPhaseActive = false;
             scheduleNextPhase();
             return;
        }
    }
    // -------------------------

    var moves = AI_GetLegalMoves_Summon();
    var bestMove = AI_SelectBestMove(moves);
    
    if (bestMove != noone) {
        var success = AI_ExecuteMove(bestMove);
        if (success) {
            iaDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : game_get_speed(gamespeed_fps));
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
    
    // --- TUTORIAL OVERRIDE ---
    if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
        var tutoMove = AI_GetTutorialMove(game.nbTurn, "Attack");
        if (tutoMove != noone) {
             var success = AI_ExecuteMove(tutoMove);
             if (success) return true;
             return false;
        } else {
             // Si pas de move tuto
             
             // SPECIAL TOUR 8: On interdit l'IA standard pour empêcher la 2ème attaque
             if (game.nbTurn == 8) {
                 return false;
             }
             
             // Pour les autres tours, on laisse le comportement par défaut (fall-through)
             // qui va exécuter l'IA standard ci-dessous.
        }
    }
    // -------------------------
    
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

    // --- TUTORIAL OVERRIDE ---
    if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
        var tutoMove = AI_GetTutorialMove(game.nbTurn, "Attack");
        if (tutoMove != noone) {
             var success = AI_ExecuteMove(tutoMove);
             if (success) {
                attackDelayFrames = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : game_get_speed(gamespeed_fps));
                 attackProcessing = true; // Continuer la boucle au prochain Step
                 return;
             }
        } 
        // Si pas de move ou move fait, on passe le tour d'attaque (IA passive sauf script)
        scheduleNextPhase();
        return;
    }
    // -------------------------

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


