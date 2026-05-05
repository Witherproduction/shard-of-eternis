event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Le Récolteur"
attack = 6;
PV = 7;
mana_cost = 7;
genre = "Humanoïde"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 'Catherine fumerol' sur la ligne de retrait et 'Yvan le costaud'sur la ligne de front"
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
tags = ["Humanoïde", "Humain", "Eveil"];
