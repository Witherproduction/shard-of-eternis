event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Voleur Finelame"
attack = 3;
defense = 5;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Lorsqu'il combat un monstre en defense, gagne +1 ATK"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_BUFF,
        scope: "single",
        conditions: {
            attacker_is_self: true,
            requires_defender_monster: true,
            defender_orientation_in: ["Defense", "DefenseVisible"]
        },
        atk: 1,
        def: 0
    }
]

