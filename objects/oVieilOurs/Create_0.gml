event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Viel ours"
attack = 2;
PV = 4;
mana_cost = 3;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Gagne +2 ATK lorsqu'il combat un monstre sur la ligne de front."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_source: "self",
        conditions: {
            attacker_is_self: true,
            requires_defender_monster: true,
            defender_field_position_in: [0, 1, 2, 3, 4]
        },
        atk: 2,
        PV: 0,
        temporary: true
    }
]


