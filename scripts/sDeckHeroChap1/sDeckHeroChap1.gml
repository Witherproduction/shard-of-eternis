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
                "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oCapeOmbre", "oCapeOmbre",
                "oFiletOmbre", "oFiletOmbre",
                "oDagueFilou", "oDagueFilou"
            ],
            hero_power: {
                id: "protection_divine",
                name: "Protection Divine",
                description: "Réduit de 1 l'ATK d'un serviteur ennemi.",
                mana_cost: 2
            }
        }
    ];
}

