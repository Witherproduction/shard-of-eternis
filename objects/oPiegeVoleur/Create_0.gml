event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Piège du voleur"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsque votre adversaire invoque un monstre, l'entrave. "
effects = [
    {
        id: 1,
        secret_activation: { on_summon: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "summoned"
    }
]
