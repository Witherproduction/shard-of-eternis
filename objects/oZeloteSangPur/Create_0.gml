// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Zélote du Sang-pur"
attack = 1;
PV = 1;
mana_cost = 2;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Ambidextrie"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ambidextrie"
isAmbidextrous = true;

event_inherited();  // Hérite des variables et comportement de oCardMonster



