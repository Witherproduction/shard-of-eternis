// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Soldat cliquethorax"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "Mort-vivant"
race = "Squelette";
tags = ["Mort-vivant", "Squelette", "Brisé"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : invoque trois Soldats squelettes aléatoires sur votre terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSoldatSquelette",
        allowed_sources: [],
        placement_criteria: { relative_role: "random" },
        label: "Brisé"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSoldatSquelette",
        allowed_sources: [],
        placement_criteria: { relative_role: "random" },
        label: "Brisé"
    },
    {
        id: 3,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oSoldatSquelette",
        allowed_sources: [],
        placement_criteria: { relative_role: "random" },
        label: "Brisé"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster

