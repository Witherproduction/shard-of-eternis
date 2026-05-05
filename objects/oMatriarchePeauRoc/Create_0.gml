event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Matriarche peau-de-roc"
attack = 6;
PV = 6;
mana_cost = 7;
genre = "Bête"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 1 'sanglier peau-de-roc' sur la ligne de front."
effects = [
    {
        id: 1,
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
