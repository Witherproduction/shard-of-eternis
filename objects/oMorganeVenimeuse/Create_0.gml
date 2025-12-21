event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Morgane la venimeuse"
attack = 5;
defense = 5;
star = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage et poison."
isPoisoner = true;
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    }
]

