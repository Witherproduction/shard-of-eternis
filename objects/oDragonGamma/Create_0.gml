event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Dragon gamma";
attack = 2000;
defense = 2000;
star = 3;
genre = "Méca / Dragon";
archetype = "Robot d'assaut";
booster = "Usine robotique";
rarity = "commun";
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Finalisation : Inflige 500 dégâts à votre adversaire";

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_END_TURN,
    effect_type: EFFECT_POINTS,
    scope: "lp",
    op: "damage",
    owner: "enemy",
    value: 500
});
