event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Sournoiserie"
genre = "Continue"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Chaque fois qu'un Humanoïde est invoqué, pioche une carte."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_MONSTER_SUMMON,
        effect_type: EFFECT_DRAW_CARDS,
        value: 1,
        conditions: { source_genre: "Humanoïde" }
    }
]
