// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Brise-os putréfié"
attack = 3;
PV = 4;
mana_cost = 3;
genre = "Mort-vivant"
race = "Skarl";
tags = ["Mort-vivant", "Skarl"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ce skarl a subit la malédiction des nécromenciens. Depuis, il ére dans les landes assoifé de violence."

event_inherited();  // Hérite des variables et comportement de oCardMonster



