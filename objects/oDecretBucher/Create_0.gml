event_inherited();

// Définit les stats spécifiques de ce sort
name = "Décret du Bûcher"
mana_cost = 3;
genre = "Sort"
race = "Ombre";
tags = ["Sort", "Ombre"];
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Détruisez un monstre Mort-vivant. Son contrôleur défausse 1 carte."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY_TARGET,
        scope: "single",
        target_zone: "field",
        owner: "both",
        criteria: { type: "Monster", genre: "Mort-vivant" },
        
        flow_next: {
            effect_type: EFFECT_DISCARD,
            owner: "source_controller",
            selection: { mode: "random", count: 1 }
        }
    }
];
