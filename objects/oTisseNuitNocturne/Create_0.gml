// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Tisse-nuit nocturne"
attack = 1;
PV = 2;
mana_cost = 2;
genre = "Bête"
race = "Araignée";
tags = ["Bête", "Araignée", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Choisissez une cible ennemie. Elle subit 1 dégât à la fin de chacun des 3 prochains tours."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_APPLY_DOT,
        value: 1,
        turns: 3,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



