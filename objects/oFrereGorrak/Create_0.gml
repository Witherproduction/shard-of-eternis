event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "FrÃ¨re de Gorrak"
attack = 3;
PV = 6;
mana_cost = 6;
genre = "HumanoÃ¯de"
Race = "Skarl"
tag = ["HumanoÃ¯de","Skarl","Eveil"]
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : RÃ©duit de 2 l'ATK de tous les monstre adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "enemy",
        atk: -2,
        aggregate: false
    }
];


race = "Skarl";
tags = ["HumanoÃ¯de", "Skarl", "Eveil"];
