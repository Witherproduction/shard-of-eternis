// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Mort pourrissant"
attack =1;
PV = 1;
mana_cost = 2;
genre = "Mort-vivant"
race = "Zombie";
tags = ["Mort-vivant", "Zombie", "Brisé"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : l'adversaire subit 2 dégâts."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        target_zone: "field",
        owner: "enemy",
        affect_opponent_lp: true,
        label: "Brisé"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



