event_inherited();
race = "Loup";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Loup galeux"
attack = 2;
PV = 3;
mana_cost = 2;
genre = "BÃªte"
tags = "BÃªte"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Gagne +3 ATK tant qu'il n'y a aucune autre bÃªte sur le terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        per_genre: "BÃªte",
        per_zone: "field",
        per_owner: "both",
        exclude_self_in_per_count: true,
        exclude_face_down_in_per_count: true,
        apply_only_if_per_genre_count_is_zero: true,
        per_zero_bonus_atk: 3
    }
]
tags = ["BÃªte", "Loup"];
