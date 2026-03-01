event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Voleur Finelame"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur

// MÃ©caniques spÃ©ciales
isPercee = true;

description = "Camouflage. PercÃ©e (Peut ignorer la ligne de front pour attaquer le HÃ©ros ou l'arriÃ¨re-garde)."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    }
]
race = "Humain";
tags = ["HumanoÃ¯de", "Humain", "Camouflage", "Percee"];
