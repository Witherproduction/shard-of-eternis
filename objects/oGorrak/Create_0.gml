event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Gorrak"
attack = 7;
PV = 7;
mana_cost = 8;
genre = "HumanoÃ¯de"
race = "Skarl";tags = ["HumanoÃ¯de", "Skarl", "Eveil", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 2 'Skarl ChÃ©tif' sur la ligne de front. n\CrÃ©puscule : Inflige 2 dÃ©gats Ã  votre adversaire pour chaque HumanoÃ¯de alliÃ© sur le terrain."
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
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        conditions: { summon_mode: "Summon" },
        summon_mode: "named",
        object_name: "oSkarlChetif",
        placement_criteria: { relative_role: "front" }
    },
    {
        id: 3,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value_per_card: 2,
        target_zone: "field",
        criteria: { type: "Monster", genre: "HumanoÃ¯de" },
        count_owner: "ally",
        label: "CrÃ©puscule"
    }
]


