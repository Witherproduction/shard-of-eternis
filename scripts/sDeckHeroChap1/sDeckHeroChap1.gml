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
                "oRodeurForet", "oRodeurForet", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oPiegeRonce", 
                
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
            id: "gardiens_recoltes",
            name: "Gardiens des Récoltes",
            description: "Un contre aux pillards : on sécurise le terrain puis on retourne leurs vols contre eux grâce aux Humanoïdes et au pillage.",
            cards: [
                "oTarrinox", "oTarrinox",
                "oTarentuleForet", "oTarentuleForet",
                "oTortueVagabonde", "oTortueVagabonde",
                "oLoupGaleux", "oLoupGaleux",
                "oJeuneLoup", "oJeuneLoup",
                "oRenardMystique", "oRenardMystique",
                "oRodeurForet", "oRodeurForet",

                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oFeuillageProtecteur", "oPiegeRonce",

                "oTunnelin", "oTunnelin", "oTunnelin",
                "oMineurTunnelin", "oMineurTunnelin", "oMineurTunnelin",
                "oBougimencienTunnelin", "oBougimencienTunnelin",
                "oPortefaix", "oPortefaix",
                "oVoleurFinelame", "oVoleurFinelame",
                "oBandit",
                "oSanglierPeauRoc", "oSanglierPeauRoc",
                "oVideGousset",

                "oMainFurtive", "oMainFurtive",
                "oAnneauVoleur",
                "oSournoiserie"
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
                "oRodeurForet", "oRodeurForet", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oPiegeRonce", 
                
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
                "oRodeurForet", "oRodeurForet", 
                
                "oGriffePredateur", "oGriffePredateur", 
                "oSautPredateur", "oSautPredateur", 
                "oFeuillageProtecteur", "oPiegeRonce", 
                
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
                "oTarrinox", "oTarrinox",
                "oTarentuleForet", "oTarentuleForet",
                "oTortueVagabonde", "oTortueVagabonde",
                "oLoupGaleux", "oLoupGaleux",
                "oJeuneLoup", "oJeuneLoup",
                "oRenardMystique", "oRenardMystique",
                "oRodeurForet", "oRodeurForet",

                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oFeuillageProtecteur", "oPiegeRonce",

                "oTunnelin", "oTunnelin", "oTunnelin",
                "oMineurTunnelin", "oMineurTunnelin", "oMineurTunnelin",
                "oBougimencienTunnelin", "oBougimencienTunnelin",
                "oLoupGrisForet", "oLoupGrisForet", "oLoupGrisForet",
                "oGeomancienTunnelin", "oGeomancienTunnelin",
                "oRodeurForet", "oRodeurForet",
                "oAraigneeForestiere",

                "oRugissementForet", "oRugissementForet",
                "oFrenesieSauvage",
                "oRacineEnvahissante"
            ]
        },
        {
            id: "assaut_forteresse",
            name: "Assaut de la forteresse",
            description: "Un assaut frontal mené par les bêtes de la forêt, renforcées par des Abyssiens, des Bandits et des Skarls pour briser les défenses.",
            cards: [
                "oTarrinox", "oTarrinox",
                "oTarentuleForet", "oTarentuleForet",
                "oTortueVagabonde", "oTortueVagabonde",
                "oLoupGaleux", "oLoupGaleux",
                "oJeuneLoup", "oJeuneLoup",
                "oRenardMystique", "oRenardMystique",
                "oRodeurForet", "oRodeurForet",
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oFeuillageProtecteur",
                "oPiegeRonce",

                "oSkarlChetif", "oSkarlChetif", "oSkarlChetif",
                "oEstafetteSkarl", "oEstafetteSkarl",
                "oBandit", "oBandit",
                "oBanditGuerrier", "oBanditGuerrier",
                "oVoleurFinelame",
                "oVideGousset",
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oRuisselierAbyssien",
                "oRodeurAbyssien",
                "oCoquillageMaree", "oCoquillageMaree",
                "oProtectionMaree",
                "oHurlementTribu"
            ]
        },
        {
            id: "rempart_contre_la_terreur",
            name: "Rempart contre la terreur",
            description: "Un rempart de Bêtes épaulé par les Skarls : on occupe le terrain, on encaisse, puis on contre-attaque sur la durée.",
            cards: [
                "oTarrinox", "oTarrinox",
                "oTarentuleForet", "oTarentuleForet",
                "oTortueVagabonde", "oTortueVagabonde",
                "oLoupGaleux", "oLoupGaleux",
                "oJeuneLoup", "oJeuneLoup",
                "oRenardMystique", "oRenardMystique",
                "oRodeurForet", "oRodeurForet",
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oFeuillageProtecteur",
                "oPiegeRonce",
                
                "oSkarlChetif", "oSkarlChetif", "oSkarlChetif",
                "oEstafetteSkarl", "oEstafetteSkarl", "oEstafetteSkarl",
                "oLieutenantGorrak",
                "oLoupGrisForet", "oLoupGrisForet", "oLoupGrisForet",
                "oJeuneOursForet", "oJeuneOursForet",
                "oSanglierPeauRoc", "oSanglierPeauRoc",
                "oRodeurForet", "oRodeurForet",
                
                "oRugissementForet", "oRugissementForet",
                "oCriMeute",
                "oFrenesieSauvage"
            ]
        }
    ];
}

