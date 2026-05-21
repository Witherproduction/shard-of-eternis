// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Patriarche putrescent"
attack = 2;
PV = 15;
mana_cost = 7;
genre = "Mort-vivant"
race = "Zombie";
tags = ["Mort-vivant", "Zombie", "Passif"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "gagne +1ATK pour chaque Mort-vivant dans votre cimetière."
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_COUNT_APPLY,
        count_source: "graveyard",
        count_owner: "ally",
        count_criteria: { genre: "Mort-vivant" },
        base: 0,
        per: 1,
        apply_mode: "set_self_attack",
        label: "Passif"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



