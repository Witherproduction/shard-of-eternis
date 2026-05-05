event_inherited();

// Définit les stats spécifiques de ce sort
name = "Cri de la meute"
mana_cost = 5;
genre = "Sort"
race = "Nature";
tags = ["Nature", "Bête"];
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Vos Bêtes gagnent +3/+3."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 3,
        PV: 3
    }
]

