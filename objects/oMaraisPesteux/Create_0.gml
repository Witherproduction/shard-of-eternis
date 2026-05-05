event_inherited();

type = "Monster";
isTerrain = true;
attack = 0;
PV = 0;

// Définit les stats spécifiques de ce sort
name = "Marais pesteux"
mana_cost = 3;
genre = "Terrain"
race = "Ombre";
tags = ["Ombre","Terrain"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Crépuscule adverse : Inflige 1 dégats à tous les serviteurs adverses blessés."

effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        conditions: { zone: "Field" },
        effect_type: EFFECT_TERRAIN_TICK,
        turns: 3
    },
    {
        id: 2,
        trigger: TRIGGER_START_TURN,
        conditions: { owner_turn: true, zone: "Field" },
        effect_type: EFFECT_TERRAIN_TICK,
        turns: 3
    },
    {
        id: 3,
        trigger: TRIGGER_END_TURN,
        conditions: { owner_turn: false, zone: "Field" },
        effect_type: EFFECT_DAMAGE_ALL,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster", is_injured: true }
    }
]
