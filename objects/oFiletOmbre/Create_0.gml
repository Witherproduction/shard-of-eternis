event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Filet de l'ombre"
mana_cost = 1;
genre = "Secret"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "S'active lorsque votre adversaire attaque avec un monstre. Entrave l'attaquant."
effects = [
    {
        id: 1,
        // Secret dÃ©clenchÃ© Ã  l'attaque
        secret_activation: { on_attack: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "attacker",
        block_attack: true,
        // block_position: true, // Removed
        duration_turns: 1
    }
]
tags = ["Ombre", "Secret", "Entrave"];
