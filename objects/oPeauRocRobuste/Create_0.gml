// Définit les stats spécifiques de ce monstre
name = "Peau-de-roc robuste"
attack = 5;
PV = 7;
mana_cost = 6;
genre = "Bête"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
has_charge = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge"
effects = []

event_inherited();  // Hérite des variables et comportement de oCardMonster
race = "Sanglier";
tags = ["Bête", "Sanglier", "Charge"];
