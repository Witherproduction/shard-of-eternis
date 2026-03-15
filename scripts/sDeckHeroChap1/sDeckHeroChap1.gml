/// @function get_hero_decks_chap1() 
/// @description Retourne la liste des decks héros préconstruits pour le Chapitre 1 
function get_hero_decks_chap1() { 
    return [ 
        { 
            id: "rebellion_horde", 
            name: "La Diversité de la Forêt", 
            description: "Un deck optimisé pour la force brute et la défense solide. Les bêtes écrasent les orcs !", 
            cards: [
                // Base Fixe (Bêtes - 20 cartes)
                "oTarrinox", "oTarrinox", 
                "oTarentuleForet", "oTarentuleForet", 
                "oTortueVagabonde", "oTortueVagabonde", 
                "oLoupGaleux", "oLoupGaleux", 
                "oJeuneLoup", "oJeuneLoup", 
                "oRenardMystique", "oRenardMystique", 
                "oVieilOurs", "oVieilOurs", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oFeuillageProtecteur", 
                
                // Base Variable (Chapitre 1 - 20 cartes)
                "oBougimencienTunnelin", "oBougimencienTunnelin", 
                "oMineurTunnelin", "oMineurTunnelin", 
                "oTunnelin", "oTunnelin", 
                "oEnvahisseurGueuleRoche", "oEnvahisseurGueuleRoche", 
                "oAraigneeForestiere", "oAraigneeForestiere", 
                "oJeuneOursForet", "oJeuneOursForet", 
                "oLoupGrisForet", "oLoupGrisForet", 
                "oRugissementForet", "oRugissementForet", 
                "oCriMeute", "oCriMeute", 
                "oPatteBriseLarmoyant", "oPatteBriseLarmoyant"
            ] 
        }, 
        { 
            id: "foret_abyssienne", 
            name: "Forêt Abyssienne", 
            description: "Un deck hybride mêlant les bêtes de la forêt et un essaim d'Abyssiens.", 
            cards: [ 
                // Base Fixe (Bêtes - 20 cartes)
                "oTarrinox", "oTarrinox", 
                "oTarentuleForet", "oTarentuleForet", 
                "oTortueVagabonde", "oTortueVagabonde", 
                "oLoupGaleux", "oLoupGaleux", 
                "oJeuneLoup", "oJeuneLoup", 
                "oRenardMystique", "oRenardMystique", 
                "oVieilOurs", "oVieilOurs", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oFeuillageProtecteur", 
                
                // Base Variable (Abyssiens & Synergie - 20 cartes)
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", 
                "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", 
                "oRodeurAbyssien", "oRodeurAbyssien", 
                
                "oMareeDeferlante", "oMareeDeferlante", 
                "oProtectionMaree", "oProtectionMaree", 
                "oFerveurMarais", "oFerveurMarais", 
                "oHurlementTribu", "oHurlementTribu", 
                
                "oTortueVagabonde", // 3ème
                "oJeuneLoup", // 3ème
                "oRenardMystique", // 3ème
                "oRacineEnvahissante"
            ] 
        }, 
        { 
            id: "alliance_foret", 
            name: "Alliance de la Forêt", 
            description: "Un deck unissant toutes les créatures de la forêt pour repousser les envahisseurs.", 
            cards: [ 
                // Base Fixe (Bêtes - 20 cartes)
                "oTarrinox", "oTarrinox", 
                "oTarentuleForet", "oTarentuleForet", 
                "oTortueVagabonde", "oTortueVagabonde", 
                "oLoupGaleux", "oLoupGaleux", 
                "oJeuneLoup", "oJeuneLoup", 
                "oRenardMystique", "oRenardMystique", 
                "oVieilOurs", "oVieilOurs", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oFeuillageProtecteur", 
                
                // Base Variable (Voleurs & Ombres - 20 cartes)
                "oGobelinFurtif", "oGobelinFurtif", "oGobelinFurtif",
                "oMaitrePasse", "oMaitrePasse", "oMaitrePasse",
                "oBanditGuerrier", "oBanditGuerrier",
                "oVoleurFinelame", "oVoleurFinelame",
                "oBandit", "oBandit",
                "oSournoiserie", "oSournoiserie",
                "oCapeOmbre", "oCapeOmbre",
                "oFiletOmbre", "oFiletOmbre",
                "oDagueFilou", "oDagueFilou"
            ]
        },
        {
            id: "fureur_sauvage",
            name: "Fureur Sauvage",
            description: "Un deck agressif basé sur les bêtes et la charge des sangliers.",
            cards: [
                // Base Fixe (Bêtes - 20 cartes)
                "oTarrinox", "oTarrinox", 
                "oTarentuleForet", "oTarentuleForet", 
                "oTortueVagabonde", "oTortueVagabonde", 
                "oLoupGaleux", "oLoupGaleux", 
                "oJeuneLoup", "oJeuneLoup", 
                "oRenardMystique", "oRenardMystique", 
                "oVieilOurs", "oVieilOurs", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oFeuillageProtecteur",

                // Complément Bêtes & Sangliers (20 cartes)
                "oPeauRocRobuste", "oPeauRocRobuste", "oPeauRocRobuste", // Charge (Rare x3)
                "oSanglierPeauRoc", "oSanglierPeauRoc", "oSanglierPeauRoc", // Charge (Commun x3)
                "oFrenesieSauvage", "oFrenesieSauvage", // Buff ATK
                "oRugissementForet", "oRugissementForet", // Buff PV
                "oLoupGrisForet", "oLoupGrisForet", "oLoupGrisForet", // Meute (Rare x3)
                "oRodeurForet", "oRodeurForet", // Invoque Jeune Loup
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere", // T1 Venimeux
                "oCriMeute", "oCriMeute" // Buff Late Game
            ]
        }
    ];
}

