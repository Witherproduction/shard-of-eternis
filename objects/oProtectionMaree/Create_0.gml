event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Protection de la marée"
genre = "Continue"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Lorsqu'un Abyssien est invoqué, piochez une carte."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_MONSTER_SUMMON,
        effect_type: EFFECT_DRAW_CARDS,
        value: 1,
        conditions: {
            source_owner: "ally",
            source_name_contains: "Abyssien"
        }
    }
]
