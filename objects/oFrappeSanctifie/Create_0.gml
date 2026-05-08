event_inherited();

// Définit les stats spécifiques de ce sort
name = "Frappe sanctifiée"
mana_cost = 2;
genre = "Sort"
race = "Lumière";
tags = ["Lumière"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige 3 dégats. Si la cible est un mort-vivant, la détruit."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_CONDITIONAL_FLOW,
        cond: { type: "target_genre", genre: "Mort-vivant" },
        flow: {
            effect_type: EFFECT_DESTROY_TARGET
        },
        else_flow: {
            effect_type: EFFECT_DAMAGE_TARGET,
            value: 3
        }
    }
];
