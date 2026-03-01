event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Distraction"
genre = "Secret"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Secret : Quand un serviteur ennemi est invoqué, le renvoie dans la main et augmente son coût de (2).";
mana_cost = 3;

effects = [
    {
        id: 1,
        // Secret: s'active sur l'invocation d'un monstre adverse
        secret_activation: { on_summon: true },
        effect_type: EFFECT_RETURN_TO_HAND,
        target_source: "summoned",
        cost_increase: 2
    }
];
tags = ["Ombre", "Sort", "Secret"];
