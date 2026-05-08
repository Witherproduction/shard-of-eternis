event_inherited();

// Définit les stats spécifiques de ce sort
name = "Frénésie du chenil"
mana_cost = 2;
genre = "Secret"
race = "Ombre";
tags = ["Ombre","Secret"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Quand un de vos monstres est attaqué, vos Bêtes gagne +1 atk et Ambidextrie durant votre prochain tour uniquement."

effects = [
    {
        id: 1,
        secret_activation: { on_attack: true },
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 1,
        PV: 0,
        temporary: true,
        grant_ambidextrous: true
    }
];