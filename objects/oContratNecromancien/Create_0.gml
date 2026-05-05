event_inherited();

// Définit les stats spécifiques de ce sort
name = "Contrat du nécromancien"
mana_cost = 3;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Détruisez un serviteur allié pour piocher 2 cartes."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SACRIFICE_TARGET,
        scope: "single",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster" },
        flow: [
            { effect_type: EFFECT_DRAW_CARDS, value: 2 }
        ]
    }
]
