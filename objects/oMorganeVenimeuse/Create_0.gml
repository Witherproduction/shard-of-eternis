// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Morgane la venimeuse"
attack = 1;
PV = 3;
mana_cost = 2;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
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

event_inherited();  // HÃ©rite des variables et comportement de oCardMonster
race = "Humain";
tags = ["HumanoÃ¯de", "Humain", "Camouflage", "Poison"];
