event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot aimant"
attack = 1000;
defense = 1000;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Perdu : Ajoute un monstre Méca de votre deck à votre main."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_SEARCH,
    search_sources: ["Deck"],
    destination: "Hand",
    search_criteria: { type: "Monster", genre: "Méca" },
    description: "Quand cette carte est envoyée au cimetière : Ajoutez un monstre Méca du Deck à votre main."
});