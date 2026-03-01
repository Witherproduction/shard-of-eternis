// DÃ©finit les stats spÃ©cifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "AraignÃ©e forestiÃ¨re"
attack = 2;
PV = 1;
mana_cost = 1;
genre = "BÃªte"
race = "AraignÃ©e";tags = ["BÃªte", "AraignÃ©e"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "A peine sortie de l'oeuf qu'elle est dÃ©ja venimeuse"

event_inherited();  // HÃ©rite des variables et comportement de oCardMonster



