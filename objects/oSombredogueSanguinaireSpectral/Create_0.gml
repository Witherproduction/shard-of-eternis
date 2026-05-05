// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Sombredogue sanguinaire spectral"
attack = 2;
PV = 3;
mana_cost = 3;
genre = "Mort-vivant"
race = "Loup";
tags = ["Mort-vivant", "Loup", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : Gagne +1 ATK et inflige 1 dégât au serviteur ennemi en face. S'il n'y en a pas, inflige 1 dégât à l'adversaire."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_source: "self",
        atk: 1,
        PV: 0,
        temporary: true,
        label: "Crépuscule",
        conditions: { owner_turn: true }
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_TARGET_FACING,
        label: "Crépuscule",
        conditions: { owner_turn: true },
        flow: { id: 21, effect_type: EFFECT_DAMAGE_TARGET, value: 1, target_source: "defender" },
        fallback_flow: { id: 22, effect_type: EFFECT_POINTS, scope: "lp", op: "damage", value: 1, owner: "enemy" }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



