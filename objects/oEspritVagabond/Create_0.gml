// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Esprit vagabond"
attack = 4;
PV = 1;
mana_cost = 3;
genre = "Mort-vivant"
race = "Fantôme";
tags = ["Mort-vivant", "Banshee", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : inflige 1 dégât à un serviteur adverse aléatoire."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        conditions: { owner_turn: true },
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        select_mode: "random",
        label: "Crépuscule"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



