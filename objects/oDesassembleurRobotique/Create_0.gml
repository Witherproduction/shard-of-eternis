event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Désassembleur robotique"
genre = "Direct"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Détruit un Mécar de niveau 2 pour invoquer deux Méca de niveau 1 depuis votre cimetière."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(
    effects,
    {
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY,
        owner: "ally",
        target_zone: "Field",
        target_types: ["Monster"],
        criteria: { type: "Monster", genre: "Méca", star_eq: 2 },
        random_select: true,
        destroy_count: 1,
        flow: [
            { effect_type: EFFECT_TEMPO, ms: 800 },
            { effect_type: EFFECT_SUMMON, allowed_sources: ["Graveyard"], criteria: { type: "Monster", genre: "Méca", star_eq: 1 } },
            { effect_type: EFFECT_SUMMON, allowed_sources: ["Graveyard"], criteria: { type: "Monster", genre: "Méca", star_eq: 1 } }
        ]
    }
);