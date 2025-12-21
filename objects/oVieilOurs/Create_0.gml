event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Viel ours"
attack = 4;
defense = 5;
star = 1;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Lorsqu'il combat un monstre en défense, reduit de 1 la DEF de la cible."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_source: "defender",
        conditions: {
            attacker_is_self: true,
            requires_defender_monster: true,
            defender_orientation_in: ["Defense", "DefenseVisible"]
        },
        atk: 0,
        def: -1
    }
]

