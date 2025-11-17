event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot de renforcement"
attack = 0;
defense = 0;
star = 2;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel : Gagne +500/500 pour chaque Méca sur le terrain."
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_BUFF,
    scope: "single",
    mode: "add",
    per_genre: "Méca",
    per_zone: "Field",
    per_owner: "both",
    per_amount_atk: 500,
    per_amount_def: 500,
});