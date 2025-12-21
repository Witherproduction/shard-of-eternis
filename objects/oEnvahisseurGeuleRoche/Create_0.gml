event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Envahisseur Geule-Roche"
attack = 5;
defense = 5;
star = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Ajoute un Loup de guerre Geule-Roche"
if (!variable_instance_exists(self, "effects")) effects = [];
array_push(effects, { id: 1, trigger: TRIGGER_ON_SUMMON, effect_type: EFFECT_ADD_TO_HAND, target_name: "Loup de guerre Geule-Roche" });

