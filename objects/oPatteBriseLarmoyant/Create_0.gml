event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Patte-brisé larmoyant"
attack = 3;
defense = 5;
star = 1;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Gagne +1 ATK uniquement durant la phase d'attaque"
effects = [
    {
        id: 1,
        trigger: TRIGGER_BATTLE_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        atk: 1,
        def: 0,
        conditions: { phase: "Attack" }
    },
    {
        id: 99,
        trigger: TRIGGER_END_PHASE,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]
