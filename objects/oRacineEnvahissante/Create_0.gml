event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Racine envahissante"
genre = "Sort"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Gèle tous les serviteurs adverses.";
mana_cost = 3;
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_ENTRAVE,
        scope: "all",
        owner: "enemy",
        target_zone: "field"
    }
]
tags = ["Sort", "Nature", "Entrave"];
