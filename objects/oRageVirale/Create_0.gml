event_inherited();

// Définit les stats spécifiques de ce sort
name = "Rage virale"
mana_cost = 2;
genre = "Sort"
race = "Nature";
tags = ["Nature"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +3 ATK à une Bête alliée jusqu'a la fin du tour. Elle subis 2 dégats après avoir attaquer."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        select_mode: "target",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 3,
        temporary: true,
        flow: [
            {
                id: 2,
                effect_type: EFFECT_MARK_ATTACK_DAMAGE,
                value: 2,
                duration_mode: "until_end_of_turn"
            }
        ]
    }
];
