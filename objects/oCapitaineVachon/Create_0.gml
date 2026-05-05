// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Capitaine Vachon"
attack = 3;
PV = 3;
mana_cost = 4;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Egide", "Repoussement"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
hasEgide = true;
hasRepoussement = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Egide. Repoussement "

event_inherited();  // Hérite des variables et comportement de oCardMonster



