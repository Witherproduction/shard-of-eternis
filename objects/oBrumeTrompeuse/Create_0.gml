event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Brume trompeuse"
mana_cost = 5;
genre = "Sort"
race = "Ombre";tags = ["Sort", "Ombre"];
rarity = "legendaire"
booster = "Retour des Archontes"
is_player_card = true;

description = "DÃ©truit tous les serviteurs qui n'ont pas Camouflage."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY,
        owner: "both",
        target_zone: "Field",
        target_types: ["Monster"],
        criteria: { exclude_camouflaged: true },
        select_all: true
    }
]

