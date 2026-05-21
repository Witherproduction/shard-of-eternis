// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Missionnaire du Sang-pur"
attack = 2;
PV = 3;
mana_cost = 3;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 2 dégâts à une cible ennemie."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



