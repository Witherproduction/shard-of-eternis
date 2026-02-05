event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Rôdeur des forêts"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
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


