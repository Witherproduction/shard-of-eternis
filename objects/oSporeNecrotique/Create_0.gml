event_inherited();

// Définit les stats spécifiques de ce sort
name = "Spore nécrotique"
mana_cost = 4;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne l'effet Poison à un serviteur ennemi. Lorsqu'il subit des dégats, piochez une carte."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        select_mode: "target",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        grant_poison: true,
        temporary: false,
        flow: [
            {
                id: 2,
                effect_type: EFFECT_MARK_DRAW_ON_DAMAGE
            }
        ]
    }
];
