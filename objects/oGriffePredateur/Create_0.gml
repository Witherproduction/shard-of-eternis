event_inherited();
race = "Nature";

name = "Griffe du prédateur";
genre = "Sort";
rarity = "commune";
booster = "Retour des Archontes";
is_player_card = true;

description = "Donne +2/+1 à une Bête alliée.";
mana_cost = 1; // Coût estimé (était Artéfact)

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_zone: "field",
        ally_only: true, // Important pour le ciblage
        criteria: { type: "Monster", genre: "Bête" },
        atk: 2,
        PV: 1
    }
];
tags = ["Sort", "Nature"];
