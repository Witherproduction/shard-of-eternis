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
                    },
                    spell_rules: {
                        "oFrenesieSauvage": "buff_beast_bonus_wolf"
                    }
                }
            },
            deck_name: "Invasion Gueule-Roche",
            difficulty: "Facile",
            portrait: "sPortraitOrcGueuleRoche",
            description: "Un deck agressif basé sur les orcs de la tribu Gueule-Roche et les bêtes sauvages. Submergez l'adversaire rapidement !",
            cards: [
                "oMassacreurGueuleRoche", "oLoupGuerreGueuleRoche",
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
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien", 
                "oRuisselierAbyssien", "oRuisselierAbyssien", "oRuisselierAbyssien", 
                "oRodeurAbyssien", "oRodeurAbyssien", "oRodeurAbyssien",
                "oCoureurAbyssien", "oCoureurAbyssien", "oCoureurAbyssien",
 
                // Sorts Abyssiens 
                "oMareeDeferlante", "oMareeDeferlante", "oMareeDeferlante", 
                "oProtectionMaree", "oProtectionMaree", "oProtectionMaree", 
                "oHurlementTribu", "oHurlementTribu", "oHurlementTribu", 
                "oFerveurMarais", "oFerveurMarais", "oFerveurMarais", 
 
 	 	 	 	"oJeuneLoup", "oJeuneLoup", "oJeuneLoup",
 	 	 	 	"oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere",

                // Ajouts demandés
                "oRenardMystique",
                "oVieilOurs", "oVieilOurs", "oVieilOurs",
                "oLoupGaleux", "oLoupGaleux", "oLoupGaleux"
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
                "oRodeurAbyssien", "oRodeurAbyssien",
                 "oGobelinFurtif", "oGobelinFurtif", "oGobelinFurtif",
                 "oMaitrePasse", "oMaitrePasse", "oMaitrePasse",
                "oPortefaix", "oPortefaix", "oPortefaix",
                "oMineurTunnelin", "oMineurTunnelin", "oMineurTunnelin",
                "oFourrageurAbyssien", "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oVideGousset", "oVideGousset", "oVideGousset",
                "oVoleurFinelame", "oVoleurFinelame",
                "oBanditGuerrier", "oBanditGuerrier", "oBanditGuerrier",
                "oBandit", "oBandit", "oBandit",
                
                // Magie
                "oSournoiserie", "oSournoiserie",
                "oBrumeTrompeuse",
                "oBrumeForet",
                "oFiletOmbre",
                "oFeuillageProtecteur",
                "oDagueFilou", "oDagueFilou",
                "oCapeOmbre",
                "oCamouflageStrategique", "oCamouflageStrategique",
                "oAttaqueFurtive"
            ]
        },
        {
            id: "Matriarche_Peau_Roc",
            name: "Matriarche Peau-roc",
            profile: {
                name: "Beastmaster",
                summon_weight: 90,
                board_presence_weight: 85,
                synergy_focus: ["Beast", "Buff", "Charge"],
                risk_tolerance: 30, // Joue très safe pour protéger ses carry
                attack_bias: 40, // Attaque peu les monstres, préfère setup
                defense_bias: 90, // Défend ses PV et ses unités clés
                target_monster_policy: "taunt_only", // Ignore les monstres sauf Provocation pour aller face
                custom_rules: {
                    prioritize_card_name: ["Matriarche Peau-roc", "Peau-de-roc robuste"],
                    protect_card: ["Matriarche Peau-roc", "Peau-de-roc robuste"], // Protège les Peau-roc
                    placement_strategy: "tank_front_carry_back",
                    placement_priority: {
                        // BACKLINE : Les Peau-roc fragiles ou à charge pour les protéger
                        "oMatriarchePeauRoc": "back",
                        "oPeauRocRobuste": "back", // Charge : On le cache derrière un tank
                        "oSanglierPeauRoc": "back",
                        "oRenardMystique": "back",
                        
                        // FRONTLINE : Les murs de PV
                        "oTortueVagabonde": "front",
                        "oJeuneOursForet": "front",
                        "oVieilOurs": "front",
                        "oTarrinox": "front" // Peut tanker si besoin
                    },
                    spell_rules: {
                        "oFrenesieSauvage": "buff_charge_unit", // Prio : Buff les unités avec Charge
                        "oGriffePredateur": "buff_charge_unit",
                        "oRugissementForet": "buff_all_beasts",
                        "oCriMeute": "buff_all_beasts"
                    },
                    attack_face_priority: ["oPeauRocRobuste", "oSanglierPeauRoc"] // Ces unités doivent viser le héros si possible
                }
            },
            deck_name: "Horde de Peau-roc",
            difficulty: "Moyen", // 5/10
            portrait: "sPortraitMatriarchePeauRoc", 
            description: "La Matriarche veille sur sa harde. Elle temporise le début de partie pour écraser ses ennemis sous le poids de ses bêtes géantes.",
            cards: [
                "oGriffePredateur", "oGriffePredateur",
                "oSautPredateur",
                "oFrenesieSauvage", "oFrenesieSauvage",
                "oRugissementForet", "oRugissementForet",
                "oPiegeRonce", "oPiegeRonce",
                "oCriMeute", "oCriMeute",
                "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", "oRenardMystique", "oRenardMystique",
                "oLoupGrisForet", "oLoupGrisForet", "oLoupGrisForet",
                "oSanglierPeauRoc",
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde",
                "oVieilOurs", "oVieilOurs", "oVieilOurs",
                "oLoupGaleux", "oLoupGaleux",
                "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet",
                "oRodeurForet", "oRodeurForet", "oRodeurForet", "oRodeurForet",
                "oPeauRocRobuste",
                "oTarentuleForet", "oTarentuleForet",
                "oTarrinox", "oTarrinox"
            ]
        },
        {
            id: "Recolteur_Recolte_Sournoise",
            name: "Le Récolteur",
            profile: {
                name: "Pilleur",
                summon_weight: 80,
                board_presence_weight: 70,
                manual_effect_weight: 75,
                removal_weight: 65,
                
                risk_tolerance: 55,
                attack_bias: 65,
                defense_bias: 45,
                
                target_monster_policy: "utility",
                target_spell_policy: "value",
                
                synergy_focus: ["Pillage", "Degats", "Camouflage"],
                
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oSanglierPeauRoc": "front",
                        "oBandit": "front",
                        "oPortefaix": "front",
                        "oTunnelin": "front",
                        "oMineurTunnelin": "front",
                        
                        "oVoleurFinelame": "back",
                        "oVideGousset": "back",
                        "oSorcierVoleur": "back",
                        "oMorganeVenimeuse": "back"
                    },
                    spell_rules: {
                        "oSournoiserie": "remove_or_slow_threat",
                        "oAttaqueFurtive": "remove_or_slow_threat",
                        "oMainFurtive": "steal_value",
                        "oAnneauVoleur": "steal_value",
                        "oFiletOmbre": "remove_or_slow_threat",
                        "oPiegeVoleur": "remove_or_slow_threat",
                        "oPiegeRonce": "remove_or_slow_threat"
                    }
                }
            },
            deck_name: "La récolte sournoise",
            difficulty: "Moyen",
            portrait: "sPortraitRecolteur",
            description: "Des pillards humains alliés aux Tunnelins. Pillage et dégâts pour épuiser l'adversaire, puis contrôle du terrain via Entrave et secrets.",
            cards: [
                // Monstres (30)
                "oTunnelin", "oTunnelin", "oTunnelin",
                "oMineurTunnelin", "oMineurTunnelin", "oMineurTunnelin",
                "oPortefaix", "oPortefaix", "oPortefaix",
                "oBougimencienTunnelin", "oBougimencienTunnelin",
                "oVoleurFinelame", "oVoleurFinelame", "oVoleurFinelame",
                "oBandit", "oBandit", "oBandit",
                "oSanglierPeauRoc", "oSanglierPeauRoc", "oSanglierPeauRoc",
                "oBanditGuerrier", "oBanditGuerrier", "oBanditGuerrier",
                "oVideGousset", "oVideGousset", "oVideGousset",
                "oMorganeVenimeuse", "oMorganeVenimeuse",
                "oSorcierVoleur", "oSorcierVoleur",

                // Magie (10)
                "oMainFurtive", "oMainFurtive",
                "oAnneauVoleur", "oAnneauVoleur",
                "oSournoiserie", "oSournoiserie",
                "oAttaqueFurtive",
                "oFiletOmbre",
                "oPiegeVoleur",
                "oPiegeRonce"
            ]
        },
        {
            id: "Armee_des_Skarls",
            name: "Armée des Skarls",
            profile: {
                name: "Horde",
                summon_weight: 92,
                board_presence_weight: 90,
                manual_effect_weight: 55,
                removal_weight: 40,
                risk_tolerance: 75,
                attack_bias: 85,
                defense_bias: 35,
                target_monster_policy: "weakest",
                target_spell_policy: "tempo",
                synergy_focus: ["Skarl", "Humain", "Tunnelin", "Abyssien", "Bête"],
                custom_rules: {
                    placement_strategy: "swarm_front_support_back",
                    placement_priority: {
                        "oSkarlChetif": "front",
                        "oEstafetteSkarl": "front",
                        "oLieutenantGorrak": "back",
                        "oFrereGorrak": "back",
                        "oRuisselierAbyssien": "back",
                        "oTortueVagabonde": "front",
                        "oSanglierPeauRoc": "front",
                        "oPortefaix": "front"
                    }
                }
            },
            deck_name: "Armée des Skarls",
            difficulty: "Difficile",
            portrait: "sPortraitSkarl",
            description: "Une armée composite menée par les Skarls : Humains, Tunnelins, Abyssiens et Bêtes rassemblés sous une seule bannière.",
            cards: [
                "oFrereGorrak",
                "oLieutenantGorrak",
                "oEstafetteSkarl", "oEstafetteSkarl", "oEstafetteSkarl",
                "oSkarlChetif", "oSkarlChetif", "oSkarlChetif",
                
                "oFourrageurAbyssien", "oFourrageurAbyssien",
                "oRuisselierAbyssien",
                
                "oSanglierPeauRoc", "oSanglierPeauRoc",
                "oTortueVagabonde", "oTortueVagabonde",
                
                "oTunnelin", "oTunnelin",
                "oMineurTunnelin", "oMineurTunnelin",
                "oBougimencienTunnelin", "oBougimencienTunnelin",
                "oGeomancienTunnelin",
                "oVieilOurs",
                "oLoupGrisForet",
                
                "oBanditGuerrier", "oBanditGuerrier",
                "oPortefaix", "oPortefaix",
                "oBandit", "oBandit",
                
                "oFeuillageProtecteur", "oFeuillageProtecteur",
                "oPiegeRonce", "oPiegeRonce",
                "oFiletOmbre", "oFiletOmbre",
                "oBrumeForet",
                "oSournoiserie",
                "oCoquillageMaree", "oCoquillageMaree"
            ]
        },
        {
            id: "Terreur_de_la_foret",
            name: "Gorrak",
            profile: {
                name: "Brute",
                summon_weight: 90,
                board_presence_weight: 85,
                manual_effect_weight: 30,
                removal_weight: 25,
                risk_tolerance: 65,
                attack_bias: 90,
                defense_bias: 35,
                target_monster_policy: "strongest",
                target_spell_policy: "tempo",
                synergy_focus: ["Skarl", "Humain"],
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oLieutenantGorrak": "back",
                        "oSorcierVoleur": "back",
                        "oMaitrePasse": "back"
                    }
                }
            },
            deck_name: "Terreur de la forêt",
            difficulty: "Difficile",
            portrait: "sPortraitGorrak",
            description: "Un deck Skarl/Humain basé sur la puissance brute : une ligne de front agressive renforcée par des boosts pour écraser l'adversaire.",
            cards: [
                "oSkarlChetif", "oSkarlChetif", "oSkarlChetif",
                "oEstafetteSkarl", "oEstafetteSkarl", "oEstafetteSkarl",
                "oPortefaix", "oPortefaix", "oPortefaix",
                "oVoleurFinelame", "oVoleurFinelame",
                "oBandit", "oBandit", "oBandit",
                "oVideGousset", "oVideGousset", "oVideGousset",
                "oBanditGuerrier", "oBanditGuerrier", "oBanditGuerrier",
                "oGeomancienTunnelin",
                "oMineurTunnelin",
                "oTunnelin",
                "oSorcierVoleur", "oSorcierVoleur", "oSorcierVoleur",
                "oMaitrePasse", "oMaitrePasse",
                "oLieutenantGorrak", "oLieutenantGorrak",

                "oCoquillageMaree", "oCoquillageMaree",
                "oDagueFilou", "oDagueFilou",
                "oSournoiserie", "oSournoiserie",
                "oCamouflageStrategique", "oCamouflageStrategique",
                "oDoubleJeu",
                "oFiletOmbre"
            ]
        }
    ];
}

function chap1_bot_events_on_start_turn(game_inst) {
    if (game_inst == noone || !instance_exists(game_inst)) return;
    if (!variable_global_exists("selected_bot_deck_id")) return;
    if (!variable_global_exists("previous_room_before_duel") || global.previous_room_before_duel != rScenario) return;
    if (!variable_instance_exists(game_inst, "timerEnabledMulligan") || game_inst.timerEnabledMulligan) return;
    if (!variable_instance_exists(game_inst, "player_current")) return;
    if (!variable_instance_exists(game_inst, "nbTurn")) return;
    if (global.selected_bot_deck_id != "Invasion_Gueule_Roche") return;
    if (game_inst.player_current != 1) return;
    if (game_inst.nbTurn != 2) return;
}

function chap1_bot_events_on_progress(game_inst) {
    if (game_inst == noone || !instance_exists(game_inst)) return false;
    if (!variable_global_exists("selected_bot_deck_id")) return false;
    if (!variable_global_exists("previous_room_before_duel") || global.previous_room_before_duel != rScenario) return false;
    if (!variable_instance_exists(game_inst, "timerEnabledMulligan") || game_inst.timerEnabledMulligan) return false;
    if (!variable_instance_exists(game_inst, "player_current")) return false;
    if (game_inst.player_current != 1) return false;
    if (!variable_instance_exists(game_inst, "phase_current")) return false;
    if (!variable_instance_exists(game_inst, "phase")) return false;
    if (game_inst.phase[game_inst.phase_current] != "Start") return false;
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;
    var botID = global.selected_bot_deck_id;
    
    if (botID == "Bandit_Grand_Chemin") {
        if (!variable_instance_exists(game_inst, "bot3_script_phase1_done")) game_inst.bot3_script_phase1_done = false;
        
        var lpB3 = instance_find(oLP_Enemy, 0);
        var lpvB3 = (lpB3 != noone && variable_instance_exists(lpB3, "nbLP")) ? lpB3.nbLP : 999999;
        
        if (!game_inst.bot3_script_phase1_done) {
            var mustTriggerB3 = (lpvB3 <= 40) || (game_inst.nbTurn == 6);
            if (mustTriggerB3) {
                game_inst.bot3_script_phase1_done = true;
                
                if (lpvB3 <= 40) {
                    game_inst.story_pending_summon_asset = "oFourrageurAbyssien";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 1;
                    
                    game_inst.story_pending_summon_asset2 = "oCoureurAbyssien";
                    game_inst.story_pending_summon_cost2 = 0;
                    game_inst.story_pending_summon_force_cost2 = true;
                    game_inst.story_pending_summon_count2 = 1;
                } else {
                    game_inst.story_pending_summon_asset = "oCoureurAbyssien";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 2;
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB3P1 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB3P1.setPortrait("sPortraitJameCalamite", 96);
                toastB3P1.setText("Voici la phase une de mon piège, envoyé les Abyssien!");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot3_script_phase2_done")) game_inst.bot3_script_phase2_done = false;
        if (!game_inst.bot3_script_phase2_done) {
            var mustTriggerB3P2 = (lpvB3 <= 30) || (game_inst.nbTurn == 10);
            if (mustTriggerB3P2) {
                game_inst.bot3_script_phase2_done = true;
                
                var canSummonB3P2 = (getLeftmostFreeMonsterSlot(false) != noone);
                if (lpvB3 <= 30 && canSummonB3P2) {
                    game_inst.story_pending_summon_asset = "oGobelinFurtif";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 1;
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oGobelinFurtif";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB3P2 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB3P2.setPortrait("sPortraitJameCalamite", 96);
                toastB3P2.setText("Tu entend la menace mais tu ne la vois pas!");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot3_script_phase3_done")) game_inst.bot3_script_phase3_done = false;
        if (!game_inst.bot3_script_phase3_done && game_inst.bot3_script_phase2_done) {
            var heroFieldMgr = instance_exists(fieldManagerHero) ? fieldManagerHero : instance_find(oFieldManagerHero, 0);
            if (heroFieldMgr != noone && instance_exists(heroFieldMgr)) {
                var heroMonsterField = heroFieldMgr.getField("Monster");
                if (heroMonsterField != noone && instance_exists(heroMonsterField)) {
                    var hasLvl5HeroMonster = false;
                    for (var iB3 = 0; iB3 < array_length(heroMonsterField.cards); iB3++) {
                        var cB3 = heroMonsterField.cards[iB3];
                        if (cB3 != 0 && instance_exists(cB3)) {
                            if (variable_instance_exists(cB3, "isFaceDown") && cB3.isFaceDown) continue;
                            var lvlB3 = variable_instance_exists(cB3, "mana_cost") ? cB3.mana_cost : -1;
                            if (lvlB3 >= 5) { hasLvl5HeroMonster = true; break; }
                        }
                    }
                    
                    if (hasLvl5HeroMonster) {
                        game_inst.bot3_script_phase3_done = true;
                        
                        game_inst.story_pending_add_to_hand_asset = "oMorganeVenimeuse";
                        
                        if (instance_exists(oStoryToast)) return true;
                        var toastB3P3 = instance_create_layer(0, 0, "UI", oStoryToast);
                        toastB3P3.setPortrait("sPortraitJameCalamite", 96);
                        toastB3P3.setText("Ce qui est bien avec le poison, c'est que ca vous tue!");
                        return true;
                    }
                }
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot3_script_phase4_done")) game_inst.bot3_script_phase4_done = false;
        if (!game_inst.bot3_script_phase4_done && game_inst.bot3_script_phase3_done) {
            var mustTriggerB3P4 = (lpvB3 <= 20) || (game_inst.nbTurn == 18);
            if (mustTriggerB3P4) {
                game_inst.bot3_script_phase4_done = true;
                
                var wantSummonB3P4 = (lpvB3 <= 20);
                var canSummonB3P4 = (getLeftmostFreeMonsterSlot(false) != noone);
                
                if (wantSummonB3P4 && canSummonB3P4) {
                    game_inst.story_pending_summon_asset = "oJamesCalamite";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 1;
                    game_inst.story_pending_summon_prefer_back = true;
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oJamesCalamite";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB3P4 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB3P4.setPortrait("sPortraitJameCalamite", 96);
                toastB3P4.setText("Et pour finir, je vole tout ce que tu as");
                return true;
            }
        }
        
        return false;
    }
    
    if (botID == "Recolteur_Recolte_Sournoise") {
        if (!variable_instance_exists(game_inst, "bot5_script_phase2_done")) game_inst.bot5_script_phase2_done = false;
        if (!game_inst.bot5_script_phase2_done) {
            var lp5 = instance_find(oLP_Enemy, 0);
            var lpv5 = (lp5 != noone && variable_instance_exists(lp5, "nbLP")) ? lp5.nbLP : 999999;
            var mustTriggerB5P2 = (lpv5 <= 40) || (game_inst.nbTurn == 4);
            if (mustTriggerB5P2) {
                game_inst.bot5_script_phase2_done = true;
                game_inst.story_pending_cast_spell_asset = "oMainFurtive";
                game_inst.story_pending_cast_spell_cost = 0;
                game_inst.story_pending_cast_spell_force_cost = true;
                
                if (instance_exists(oStoryToast)) return true;
                var toastB5P2 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB5P2.setPortrait("sPortraitRecolteur", 96);
                toastB5P2.setText("Ce que tu possedes m'appartient!");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot5_script_phase3_done")) game_inst.bot5_script_phase3_done = false;
        if (!game_inst.bot5_script_phase3_done) {
            var lp5b = instance_find(oLP_Enemy, 0);
            var lpv5b = (lp5b != noone && variable_instance_exists(lp5b, "nbLP")) ? lp5b.nbLP : 0;
            var isTurn8 = (game_inst.nbTurn == 8);
            var lpHigh = (lpv5b >= 30);
            
            if (isTurn8 || lpHigh) {
                game_inst.bot5_script_phase3_done = true;
                
                if (isTurn8) {
                    game_inst.story_pending_add_to_hand_asset = "oVoleurFinelame";
                    game_inst.story_pending_cast_spell_asset = "oMainFurtive";
                    game_inst.story_pending_cast_spell_cost = 0;
                    game_inst.story_pending_cast_spell_force_cost = true;
                } else {
                    var canSummonB5P3 = (getLeftmostFreeMonsterSlot(false) != noone);
                    if (canSummonB5P3) {
                        game_inst.story_pending_summon_asset = "oVoleurFinelame";
                        game_inst.story_pending_summon_cost = 0;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 1;
                        game_inst.story_pending_summon_prefer_back = true;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oVoleurFinelame";
                    }
                    game_inst.story_pending_cast_spell_asset = "oMainFurtive";
                    game_inst.story_pending_cast_spell_cost = 0;
                    game_inst.story_pending_cast_spell_force_cost = true;
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB5P3 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB5P3.setPortrait("sPortraitRecolteur", 96);
                toastB5P3.setText("Pendant que tu regarde la, j'agit ici !");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot5_script_phase4_done")) game_inst.bot5_script_phase4_done = false;
        if (!game_inst.bot5_script_phase4_done) {
            var lp5c = instance_find(oLP_Enemy, 0);
            var lpv5c = (lp5c != noone && variable_instance_exists(lp5c, "nbLP")) ? lp5c.nbLP : 0;
            var isTurn18 = (game_inst.nbTurn == 18);
            if (isTurn18) {
                game_inst.bot5_script_phase4_done = true;
                
                game_inst.story_pending_cast_spell_asset = "oMainFurtive";
                game_inst.story_pending_cast_spell_cost = 0;
                game_inst.story_pending_cast_spell_force_cost = true;
                
                if (lpv5c >= 20) {
                    var canSummonAny = (getLeftmostFreeMonsterSlot(false) != noone);
                    if (canSummonAny) {
                        game_inst.story_pending_summon_asset = "oRecolteur";
                        game_inst.story_pending_summon_cost = 0;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 1;
                        game_inst.story_pending_summon_prefer_back = true;
                        
                        game_inst.story_pending_summon_asset2 = "oCatherineFumerol";
                        game_inst.story_pending_summon_cost2 = 0;
                        game_inst.story_pending_summon_force_cost2 = true;
                        game_inst.story_pending_summon_count2 = 1;
                        game_inst.story_pending_summon_prefer_back2 = true;
                        
                        game_inst.story_pending_summon_asset3 = "oYvanCostaud";
                        game_inst.story_pending_summon_cost3 = 0;
                        game_inst.story_pending_summon_force_cost3 = true;
                        game_inst.story_pending_summon_count3 = 1;
                        game_inst.story_pending_summon_prefer_front3 = true;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oRecolteur";
                    }
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oRecolteur";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB5P4 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB5P4.setPortrait("sPortraitRecolteur", 96);
                toastB5P4.setText("Yvan ! Catherine ! Pour une fois, salissons nous les mains !");
                return true;
            }
        }
        
        return false;
    }
    
    if (botID == "Terreur_de_la_foret") {
        var lp7 = instance_find(oLP_Enemy, 0);
        var lpv7 = (lp7 != noone && variable_instance_exists(lp7, "nbLP")) ? lp7.nbLP : 999999;
        
        if (!variable_instance_exists(game_inst, "bot7_script_phase2_done")) game_inst.bot7_script_phase2_done = false;
        if (!game_inst.bot7_script_phase2_done) {
            var mustTriggerB7P2 = (lpv7 <= 40) || (game_inst.nbTurn == 6);
            if (mustTriggerB7P2) {
                game_inst.bot7_script_phase2_done = true;
                
                if (game_inst.nbTurn == 6) {
                    game_inst.story_pending_add_to_hand_asset = "oSkarlChetif";
                } else {
                    var canSummonB7P2 = (getLeftmostFreeMonsterSlot(false) != noone);
                    if (canSummonB7P2) {
                        game_inst.story_pending_summon_asset = "oSkarlChetif";
                        game_inst.story_pending_summon_cost = 3;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 1;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oSkarlChetif";
                    }
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB7P2 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB7P2.setPortrait("sPortraitGorrak", 96);
                toastB7P2.setText("Mes enfants, venez m'aider !");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot7_script_phase3_done")) game_inst.bot7_script_phase3_done = false;
        if (!game_inst.bot7_script_phase3_done && game_inst.bot7_script_phase2_done) {
            var mustTriggerB7P3 = (lpv7 <= 30) || (game_inst.nbTurn == 12);
            if (mustTriggerB7P3) {
                game_inst.bot7_script_phase3_done = true;
                
                if (game_inst.nbTurn == 12) {
                    game_inst.story_pending_add_to_hand_asset = "oEstafetteSkarl";
                    game_inst.story_pending_add_to_hand_asset2 = "oEstafetteSkarl";
                } else {
                    var canSummonB7P3 = (getLeftmostFreeMonsterSlot(false) != noone);
                    if (canSummonB7P3) {
                        game_inst.story_pending_summon_asset = "oEstafetteSkarl";
                        game_inst.story_pending_summon_cost = 3;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 2;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oEstafetteSkarl";
                        game_inst.story_pending_add_to_hand_asset2 = "oEstafetteSkarl";
                    }
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB7P3 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB7P3.setPortrait("sPortraitGorrak", 96);
                toastB7P3.setText("Skarls ! Rapportez-moi sa tête !");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot7_script_phase4_done")) game_inst.bot7_script_phase4_done = false;
        if (!game_inst.bot7_script_phase4_done && game_inst.bot7_script_phase3_done) {
            var mustTriggerB7P4 = (lpv7 <= 20) || (game_inst.nbTurn == 18);
            if (mustTriggerB7P4) {
                game_inst.bot7_script_phase4_done = true;
                
                if (game_inst.nbTurn == 18) {
                    game_inst.story_pending_add_to_hand_asset = "oGorrak";
                } else {
                    var canSummonB7P4 = (getLeftmostFreeMonsterSlot(false) != noone);
                    if (canSummonB7P4) {
                        game_inst.story_pending_summon_asset = "oGorrak";
                        game_inst.story_pending_summon_cost = 8;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 1;
                        
                        game_inst.story_pending_summon_asset2 = "oEstafetteSkarl";
                        game_inst.story_pending_summon_count2 = 2;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oGorrak";
                    }
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB7P4 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB7P4.setPortrait("sPortraitGorrak", 96);
                toastB7P4.setText("Je vais te broyer, petit homme !");
                return true;
            }
        }
        
        return false;
    }
    
    if (botID == "Matriarche_Peau_Roc") {
        var lp4 = instance_find(oLP_Enemy, 0);
        var lpv4 = (lp4 != noone && variable_instance_exists(lp4, "nbLP")) ? lp4.nbLP : 999999;
        
        if (!variable_instance_exists(game_inst, "bot4_script_phase1_done")) game_inst.bot4_script_phase1_done = false;
        if (!game_inst.bot4_script_phase1_done) {
            var mustTriggerB4P1 = (lpv4 <= 40) || (game_inst.nbTurn == 8);
            if (mustTriggerB4P1) {
                game_inst.bot4_script_phase1_done = true;
                
                var canSummonB4P1 = (getLeftmostFreeMonsterSlot(false) != noone);
                if (lpv4 <= 40 && canSummonB4P1) {
                    game_inst.story_pending_summon_asset = "oSanglierPeauRoc";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 1;
                    game_inst.story_pending_summon_prefer_front = true;
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oSanglierPeauRoc";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB4P1 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB4P1.setPortrait("sPortraitMatriarchePeauRoc", 96);
                toastB4P1.setText("HNNFF… GRRRR !");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot4_script_phase2_done")) game_inst.bot4_script_phase2_done = false;
        if (!game_inst.bot4_script_phase2_done && game_inst.bot4_script_phase1_done) {
            var mustTriggerB4P2 = (lpv4 <= 30) || (game_inst.nbTurn == 12);
            if (mustTriggerB4P2) {
                game_inst.bot4_script_phase2_done = true;
                
                var wantSummonB4P2 = (lpv4 <= 30);
                var canSummonB4P2 = (getLeftmostFreeMonsterSlot(false) != noone);
                if (wantSummonB4P2 && canSummonB4P2) {
                    game_inst.story_pending_summon_asset = "oPeauRocRobuste";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_summon_count = 1;
                    game_inst.story_pending_summon_prefer_back = true;
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oPeauRocRobuste";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB4P2 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB4P2.setPortrait("sPortraitMatriarchePeauRoc", 96);
                toastB4P2.setText("GRRR… *souffle lourd*…");
                return true;
            }
        }
        
        if (!variable_instance_exists(game_inst, "bot4_script_phase3_done")) game_inst.bot4_script_phase3_done = false;
        if (!game_inst.bot4_script_phase3_done && game_inst.bot4_script_phase2_done) {
            var mustTriggerB4P3 = (lpv4 <= 15) || (game_inst.nbTurn == 16);
            if (mustTriggerB4P3) {
                game_inst.bot4_script_phase3_done = true;
                
                if (lpv4 <= 15) {
                    var freeSlots = 0;
                    var fmE = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
                    if (fmE != noone && instance_exists(fmE)) {
                        var monsterFieldE = fmE.getField("Monster");
                        if (monsterFieldE != noone && instance_exists(monsterFieldE)) {
                            for (var iB4 = 0; iB4 < array_length(monsterFieldE.cards); iB4++) {
                                if (monsterFieldE.cards[iB4] == 0) freeSlots++;
                            }
                        }
                    }
                    
                    if (freeSlots >= 2) {
                        game_inst.story_pending_summon_asset = "oMatriarchePeauRoc";
                        game_inst.story_pending_summon_cost = 0;
                        game_inst.story_pending_summon_force_cost = true;
                        game_inst.story_pending_summon_count = 1;
                        game_inst.story_pending_summon_prefer_back = true;
                        
                        game_inst.story_pending_summon_asset2 = "oSanglierPeauRoc";
                        game_inst.story_pending_summon_cost2 = 0;
                        game_inst.story_pending_summon_force_cost2 = true;
                        game_inst.story_pending_summon_count2 = 1;
                        game_inst.story_pending_summon_prefer_front2 = true;
                    } else {
                        game_inst.story_pending_add_to_hand_asset = "oMatriarchePeauRoc";
                    }
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oMatriarchePeauRoc";
                }
                
                if (instance_exists(oStoryToast)) return true;
                var toastB4P3 = instance_create_layer(0, 0, "UI", oStoryToast);
                toastB4P3.setPortrait("sPortraitMatriarchePeauRoc", 96);
                toastB4P3.setText("*GROUIK*… GRRROONK ! HNNNFF !!");
                return true;
            }
        }
        
        return false;
    }
    
    if (botID != "Invasion_Gueule_Roche") return false;
    
    {
        if (!variable_instance_exists(game_inst, "bot1_script_part2_done")) game_inst.bot1_script_part2_done = false;
        if (!game_inst.bot1_script_part2_done) {
            var lp = instance_find(oLP_Enemy, 0);
            var lpv = (lp != noone && variable_instance_exists(lp, "nbLP")) ? lp.nbLP : 999999;
            
            var mustTrigger = (lpv <= 40) || (game_inst.nbTurn == 6);
            if (mustTrigger) {
                game_inst.bot1_script_part2_done = true;

                var wantSummon = (lpv <= 40);
                var canSummon = (getLeftmostFreeMonsterSlot(false) != noone);
                
                if (wantSummon && canSummon) {
                    game_inst.story_pending_summon_asset = "oLoupGuerreGueuleRoche";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oLoupGuerreGueuleRoche";
                }

                if (instance_exists(oStoryToast)) return true;
                var toast2 = instance_create_layer(0, 0, "UI", oStoryToast);
                toast2.setPortrait("sPortraitOrcGueuleRoche", 96);
                toast2.setText("Envoyez les loups, ils ont faim!");
                return true;
            }
        }
    }

    if (game_inst.nbTurn >= 12) {
        if (!variable_instance_exists(game_inst, "bot1_script_part3_done")) game_inst.bot1_script_part3_done = false;
        if (!game_inst.bot1_script_part3_done) {
            var lp3 = instance_find(oLP_Enemy, 0);
            var lpv3 = (lp3 != noone && variable_instance_exists(lp3, "nbLP")) ? lp3.nbLP : 999999;

            var mustTrigger3 = (lpv3 <= 30) || (game_inst.nbTurn == 12);
            if (mustTrigger3) {
                game_inst.bot1_script_part3_done = true;

                var wantSummon3 = (lpv3 <= 30);
                var canSummon3 = (getLeftmostFreeMonsterSlot(false) != noone);

                if (wantSummon3 && canSummon3) {  
                    game_inst.story_pending_summon_asset = "oEnvahisseurGueuleRoche";
                    game_inst.story_pending_summon_cost = 0;
                    game_inst.story_pending_summon_force_cost = true;
                    game_inst.story_pending_add_to_hand_asset = "oLoupGuerreGueuleRoche";
                } else {
                    game_inst.story_pending_add_to_hand_asset = "oEnvahisseurGueuleRoche";
                }

                if (instance_exists(oStoryToast)) return true;
                var toast3 = instance_create_layer(0, 0, "UI", oStoryToast);
                toast3.setPortrait("sPortraitOrcGueuleRoche", 96);
                toast3.setText("Geule roche, brisez moi leur défense ! J'arrive!");
                return true;
            }
        }
    }

    if (!variable_instance_exists(game_inst, "bot1_script_part4_done")) game_inst.bot1_script_part4_done = false;
    if (!game_inst.bot1_script_part4_done) {
        var lp4 = instance_find(oLP_Enemy, 0);
        var lpv4 = (lp4 != noone && variable_instance_exists(lp4, "nbLP")) ? lp4.nbLP : 999999;

        var mustTrigger4 = (lpv4 <= 15) || (game_inst.nbTurn == 16);
        if (mustTrigger4) {
            game_inst.bot1_script_part4_done = true;

            game_inst.story_pending_add_to_hand_asset = "oMassacreurGueuleRoche";
            game_inst.story_pending_summon_asset = "oLoupGuerreGueuleRoche";
            game_inst.story_pending_summon_cost = 0;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;

            if (instance_exists(oStoryToast)) return true;
            var toast4 = instance_create_layer(0, 0, "UI", oStoryToast);
            toast4.setPortrait("sPortraitOrcGueuleRoche", 96);
            toast4.setText("Assez ! C'est l'heure du bain de sang !");
            return true;
        }
    }
    
    return false;
}

function chap1_bot_events_on_enemy_draw(game_inst) {
    if (game_inst == noone || !instance_exists(game_inst)) return false;
    if (!variable_global_exists("selected_bot_deck_id")) return false;
    if (!variable_global_exists("previous_room_before_duel") || global.previous_room_before_duel != rScenario) return false;
    if (!variable_instance_exists(game_inst, "timerEnabledMulligan") || game_inst.timerEnabledMulligan) return false;
    if (!variable_instance_exists(game_inst, "player_current")) return false;
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;
    if (game_inst.player_current != 1) return false;
    var botID = global.selected_bot_deck_id;
    
    if (game_inst.nbTurn == 2) {
        if (botID == "Invasion_Gueule_Roche") {
            if (!variable_instance_exists(game_inst, "bot1_script_intro_done")) game_inst.bot1_script_intro_done = false;
            if (game_inst.bot1_script_intro_done) return false;
            game_inst.bot1_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toast = instance_create_layer(0, 0, "UI", oStoryToast);
            toast.setPortrait("sPortraitOrcGueuleRoche", 96);
            toast.setText("L'odeur du raison... Geule-Roche ! Brulez tout!");
            return true;
        }
        
        if (botID == "Bandit_Grand_Chemin") {
            if (!variable_instance_exists(game_inst, "bot3_script_intro_done")) game_inst.bot3_script_intro_done = false;
            if (game_inst.bot3_script_intro_done) return false;
            game_inst.bot3_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB3 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB3.setPortrait("sPortraitJameCalamite", 96);
            toastB3.setText("Vous êtes tombés dans le piège du grand James la Calamité");
            return true;
        }
        
        if (botID == "Essaim_Abyssien") {
            if (!variable_instance_exists(game_inst, "bot2_script_intro_done")) game_inst.bot2_script_intro_done = false;
            if (game_inst.bot2_script_intro_done) return false;
            game_inst.bot2_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB2 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB2.setPortrait("sPortraitAbyssien", 96);
            toastB2.setText("BLOP-GURGL-AARGH !");
            return true;
        }
        
        if (botID == "Matriarche_Peau_Roc") {
            if (!variable_instance_exists(game_inst, "bot4_script_intro_done")) game_inst.bot4_script_intro_done = false;
            if (game_inst.bot4_script_intro_done) return false;
            game_inst.bot4_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB4 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB4.setPortrait("sPortraitMatriarchePeauRoc", 96);
            toastB4.setText("GRRR… *souffle lourd*… HNNFF !");
            return true;
        }
        
        if (botID == "Recolteur_Recolte_Sournoise") {
            if (!variable_instance_exists(game_inst, "bot5_script_intro_done")) game_inst.bot5_script_intro_done = false;
            if (game_inst.bot5_script_intro_done) return false;
            game_inst.bot5_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB5 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB5.setPortrait("sPortraitRecolteur", 96);
            toastB5.setText("Il est l'heure de passer à la caisse !");
            return true;
        }

        if (botID == "Armee_des_Skarls") {
            if (!variable_instance_exists(game_inst, "bot6_script_intro_done")) game_inst.bot6_script_intro_done = false;
            if (game_inst.bot6_script_intro_done) return false;
            game_inst.bot6_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6.setPortrait("sPortraitSkarl", 96);
            toastB6.setText("Les humains nous attaquent, abattez les !");
            return true;
        }
        
        if (botID == "Terreur_de_la_foret") {
            if (!variable_instance_exists(game_inst, "bot7_script_intro_done")) game_inst.bot7_script_intro_done = false;
            if (game_inst.bot7_script_intro_done) return false;
            game_inst.bot7_script_intro_done = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB7 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB7.setPortrait("sPortraitGorrak", 96);
            toastB7.setText("De la viande fraîche !");
            return true;
        }
    }
    
    if (botID == "Armee_des_Skarls") {
        if (game_inst.nbTurn == 4) {
            if (!variable_instance_exists(game_inst, "bot6_script_phase2_done")) game_inst.bot6_script_phase2_done = false;
            if (game_inst.bot6_script_phase2_done) return false;
            game_inst.bot6_script_phase2_done = true;
            
            game_inst.story_pending_summon_asset = "oJeuneLoup";
            game_inst.story_pending_summon_cost = 1;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6P2 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6P2.setPortrait("sPortraitSkarl", 96);
            toastB6P2.setText("Lâchez les bêtes !");
            return true;
        }
        
        if (game_inst.nbTurn == 6) {
            if (!variable_instance_exists(game_inst, "bot6_script_phase3_done")) game_inst.bot6_script_phase3_done = false;
            if (game_inst.bot6_script_phase3_done) return false;
            game_inst.bot6_script_phase3_done = true;
            
            game_inst.story_pending_summon_asset = "oFourrageurAbyssien";
            game_inst.story_pending_summon_cost = 2;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;

            game_inst.story_pending_summon_asset2 = "oCoureurAbyssien";
            game_inst.story_pending_summon_cost2 = 0;
            game_inst.story_pending_summon_force_cost2 = true;
            game_inst.story_pending_summon_count2 = 1;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6P3 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6P3.setPortrait("sPortraitSkarl", 96);
            toastB6P3.setText("Envoyez les Abyssiens !");
            return true;
        }
        
        if (game_inst.nbTurn == 8) {
            if (!variable_instance_exists(game_inst, "bot6_script_phase4_done")) game_inst.bot6_script_phase4_done = false;
            if (game_inst.bot6_script_phase4_done) return false;
            game_inst.bot6_script_phase4_done = true;
            
            game_inst.story_pending_summon_asset = "oBandit";
            game_inst.story_pending_summon_cost = 4;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6P4 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6P4.setPortrait("sPortraitSkarl", 96);
            toastB6P4.setText("Humains, à votre tour, servez le maître !");
            return true;
        }
        
        if (game_inst.nbTurn == 12) {
            if (!variable_instance_exists(game_inst, "bot6_script_phase5_done")) game_inst.bot6_script_phase5_done = false;
            if (game_inst.bot6_script_phase5_done) return false;
            game_inst.bot6_script_phase5_done = true;
            
            game_inst.story_pending_summon_asset = "oEstafetteSkarl";
            game_inst.story_pending_summon_cost = 3;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 2;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6P5 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6P5.setPortrait("sPortraitSkarl", 96);
            toastB6P5.setText("Skarls ! Protégez le patron !");
            return true;
        }
        
        if (game_inst.nbTurn == 14) {
            if (!variable_instance_exists(game_inst, "bot6_script_phase6_done")) game_inst.bot6_script_phase6_done = false;
            if (game_inst.bot6_script_phase6_done) return false;
            game_inst.bot6_script_phase6_done = true;
            
            game_inst.story_pending_summon_asset = "oFrereGorrak";
            game_inst.story_pending_summon_cost = 7;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;
            game_inst.story_pending_summon_trigger_as_summon = true;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB6P6 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB6P6.setPortrait("sPortraitSkarl", 96);
            toastB6P6.setText("Attention, le frère du patron entre en scène !");
            return true;
        }
    }
    
    if (botID == "Essaim_Abyssien") {
        if (game_inst.nbTurn == 4) {
            if (!variable_instance_exists(game_inst, "bot2_script_wave1_done")) game_inst.bot2_script_wave1_done = false;
            if (game_inst.bot2_script_wave1_done) return false;
            game_inst.bot2_script_wave1_done = true;
            
            game_inst.story_pending_summon_asset = "oCoureurAbyssien";
            game_inst.story_pending_summon_cost = 0;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 1;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB2W1 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB2W1.setPortrait("sPortraitAbyssien", 96);
            toastB2W1.setText("BLOP-GURGL-AARGH !");
            return true;
        }
        
        if (game_inst.nbTurn == 8) {
            if (!variable_instance_exists(game_inst, "bot2_script_wave2_done")) game_inst.bot2_script_wave2_done = false;
            if (game_inst.bot2_script_wave2_done) return false;
            game_inst.bot2_script_wave2_done = true;
            
            game_inst.story_pending_summon_asset = "oCoureurAbyssien";
            game_inst.story_pending_summon_cost = 0;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 2;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB2W2 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB2W2.setPortrait("sPortraitAbyssien", 96);
            toastB2W2.setText("GURGL-BLOP-BLOP-AARGH !");
            return true;
        }
        
        if (game_inst.nbTurn == 12) {
            if (!variable_instance_exists(game_inst, "bot2_script_wave3_done")) game_inst.bot2_script_wave3_done = false;
            if (game_inst.bot2_script_wave3_done) return false;
            game_inst.bot2_script_wave3_done = true;
            
            game_inst.story_pending_summon_asset = "oCoureurAbyssien";
            game_inst.story_pending_summon_cost = 0;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 3;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB2W3 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB2W3.setPortrait("sPortraitAbyssien", 96);
            toastB2W3.setText("BLOP-BLOP-GURGL-GURGL-AARGH !");
            return true;
        }
        
        if (game_inst.nbTurn == 16) {
            if (!variable_instance_exists(game_inst, "bot2_script_wave4_done")) game_inst.bot2_script_wave4_done = false;
            if (game_inst.bot2_script_wave4_done) return false;
            game_inst.bot2_script_wave4_done = true;
            
            game_inst.story_pending_summon_asset = "oCoureurAbyssien";
            game_inst.story_pending_summon_cost = 0;
            game_inst.story_pending_summon_force_cost = true;
            game_inst.story_pending_summon_count = 4;
            
            if (instance_exists(oStoryToast)) return true;
            var toastB2W4 = instance_create_layer(0, 0, "UI", oStoryToast);
            toastB2W4.setPortrait("sPortraitAbyssien", 96);
            toastB2W4.setText("BLOP-GURGL-AARGH !!!");
            return true;
        }
    }
    
    if (botID == "Invasion_Gueule_Roche") {
        return chap1_bot_events_on_progress(game_inst);
    }
    return false;
}
