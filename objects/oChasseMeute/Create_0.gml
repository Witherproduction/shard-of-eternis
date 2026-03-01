event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Chasse en meute"
mana_cost = 3;
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;
element = "Nature"

description = "Inflige 2 dÃ©gats Ã  votre adversaire pour chaque BÃªte que vous contrÃ´lez."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_POINTS,
        scope: "lp",
        owner: "enemy",
        operation: "damage",
        value_per_card: 2,
        count_owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "BÃªte" }
    }
]
tags = ["Nature", "Sort"];
