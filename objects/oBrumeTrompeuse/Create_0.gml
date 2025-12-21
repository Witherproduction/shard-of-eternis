event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Brume trompeuse"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "legendaire"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsqu'un de vos monstres doit être détruit par un effet. Annule l'effet et détruit un serviteur adverse."
effects = [
    {
        id: 1,
        // Activation en secret lors d'une tentative de destruction
        secret_activation: { on_destroy_attempt: true },
        effect_type: EFFECT_DESTROY,
        owner: "enemy",
        target_zone: "Field",
        criteria: { type: "Monster" },
        random_select: true,
        value: 1
    }
]
