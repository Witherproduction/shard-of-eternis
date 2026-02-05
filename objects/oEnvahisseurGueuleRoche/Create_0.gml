// Définit les stats spécifiques de ce monstre
name = "Envahisseur Gueule-Roche"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Ajoute un Loup de guerre Gueule-Roche"
if (!variable_instance_exists(self, "effects")) effects = [];
array_push(effects, { id: 1, trigger: TRIGGER_ON_SUMMON, effect_type: EFFECT_ADD_TO_HAND, object_name: "oLoupGuerreGueuleRoche" });

event_inherited();  // Hérite des variables et comportement de oCardMonster
