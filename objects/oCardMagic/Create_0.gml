// oCardMagic - Create event
event_inherited();
type = "Magic";

// Ici tu peux ajouter d'autres variables propres aux monstres, par exemple :

orientation = "Attack";
orientationChangedThisTurn = false;
attackModeActivated = false;

// Callback appelé par oSelectManager quand une cible est choisie pour ce sort
    onTargetSelected = function(targetCard) {
        show_debug_message("### oCardMagic.onTargetSelected: " + string(targetCard));
        
        // Jouer le sort avec la cible sélectionnée
        // TOUTES les cartes Magie sont jouées en mode Sort (sans slot sur le terrain)
        var payload = {
            card: id,
            xy: [0, 0, -1], // Toujours -1 pour indiquer un sort Sort
            summon_mode: "Summon"
        };
    
    if (variable_instance_exists(id, "instance_uid")) {
        payload.card_uid = instance_uid;
    }
    
    if (targetCard != noone && instance_exists(targetCard)) {
        // Ajouter la cible au payload
        payload.target = targetCard;
        if (variable_instance_exists(targetCard, "instance_uid")) {
            payload.target_uid = targetCard.instance_uid;
        }
    }
    
    RequestGameAction(ACTION_SUMMON, payload);
    
    // Nettoyage UI après utilisation
    UIManager.selectedSummonOrSet = "";
    if (instance_exists(oSelectManager)) {
        with(oSelectManager) { unSelectAll(); }
    }
    UIManager.hideSummonAndSet();
    UIManager.hideEffectButton();
}
