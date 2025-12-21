// === Script de stockage des decks préconstruits pour le mode histoire ===
// Ces decks ne sont pas visibles dans le constructeur de deck du joueur
// Ils sont destinés à être utilisés dans des scènes spécifiques du scénario

/// @function get_story_decks_list()
/// @description Retourne la liste des decks préconstruits pour l'histoire
function get_story_decks_list() {
    return [
        {
            name: "Deck Intro (Tuto)",
            cards: [
                "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", 
                "oLoupGrisForet", "oLoupGrisForet",
                "oJeuneOursForet", "oJeuneOursForet",
                "oVieilOurs",
                "oRenardMystique", "oRenardMystique",
                "oTarentuleForet", "oTarentuleForet",
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere"
            ]
        },
        {
            name: "Deck Guerrier (Histoire)",
            cards: [
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", 
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", 
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", 
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire",
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", 
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", 
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", 
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire"
            ]
        },
        {
            name: "Deck Voleur (Histoire)",
            cards: [
                "oVoleurFinelame", "oVoleurFinelame", "oVoleurFinelame",
                "oSorcierVoleur", "oSorcierVoleur", "oSorcierVoleur",
                "oCatherineFumerol", "oCatherineFumerol",
                "oAnneauVoleur", "oAnneauVoleur",
                "oEspionnage", "oEspionnage",
                "oAttaqueFurtive", "oAttaqueFurtive",
                "oPiegeVoleur", "oPiegeVoleur",
                "oDistraction", "oDistraction"
            ]
        }
    ];
}
