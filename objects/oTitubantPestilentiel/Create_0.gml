// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Titubant pestilentiel"
attack = 0;
PV = 1;
mana_cost = 1;
genre = "Mort-vivant"
race = "Zombie";
tags = ["Mort-vivant", "Zombie", "Brisé"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : le serviteur ennemi en face subit 1 dégât à la fin de chacun des 3 prochains tours."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_TARGET_FACING,
        label: "Brisé",
        flow: { id: 11, effect_type: EFFECT_APPLY_DOT, value: 1, turns: 3, target_source: "defender" }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



