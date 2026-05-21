// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Aile-sang de la pénombre"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "Bête"
race = "Chauve-souris";
tags = ["Bête", "Chauve-souris", "Ponction"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ponction"
effects = [
    {
        id: 1,
        trigger: TRIGGER_PASSIVE,
        effect_type: EFFECT_PONCTION
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



