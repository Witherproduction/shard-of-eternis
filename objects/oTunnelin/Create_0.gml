event_inherited();
race = "Tunnelin";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Tunnelin"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque une copie de ce serviteur Ã  ses cotÃ©s."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oTunnelin",
        placement_criteria: { relative_role: "adjacent" }
    }
]

tags = ["HumanoÃ¯de", "Tunnelin", "Eveil"];
