event_inherited();
race = "Ombre";

name = "Sournoiserie";
genre = "Sort";
rarity = "rare";
booster = "Retour des Archontes";
is_player_card = true;

description = "Inflige 2 dégâts à un serviteur ennemi et l'Entrave.";
mana_cost = 2;
element = "Ombre";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        damage: 2,
        element: "Ombre",
        select_mode: "target",
        scope: "single",
        target_zone: "field",
        owner: "enemy",
        criteria: { type: "Monster" },
        flow: [
            { effect_type: EFFECT_ENTRAVE, scope: "single" }
        ]
    }
];
tags = ["Sort", "Ombre", "Entrave"];
