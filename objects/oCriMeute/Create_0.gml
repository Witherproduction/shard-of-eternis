event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Cri de la meute"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Jusqu'à la fin du tour, vos Bêtes gagnent +1 ATK."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        temporary: true,
        atk: 1,
        def: 0
    }
]