event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Bandit guerrier"
attack = 5;
PV = 5;
mana_cost = 5;
genre = "Humanoïde"
race = "Humain";tags = ["Humanoïde", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un bandit sur un emplacement libre adjacent."
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



