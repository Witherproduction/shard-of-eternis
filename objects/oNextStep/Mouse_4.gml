show_debug_message("### oNextStep.clic")

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager)) {
    var tuto = instance_find(oTutorielManager, 0);
    if (variable_instance_exists(tuto, "isClickAllowed") && !tuto.isClickAllowed(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0))) {
        return;
    }
}

// Permet au parent (oButtonBlock) de bloquer si nécessaire
event_inherited();

// Vérifier si on est dans la room de duel
if (room != rDuel) {
    exit;
}

if (global.isGraveyardViewerOpen) exit;

// Si le bouton est activé
if (image_index == 0) {
	
	// Check online turn
	if (instance_exists(oGame) && variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
	    if (!oGame.is_local_turn) exit;
	}
	
	// Repose toutes les cartes sélectionnées
	// selectManager.unSelectAll(); // Géré par le contrôleur désormais
	// game.nextPhase(); // Géré par le contrôleur désormais
	
	// Utilisation du nouveau système de Commandes (Phase 1.2 PvP)
	// Calcul des valeurs cibles pour forcer la synchro
	var target_phase = (oGame.phase_current + 1) % 3;
	var target_player = oGame.player_current;
	var target_turn = oGame.nbTurn;
	
	if (oGame.phase[oGame.phase_current] == "Attack") {
	    target_player = (target_player + 1) % 2;
	    target_turn++;
	}
	
	RequestGameAction(ACTION_NEXT_PHASE, {
	    target_phase_index: target_phase,
	    target_player_index: target_player,
	    target_turn: target_turn
	});
}
