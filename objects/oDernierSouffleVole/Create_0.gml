event_inherited();

// Définit les stats spécifiques de ce sort
name = "Dernier souffle volé"
mana_cost = 2;
genre = "Secret"
race = "Ombre";
tags = ["Ombre","Secret"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Quand un allié meurt, inflige 2 dégats au héros adverse et soigne votre héros de 2."

effects = [
    {
        id: 1,
        // Secret (tour adverse) : quand un allié va être détruit
        secret_activation: { on_destroy_attempt: true, allow_combat: true, only_if_opponent: true },
        // Filtre pour éviter les activations sur des cartes non-monstres
        conditions: { target_type: "monster" },
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value: 2,
        flow: [
            {
                effect_type: EFFECT_POINTS,
                op: "heal",
                scope: "lp",
                owner: "ally",
                value: 2
            }
        ]
    }
];
