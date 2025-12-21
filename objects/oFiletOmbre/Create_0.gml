event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Filet de l'ombre"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsque votre adversaire attaque avec un monstre. Entrave l'attaquant."
effects = [
    {
        id: 1,
        // Secret déclenché à l'attaque
        secret_activation: { on_attack: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "attacker",
        block_attack: true,
        block_position: true,
        duration_turns: 1
    }
]
