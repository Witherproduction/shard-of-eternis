// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Esprit tourmenteur"
attack = 2;
PV = 2;
mana_cost = 3;
genre = "Mort-vivant"
race = "Fantôme";
tags = ["Mort-vivant", "Banshee", "Attaque"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Lorsque cette carte inflige des dégâts au combat, l'adversaire subit 2 dégâts.."
effects = [
    {
        id: 1,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        conditions: { attacker_is_self: true, requires_defender_monster: true },
        target_zone: "field",
        affect_opponent_lp: true,
        label: "Attaque"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



