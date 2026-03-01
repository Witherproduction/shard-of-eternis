event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Feuillage protecteur"
genre = "Secret"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;
mana_cost = 2;

description = "S'active lorsque votre adversaire dÃ©truit un de vos monstres. Annule la destruction du monstre et lui confÃ¨re Illusion."
effects = [
    {
        id: 1,
        // Secret: annule la destruction d'un de vos monstres, mÃªme en combat, si initiÃ©e par l'adversaire
        secret_activation: { on_destroy_attempt: true, allow_combat: true, only_if_opponent: true },
        effect_type: EFFECT_ILLUSION,
        secret_let_destruction_proceed: true
    }
]
tags = ["Secret", "Sort", "Nature"];
