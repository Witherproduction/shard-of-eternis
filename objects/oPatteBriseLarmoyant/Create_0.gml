event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Patte-brisÃ© larmoyant"
attack = 1;
PV = 5;
mana_cost = 2;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
isHeroOwner = true; // NÃ©cessaire pour le systÃ¨me de triggers
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
tags = ["BÃªte", "Loup"];
