event_inherited();
race = "Eau";

name = "Coquillage des marÃ©es";
genre = "Sort";
rarity = "rare";
booster = "Retour des Archontes";
is_player_card = true;

description = "Donne +2 PV Ã  tous vos serviteurs.";
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        target_zone: "field",
        owner: "ally",
        criteria: { type: "Monster" },
        atk: 0,
        PV: 2
    }
];
tags = ["Eau", "Sort"];
