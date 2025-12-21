event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Marée déferlante"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Invoque 2 'Coureur Abyssien'"
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oCoureurAbyssien",
        count: 2
    }
]
