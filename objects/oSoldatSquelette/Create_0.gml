// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Soldat squelette"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "Mort-vivant"
race = "Squelette";
tags = ["Mort-vivant", "Squelette"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Même mort, il continue de combattre pour sauver son royaume."

event_inherited();  // Hérite des variables et comportement de oCardMonster



