event_inherited();

// Définit les stats spécifiques de ce sort
name = "Marque de décomposition"
mana_cost = 2;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne -2/-2 à un serviteur adverse. S'il meurt durant ce tour, piochez 1 carte."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        atk: -2,
        PV: -2,
        temporary: false,
        flow_next: {
            effect_type: EFFECT_MARK_DRAW_ON_DEATH_THIS_TURN
        }
    }
];
