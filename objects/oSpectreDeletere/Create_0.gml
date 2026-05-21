// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Spectre délétère"
attack = 4;
PV = 2;
mana_cost = 3;
genre = "Mort-vivant"
race = "Fantôme";
tags = ["Mort-vivant", "Banshee", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 1 dégât à tous les ennemis."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_ALL,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



