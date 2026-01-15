event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Hurlement de la tribu"
genre = "Continue"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Vos Abyssien ont +1 ATK"
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_BUFF,
        scope: "all",
        aggregate: true,
        owner: "ally",
        criteria: { type: "Monster", name_contains: "Abyssien" },
        atk: 1,
        def: 0
    }
]
