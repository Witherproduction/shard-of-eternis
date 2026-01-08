/// @function get_hero_decks_chap1()
/// @description Retourne la liste des decks héros préconstruits pour le Chapitre 1
function get_hero_decks_chap1() {
    return [
        {
            id: "rebellion_horde",
            name: "La Diversité de la Forêt",
            description: "Un deck optimisé pour la force brute et la défense solide. Les bêtes écrasent les orcs !",
            cards: [
                // La Grande Meute (Bêtes Diverses - 21 cartes)
                "oTarrinox", "oTarrinox",
                "oAraigneeForestiere", "oAraigneeForestiere",
                "oTarentuleForet", "oTarentuleForet",
                "oJeuneOursForet", "oJeuneOursForet",
                "oVieilOurs", "oVieilOurs",
                "oTortueVagabonde", "oTortueVagabonde",
                "oLoupGrisForet", "oLoupGrisForet",
                "oLoupGaleux", "oLoupGaleux",
                "oRodeurForet", "oRodeurForet",
                "oJeuneLoup", "oJeuneLoup",
                "oPatteBriseLarmoyant",
                
                // L'Appui Gueule-roche (Orcs & Montures - 6 cartes)
                "oEnvahisseurGeuleRoche", "oEnvahisseurGeuleRoche",
                "oLoupGuerreGeuleRoche", "oLoupGuerreGeuleRoche",
                "oPeauRocRobuste", "oPeauRocRobuste",
                
                // Magies et Soutien (10 cartes)
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oRugissementForet", "oRugissementForet",
                "oRacineEnvahissante", "oRacineEnvahissante",
                "oCriMeute", "oCriMeute",
                
                // Secrets et Tactique (4 cartes)
                "oFeuillageProtecteur", "oFeuillageProtecteur",
                "oPiegeRonce", "oPiegeRonce"
            ]
        },
        {
            id: "intro_tuto",
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
            id: "guerrier_hist",
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
            id: "voleur_hist",
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
