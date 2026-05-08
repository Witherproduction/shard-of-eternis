event_inherited();

type = "Monster";
isTerrain = true;
attack = 0;
PV = 0;

// Définit les stats spécifiques de ce sort
name = "Loi martiale"
mana_cost = 4;
genre = "Terrain"
race = "Lumière";
tags = ["Lumiere","Terrain"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Le 1er monstre joué par votre adverse à chaque tour est entravé. Dure 3 tours"

effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_MONSTER_SUMMON,
        conditions: { opponent_turn: true, zone: "Field", source_owner: "enemy", once_per_turn: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "source",
        duration_turns: 1
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
