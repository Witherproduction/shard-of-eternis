event_inherited();

// Définit les stats spécifiques de ce sort
name = "Morsure contagieuse"
mana_cost = 3;
genre = "Sort"
race = "Nature";
tags = ["Nature"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige 2 dégats à un monstre. S'il meurt, invoque une Bête de votre deck de niveau 2 ou moins."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        flow_next: {
            effect_type: EFFECT_CONDITIONAL_FLOW,
            cond: { type: "target_alive" },
            else_flow: {
                effect_type: EFFECT_SUMMON,
                summon_mode: "named",
                from_deck_only: true,
                select_mode: "random",
                criteria: { type: "Monster", genre: "Bête", star_lte: 2 }
            }
        }
    }
];
