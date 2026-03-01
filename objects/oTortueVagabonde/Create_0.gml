// DÃ©finit les stats spÃ©cifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Tortue vagabonde"
attack = 1;
PV = 6;
mana_cost = 2;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Elle longe la lisiÃ¨re sÃ©parant les forÃªt Ã  la recherche de ses enfants."

event_inherited();  // HÃ©rite des variables et comportement de oCardMonster


race = "Tortue";
tags = ["BÃªte", "Tortue"];
