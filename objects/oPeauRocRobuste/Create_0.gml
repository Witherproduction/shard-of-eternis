// Définit les stats spécifiques de ce monstre
name = "Peau-de-roc robuste"
attack = 2;
PV = 5;
mana_cost = 4;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
has_charge = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge"
effects = []

event_inherited();  // Hérite des variables et comportement de oCardMonster
