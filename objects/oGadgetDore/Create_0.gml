event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gadget doré"
attack = 1000;
defense = 1000;
star = 3;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel et Perdu : Ajoute dans votre main un Gadget bronze et un Gadget argent depuis votre deck ou cimetière."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_SEARCH,
    search_sources: ["Deck", "Graveyard"],
    destination: "Hand",
    search_criteria: { name: "Gadget bronze" },
    flow: [
        { effect_type: EFFECT_TEMPO, ms: 500 },
        { effect_type: EFFECT_SEARCH, search_sources: ["Deck", "Graveyard"], destination: "Hand", search_criteria: { name: "Gadget argent" } }
    ],
    description: "À l'invocation : Ajoutez un Gadget bronze et un Gadget argent du Deck ou du Cimetière à votre main."
});
array_push(effects, {
    id: 2,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_SEARCH,
    search_sources: ["Deck", "Graveyard"],
    destination: "Hand",
    search_criteria: { name: "Gadget bronze" },
    flow: [
        { effect_type: EFFECT_TEMPO, ms: 500 },
        { effect_type: EFFECT_SEARCH, search_sources: ["Deck", "Graveyard"], destination: "Hand", search_criteria: { name: "Gadget argent" } }
    ],
    description: "Quand cette carte est envoyée au cimetière : Ajoutez un Gadget bronze et un Gadget argent du Deck ou du Cimetière à votre main."
});