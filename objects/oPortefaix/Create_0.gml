event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Portefaix"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Eveil : Purge un serviteur adverse (Retire tous ses effets)."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PURGE,
        owner: "both",
        target_zone: "Field",
        target_types: ["Monster"],
        select_mode: "target",
        random_select: false,
        conditions: { summon_mode: "Summon" }
    }
]

race = "Humain";
tags = ["Humanoïde", "Humain", "Camouflage", "Eveil"];
