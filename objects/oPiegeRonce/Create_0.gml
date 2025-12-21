event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Piège de ronce"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsque vous êtes attaqué directement. Entrave tout les serviteurs adverse."
effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "all",
        owner: "enemy"
    }
]
