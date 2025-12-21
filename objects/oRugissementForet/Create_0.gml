event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Rugissement de la forêt"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Vos Bêtes gagnent +1 DEF jusqu'au début de votre prochain tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        aggregate: true,
        atk: 0,
        def: 1
    },
    {
        id: 99,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE,
        conditions: { owner_turn: true }
    }
]
