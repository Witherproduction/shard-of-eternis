// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Molosse décrépit"
attack = 2;
PV = 2;
mana_cost = 3;
genre = "Mort-vivant"
race = "Loup";
tags = ["Mort-vivant", "Loup", "Charge", "Repoussement"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
has_charge = true;
hasRepoussement = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge. Repoussement."

event_inherited();  // Hérite des variables et comportement de oCardMonster



