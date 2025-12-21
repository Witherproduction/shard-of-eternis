event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Saut du prédateur"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Si vous contrôlez au moins 2 Bêtes, selectionne un Bête et lui donne +2 ATK."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 2,
        conditions: {
            owner_turn: true,
            min_genre_count_on_field: { genre: "Bête", owner: "ally", count: 2 }
        }
    }
]
