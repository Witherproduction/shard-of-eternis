/// @function get_hero_decks_tuto()
/// @description Retourne la liste des decks héros pour le Tutoriel (Chapitre 0)
function get_hero_decks_tuto() {
    return [
        {
            id: "tuto_deck_hero",
            name: "Deck d'Initiation",
            description: "Un deck équilibré pour apprendre les bases du duel.",
            cards: [
                // Main de départ (5 cartes) - T1
                "oAraigneeForestiere", "oFeuillageProtecteur", "oGriffePredateur", // 1 Araignée, 1 Feuillage, 1 Griffe
                "oPeauRocRobuste", // 1 Peau de Roc
                "oMaitrePasse", // 1 Maître des Passes
                
                // Pioche Tour 3
                "oGobelinFurtif", 
                
                // Pioche Tour 5
                "oMaitrePasse", 
                
                // Pioche Tour 7
                "oEnvahisseurGeuleRoche", 
                
                // Pioche Tour 9
                "oGriffePredateur", 
                
                // Pioche Tour 11 (2 cartes car main < 5)
                "oCriMeute", 
                "oFeuillageProtecteur", 
                
                // Reste du deck (Remplissage pour atteindre 19 cartes)
                "oAraigneeForestiere", "oAraigneeForestiere", // Reste des 5 Araignées (3 utilisées) -> 2 ici
                "oPeauRocRobuste", // Reste des 2 Peau (1 utilisée) -> 1 ici
                "oEnvahisseurGeuleRoche", // Reste des 2 Envahisseurs (1 utilisé) -> 1 ici
                "oGobelinFurtif", // Reste des 2 Gobelins (1 utilisé) -> 1 ici
                "oGriffePredateur", // Reste des 2 Griffes (1 utilisée) -> 1 ici
                "oCriMeute", // Reste des 2 Cris (1 utilisé) -> 1 ici
                "oFeuillageProtecteur" // Reste des 2 Feuillages (1 utilisé) -> 1 ici
            ]
        }
    ];
}
