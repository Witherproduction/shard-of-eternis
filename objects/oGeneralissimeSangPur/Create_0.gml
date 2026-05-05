// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Generalissime du Sang-pur"
attack = 4;
PV = 8;
mana_cost = 7;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Eveil", "Aube"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Ajoutez 2 Capitaines du Sang Pur aléatoires. Aube : Inflige 1 dégât à tous les ennemis pour chaque Capitaine du Sang Pur allié sur le terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_ADD_RANDOM_TO_HAND,
        object_names: ["oCapitaineMelrache", "oCapitainePerrine", "oCapitaineVachon"],
        label: "Eveil"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_ADD_RANDOM_TO_HAND,
        object_names: ["oCapitaineMelrache", "oCapitainePerrine", "oCapitaineVachon"],
        label: "Eveil"
    },
    {
        id: 3,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_COUNT_APPLY,
        count_source: "field",
        per: 1,
        base: 0,
        count_owner: "ally",
        count_object_names: ["oCapitaineMelrache", "oCapitainePerrine", "oCapitaineVachon"],
        apply_mode: "damage_all",
        owner: "enemy",
        monster_type: "Monster",
        target_zone: "field",
        visual_fx: "multicible",
        element: "ombre",
        label: "Aube",
        conditions: { owner_turn: true }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster

