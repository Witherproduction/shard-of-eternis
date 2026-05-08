event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gorrak"
attack = 7;
PV = 7;
mana_cost = 8;
genre = "Humanoïde"
race = "Skarl";tags = ["Humanoïde", "Skarl", "Eveil", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 1 'Skarl Chétif' sur la ligne de front. n\Crépuscule : Inflige 2 dégats à votre adversaire pour chaque Humanoïde allié sur le terrain."
element = "physique"

effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oSkarlChetif",
        placement_criteria: { relative_role: "front" }
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value_per_card: 2,
        target_zone: "field",
        criteria: { type: "Monster", genre: "Humanoïde" },
        count_owner: "ally",
        label: "Crépuscule"
    }
]


