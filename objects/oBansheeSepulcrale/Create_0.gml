// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Banshee Sépulcrale"
attack = 3;
PV = 3;
mana_cost = 4;
genre = "Mort-vivant"
race = "Banshee";
tags = ["Mort-vivant", "Banshee", "Aura"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Aura : Les serviteur ennemis sur la ligne de front ont -1/-1."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_AURA_ALL_MONSTERS_DEBUFF,
        atk: -1,
        PV: -1,
        owner: "enemy",
        front_line_only: true
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



