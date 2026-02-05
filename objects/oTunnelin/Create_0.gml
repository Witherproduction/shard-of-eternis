event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tunnelin"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque une copie de ce serviteur."
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


