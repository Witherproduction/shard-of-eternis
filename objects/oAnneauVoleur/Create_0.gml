event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Anneau du voleur"
genre = "Artéfact"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Lorsque le serviteur équipé attaque, copie une carte de la main adverse et l'ajoute à votre main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_EQUIP_SELECT_TARGET,
        ally_only: true
    },
    {
        id: 2,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_PILLAGE,
        operation: "copy",
        source_zone: "Hand",
        destination: "Hand",
        random_select: true,
        value: 1,
        conditions: { attacker_is_equipped_target: true }
    },
    {
        id: 99,
        trigger: TRIGGER_LEAVE_FIELD,
        effect_type: EFFECT_EQUIP_CLEANUP
    }
]
