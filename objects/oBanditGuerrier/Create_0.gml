event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Bandit guerrier"
attack = 3;
PV = 2;
mana_cost = 4;
genre = "Humanoïde"
race = "Humain";tags = ["Humanoïde", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un bandit à ses cotés."
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



