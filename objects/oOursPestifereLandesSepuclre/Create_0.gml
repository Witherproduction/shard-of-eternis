// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Ours pestiféré des Landes du Sépulcre"
attack = 2;
PV = 12;
mana_cost = 8;
genre = "Bête"
race = "Ours";
tags = ["Bête", "Ours", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : Perd 1 PV."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_LOSE_DEFENSE,
        value: 1,
        conditions: { owner_turn: true },
        label: "Crépuscule"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



