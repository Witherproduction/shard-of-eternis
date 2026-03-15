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
                "oMorganeVenimeuse", "oMorganeVenimeuse", "oMorganeVenimeuse",
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
                "oSournoiserie",
                "oBrumeTrompeuse",
                "oBrumeForet",
                "oFiletOmbre",
                "oFeuillageProtecteur",
                "oDagueFilou",
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
            portrait: "sMatriarchePeauRoc", 
            description: "La Matriarche veille sur sa harde. Elle temporise le début de partie pour écraser ses ennemis sous le poids de ses bêtes géantes.",
            cards: [
                // --- Finisseurs (Late Game T6+) --- (4 cartes)
                "oMatriarchePeauRoc", // T7 Légendaire
                "oTarrinox", // T8 Épique (Grosse menace Araignée)
                "oPeauRocRobuste", "oPeauRocRobuste", "oPeauRocRobuste", // T6 Charge

                // --- Coeur de Deck (Mid Game T4-T5) --- (12 cartes)
                "oTortueVagabonde", "oTortueVagabonde", "oTortueVagabonde", // T4 Tank
                "oJeuneOursForet", "oJeuneOursForet", "oJeuneOursForet", // T5 Solide
                "oLoupGaleux", "oLoupGaleux", // T5 Gros stats si seul
                "oLoupGrisForet", "oLoupGrisForet", // T4 Meute
                "oTarentuleForet", "oTarentuleForet", // T6 Pop

                // --- Early Game (T1-T3) --- (14 cartes)
                "oSanglierPeauRoc", "oSanglierPeauRoc", "oSanglierPeauRoc", // T4 -> T2/3 en valeur réelle
                "oRenardMystique", "oRenardMystique", // T1 Illusion (Remplace Loup Gueule-Roche)
                "oVieilOurs", "oVieilOurs", // T4 -> T3 Solide
                "oAraigneeForestiere", "oAraigneeForestiere", "oAraigneeForestiere", // T1 Gestion
                "oJeuneLoup", "oJeuneLoup", "oJeuneLoup", // T1 Early présence
                // --- Sorts de Contrôle/Soutien --- (10 cartes)
                "oFrenesieSauvage", "oFrenesieSauvage", // T2 Buff
                "oRugissementForet", "oRugissementForet", // T2 Buff PV (Survie)
                "oCriMeute", "oCriMeute", // T5 Buff Late
                "oFeuillageProtecteur", "oFeuillageProtecteur", // T2 Protection
                "oRacineEnvahissante", "oRacineEnvahissante" // T3 Contrôle (Gèle/Entrave) pour temporiser
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
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;
    if (global.selected_bot_deck_id != "Invasion_Gueule_Roche") return false;
    
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
            game_inst.story_pending_summon_count = 2;

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
    if (global.selected_bot_deck_id != "Invasion_Gueule_Roche") return false;
    if (game_inst.player_current != 1) return false;
    
    if (game_inst.nbTurn == 2) {
        if (!variable_instance_exists(game_inst, "bot1_script_intro_done")) game_inst.bot1_script_intro_done = false;
        if (game_inst.bot1_script_intro_done) return false;
        game_inst.bot1_script_intro_done = true;
        
        if (instance_exists(oStoryToast)) return true;
        var toast = instance_create_layer(0, 0, "UI", oStoryToast);
        toast.setPortrait("sPortraitOrcGueuleRoche", 96);
        toast.setText("L'odeur du raison... Geule-Roche ! Brulez tout!");
        return true;
    }
    return chap1_bot_events_on_progress(game_inst);
}
