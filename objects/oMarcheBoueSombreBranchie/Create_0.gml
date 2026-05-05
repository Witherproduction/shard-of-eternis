// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Marche-boue Sombre-branchie"
attack = 2;
PV = 4;
mana_cost = 3;
genre = "Humanoïde"
race = "Abyssien";
tags = ["Humanoïde", "Abyssien", "Camouflage"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Tant que cette carte posséde camouflage, elle a +1ATK."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_SET_SELF_BUFF_CONTRIB,
        contrib_key: "marche_boue_camo",
        atk: 1,
        PV: 0,
        active_if_self_property: "isCamouflage"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster


