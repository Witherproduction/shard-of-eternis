event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Coquillage des marées"
genre = "Artéfact"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne +1 DEF à un Humanoïde."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_EQUIP_SELECT_TARGET,
        ally_only: true,
        allowed_genres: "Humanoïde"
    },
    {
        id: 2,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "equip",
        aggregate: true,
        criteria: { type: "Monster", genre: "Humanoïde" },
        atk: 0,
        def: 1
    },
    {
        id: 99,
        trigger: TRIGGER_LEAVE_FIELD,
        effect_type: EFFECT_EQUIP_CLEANUP
    }
]
