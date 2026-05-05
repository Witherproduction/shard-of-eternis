// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Grégor Vieille-Aube"
attack = 4;
PV = 6;
mana_cost = 5;
genre = "Mort-vivant"
race = "Squelette";
tags = ["Mort-vivant", "Squelette", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Crépuscule : Lance 3 projectiles d'arcane. Chaque projectile inflige 1 dégât à un ennemi aléatoire. Si Thalia Vieille-Aube est en jeu, lance 2 projectiles supplémentaires."
effects = [
    {
        id: 1,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_RANDOM_PROJECTILES,
        count: 3,
        damage: 1,
        include_enemy_hero: true,
        element: "arcane",
        label: "Crépuscule",
        conditions: { owner_turn: true }
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_TRACK_FIELD_PRESENCE,
        tracker_key: "gregor",
        owner: "ally",
        conditions: { owner_turn: true },
        checks: [
            { key: "thalia", object_name: "oThaliaVieilleAube" }
        ],
        activate_effect_ids: [3]
    },
    {
        id: 3,
        trigger: TRIGGER_PASSIVE,
        effect_type: EFFECT_CONDITIONAL_FLOW,
        presence_key: "thalia",
        cond: { type: "context_active" },
        flow: {
            id: 31,
            effect_type: EFFECT_RANDOM_PROJECTILES,
            count: 2,
            damage: 1,
            include_enemy_hero: true,
            element: "arcane"
        }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



