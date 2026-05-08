event_inherited();

// Définit les stats spécifiques de ce sort
name = "Exhumation rapide"
mana_cost = 2;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Ajoutez un serviteur aléatoire de votre cimetière à votre main. Il coûte (1) de moins."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SEARCH,
        search_sources: ["Graveyard"],
        destination: "Hand",
        max_targets: 1,
        random_select: true,
        search_criteria: { type: "Monster" },
        cost_delta: -1
    }
];
