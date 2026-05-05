// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Dévoreur des ombres"
attack = 4;
PV = 1;
mana_cost = 3;
genre = "Bête"
race = "Loup";
tags = ["Bête", "Loup", "Charge", "Repoussement"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
has_charge = true;
hasRepoussement = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge. Repoussement."

event_inherited();  // Hérite des variables et comportement de oCardMonster



