event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Guerrier Alpha"
attack = 500;
defense = 1000;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Perdu : Invoque un Méca de niveau 1 depuis votre deck."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_SUMMON,
    summon_mode: "named",
    allowed_sources: ["Deck"],
    criteria: { type: "Monster", genre: "Méca", star_eq: 1 },
    description: "Quand cette carte est envoyée au cimetière : Invoquez spécialement un Méca de niveau 1 depuis votre deck."
});