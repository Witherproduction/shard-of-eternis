event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Massacreur Geule-Roche"
attack = 10;
defense = 6;
star = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Aura : Les 'Loup de guerre Geule-Roche' ont +2/+2."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "aura",
        aggregate: true,
        target_zone: "field",
        criteria: { type: "Monster" },
        bonus_if_names: ["oLoupGuerreGeuleRoche"],
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
