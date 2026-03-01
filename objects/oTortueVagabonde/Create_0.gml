// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Tortue vagabonde"
attack = 1;
PV = 6;
mana_cost = 2;
genre = "Bête"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Elle longe la lisière séparant les forêt à la recherche de ses enfants."

event_inherited();  // Hérite des variables et comportement de oCardMonster


race = "Tortue";
tags = ["Bête", "Tortue"];
