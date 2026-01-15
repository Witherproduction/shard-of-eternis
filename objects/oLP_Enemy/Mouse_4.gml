// Clic sur l'ennemi pour attaque directe
show_debug_message("### oLP_Enemy.Click - Clic sur l'ennemi");

// Vérifier si on est dans la room de duel
if (room != rDuel) {
    exit;
}

if (global.isGraveyardViewerOpen) exit;

// Vérifier si on est en mode attaque avec une carte sélectionnée
// IMPORTANT: L'attaque directe n'est possible QUE si le mode attaque a été activé via le bouton
if (selectManager.attackMode && selectManager.selected != noone) {
    var selectedCard = selectManager.selected;
    
    // Vérifier les conditions pour l'attaque directe
    if (selectedCard.isHeroOwner && selectedCard.type == "Monster" && selectedCard.zone == "FieldSelected" 
        && selectedCard.orientation == "Attack"
        && instance_exists(game) && game.player[game.player_current] == "Hero" && game.phase[game.phase_current] == "Attack") {
        
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
