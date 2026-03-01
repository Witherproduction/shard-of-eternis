event_inherited();
race = "Humain";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Sorcier voleur"
attack = 2;
PV = 2;
mana_cost = 2;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Vole un sort du deck adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PILLAGE,
        source_zone: "Deck",
        destination: "Hand",
        random_select: true,
        criteria: { is_magic: true }
    }
]


tags = ["HumanoÃ¯de", "Humain", "Eveil", "Pillage"];
