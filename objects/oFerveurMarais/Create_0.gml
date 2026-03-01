event_inherited();
race = "Eau";

name = "Ferveur du marais";
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "rare";
booster = "Retour des Archontes";
is_player_card = true;

description = "Invoque 3 Coureurs Abyssiens (1/1) sur des emplacements aléatoires.";
mana_cost = 3;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_GENERIC_FLOW,
        flow: [
            { effect_type: EFFECT_SUMMON, summon_mode: "named", object_name: "oCoureurAbyssien", placement_criteria: { role: "random" } },
            { effect_type: EFFECT_TEMPO, frames: 10 },
            { effect_type: EFFECT_SUMMON, summon_mode: "named", object_name: "oCoureurAbyssien", placement_criteria: { role: "random" } },
            { effect_type: EFFECT_TEMPO, frames: 10 },
            { effect_type: EFFECT_SUMMON, summon_mode: "named", object_name: "oCoureurAbyssien", placement_criteria: { role: "random" } }
        ]
    }
];
tags = ["Eau", "Sort"];
