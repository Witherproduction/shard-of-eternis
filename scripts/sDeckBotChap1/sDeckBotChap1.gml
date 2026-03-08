/// @function get_bot_decks_chap1()
/// @description Retourne la liste des decks bots pour le Chapitre 1
function get_bot_decks_chap1() {
    return [
        {
            id: "Invasion_Gueule_Roche",
            name: "Orc Gueule-Roche",
            profile: {
                // Style Equilibré & Puissant
                summon_weight: 85,          // Priorité haute à l'invocation
                board_presence_weight: 80,  // Cherche à avoir la plus grosse force de frappe
                
                risk_tolerance: 50,         // Equilibré (ni suicidaire, ni peureux)
                attack_bias: 60,            // Légère préférence pour l'attaque
                defense_bias: 50,           // Sait se défendre si nécessaire
                defense_trigger_margin: 50, // Passe en défense si l'adversaire prend l'avantage
                
                target_monster_policy: "strongest", // Vise les menaces
                target_spell_policy: "tempo",

                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oTortueVagabonde": "front",
                        "oJeuneOursForet": "front",
                        "oSanglierPeauRoc": "front"
                    },
                    conditional_play: {
                        "oMassacreurGueuleRoche": {
                             requires_on_board: ["oLoupGuerreGueuleRoche"]
                        }
                    }
                }
            },
            deck_name: "Invasion Gueule-Roche",
            difficulty: "Facile",
            portrait: "sPortraitOrcGueuleRoche",
            description: "Un deck agressif basé sur les orcs de la tribu Gueule-Roche et les bêtes sauvages. Submergez l'adversaire rapidement !",
            cards: [
                "oMassacreurGueuleRoche", "oMassacreurGueuleRoche",
                "oEnvahisseurGueuleRoche", "oEnvahisseurGueuleRoche", "oEnvahisseurGueuleRoche",
                "oLoupGuerreGueuleRoche", "oLoupGuerreGueuleRoche",
                
                "oGobelinFurtif", "oGobelinFurtif",
                "oTunnelin", "oTunnelin",
                "oMineurTunnelin", "oMineurTunnelin",
                
                "oTortueVagabonde","oTortueVagabonde",
                "oSanglierPeauRoc", "oSanglierPeauRoc",
                "oJeuneOursForet", "oJeuneOursForet",
                "oLoupGaleux", "oLoupGaleux",
                "oLoupGrisForet", "oLoupGrisForet",
                "oAraigneeForestiere", "oAraigneeForestiere",
                "oJeuneLoup", "oJeuneLoup", "oJeuneLoup",
                
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur", "oSautPredateur",
                "oFrenesieSauvage", "oFrenesieSauvage",
                "oRugissementForet", "oRugissementForet",
                "oCriMeute", "oCriMeute",
                "oFeuillageProtecteur", "oFeuillageProtecteur"
            ]
        },
        {
            id: "Essaim_Abyssien",
            name: "Essaim Abyssien",
            profile: {
                // Style Nuée Personnalisé
                summon_weight: 90,          // Priorité absolue à l'invasion
                board_presence_weight: 95,  // Veut un terrain plein
                continuous_weight: 75,      // Aime les boosts continus
                
                risk_tolerance: 70,         // Prend des risques pour s'étendre
                attack_bias: 80,            // Très agressif
                defense_bias: 40,           // Peu de défense
                sacrifice_tolerance: 70,    // Prêt à mourir pour la ruche
                
                target_monster_policy: "weakest", // Elimine les faibles pour passer
                
                // Règles Spécifiques (implémentées dans sAIBrain)
                custom_rules: {
                    prioritize_card_name: "Ruisselier", // Priorité #1
                    swarm_trigger_card: "Ruisselier",   // Si présent, invoquer tout ce qui bouge
                    max_same_continuous: 2,             // Limite de doublons continus
                    force_attack_abyssien_condition: true, // Si Magie Continue ou Ruisselier présent -> Attaque
                    
                    // Placement
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oRuisselierAbyssien": "back",
                        "oCoureurAbyssien": "front",
                        "oFourrageurAbyssien": "front",
                        "oTortueVagabonde": "front",
                        "oVieilOurs": "front"
                    },
                    
                    // Règles de Sorts
                    spell_rules: {
                        "oMareeDeferlante": "bounce_big_threat",
                        "oProtectionMaree": "buff_if_3_abyssien",
                        "oHurlementTribu": "sac_coureur_buff_2",
                        "oFerveurMarais": "summon_if_3_slots"
                    }
                }
            },
            deck_name: "Essaim Abyssien",
            difficulty: "Moyen",
            portrait: "sPortraitAbyssien",
            description: "Un deck basé sur les Abyssiens qui se multiplient et submergent l'adversaire, soutenus par quelques bêtes de la forêt.",
            cards: [
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde", 
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", 
                "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", 
                "oRodeurAbyssien", "oRodeurAbyssien", 
                "oRodeurAbyssien", "oRodeurAbyssien", 
 
                // Sorts Abyssiens 
                "oMareeDeferlante", "oMareeDeferlante", "oMareeDeferlante", 
                "oProtectionMaree", "oProtectionMaree", "oProtectionMaree", 
                "oHurlementTribu", "oHurlementTribu", "oHurlementTribu", 
                "oFerveurMarais", "oFerveurMarais", "oFerveurMarais", 
 
 	 	 	 	"oJeuneLoup", "oJeuneLoup", 
 	 	 	 	"oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere",

                // Ajouts demandés
                "oVieilOurs", "oVieilOurs",
                "oLoupGaleux", "oLoupGaleux"
            ]
        },
        {
            id: "Bandit_Grand_Chemin",
            name: "James la Calamité",
            profile: {
                name: "Trickster",
                // Style Rusé & Sournois
                summon_weight: 70,          // Bon équilibre d'invocation
                board_presence_weight: 60,  // Ne cherche pas forcément la domination brute
                manual_effect_weight: 90,   // Adore utiliser ses capacités et sorts
                removal_weight: 80,         // Fort accent sur l'élimination/contrôle
                
                risk_tolerance: 65,         // Agressif et opportuniste
                attack_bias: 70,            // Attaque souvent (furtivité)
                defense_bias: 30,           // Peu de défense passive
                sacrifice_tolerance: 80,    // N'hésite pas à sacrifier ses propres unités
                
                target_monster_policy: "utility", // Vise les unités stratégiques
                target_spell_policy: "value",
                
                synergy_focus: ["Stealth", "Sacrifice"],
                
                // Règles Spécifiques (implémentées dans sAIBrain)
                custom_rules: {
                    prioritize_card_name: ["James la Calamité", "Morgane la Venimeuse"], // Priorité #1
                    protect_card: "James la Calamité", // Ne jamais attaquer avec cette carte
                    
                    // Placement : James au fond pour le protéger
                    placement_priority: {
                        "oJamesCalamite": "back",
                        "oMorganeVenimeuse": "back",
                        "oGobelinFurtif": "front", // Ecran de fumée
                        "oVideGousset": "front"
                    },
                    
                    // Règles de Sorts
                    spell_rules: {
                        "oBrumeForet": "buff_if_no_camo_bonus_combo",
                        "oCapeOmbre": "buff_if_no_camo",
                        "oCamouflageStrategique": "buff_if_camo",
                        "oAttaqueFurtive": "damage_bonus_if_camo"
                    },
                    
                    poison_sacrifice_logic: true
                }
            },
            deck_name: "Bandit de Grand Chemin",
            difficulty: "Difficile",
            portrait: "sPortraitJameCalamite",
            description: "Un deck sournois utilisant les mécaniques de vol, de camouflage et de sacrifice pour contrôler le terrain et surprendre l'adversaire.",
            cards: [
                // Monstres
                "oJamesCalamite",
                "oMorganeVenimeuse", "oMorganeVenimeuse",
                 "oGobelinFurtif", "oGobelinFurtif", "oGobelinFurtif",
                 "oMaitrePasse", "oMaitrePasse", "oMaitrePasse",
                "oPortefaix", "oPortefaix",
                "oMineurTunnelin", "oMineurTunnelin", "oMineurTunnelin",
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oVideGousset", "oVideGousset", "oVideGousset",
                "oVoleurFinelame", "oVoleurFinelame",
                "oBanditGuerrier", "oBanditGuerrier", "oBanditGuerrier",
                
                // Magie
                "oSournoiserie", "oSournoiserie",
                "oBrumeTrompeuse",
                "oBrumeForet", "oBrumeForet",
                "oFiletOmbre", "oFiletOmbre",
                "oFeuillageProtecteur", "oFeuillageProtecteur",
                "oDagueFilou", "oDagueFilou",
                "oCapeOmbre", "oCapeOmbre",
                "oCamouflageStrategique", "oCamouflageStrategique",
                "oAttaqueFurtive", "oAttaqueFurtive"
            ]
        }
    ];
}
