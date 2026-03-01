// Définit les stats spécifiques de ce monstre
name = "Gobelin Furtif"
attack = 3;
PV = 2;
mana_cost = 2;
genre = "Humanoïde"
tags = ["Humanoïde", "Gobelin", "Camouflage"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
description = "Camouflage."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    }
]

event_inherited();
race = "Gobelin";  // Hérite des variables et comportement de oCardMonster

