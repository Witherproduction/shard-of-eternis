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
	
	// Repose toutes les cartes sélectionnées
	selectManager.unSelectAll();
	game.nextPhase();
}
