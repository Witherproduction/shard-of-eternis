event_inherited();

type = "Monster";
isTerrain = true;
attack = 0;
PV = 0;

// Définit les stats spécifiques de ce sort
name = "Brouillard des cimetières"
mana_cost = 3;
genre = "Terrain"
race = "Ombre";
tags = ["Ombre", "Terrain"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Aube adverse : Augmente de (1) le cout du 1er monstre que votre adversaire joue ce tour. Dure 3 tours."
effects = [
    {
        id: 1,
        trigger: TRIGGER_START_TURN,
        conditions: { opponent_turn: true, zone: "Field" },
        effect_type: EFFECT_SET_NEXT_PLAYED_MONSTER_COST_BONUS,
        owner: "enemy",
        value: 1
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
