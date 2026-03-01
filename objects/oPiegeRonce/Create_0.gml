event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Piège de ronce"
genre = "Secret"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;
mana_cost = 4;

description = "Secret : Quand un ennemi vous attaque, Inflige 3 dégats à tous les adversaires."
element = "Nature";
effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_DAMAGE_ALL,
        value: 3,
        owner: "enemy",
        scope: "all",
        monster_type: "Monster",
        element: "multicible"
    }
];
tags = ["Sort", "Secret", "Canture"];
