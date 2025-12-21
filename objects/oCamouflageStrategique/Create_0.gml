event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Camouflage stratégique"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Selectionne un serviteur avec camouflage. Lui permet d'attaquer ce tour sans perdre camouflage."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        only_camouflaged: true,
        keep_camouflage_this_turn: true,
        atk: 0,
        def: 0
    }
]
