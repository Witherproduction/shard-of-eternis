event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Cape d'ombre"
mana_cost = 2;
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Donne +2/+2 et Camouflage à un serviteur."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        atk: 2,
        PV: 2,
        grant_camouflage: true
    }
]
