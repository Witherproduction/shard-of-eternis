// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "MaÃ®tre des passes"
attack = 3;
PV = 4;
mana_cost = 4;
genre = "HumanoÃ¯de"
tags = ["HumanoÃ¯de", "Humain", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "CrÃ©puscule : Invoque un HumanoÃ¯de de coÃ»t 2 ou moins depuis votre main." 
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        allowed_sources: ["Hand"],
        criteria: { type: "Monster", genre: "HumanoÃ¯de", star_lte: 2 },
        placement_criteria: { relative_role: "random" }
    }
]

event_inherited();  // HÃ©rite des variables et comportement de oCardMonster
race = "Humain";

