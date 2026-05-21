/// @description Step oIA - Throttle global des actions et dépilement des attaques IA
// Applique un délai global entre les actions IA (2s via IA_ACTION_DELAY_FRAMES)
// et séquence les attaques pendant la phase "Attack".

if (!instance_exists(game)) exit;
if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") exit;

// États et compteurs globaux de l'IA
if (!variable_instance_exists(id, "iaDelayFrames")) iaDelayFrames = 0;
if (!variable_instance_exists(id, "iaNextPhasePending")) iaNextPhasePending = false;
if (!variable_instance_exists(id, "attackProcessing")) attackProcessing = false;
if (!variable_instance_exists(id, "attackDelayFrames")) attackDelayFrames = 0;

var delay_cfg = (variable_global_exists("IA_ACTION_DELAY_FRAMES") ? global.IA_ACTION_DELAY_FRAMES : 30);

// --- Gestion de l'attente des animations (Globale) ---
// FX_Effect projectile/one_shot ne doivent pas bloquer l'IA (seul le halo de présentation)
var fx_active = (instance_exists(FX_Invocation) || instance_exists(FX_Combat) || instance_exists(FX_Destruction) || instance_exists(FX_Poison) || instance_exists(oFX_Draw) || instance_exists(oFX_Discard));
if (script_exists(asset_get_index("fxAuraIsBusy")) && fxAuraIsBusy()) {
    fx_active = true;
}

if (fx_active) {
    // Tant qu'une animation est active, on maintient les délais à leur valeur initiale
    // pour garantir une pause complète APRES la fin de l'animation.
    iaDelayFrames = delay_cfg;
    if (variable_instance_exists(id, "attackDelayFrames")) attackDelayFrames = delay_cfg;
    exit; // On arrête tout traitement IA pour ce step
}

// Décrément du délai global
if (iaDelayFrames > 0) iaDelayFrames -= 1;

// Transition de phase planifiée avec délai
if (iaNextPhasePending && iaDelayFrames <= 0) {
    iaNextPhasePending = false;
    
    // [HEARTHSTONE] Transition logic: Summoning -> Attacking -> End Turn
    if (aiTurnState == "Summoning") {
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA Step: Summoning done -> Switching to Attacking");
        aiTurnState = "Attacking";
        attack();
    } 
    else if (aiTurnState == "Attacking") {
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oIA Step: Attacking done -> End Turn");
        aiTurnState = "Done";
        game.nextPhase();
    } 
    else {
        // Fallback for other states or safety
        game.nextPhase();
    }
    
    exit; // ne pas enchaîner d'autres actions ce Step
}

// --- Boucle de phase principale (Summon/Main) ---
// Si l'IA est active dans sa phase principale, on boucle tant qu'elle a des actions
if (variable_instance_exists(id, "aiMainPhaseActive") && aiMainPhaseActive) {
    // SECURITY CHECK
    if (variable_instance_exists(game, "player") && game.player[game.player_current] != "Enemy") {
        aiMainPhaseActive = false;
        exit;
    }

    if (iaDelayFrames <= 0) {
        // Relancer la logique d'invocation pour voir s'il y a d'autres actions possibles
        summon();
        // Note: summon() va soit remettre un délai et garder active=true,
        // soit mettre active=false et appeler scheduleNextPhase().
        if (iaNextPhasePending) exit; // Si on passe à la phase suivante, on arrête là pour ce step
    }
}

// --- Dépiler séquentiellement les activations manuelles pendant la phase Summon ---
if (global.current_phase == "Summon" && manualEffectProcessing) {
    // Respecter délai configurable entre activations
    if (iaDelayFrames > 0) { exit; }

    // Exécuter une seule action puis réactiver le délai
    var qlen = array_length(manualEffectsQueue);
    if (qlen > 0) {
        var action = manualEffectsQueue[0];
        manualEffectsQueue = array_delete(manualEffectsQueue, 0, 1);
        AI_ActionExec_Perform(action);
        iaDelayFrames = delay_cfg; // attendre avant la prochaine activation
        exit;
    } else {
        // File vidée: terminer le traitement
        manualEffectProcessing = false;
        
        // Si on est dans la boucle Main Phase IA, on continue
        if (variable_instance_exists(id, "aiMainPhaseActive") && aiMainPhaseActive) {
             iaDelayFrames = delay_cfg;
        } else {
             // Sinon on termine la phase
             iaNextPhasePending = true;
             iaDelayFrames = delay_cfg;
        }
        exit;
    }
}

// --- Boucle principale de la phase d'invocation (Main Phase) ---
if (global.current_phase == "Summon" && variable_instance_exists(id, "aiMainPhaseActive") && aiMainPhaseActive) {
    // Si des effets manuels sont en cours, on attend qu'ils finissent
    if (manualEffectProcessing) exit;

    // Attendre le délai (animations, etc.)
    if (iaDelayFrames > 0) exit;
    
    // Relancer la logique de summon pour la prochaine action
    summon();
    exit;
}

// --- Séquencement d'attaque uniquement pendant la phase Attack ---
// [HEARTHSTONE] "Main" phase also covers attacking now
if ((global.current_phase == "Attack" || global.current_phase == "Main") && attackProcessing) {
    // SECURITY CHECK
    if (variable_instance_exists(game, "player") && game.player[game.player_current] != "Enemy") {
        attackProcessing = false;
        exit;
    }

    // Délai configurable entre attaques
    if (attackDelayFrames > 0) { attackDelayFrames -= 1; exit; }

    // Attendre la fin des FX de combat si activés
    var fx_on = (variable_global_exists("USE_COMBAT_FX") && global.USE_COMBAT_FX);
    if (fx_on) {
        if (instance_number(FX_Combat) > 0) exit; // attendre la fin du combat courant
    }

    // Lancer la prochaine attaque ou planifier la clôture de la phase
    if (!iaAttackTryLaunchNext()) {
        attackProcessing = false;
        iaNextPhasePending = true;
        iaDelayFrames = delay_cfg; // attendre 2s avant nextPhase
    } else {
        attackDelayFrames = delay_cfg; // attendre 2s avant prochaine attaque
    }
}
