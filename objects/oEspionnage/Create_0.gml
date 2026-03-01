event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Espionnage"
mana_cost = 1;
genre = "Sort"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Devoile 3 carte du deck adverse. Choississez une carte Ã  placer sur le dessus du deck."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DECK_REORDER_TOP3,
        owner: "enemy",
        pick_one: true
    }
]
tags = ["Ombre", "Sort"];
