event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Attaque furtive"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne +2 ATK à vos serviteurs avec camouflage"
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        only_camouflaged: true,
        atk: 2,
        def: 0
    }
]
