event_inherited();

// Définit les stats spécifiques de ce sort
name = "Siphon d'âme"
mana_cost = 2;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige 3 dégats à une cible. Soigne votre héros de 3."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 3,
        scope: "field",
        select_mode: "target",
        owner: "enemy",
        element: "Ombre",
        flow: [
            {
                id: 2,
                effect_type: EFFECT_POINTS,
                op: "heal",
                scope: "lp",
                owner: "ally",
                value: 3
            }
        ]
    }
];
