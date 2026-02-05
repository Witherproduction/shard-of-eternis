event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Catherine Fumerol"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crepuscule : Inflige 3 dégats à votre adversaire."
element = "feu"

effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value: 3
    }
]


