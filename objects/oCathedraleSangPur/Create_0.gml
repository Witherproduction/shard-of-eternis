event_inherited();

type = "Monster";
isTerrain = true;
attack = 0;
PV = 0;

// Définit les stats spécifiques de ce sort
name = "Cathédrale du sang-pur"
mana_cost = 3;
genre = "Terrain"
race = "Lumière";
tags = ["Lumiere","Terrain"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Aube : Un Humain allié aléatoire gagne +1/+1. Dure 3 tours"
effects = [
    {
        id: 1,
        trigger: TRIGGER_START_TURN,
        conditions: { owner_turn: true, zone: "Field" },
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        select_mode: "random",
        atk: 1,
        PV: 1,
        criteria: { type: "monster", race: "Humain" }
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
]
