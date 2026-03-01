event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "James la CalamitÃ©"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "HumanoÃ¯de"
race = "Humain";tags = ["HumanoÃ¯de", "Humain", "Camouflage", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Camouflage. CrÃ©puscule : Pille une carte du deck adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_PILLAGE,
        operation: "steal",
        source_zone: "Deck",
        destination: "Hand",
        value: 1,
        random_select: true,
        label: "CrÃ©puscule"
    }
]



