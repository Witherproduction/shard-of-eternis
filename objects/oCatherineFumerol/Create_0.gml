event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Catherine Fumerol"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "HumanoÃ¯de"
race = "Humain";tags = ["Humain", "HumanoÃ¯de", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Crepuscule : Inflige 3 dÃ©gats Ã  votre adversaire."
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


