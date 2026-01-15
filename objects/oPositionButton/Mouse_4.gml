show_debug_message("### oPositionButton.Click");
if (global.isGraveyardViewerOpen) exit;

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) exit;

show_debug_message("parentCard: " + string(parentCard));

// Vérifier que la carte parente existe
if (parentCard == noone || !instance_exists(parentCard)) {
    show_debug_message("ERROR: parentCard is invalid or doesn't exist");
    return;
}

// Si une animation est déjà en cours, on ne bloque plus : on va recibler
if (variable_instance_exists(parentCard, "position_anim_active") && parentCard.position_anim_active) {
    show_debug_message("Animation already active: retargeting to new orientation");
}

show_debug_message("parentCard exists, sending RequestGameAction SWITCH_POSITION");

// Utilisation du Command Pattern pour changer la position
if (script_exists(asset_get_index("RequestGameAction"))) {
    var payload = {
        card_uid: parentCard.instance_uid
    };
    RequestGameAction(ACTION_SWITCH_POSITION, payload);
} else {
    show_debug_message("CRITICAL ERROR: RequestGameAction script not found");
}

// Empêche la propagation du clic vers les objets en dessous
exit;