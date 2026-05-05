// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Grande prêtresse du Sang-pur"
attack = 3;
PV = 8;
mana_cost = 6;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Eveil", "Aube"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Donne Égide à vos autres serviteurs. Aube : Soigne 2 PV à tous les alliés."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_EGIDE,
        scope: "all",
        owner: "ally",
        criteria: { type: "Monster", exclude_self: true },
        label: "Eveil"
    },
    {
        id: 2,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_HEAL_ALL,
        value: 2,
        owner: "ally",
        target_zone: "field",
        monster_type: "Monster",
        label: "Aube",
        conditions: { owner_turn: true }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



