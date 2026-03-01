event_inherited();
race = "Eau";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "MarÃ©e dÃ©ferlante"
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Renvoyez un serviteur adverse dans la main de son propriÃ©taire."
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_RETURN_TO_HAND,
        target_type: "monster",
        owner: "enemy"
    }
];
tags = ["Eau", "Sort"];
