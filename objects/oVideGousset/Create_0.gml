event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "VideGousset"
attack = 3;
PV = 4;
mana_cost = 4;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Eveil : Pille une carte du deck adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PILLAGE,
        source_zone: "Deck",
        destination: "Hand",
        random_select: true,
        value: 1,
        conditions: { summon_mode: "Summon" }
    }
]


race = "Humain";
tags = ["HumanoÃ¯de", "Humain", "Camouflage", "Eveil", "Pillage"];
