event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Main furtive"
mana_cost = 1;
genre = "Sort"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Copie une carte de la main de votre adversaire et l'ajoute à votre main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "copy",
        source_zone: "Hand",
        destination: "Hand",
        random_select: true,
        value: 1
    }
]
tags = ["Ombre", "Sort", "Pillage"];
