// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Bâtard putride"
attack = 2;
PV = 5;
mana_cost = 4;
genre = "Mort-vivant"
race = "Skarl";
tags = ["Mort-vivant", "Skarl", "Eveil"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil :Augmente de 1 le coût d'une carte aléatoire dans la main adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_INCREASE_HAND_COST,
        owner: "enemy",
        value: 1
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



