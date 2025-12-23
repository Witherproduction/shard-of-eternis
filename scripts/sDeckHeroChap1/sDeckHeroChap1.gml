/// @function get_hero_decks_chap1()
/// @description Retourne la liste des decks héros préconstruits pour le Chapitre 1
function get_hero_decks_chap1() {
    return [
        {
            id: "rebellion_horde",
            name: "La Meute de la Lisière",
            description: "Un deck optimisé pour la force brute et la défense solide. Les bêtes écrasent les orcs !",
            cards: [
                // Monstres (25)
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde",
                "oEnvahisseurGeuleRoche", "oEnvahisseurGeuleRoche", "oEnvahisseurGeuleRoche",
                "oLoupGuerreGeuleRoche", "oLoupGuerreGeuleRoche", "oLoupGuerreGeuleRoche",
                "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet",
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere",
                "oPeauRocRobuste", "oPeauRocRobuste", "oPeauRocRobuste",
                "oVieilOurs", "oVieilOurs", "oVieilOurs",
                "oTarentuleForet", "oTarentuleForet",
                "oRodeurForet", "oRodeurForet",
                
                // Magies (11)
                "oGriffePredateur", "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur", "oSautPredateur",
                "oRacineEnvahissante", "oRacineEnvahissante",
                "oRugissementForet", "oRugissementForet", "oRugissementForet",
                
                // Pièges / Secrets (4)
                "oPiegeRonce", "oPiegeRonce",
                "oFeuillageProtecteur", "oFeuillageProtecteur"
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
