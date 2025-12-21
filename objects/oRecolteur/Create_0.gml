event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Le Récolteur"
attack = 6;
defense = 6;
star = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 'Catherine fumerol' et 'Yvan le costaud'"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oCatherineFumerol"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oYvanCostaud"
    }
]

