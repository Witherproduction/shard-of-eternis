event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Machine de recyclage"
genre = "Continue"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Lorsqu'un Méca de niveau 1 est envoyé au cimetière, l'envoi à la place dans le deck."

if (!variable_instance_exists(id, "effects")) effects = [];
effects[0] = {
    id: "machine_recyclage_redirect_lv1_meca",
    trigger: TRIGGER_ON_MONSTER_SENT_TO_GRAVEYARD,
    effect_type: EFFECT_SEARCH,
    search_sources: ["Graveyard"],
    destination: "Deck",
    shuffle_deck: true,
    max_targets: 1,
    search_criteria: { type: "Monster", genre: "Méca", star_eq: 1 },
    prefer_last_in_graveyard: true,
    conditions: { target_type: "Monster", target_genre: "Méca" },
    description: "Tant que cette carte est sur le terrain : lorsqu'un Méca de niveau 1 est envoyé au cimetière, renvoyez-le dans le deck."
};