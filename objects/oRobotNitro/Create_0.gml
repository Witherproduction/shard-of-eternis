event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot nitro"
attack = 500;
defense = 500;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel : Attaque directement l'adversaire"
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_ATTACK_DIRECT,
    owner: "ally",
    target_zone: "Field",
});