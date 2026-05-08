event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Manipulation du butin"
mana_cost = 1;
genre = "Sort"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Echange une carte aléatoire de votre main avec une carte aléatoire de la main adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "exchange"
    }
]
tags = ["Ombre", "Sort", "Pillage"];
