/// @function get_bot_decks_tuto()
/// @description Retourne la liste des decks bots pour le Tutoriel (Chapitre 0)
function get_bot_decks_tuto() {
    return [
        {
            id: "tuto_deck_bot",
            name: "Adversaire d'Entraînement",
            difficulty: 1,
            description: "Un adversaire passif pour s'exercer.",
            cards: [
                // Main de départ (5 cartes) - Contient les cartes pour les tours scriptés
                "oAraigneeForestiere", // Jouée T2 (Attaque)
                "oTortueVagabonde", // Jouée T4 (Défense Cachée)
                "oAraigneeForestiere", // Jouée T6 (Attaque)
                "oAraigneeForestiere", // Jouée T8 (Attaque)
                "oAraigneeForestiere", // Jouée T10 (Défense)
                
                // Pioche suivante (Remplissage)
                "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet", // 5 Ours
                "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", // 5 Loups
                "oAraigneeForestiere", // Reste des Araignées (4 utilisées) -> 1 ici
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde" // Reste des Tortues (1 utilisée) -> 4 ici
            ]
        }
    ];
}
