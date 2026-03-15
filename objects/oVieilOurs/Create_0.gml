event_inherited();
race = "Ours";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Vieil ours"
attack = 3;
PV = 5;
mana_cost = 4;
genre = "Bête"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ce monstre gagne temporairement +2 ATK lorsqu'il combat un monstre sur la ligne de front."
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

tags = ["Bête", "Ours"];
