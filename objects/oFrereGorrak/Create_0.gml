event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Frère de Gorrak"
attack = 6;
PV = 8;
mana_cost = 7;
genre = "Humanoïde"
Race = "Skarl"
tag = ["Humanoïde","Skarl","Eveil"]
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Réduit de 2 l'ATK de tous les monstre adverse"
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
tags = ["Humanoïde", "Skarl", "Eveil"];
