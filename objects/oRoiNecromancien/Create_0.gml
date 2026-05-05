// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Roi nécromancien"
attack = 5;
PV = 7;
mana_cost = 8;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Ponction", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ponction. Crépuscule :  invoque un serviteur Mort-vivant aléatoire de votre cimetière coûtant 3 ou moins."
hasPonction = true;
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        allowed_sources: ["Graveyard"],
        select_mode: "random",
        criteria: { type: "Monster", genre: "Mort-vivant", star_lte: 3 },
        label: "Crépuscule",
        conditions: { owner_turn: true }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



