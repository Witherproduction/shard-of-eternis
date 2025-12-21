event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Frénésie sauvage"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne Ambidextrie à une Bête allié."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        grant_ambidextrous: true
    }
]
