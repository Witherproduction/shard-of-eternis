event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Fourrageur Abyssien"
attack = 2;
PV = 1;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un 'Courreur Abyssien'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oCoureurAbyssien",
        placement_criteria: { relative_role: "adjacent" }
    }
];


