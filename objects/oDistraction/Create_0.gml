event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Distraction"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsque votre adverse invoque un monstre. Copie une carte de la main adverse et l'ajoute à votre main."
effects = [
    {
        id: 1,
        // Secret: s'active sur l'invocation d'un monstre adverse
        secret_activation: { on_summon: true },
        effect_type: EFFECT_PILLAGE,
        operation: "copy",
        source_zone: "Hand",
        destination: "Hand",
        random_select: true,
        value: 1
    }
]
