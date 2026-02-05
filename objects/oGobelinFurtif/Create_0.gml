// Définit les stats spécifiques de ce monstre
name = "Gobelin Furtif"
attack = 3;
PV = 2;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
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

event_inherited();  // Hérite des variables et comportement de oCardMonster
