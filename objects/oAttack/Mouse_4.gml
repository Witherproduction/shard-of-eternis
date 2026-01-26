/// @description Attack Button Click

if (global.isGraveyardViewerOpen) exit;

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) exit;

// Left pressed (clic gauche)
if (global.isGraveyardViewerOpen) exit;
if (parentCard != "" && selectManager.attackMode == false) {
    // Vérifier que l'instance de la carte parent existe encore
    if (!instance_exists(parentCard)) {
        return;
    }
    // Garde: activer le mode attaque uniquement pour un monstre du héros en phase Attack et orienté en Attaque
    if (!(instance_exists(game) && game.phase[game.phase_current] == "Attack")) {
        show_debug_message("### oAttack.Click: Pas en phase d'attaque");
        exit;
    }
    // Règle: pas d'attaque au tour 1 du duel
    if (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1) {
        show_debug_message("### oAttack.Click: Attaque interdite au tour 1 du duel -> pas de mode attaque");
        exit;
    }
    if (!(variable_instance_exists(parentCard, "type") && parentCard.type == "Monster")) {
        exit;
    }
    if (!(variable_instance_exists(parentCard, "isHeroOwner") && parentCard.isHeroOwner)) {
        show_debug_message("### oAttack.Click: Pas le propriétaire (isHeroOwner=false)");
        exit;
    }
    if (!(variable_instance_exists(parentCard, "orientation") && parentCard.orientation == "Attack")) {
        show_debug_message("### oAttack.Click: Pas en orientation Attaque");
        exit;
    }
    if (variable_instance_exists(parentCard, "entrave_turns_remaining") && parentCard.entrave_turns_remaining > 0 && variable_instance_exists(parentCard, "entrave_block_attack") && parentCard.entrave_block_attack) {
        show_debug_message("### oAttack.Click: carte entravée -> mode attaque bloqué");
        exit;
    }
    
    selectManager.attackMode = true;
    UIManager.hideAttackButton();
    
    // Créer la flèche de ciblage
    selectManager.createTargetingArrow(parentCard);
}