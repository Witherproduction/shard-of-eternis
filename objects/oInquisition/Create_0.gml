event_inherited();

// Définit les stats spécifiques de ce sort
name = "Inquisition"
mana_cost = 2;
genre = "Sort"
race = "Lumière";
tags = ["Lumière"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Purge un monstre puis lui inflige 2 dégats."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PURGE,
        scope: "single",
        owner: "both",
        target_zone: "field",
        criteria: { type: "Monster" },
        flow_next: {
            effect_type: EFFECT_DAMAGE_TARGET,
            value: 2
        }
    }
];
