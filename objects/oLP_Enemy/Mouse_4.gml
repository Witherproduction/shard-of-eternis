// Clic sur l'ennemi pour attaque directe
show_debug_message("### oLP_Enemy.Click - Clic sur l'ennemi");

// Vérifier si on est dans la room de duel
if (room != rDuel) {
    exit;
}

if (global.isGraveyardViewerOpen) exit;

// === Gestion Ciblage Effet (Magie) ===
if (instance_exists(oSelectManager) && oSelectManager.targetingEffect) {
    show_debug_message("### oLP_Enemy: Clic détecté en mode ciblage d'effet");
    var effectId = oSelectManager.targetingEffectId;
    if (effectId != noone) {
        // On autorise le ciblage du héros adverse
        // (Idéalement, on devrait vérifier si l'effet l'autorise, mais pour l'instant on suppose que oui si le joueur clique)
        // TODO: Ajouter une vérification des critères si nécessaire
        
        show_debug_message("### oLP_Enemy: Sélection comme cible d'effet");
        effectId.onTargetSelected(id);
        
        // Désactiver le ciblage (géré dans onTargetSelected normalement, mais sécurité)
        oSelectManager.targetingEffect = false;
        oSelectManager.targetingEffectId = noone;
        oSelectManager.remove();
        return;
    }
}

// Vérifier si on est en mode attaque avec une carte sélectionnée
// IMPORTANT: L'attaque directe n'est possible QUE si le mode attaque a été activé via le bouton
if (selectManager.attackMode && selectManager.selected != noone) {
    var selectedCard = selectManager.selected;
    
    // Vérifier les conditions pour l'attaque directe
    var isMyTurn = false;
    if (instance_exists(game)) {
        if (variable_instance_exists(game, "local_player_index")) {
            isMyTurn = (game.player_current == game.local_player_index);
        } else {
            isMyTurn = (game.player_current == 0);
        }
    }

    if (selectedCard.isHeroOwner && selectedCard.type == "Monster" && selectedCard.zone == "FieldSelected" 
        && selectedCard.orientation == "Attack"
        && instance_exists(game) && isMyTurn && (game.phase[game.phase_current] == "Attack" || game.phase[game.phase_current] == "Main")) {
        
        // Utilisation du Command Pattern pour l'attaque directe
        RequestGameAction(ACTION_ATTACK, {
            attacker_uid: selectedCard.instance_uid,
            target_type: "direct_lp"
        });
        
    } else {
        show_debug_message("### Conditions non remplies pour l'attaque directe");
    }
} else {
    show_debug_message("### Pas en mode attaque ou aucune carte sélectionnée");
}
