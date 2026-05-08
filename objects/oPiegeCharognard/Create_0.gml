event_inherited();

// Définit les stats spécifiques de ce sort
name = "Piège du charognard"
mana_cost = 2;
genre = "Secret"
race = "Nature";
tags = ["Nature","Secret","Poison"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Secret (tour adverse) : Quand un ennemi attaque votre héros, ce monstre reçoit Poison et l'attaque est annulée."

effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "attacker",
        block_attack: true,
        duration_turns: 1,
        flow: [
            {
                effect_type: EFFECT_BUFF,
                scope: "single",
                target_source: "attacker",
                grant_poison: true,
                temporary: false
            }
        ]
    }
];
