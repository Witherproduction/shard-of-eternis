event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Loup galeux"
attack = 4;
defense = 3;
star = 1;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Gagne +3 ATK tant qu'il n'y a aucune autre bête sur le terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        per_genre: "Bête",
        per_zone: "field",
        per_owner: "both",
        exclude_self_in_per_count: true,
        exclude_face_down_in_per_count: true,
        apply_only_if_per_genre_count_is_zero: true,
        per_zero_bonus_atk: 3
    }
]
