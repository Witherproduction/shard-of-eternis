event_inherited();

// Définit les stats spécifiques de ce sort
name = "Déclaration d'hérésie"
mana_cost = 3;
genre = "Secret"
race = "Lumiere";
tags = ["Lumiere","Secret"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Lorsque votre adverse active un sort, lui inflige 2 dégats et vous piochez une carte."

effects = [
    {
        id: 1,
        secret_activation: { on_spell_cast: true },
        effect_type: EFFECT_POINTS,
        op: "damage",
        scope: "lp",
        owner: "enemy",
        value: 2,
        flow: [
            { effect_type: EFFECT_DRAW_CARDS, value: 1 }
        ]
    }
]
