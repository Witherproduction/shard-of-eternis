event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gadget bronze"
attack = 0;
defense = 0;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Perdu : Ajoute un Gadget argent du deck ou cimetière à votre main."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_SEARCH,
    search_sources: ["Deck", "Graveyard"],
    destination: "Hand",
    search_criteria: { name: "Gadget argent" },
    description: "Quand cette carte est envoyée au cimetière : Ajoutez un Gadget argent du Deck ou du Cimetière à votre main."
});