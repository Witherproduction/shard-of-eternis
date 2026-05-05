// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Croc-entrave des brumes"
attack = 2;
PV = 4;
mana_cost = 4;
genre = "Bête"
race = "Loup";
tags = ["Bête", "Loup", "Eveil", "Entrave"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Le serviteur ennemi en face est Entravé pendant 1 tour et subit 1 dégât à la fin de vos 2 prochains tours."
effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_TARGET_FACING,
    flow: [
        { id: 2, effect_type: EFFECT_ENTRAVE, scope: "single", owner: "enemy" },
        { id: 3, effect_type: EFFECT_APPLY_DOT, value: 1, turns: 2 }
    ]
});

event_inherited();  // Hérite des variables et comportement de oCardMonster



