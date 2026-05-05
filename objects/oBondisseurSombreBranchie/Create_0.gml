// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Bondisseur Sombre-branchie"
attack = 3;
PV = 1;
mana_cost = 2;
genre = "Humanoïde"
race = "Abyssien";
tags = ["Humanoïde", "Abyssien", "Charge"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
has_charge = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge"

event_inherited();  // Hérite des variables et comportement de oCardMonster



