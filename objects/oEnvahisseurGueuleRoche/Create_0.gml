// Définit les stats spécifiques de ce monstre
name = "Envahisseur Gueule-Roche"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "Humanoïde"
race = "Orc"
tags = ["Humanoïde", "Orc", "Eveil"];
array_push(effects, { id: 1, trigger: TRIGGER_ON_SUMMON, effect_type: EFFECT_ADD_TO_HAND, object_name: "oLoupGuerreGueuleRoche" });

event_inherited();  // Hérite des variables et comportement de oCardMonster

race = "Orc";