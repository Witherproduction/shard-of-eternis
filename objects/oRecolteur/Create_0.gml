event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Le RÃ©colteur"
attack = 4;
PV = 6;
mana_cost = 6;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 'Catherine fumerol' et 'Yvan le costaud'"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oCatherineFumerol",
        placement_criteria: { relative_role: "support" }
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oYvanCostaud",
        placement_criteria: { relative_role: "tank" }
    }
]

race = "Humain";
tags = ["HumanoÃ¯de", "Humain", "Eveil"];
