event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Bandit guerrier"
attack = 3;
PV = 2;
mana_cost = 4;
genre = "HumanoÃ¯de"
race = "Humain";tags = ["HumanoÃ¯de", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un bandit Ã  ses cotÃ©s."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oBandit",
        conditions: { summon_mode: "Summon" },
        placement_criteria: { relative_role: "adjacent" }
    }
]



