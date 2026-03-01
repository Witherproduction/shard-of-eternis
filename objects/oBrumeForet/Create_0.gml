event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Brume de la forÃªt"
genre = "Sort"
race = "Ombre";tags = ["Ombre", "Sort", "Combo"];
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "ConfÃ¨re +2 ATK et Camouflage Ã  un serviteur alliÃ©.\nCombo (Camouflage) : DÃ©truit un serviteur ennemi alÃ©atoire."
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        target_type: "monster",
        scope: "single",
        owner: "ally",
        atk: 2,
        PV: 0,
        grant_camouflage: true,
        select_mode: "target",
        flow: [
            {
                effect_type: EFFECT_DESTROY,
                select_mode: "random",
                random_select: true,
                destroy_count: 1,
                owner: "enemy",
                target_zone: "field",
                target_types: ["Monster"],
                condition: "control_camouflaged",
                check_condition_before: true
            }
        ]
    }
]

