event_inherited();

// Définit les stats spécifiques de ce sort
name = "Négation mortuaire"
mana_cost = 4;
genre = "Secret"
race = "Ombre";
tags = ["Ombre","Secret"];
rarity = "Epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Lorsqu'un de vos serviteur meurt, soigne votre héros d'un montant égal à ses Pv de base."

effects = [
    {
        id: 1,
        secret_activation: { on_destroy_attempt: true, allow_combat: true, only_if_opponent: true },
        conditions: { target_type: "monster" },
        effect_type: EFFECT_POINTS,
        op: "heal",
        scope: "lp",
        owner: "ally",
        use_target_defense_as_value: true
    }
];
