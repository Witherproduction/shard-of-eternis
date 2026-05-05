// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Journalier des Landes du sépulcre"
attack = 1;
PV = 2;
mana_cost = 1;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Maintenant qu'il a l'âge, il aide son perd dans les champs."

event_inherited();  // Hérite des variables et comportement de oCardMonster



