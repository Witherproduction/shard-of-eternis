event_inherited();

// Définit les stats spécifiques de ce sort
name = "Bouclier de foi"
mana_cost = 5;
genre = "Sort"
race = "Lumière";
tags = ["Lumière", "Sort"];
rarity = "legendaire"
booster = "Retour des Archontes"
is_player_card = true;

description = "Votre héros ne peut pas subir de dégats jusqu'à la fin du tour adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_IMMUNITY,
        owner: "ally",
        duration_mode: "until_next_owner_turn"
    }
]
