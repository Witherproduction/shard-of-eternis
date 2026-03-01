event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Matriarche peau-de-roc"
attack = 5;
PV = 6;
mana_cost = 6;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 2 'sanglier peau-de-roc' sur la ligne de front."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSanglierPeauRoc",
        conditions: { summon_mode: "Summon" },
        placement_criteria: { relative_role: "front" }
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSanglierPeauRoc",
        conditions: { summon_mode: "Summon" },
        placement_criteria: { relative_role: "front" }
    }
]

race = "Sanglier";
tags = ["BÃªte", "Sanglier", "Eveil"];
