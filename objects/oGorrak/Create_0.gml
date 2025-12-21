event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gorrak"
attack = 7;
defense = 7;
star = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 2 'Estafette Skarl'. Crépuscule : Inflige 3 dégats à votre adversaire pour chaque Humanoïde allié sur le terrain."
element = "physique"

effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oEstafetteSkarl"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oEstafetteSkarl"
    },
    {
        id: 3,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value_per_card: 3,
        target_zone: "field",
        criteria: { type: "Monster", genre: "Humanoïde" },
        count_owner: "ally",
        label: "Crépuscule"
    }
]

