event_inherited();
race = "Loup";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Jeune loup"
attack = 1;
PV = 2;
mana_cost = 1;
genre = "Bête"
tags = "Bête"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Gagne +1 ATK pour chaque autre 'Jeune loup' sur le terrain"
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        per_name: "Jeune loup",
        per_amount_atk: 1,
        per_zone: "field",
        per_owner: "both",
        exclude_self_in_per_count: true,
        exclude_face_down_in_per_count: true
    }
]

tags = ["Bête", "Loup"];
