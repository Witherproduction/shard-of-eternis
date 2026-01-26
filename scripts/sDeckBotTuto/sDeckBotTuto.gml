/// @function get_bot_decks_tuto()
/// @description Retourne la liste des decks bots pour le Tutoriel
function get_bot_decks_tuto() {
    return [
        {
            id: "tuto_deck_bot", // ID String pour les bots
            chapter: 0,
            name: "Bot d'Entrainement",
            deck_name: "Deck d'Entrainement",
            difficulty: "Facile",
            portrait: "sSoldat1",
            description: "Un adversaire simple pour apprendre les bases.",
            cards: [
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere",
                "oFeuillageProtecteur", "oFeuillageProtecteur", "oFeuillageProtecteur",
                "oGriffePredateur", "oGriffePredateur", "oGriffePredateur",
                "oPeauRocRobuste", "oPeauRocRobuste", "oPeauRocRobuste",
                "oMaitrePasse", "oMaitrePasse", "oMaitrePasse",
                "oGobelinFurtif", "oGobelinFurtif", "oGobelinFurtif",
                "oEnvahisseurGeuleRoche", "oEnvahisseurGeuleRoche"
            ],
            profile: {
                summon_weight: 50,
                continuous_weight: 50,
                manual_effect_weight: 50,
                secret_weight: 50,
                removal_weight: 50,
                board_presence_weight: 50,
                draw_weight: 50,
                tutor_weight: 50
            }
        }
    ];
}
