event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Morgane la venimeuse"
attack = 1;
PV = 3;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage et poison."
effects = [
    {
        id: 1,
        trigger: TRIGGER_PASSIVE,
        effect_type: EFFECT_STEALTH,
        conditions: {}
    },
    {
        id: 2,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_POISON,
        conditions: {}
    }
]


