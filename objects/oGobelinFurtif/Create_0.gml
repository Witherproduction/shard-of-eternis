// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Gobelin Furtif"
attack = 3;
PV = 2;
mana_cost = 2;
genre = "HumanoÃ¯de"
tags = ["HumanoÃ¯de", "Gobelin", "Camouflage"];
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
race = "Gobelin";  // HÃ©rite des variables et comportement de oCardMonster

