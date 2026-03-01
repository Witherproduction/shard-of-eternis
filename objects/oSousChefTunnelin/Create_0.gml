event_inherited();
race = "Tunnelin";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Sous-chef Tunnelin"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Donne +2 ATK Ã  tous vos serviteur sur le terrain"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        criteria: { type: "Monster" },
        atk: 2
    }
]


tags = ["HumanoÃ¯de", "Tunnelin", "Eveil"];
