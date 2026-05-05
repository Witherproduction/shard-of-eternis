// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Avant-garde du du Sang-Pur"
attack = 1;
PV = 6;
mana_cost = 3;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Il donnera sa vie pour protéger l'Ordre du sang pur."

event_inherited();  // Hérite des variables et comportement de oCardMonster



