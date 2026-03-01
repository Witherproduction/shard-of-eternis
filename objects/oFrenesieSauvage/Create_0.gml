event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "FrÃ©nÃ©sie sauvage"
mana_cost = 2;
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "ConfÃ¨re +1 ATK et Ambidextrie Ã  une BÃªte alliÃ©."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "BÃªte" },
        atk: 1,
        grant_ambidextrous: true
    }
]
tags = ["Nature", "Ambidextrie", "Sort"];
