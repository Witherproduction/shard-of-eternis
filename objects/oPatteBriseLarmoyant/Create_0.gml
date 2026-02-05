event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Patte-brisé larmoyant"
attack = 1;
PV = 5;
mana_cost = 2;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Gagne +2 ATK durant le tour adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        atk: 2,
        PV: 0,
        conditions: { opponent_turn: true }
    },
    {
        id: 2,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        atk: 2,
        PV: 0,
        conditions: { opponent_turn: true }
    },
    {
        id: 99,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE,
        conditions: { opponent_turn: true }
    }
]
