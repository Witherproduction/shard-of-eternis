// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Matriarche des bois noirs"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "Bête"
race = "Araignée";
tags = ["Bête", "Araignée", "Eveil"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Choisissez une cible ennemie. Elle subit 2 dégâts à la fin de chacun des 2 prochains tours."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_APPLY_DOT,
        value: 2,
        turns: 2,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



