event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Fourrageur Abyssien"
attack = 2;
PV = 1;
mana_cost = 2;
genre = "HumanoÃ¯de"
race = "Abyssien";tags = ["HumanoÃ¯de", "Abyssien", "Eveil"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un 'Courreur Abyssien'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oCoureurAbyssien",
        placement_criteria: { relative_role: "adjacent" }
    }
];


