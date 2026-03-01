// Définit les stats spécifiques de ce monstre
name = "Morgane la venimeuse"
attack = 1;
PV = 3;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
isPoisoner = true; // Force l'activation du poison
description = "Camouflage et poison."
effects = [
    {
            id: 1,
            trigger: TRIGGER_ENTER_FIELD,
            effect_type: EFFECT_CAMOUFLAGE,
            conditions: {}
        },
    {
        id: 2,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_POISON,
        conditions: {}
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster
race = "Humain";
tags = ["Humanoïde", "Humain", "Camouflage", "Poison"];
