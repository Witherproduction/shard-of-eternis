event_inherited();
race = "Ombre";

name = "Dague du filou";
genre = "Sort";
rarity = "commun";
booster = "Retour des Archontes";
is_player_card = true;

description = "Donne +1 ATK. Combo (Camouflage) : Donne +3 ATK Ã  la place.";
mana_cost = 1;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_zone: "field",
        criteria: { type: "Monster" },
        atk: 1,
        PV: 0,
        bonus_condition: "control_camouflaged",
        bonus_atk: 2
    }
];
tags = ["Ombre", "Sort", "Combo"];
