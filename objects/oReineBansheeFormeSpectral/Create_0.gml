// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Reine banshee, forme spectale"
attack = 4;
PV = 6;
mana_cost = 6;
genre = "Mort-vivant"
race = "Banshee";
tags = ["Mort-vivant", "Banshee", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : inflige 2 dégâts d'Ombre à tous les ennemis."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        owner: "enemy",
        target_zone: "field",
        element: "ombre",
        label: "Crépuscule",
        conditions: { owner_turn: true }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



