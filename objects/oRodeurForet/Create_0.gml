event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "RÃ´deur des forÃªts"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un 'jeune loup'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oJeuneLoup",
        placement_criteria: { relative_role: "adjacent" }
    }
]


race = "Loup";
tags = ["BÃªte", "Loup", "Eveil"];
