event_inherited();
race = "Tunnelin";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tunnelin"
attack = 1;
PV = 2;
mana_cost = 2;
genre = "Humanoïde"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque une copie de ce serviteur à ses cotés."
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

tags = ["Humanoïde", "Tunnelin", "Eveil"];
