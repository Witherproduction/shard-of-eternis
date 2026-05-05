// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Thalia Vieille-Aube"
attack = 2;
PV = 5;
mana_cost = 4;
genre = "Mort-vivant"
race = "Banshee";
tags = ["Mort-vivant", "Banshee", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : Inflige 2 dégâts d'Ombre à un ennemi aléatoire. Si Grégor Vieille-Aube est en jeu, inflige 1 dégât d'Ombre supplémentaire."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_RANDOM_PROJECTILES,
        count: 1,
        damage: 2,
        bonus_damage: 1,
        bonus_damage_if_ally_object_names: ["oGregorVieilleAube"],
        include_enemy_hero: true,
        element: "ombre",
        label: "Crépuscule",
        conditions: { owner_turn: true }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



