event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Yvan le Costaud"
attack = 2;
PV = 5;
mana_cost = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Tant que cette carte est sur le terrain, 'Catherine Fumerol' ne peut pas être détruit"
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_PROTECTION,
        scope: "aura",
        owner: "ally",
        criteria: { object_name: "oCatherineFumerol" }
    },
    {
        id: 99,
        trigger: TRIGGER_LEAVE_FIELD,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]

race = "Humain";
tags = ["Humanoïde", "Humain"];
