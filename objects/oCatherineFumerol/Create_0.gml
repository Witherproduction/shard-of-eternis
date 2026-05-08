event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Catherine Fumerol"
attack = 3;
PV = 3;
mana_cost = 4;
genre = "Humanoïde"
race = "Humain";tags = ["Humain", "Humanoïde", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crepuscule : Inflige 2 dégats à votre adversaire."
element = "feu"

effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value: 2
    }
]


