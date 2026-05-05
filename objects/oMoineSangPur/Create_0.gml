// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Moine du Sang-pur"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Attaque", "Fauchage"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Fauchage (1)"
effects = [
    {
        id: 1,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_CLEAVE_ADJACENT,
        value: 1,
        owner: "enemy",
        conditions: { attacker_is_self: true },
        label: "Attaque"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



