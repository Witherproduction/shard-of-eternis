event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Rugissement de la forÃªt"
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +2 PV Ã  toutes vos BÃªtes.";
mana_cost = 2;
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "BÃªte" },
        atk: 0,
        PV: 2
    }
]
tags = ["Sort", "Nature"];
