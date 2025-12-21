event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Peau-de-roc robuste"
attack = 4;
defense = 3;
star = 1;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Gagne +3 ATK jusqu'a la fin du tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "single",
        aggregate: true,
        atk: 3,
        def: 0
    },
    {
        id: 99,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]

