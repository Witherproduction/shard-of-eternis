event_inherited();


// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Camouflage stratÃ©gique"
mana_cost = 2;
genre = "Sort"
race = "Ombre";tags = ["Ombre", "Sort"];
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +1/+2 Ã  un serviteur. S'il a Camouflage, il peut attaquer ce tour sans le perdre."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        keep_camouflage_this_turn: true,
        atk: 1,
        PV: 2
    }
]

