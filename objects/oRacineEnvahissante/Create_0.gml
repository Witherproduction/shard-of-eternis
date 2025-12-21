event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Racine envahissante"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Entrave un serviteur adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" }
    }
]
