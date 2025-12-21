event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Feuillage protecteur"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "S'active lorsque votre adversaire détruit un de vos monstres. Annule la destruction du monstre."
effects = [
    {
        id: 1,
        // Secret: annule la destruction d'un de vos monstres, même en combat, si initiée par l'adversaire
        secret_activation: { on_destroy_attempt: true, allow_combat: true, only_if_opponent: true }
        // Aucun effet supplémentaire: l'annulation est gérée par le moteur (interception destroyCard)
    }
]
