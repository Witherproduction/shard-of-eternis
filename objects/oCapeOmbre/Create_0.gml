event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Cape d'ombre"
mana_cost = 4;
genre = "Sort"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +4/+4 et Camouflage à un serviteur."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        atk: 4,
        PV: 4,
        grant_camouflage: true
    }
]
tags = ["Ombre", "Sort"];
