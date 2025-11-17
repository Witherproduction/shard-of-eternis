event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tireur bêta"
attack = 1500;
defense = 500;
star = 2;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel : Détruit un monstre sur le terrain adverse aléatoire."
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_DESTROY,
    owner: "enemy",
    target_zone: "Field",
    target_types: ["Monster"],
    random_select: true,
    destroy_count: 1,
    
});