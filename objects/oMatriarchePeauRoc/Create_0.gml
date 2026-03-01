event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Matriarche peau-de-roc"
attack = 5;
PV = 6;
mana_cost = 6;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
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
tags = ["Bête", "Sanglier", "Eveil"];
