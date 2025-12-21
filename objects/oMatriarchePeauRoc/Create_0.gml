event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Matriarche peau-de-roc"
attack = 6;
defense = 6;
star = 3;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque 2 'sanglier peau-de-roc'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSanglierPeauRoc",
        conditions: { summon_mode: "Summon" }
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSanglierPeauRoc",
        conditions: { summon_mode: "Summon" }
    }
]

