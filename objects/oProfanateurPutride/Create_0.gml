// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Profanateur putride"
attack = 2;
PV = 7;
mana_cost = 5;
genre = "Mort-vivant"
race = "Skarl";
tags = ["Mort-vivant", "Skarl", "Passif"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Lorsqu'un de vos serviteurs est détruit, augmente de 1 le coût d'une carte aléatoire dans la main adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_INCREASE_HAND_COST,
        value: 1,
        owner: "enemy",
        conditions: {
            source_owner: "ally",
            source_is_not_self: true,
            source_type: "Monster"
        },
        label: "Passif"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



