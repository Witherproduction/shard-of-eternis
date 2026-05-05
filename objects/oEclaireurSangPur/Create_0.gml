// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Eclaireur du du Sang-Pur"
attack = 2;
PV = 3;
mana_cost = 3;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Aube"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Aube : Inflige 1 dégats à votre adversaire."
effects = [
    {
        id: 1,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        target_zone: "field",
        affect_opponent_lp: true,
        label: "Aube"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



