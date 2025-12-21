event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Ferveur du marais"
genre = "Continue"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Lorsqu'un Abyssien est invoqué, invoque un 'coureur Abyssien'."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_MONSTER_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oCoureurAbyssien",
        conditions: {
            source_owner: "ally",
            source_name_contains: "Abyssien"
        }
    }
]
