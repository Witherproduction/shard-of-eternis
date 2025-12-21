event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Cape d'ombre"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne camouflage à un serviteur"
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_CAMOUFLAGE,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" }
    }
]
