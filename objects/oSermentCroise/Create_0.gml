event_inherited();

// Définit les stats spécifiques de ce sort
name = "Serment du croisé"
mana_cost = 2;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +3/+3 à un Humain allié. S'il tue un monstre ce tour-ci, piochez une carte."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        select_mode: "target",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", race: "Humain" },
        atk: 3,
        PV: 3,
        temporary: false,
        flow: [
            {
                id: 2,
                effect_type: EFFECT_MARK_DRAW_ON_KILL_THIS_TURN
            }
        ]
    }
];
