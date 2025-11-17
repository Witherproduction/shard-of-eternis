event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot magnétique"
attack = 1000;
defense = 1000;
star = 2;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel : Détruit un Méca sur votre terrain pour gagner son ATK et sa DEF." 

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_DESTROY_TARGET,
    owner: "ally",
    target_zone: "Field",
    criteria: { type: "Monster", genre: "Méca", exclude_self: true },
    grant_destroyed_stats: true,
    flow: [
        { effect_type: EFFECT_TEMPO, ms: 300 },
        { effect_type: EFFECT_BUFF, scope: "single" }
    ],
    description: "À l'invocation : Détruisez un Méca allié et gagnez son ATK/DEF."
});