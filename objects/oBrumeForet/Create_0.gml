event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Brume de la forêt"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Réduit de 1 l'ATK des serviteurs adverse jusqu'à la fin du tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        aggregate: true,
        atk: -1,
        def: 0
    },
    {
        id: 99,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]
