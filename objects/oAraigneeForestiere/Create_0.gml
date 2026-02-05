// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Araignée forestière"
attack = 2;
PV = 1;
mana_cost = 1;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "A peine sortie de l'oeuf qu'elle est déja venimeuse"

event_inherited();  // Hérite des variables et comportement de oCardMonster


