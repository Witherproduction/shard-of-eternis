event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Manipulation du butin"
mana_cost = 1;
genre = "Sort"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Echange une carte alÃ©atoire de votre main avec une carte alÃ©atoire de la main adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "exchange"
    }
]
tags = ["Ombre", "Sort", "Pillage"];
