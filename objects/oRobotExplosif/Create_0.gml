event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot explosif"
attack = 500;
defense = 500;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Tombe : Inflige 500 dégâts à votre adversaire pour chaque Robot explosif sur votre terrain ou cimetière."

if (!variable_instance_exists(id, "effects")) effects = [];
effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_DESTROY,
    effect_type: EFFECT_POINTS,
    scope: "lp",
    op: "damage",
    owner: "enemy",
    value_per_card: 500,
    target_zone: ["field", "graveyard"],
    count_owner: "ally",
    criteria: { object_name: "oRobotExplosif", type: "Monster" },
    description: "Quand cette carte est détruite : Infligez 500 dégâts par Robot explosif sur votre Terrain et dans votre Cimetière."
});