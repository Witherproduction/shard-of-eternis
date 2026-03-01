event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Cape d'ombre"
mana_cost = 2;
genre = "Sort"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +2/+2 et Camouflage Ã  un serviteur."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        atk: 2,
        PV: 2,
        grant_camouflage: true
    }
]
tags = ["Ombre", "Sort"];
