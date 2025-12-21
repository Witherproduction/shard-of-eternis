event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Main furtive"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Copie une carte de la main de votre adversaire et l'ajoute à votre main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "copy",
        source_zone: "Hand",
        destination: "Hand",
        random_select: true,
        value: 1
    }
]
