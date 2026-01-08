/// @function get_hero_decks_chap0()
/// @description Retourne le deck préconstruit pour le Tutoriel (Chapitre 0)
function get_hero_decks_chap0() {
    return [
        {
            id: "initiation_deck",
            name: "Deck d'Apprentissage",
            description: "Un petit deck pour apprendre les bases du combat.",
            cards: [
                // Ordre précis pour le script du tutoriel :
                // Pioche 1 (T1): Monstre (Jeune Loup)
                "oJeuneLoup",
                // Pioche 2 (T2): Artefact (Dague du Filou - ou autre arme simple)
                "oDagueFilou", 
                // Pioche 3 (T3): Magie (Soin ou Buff)
                "oCriMeute",
                // Reste du deck (au cas où)
                "oJeuneLoup", "oJeuneLoup", "oBandit", "oBandit"
            ]
        }
    ];
}

/// @function get_bot_decks_chap0()
/// @description Retourne le deck bot pour le Tutoriel (Chapitre 0)
function get_bot_decks_chap0() {
    return [
        {
            id: 0,
            name: "Mannequin d'Entrainement",
            profile: "Passif",
            deck_name: "Sac de Frappe",
            difficulty: "Tutoriel",
            portrait: "sBandit", // Image temporaire
            description: "Un adversaire qui ne riposte pas.",
            cards: [
                // Ne fait rien ou joue des trucs faibles
                "oBandit", "oBandit", "oBandit", "oBandit", "oBandit"
            ]
        }
    ];
}
