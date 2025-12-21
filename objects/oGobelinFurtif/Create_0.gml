event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gobelin furtif"
attack = 4;
defense = 3;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage"

effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    }
];

