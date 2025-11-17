event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Convoyeur"
genre = "Direct"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Envoie un Méca aléatoire de votre deck à votre cimetière."

effects = [];
array_push(
    effects,
    {
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SEARCH,
        search_sources: ["Deck"],
        destination: "Graveyard",
        search_criteria: { type: "Monster", genre: "Méca" },
        random_select: true,
        description: "Envoyez aléatoirement un monstre Méca du deck au cimetière."
    }
);