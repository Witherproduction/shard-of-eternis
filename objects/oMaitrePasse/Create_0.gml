// Définit les stats spécifiques de ce monstre
name = "Maître des passes"
attack = 5;
PV = 6;
mana_cost = 6;
genre = "Humanoïde"
tags = ["Humanoïde", "Humain", "Crepuscule"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : Invoque un Humanoïde de coût 3 ou moins depuis votre main." 
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        allowed_sources: ["Hand"],
        criteria: { type: "Monster", genre: "Humanoïde", star_lte: 3 },
        placement_criteria: { relative_role: "random" }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster
race = "Humain";

