event_inherited();

// Définit les stats spécifiques de ce sort
name = "Purification du Sang-pur"
mana_cost = 5;
genre = "Sort"
race = "Lumière";
tags = ["Lumière"];
rarity = "Epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige 2 dégats à tous les monstres. En inflige 4 si c'est des mort-vivant."

effects = [
    {
        id: 1,
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        target_zone: "field",
        monster_type: "Monster",
        visual_fx: "multicible"
    },
    {
        id: 2,
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        target_zone: "field",
        monster_type: "Monster",
        criteria: { genre: "Mort-vivant" },
        visual_fx: "multicible"
    }
];
