event_inherited();

type = "Monster";
isTerrain = true;
attack = 0;
PV = 0;

// Définit les stats spécifiques de ce sort
name = "Nécropole profanée"
mana_cost = 3;
genre = "Terrain"
race = "Ombre";
tags = ["Ombre","Terrain"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Crépuscule : Soigne votre héros de 1 pour chaque mort-vivant allié. Dure 3 tours."

effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        conditions: { owner_turn: true, zone: "Field" },
        effect_type: EFFECT_POINTS,
        op: "heal",
        scope: "lp",
        owner: "ally",
        value_per_card: 1,
        count_owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Mort-vivant" }
    },
    {
        id: 2,
        trigger: TRIGGER_ENTER_FIELD,
        conditions: { zone: "Field" },
        effect_type: EFFECT_TERRAIN_TICK,
        turns: 3
    },
    {
        id: 3,
        trigger: TRIGGER_START_TURN,
        conditions: { owner_turn: true, zone: "Field" },
        effect_type: EFFECT_TERRAIN_TICK,
        turns: 3
    }
];
