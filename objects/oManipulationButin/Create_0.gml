event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Manipulation du butin"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Echange une carte aléatoire de votre main avec une carte aléatoire de la main adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "exchange"
    }
]
