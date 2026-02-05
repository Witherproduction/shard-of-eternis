event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Camouflage stratégique"
mana_cost = 2;
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne +1/+2 à un serviteur. S'il a Camouflage, il peut attaquer ce tour sans le perdre."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        keep_camouflage_this_turn: true,
        atk: 1,
        PV: 2
    }
]
