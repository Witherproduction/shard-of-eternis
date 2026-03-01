event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Massacreur Gueule-Roche"
attack = 7;
PV = 6;
mana_cost = 7;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Aura : Les 'Loup de guerre Gueule-Roche' ont +2/+2."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "aura",
        aggregate: true,
        target_zone: "field",
        criteria: { type: "Monster" },
        bonus_if_names: ["oLoupGuerreGueuleRoche"],
        exclude_face_down_targets: true,
        atk_bonus: 2,
        def_bonus: 2
    },
    {
        id: 99,
        trigger: TRIGGER_LEAVE_FIELD,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]


race = "Orc";
tags = ["Orc", "Aura", "HumanoÃ¯de"];
