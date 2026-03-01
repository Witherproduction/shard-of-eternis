event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Patte-brisé larmoyant"
attack = 1;
PV = 5;
mana_cost = 2;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
isHeroOwner = true; // Nécessaire pour le système de triggers
description = "Gagne +2 ATK durant le tour adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_BUFF,
        scope: "self",
        aggregate: true,
        atk: 2,
        PV: 0,
        conditions: { opponent_turn: true },
        show_aura: false
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE,
        scope: "self",
        conditions: { opponent_turn: true },
        show_aura: false
    }
]
race = "Loup";
tags = ["Bête", "Loup"];
