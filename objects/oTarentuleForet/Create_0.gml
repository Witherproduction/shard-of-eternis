event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Tarentule des forÃªts"
attack = 4;
PV = 4;
mana_cost = 4;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "BrisÃ© : Invoque 2 'AraignÃ©e forestiÃ¨re'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oAraigneeForestiere",
        placement_criteria: { relative_role: "adjacent" }
    },
    {
        id: 2,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oAraigneeForestiere",
        placement_criteria: { relative_role: "adjacent" }
    }
]


race = "AraignÃ©e";
tags = ["BÃªte", "AraignÃ©e", "BrisÃ©"];
