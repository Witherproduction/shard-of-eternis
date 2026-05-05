event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tarentule des forêts"
attack = 6;
PV = 5;
mana_cost = 6;
genre = "Bête"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : Invoque 2 'Araignée forestière'sur les emplacements adjacents de cette carte."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oAraigneeForestiere",
        placement_criteria: { relative_role: "adjacent" }
    },
    {
        id: 2,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oAraigneeForestiere",
        placement_criteria: { relative_role: "adjacent" }
    }
]


race = "Araignée";
tags = ["Bête", "Araignée", "Brisé"];
