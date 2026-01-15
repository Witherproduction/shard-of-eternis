/// @function get_bot_decks_chap1()
/// @description Retourne la liste des decks bots pour le Chapitre 1
function get_bot_decks_chap1() {
    return [
        {
            id: 1,
            name: "Orc Geule-Roche",
            profile: "Aggro",
            deck_name: "Invasion Geule-Roche",
            difficulty: "Facile",
            portrait: "sPortraitOrcGeuleRoche",
            description: "Un deck agressif basé sur les orcs de la tribu Geule-Roche et les bêtes sauvages. Submergez l'adversaire rapidement !",
            cards: [
                "oMassacreurGueuleRoche", "oMassacreurGueuleRoche",
                "oEnvahisseurGueuleRoche", "oEnvahisseurGueuleRoche",
                "oLoupGuerreGueuleRoche", "oLoupGuerreGueuleRoche",
                
                "oGobelinFurtif", "oGobelinFurtif",
                "oBandit", "oBandit",
                "oMineurTunnelin", "oMineurTunnelin",
                
                "oTarentuleForet",
                "oPatteBriseLarmoyant",
                "oTortueVagabonde",
                "oSanglierPeauRoc",
                "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet",
                "oLoupGaleux", "oLoupGaleux",
                "oLoupGrisForet", "oLoupGrisForet",
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere",
                
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oChasseMeute", "oChasseMeute",
                "oRugissementForet", "oRugissementForet",
                "oCriMeute", "oCriMeute",
                
              
                "oFeuillageProtecteur", "oFeuillageProtecteur"
            ]
        },
        {
            id: 2,
            name: "Essaim Abyssien",
            profile: "swarm",
            deck_name: "Essaim Abyssien",
            difficulty: "Moyen",
            portrait: "sPortraitAbyssien",
            description: "Un deck basé sur les Abyssiens qui se multiplient et submergent l'adversaire, soutenus par quelques bêtes de la forêt.",
            cards: [
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde",
                // Abyssiens doublés (6 copies chacun)
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien",
                "oRodeurAbyssien", "oRodeurAbyssien", "oRodeurAbyssien", "oRodeurAbyssien", "oRodeurAbyssien", "oRodeurAbyssien",

                // Sorts Abyssiens
                "oMareeDeferlante", "oMareeDeferlante", "oMareeDeferlante",
                "oProtectionMaree", "oProtectionMaree", "oProtectionMaree",
                "oHurlementTribu", "oHurlementTribu", "oHurlementTribu",
                "oFerveurMarais", "oFerveurMarais", "oFerveurMarais",

                // Loups retirés pour faire de la place
                // "oJeuneLoup", "oJeuneLoup", "oJeuneLoup",
                // "oLoupGaleux", "oLoupGaleux", "oLoupGaleux",
                // "oLoupGrisForet", "oLoupGrisForet", "oLoupGrisForet",

                "oJeuneLoup", "oJeuneLoup",
                "oJeuneOursForet", "oJeuneOursForet",
                "oVieilOurs",
                "oPeauRocRobuste", "oPeauRocRobuste"
            ]
        }
    ];
}
