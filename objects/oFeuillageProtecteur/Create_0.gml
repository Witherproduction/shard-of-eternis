event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Feuillage protecteur"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;
mana_cost = 2;

description = "S'active lorsque votre adversaire détruit un de vos monstres. Annule la destruction du monstre et lui confère Illusion."
effects = [
    {
        id: 1,
        // Secret: annule la destruction d'un de vos monstres, même en combat, si initiée par l'adversaire
        secret_activation: { on_destroy_attempt: true, allow_combat: true, only_if_opponent: true },
        effect_type: EFFECT_ILLUSION,
        secret_let_destruction_proceed: true
    }
]
tags = ["Secret", "Sort", "Nature"];
