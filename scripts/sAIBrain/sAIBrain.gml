/// sAIBrain.gml
/// Cerveau de l'IA : Prise de décision et Exécution

/// @function AI_SelectBestMove(moves)
/// @description Choisit le meilleur coup parmi une liste de coups légaux.
/// @param {Array} moves Liste de coups générée par AI_GetLegalMoves_*
/// @return {Struct|noone} Le meilleur coup ou noone
function AI_SelectBestMove(moves) {
    var bestMove = noone;
    var bestScore = -999999;
    
    // Récupération du profil IA
    var botID = (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) ? global.selected_bot_deck_id : "Invasion_Gueule_Roche";
    var profile = AI_Config_GetBotProfile(botID);
    
    var p_summon = (profile != undefined && variable_struct_exists(profile, "summon_weight")) ? (profile.summon_weight / 50.0) : 1.0;
    var p_direct = (profile != undefined && variable_struct_exists(profile, "direct_damage_bias")) ? (profile.direct_damage_bias / 50.0) : 1.0;
    var p_removal = (profile != undefined && variable_struct_exists(profile, "removal_weight")) ? (profile.removal_weight / 50.0) : 1.0;
    var p_sac = (profile != undefined && variable_struct_exists(profile, "sacrifice_tolerance")) ? (profile.sacrifice_tolerance / 50.0) : 1.0;
    var p_manual = (profile != undefined && variable_struct_exists(profile, "manual_effect_weight")) ? (profile.manual_effect_weight / 50.0) : 1.0;
    var p_continuous = (profile != undefined && variable_struct_exists(profile, "continuous_weight")) ? (profile.continuous_weight / 50.0) : 1.0;
    var p_draw = (profile != undefined && variable_struct_exists(profile, "draw_weight")) ? (profile.draw_weight / 50.0) : 1.0;
    var p_tutor = (profile != undefined && variable_struct_exists(profile, "tutor_weight")) ? (profile.tutor_weight / 50.0) : 1.0;
    var p_risk = (profile != undefined && variable_struct_exists(profile, "risk_tolerance")) ? (profile.risk_tolerance / 50.0) : 1.0;

    for (var i = 0; i < array_length(moves); i++) {
        var move = moves[i];
        var moveScoreVal = -999999;

        // --- HEURISTIQUES DE SCORING ---
        
        if (move.type == "summon") {
            // Score = Valeur de la carte invoquée
            var cardVal = AI_GetCardScore_Predicted(move.card);
            
            moveScoreVal = cardVal;
            
            // --- MANA CURVE OPTIMIZATION (Hearthstone Style) ---
            var cost = variable_instance_exists(move.card, "mana_cost") ? move.card.mana_cost : 0;
            var currentMana = (variable_global_exists("mana_enemy") ? global.mana_enemy : 0);
            
            // Bonus pour utilisation efficace du mana (Curving out)
            if (currentMana > 0) {
                if (cost == currentMana) {
                    moveScoreVal += 500; // Perfect Mana usage
                } else if (cost >= currentMana - 1) {
                    moveScoreVal += 250; // Good usage
                }
                
                // Penalize playing very low cost cards when high mana is available (unless they are combo pieces)
                if (currentMana >= 5 && cost <= 2) {
                    moveScoreVal -= 100; 
                }
            }
            
            // --- CHECK PRIORITY MONSTERS (From Profile Custom Rules) ---
            var customRules = variable_struct_exists(profile, "custom_rules") ? profile.custom_rules : undefined;
            if (customRules != undefined) {
                // 0. Conditional Play Rule (e.g. Massacreur only if Loup present)
                if (variable_struct_exists(customRules, "conditional_play")) {
                    var cName = variable_instance_exists(move.card, "name") ? move.card.name : "";
                    // Check Object Name as fallback
                    var cObjName = object_get_name(move.card.object_index);
                    
                    var condRule = variable_struct_exists(customRules.conditional_play, cName) ? variable_struct_get(customRules.conditional_play, cName) : undefined;
                    if (condRule == undefined) {
                        condRule = variable_struct_exists(customRules.conditional_play, cObjName) ? variable_struct_get(customRules.conditional_play, cObjName) : undefined;
                    }

                    if (condRule != undefined) {
                        if (variable_struct_exists(condRule, "requires_on_board")) {
                            var reqCards = condRule.requires_on_board;
                            var conditionMet = false;
                            
                            if (instance_exists(oFieldManagerEnemy)) {
                                with (oCardParent) {
                                    var __onBoard = false;
                                    if (variable_instance_exists(id, "zone")) {
                                        __onBoard = (zone == "Field" || zone == "FieldSelected" || zone == "Board");
                                    } else if (variable_instance_exists(id, "location")) {
                                        __onBoard = (location == "Board" || location == "Field");
                                    }
                                    
                                    if (variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && __onBoard) {
                                        var myName = variable_instance_exists(id, "name") ? name : "";
                                        var myObjName = object_get_name(object_index);
                                        
                                        for (var r=0; r<array_length(reqCards); r++) {
                                            if (string_pos(reqCards[r], myName) > 0 || string_pos(reqCards[r], myObjName) > 0) {
                                                conditionMet = true;
                                                break;
                                            }
                                        }
                                        if (conditionMet) break;
                                    }
                                }
                            }
                            
                            if (!conditionMet) {
                                var strict = (variable_struct_exists(condRule, "forbid_if_missing") && condRule.forbid_if_missing);
                                if (strict) {
                                    moveScoreVal = -9999; // FORBIDDEN MOVE
                                } else {
                                    var penalty = variable_struct_exists(condRule, "missing_penalty") ? condRule.missing_penalty : 600;
                                    moveScoreVal -= penalty;
                                }
                            } else {
                                var bonus = variable_struct_exists(condRule, "met_bonus") ? condRule.met_bonus : 400;
                                moveScoreVal += bonus;
                            }
                        }
                    }
                }

                // 1. Prioritize specific card names (e.g. Ruisselier, James, Morgane)
                if (variable_struct_exists(customRules, "prioritize_card_name")) {
                    var pNames = customRules.prioritize_card_name;
                    var cName = variable_instance_exists(move.card, "name") ? move.card.name : "";
                    
                    if (is_array(pNames)) {
                        for (var k = 0; k < array_length(pNames); k++) {
                            if (string_pos(pNames[k], cName) > 0) {
                                moveScoreVal += 2000; // HUGE PRIORITY
                                break;
                            }
                        }
                    } else if (is_string(pNames)) {
                         if (string_pos(pNames, cName) > 0) {
                            moveScoreVal += 2000; // HUGE PRIORITY
                        }
                    }
                }
                
                // 2. Swarm Trigger Logic (If trigger card exists on field, boost all summons)
                if (variable_struct_exists(customRules, "swarm_trigger_card")) {
                    var tName = customRules.swarm_trigger_card;
                    var triggerExists = false;
                    
                    // Check if trigger card is on AI board
                    if (instance_exists(oFieldManagerEnemy)) {
                        with (oCardParent) {
                             if (variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && variable_instance_exists(id, "location") && location == "Board") {
                                 var myName = variable_instance_exists(id, "name") ? name : "";
                                 if (string_pos(tName, myName) > 0) {
                                     triggerExists = true;
                                     break;
                                 }
                             }
                        }
                    }
                    
                    // If trigger card is present, boost ALL summons to flood the board
                    if (triggerExists) {
                        moveScoreVal += 500;
                    }
                }
            }
            
            // --- BONUS EFFET A L'INVOCATION ---
            if (variable_struct_exists(move, "has_on_summon_effect") && move.has_on_summon_effect) {
                var eType = variable_struct_exists(move, "effect_type") ? move.effect_type : "";
                var target = variable_struct_exists(move, "effect_target") ? move.effect_target : noone;
                var effectScore = 0;
                
                switch (eType) {
                    case "draw_cards":
                        effectScore = 100 * p_draw;
                        break;
                        
                    case "destroy_target":
                    case "banish_target":
                    case "return_to_hand":
                    case "damage_target":
                    case "entrave":
                        if (target != noone) {
                            var targetVal = AI_GetCardScore(target);
                            var cOwner = (is_struct(move.card) && variable_struct_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : ((variable_instance_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : undefined);
                            var tOwner = (is_struct(target) && variable_struct_exists(target, "isHeroOwner")) ? target.isHeroOwner : ((variable_instance_exists(target, "isHeroOwner")) ? target.isHeroOwner : undefined);
                            var isAlly = (cOwner != undefined && tOwner != undefined && cOwner == tOwner);
                            if (isAlly) {
                                effectScore = -targetVal * 2; // Penalty for targeting ally with negative effect
                            } else {
                                effectScore = targetVal * p_removal;
                            }
                        }
                        break;
                        
                    case "buff":
                    case "set_attack":
                    case "equip_select_target":
                    case "heal_target":
                        if (target != noone) {
                            // Si cible = soi-même (card), on booste le score car c'est un "super monstre"
                            if (target == move.card) {
                                effectScore = 100 * p_direct;
                            } else {
                                var targetAtk = variable_instance_exists(target, "attack") ? target.attack : 0;
                                effectScore = 50 + (targetAtk * 0.5);
                            }
                        }
                        break;
                        
                    case "destroy_all":
                         var valEnemies = 0; var valAllies = 0;
                         if (instance_exists(oFieldMonsterHero)) {
                            var enemies = oFieldMonsterHero.cards;
                            for (var e = 0; e < array_length(enemies); e++) {
                                if (enemies[e] != 0 && instance_exists(enemies[e])) valEnemies += AI_GetCardScore(enemies[e]);
                            }
                         }
                         if (instance_exists(oFieldMonsterEnemy)) {
                             var allies = oFieldMonsterEnemy.cards;
                             for (var a = 0; a < array_length(allies); a++) {
                                 if (allies[a] != 0 && instance_exists(allies[a])) valAllies += AI_GetCardScore(allies[a]);
                             }
                         }
                         effectScore = (valEnemies - valAllies) * p_removal;
                         break;
                }
                moveScoreVal += effectScore;
            }
            
            // Petit bonus pour inciter à jouer si c'est positif, pondéré par summon_weight
            if (moveScoreVal > 0) moveScoreVal += 10 * p_summon; 
            
        } else if (move.type == "set_card") {
            // Poser une carte (Secret/Piege)
            // C'est généralement une bonne idée si on a de la place
            // Score modéré pour ne pas bloquer les invocations importantes, mais prioritaire sur rien faire
            moveScoreVal = 30; 
            
            // Si on est un bot "Control", on aime les pièges
            if (p_removal > 1.2) moveScoreVal += 20;
            
        } else if (move.type == "activate" || move.type == "activate_effect") {
            // Magie - Scoring contextuel avancé
            var effectType = variable_struct_exists(move, "effect_type") ? move.effect_type : "unknown";
            var target = move.target;
            
            moveScoreVal = 0;
            
            // --- CUSTOM SPELL RULES (Added for Bot 2) ---
            var spellRules = (profile != undefined && variable_struct_exists(profile, "custom_rules") && variable_struct_exists(profile.custom_rules, "spell_rules")) ? profile.custom_rules.spell_rules : undefined;
            var rule = undefined;
            
            if (spellRules != undefined) {
                 var cName = variable_instance_exists(move.card, "name") ? move.card.name : "";
                 var cObj = object_get_name(move.card.object_index);
                 
                 if (variable_struct_exists(spellRules, cName)) rule = variable_struct_get(spellRules, cName);
                 else if (variable_struct_exists(spellRules, cObj)) rule = variable_struct_get(spellRules, cObj);

                 if (rule != undefined) {
                     // 1. Marée Déferlante: Bounce Dangerous Threat
                    if (rule == "bounce_big_threat" && target != noone) {
                        var tAtk = variable_instance_exists(target, "attack") ? target.attack : 0;
                        var tPV = variable_instance_exists(target, "PV") ? target.PV : 0;
                        var hasTaunt = (variable_instance_exists(target, "has_taunt") && target.has_taunt);
                        
                        // Définition de "Dangereux"
                        var isLethalThreat = (tAtk >= 4 || hasTaunt); // Menace majeure
                        var isMinorThreat = (tAtk >= 2);              // Menace mineure
                        
                        if (isLethalThreat) {
                            moveScoreVal += 1500; // Priorité élevée mais permet de jouer un gros monstre si mieux
                        } else if (isMinorThreat) {
                            moveScoreVal += 600;  // Bon coup, mais moins prioritaire qu'un monstre (Score ~1000)
                        } else {
                            moveScoreVal -= 200;  // Inutile sur cible inoffensive
                        }
                    }
                    
                    // 2. Protection Marée: Buff if 2+ Abyssien
                    else if (rule == "buff_if_3_abyssien") {
                        var count = 0;
                        if (instance_exists(oFieldMonsterEnemy)) {
                            with(oCardParent) {
                                if (variable_instance_exists(id, "location") && location == "Board" && 
                                    variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && 
                                    variable_instance_exists(id, "name") && string_pos("Abyssien", name) > 0) {
                                    count++;
                                }
                            }
                        }
                        
                        // Scaling dynamique : Plus on touche de cibles, plus c'est fort
                        if (count >= 2) {
                             moveScoreVal += 400 * count; // 2 cibles = 800, 3 cibles = 1200
                        } else {
                             moveScoreVal -= 500;
                        }
                    }
                    
                    // 3. Hurlement Tribu: Sacrifier faible/Abyssien pour booster
                    else if (rule == "sac_coureur_buff_2" && target != noone) {
                        var tName = variable_instance_exists(target, "name") ? target.name : "";
                        var tAtk = variable_instance_exists(target, "attack") ? target.attack : 0;
                        var tHP = variable_instance_exists(target, "current_hp") ? target.current_hp : (variable_instance_exists(target, "PV") ? target.PV : 0);
                        
                        var isWeak = (tAtk <= 2 || tHP <= 2);
                        var isAbyssien = (string_pos("Abyssien", tName) > 0 || string_pos("Coureur", tName) > 0);
                        
                        if (isWeak || isAbyssien) {
                             var otherAllies = 0;
                             if (instance_exists(oFieldMonsterEnemy)) {
                                var cards = oFieldMonsterEnemy.cards;
                                for(var k=0; k<array_length(cards); k++) {
                                    if (cards[k] != 0 && instance_exists(cards[k]) && cards[k] != target) otherAllies++;
                                }
                             }
                             
                             if (otherAllies >= 1) moveScoreVal += 800; // Bon coup tactique
                             else moveScoreVal -= 200;
                        } else {
                            moveScoreVal -= 500;
                        }
                    }
                    
                    // 4. Ferveur Marais: Summon if 2 slots
                    else if (rule == "summon_if_3_slots") {
                        var freeSlots = 0;
                        if (instance_exists(oFieldMonsterEnemy)) {
                             var cards = oFieldMonsterEnemy.cards;
                             for(var k=0; k<array_length(cards); k++) {
                                 if (cards[k] == 0) freeSlots++;
                             }
                        }
                        
                        if (freeSlots >= 2) moveScoreVal += 900; // Comparable à une invocation de monstre
                        else moveScoreVal -= 500; 
                    }

                    // --- BOT 3 RULES (Bandit) ---

                    // 5. Brume de la Foret: Buff non-camo, bonus if other camo exists
                    else if (rule == "buff_if_no_camo_bonus_combo" && target != noone) {
                        var tIsCamo = (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) || (variable_instance_exists(target, "effects_text") && string_pos("Camouflage", target.effects_text) > 0);
                        
                        if (!tIsCamo) {
                            moveScoreVal += 300; // Base score for buffing non-camo (gives camo)
                            
                            // Check for Combo (another camo unit on board)
                            var hasOtherCamo = false;
                            if (instance_exists(oFieldMonsterEnemy)) {
                                with(oCardParent) {
                                    if (variable_instance_exists(id, "location") && location == "Board" && 
                                        variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && 
                                        id != target) {
                                        
                                        var myCamo = (variable_instance_exists(id, "isCamouflage") && id.isCamouflage) || (variable_instance_exists(id, "effects_text") && string_pos("Camouflage", id.effects_text) > 0);
                                        if (myCamo) {
                                            hasOtherCamo = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            if (hasOtherCamo) {
                                moveScoreVal += 500; // Combo activated! Destroy random enemy is huge.
                            }
                        } else {
                            moveScoreVal -= 200; // Do not use on already camouflaged unit (waste of effect)
                        }
                    }

                    // 6. Cape d'ombre: Buff non-camo
                    else if (rule == "buff_if_no_camo" && target != noone) {
                        var tIsCamo = (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) || (variable_instance_exists(target, "effects_text") && string_pos("Camouflage", target.effects_text) > 0);
                        
                        if (!tIsCamo) {
                            moveScoreVal += 400; // Good buff (+4/+4 + Camo)
                        } else {
                            moveScoreVal -= 100; // Less value if already camo, but stats are still good so not huge penalty
                        }
                    }

                    // 7. Camouflage Strategique: Must target camo
                    else if (rule == "buff_if_camo" && target != noone) {
                        var tIsCamo = (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) || (variable_instance_exists(target, "effects_text") && string_pos("Camouflage", target.effects_text) > 0);
                        
                        if (tIsCamo) {
                            moveScoreVal += 400; // Keeps camo + stats -> Good
                        } else {
                            moveScoreVal -= 500; // Rules say MUST target camo
                        }
                    }

                    // 8. Attaque Furtive: Bonus damage if camo exists
                    else if (rule == "damage_bonus_if_camo") {
                         var hasCamo = false;
                         if (instance_exists(oFieldMonsterEnemy)) {
                            with(oCardParent) {
                                if (variable_instance_exists(id, "location") && location == "Board" && 
                                    variable_instance_exists(id, "isHeroOwner") && !isHeroOwner) {
                                    
                                    var myCamo = (variable_instance_exists(id, "isCamouflage") && id.isCamouflage) || (variable_instance_exists(id, "effects_text") && string_pos("Camouflage", id.effects_text) > 0);
                                    if (myCamo) {
                                        hasCamo = true;
                                        break;
                                    }
                                }
                            }
                        }
                        
                        if (hasCamo) {
                            moveScoreVal += 400; // 4 damage for 1 mana is huge value
                        } else {
                            moveScoreVal += 100; // 2 damage is okay but less priority
                        }
                    }
                    
                    else if (rule == "buff_beast_bonus_wolf") {
                        var beastCount = 0;
                        var hasWarWolf = false;
                        if (instance_exists(oFieldMonsterEnemy)) {
                            var cards = oFieldMonsterEnemy.cards;
                            for (var kk = 0; kk < array_length(cards); kk++) {
                                var c = cards[kk];
                                if (c == 0 || !instance_exists(c)) continue;
                                var g = variable_instance_exists(c, "genre") ? string_lower(string(c.genre)) : "";
                                g = string_replace_all(g, "ê", "e");
                                if (g == "bete") beastCount++;
                                if (c.object_index == oLoupGuerreGueuleRoche) hasWarWolf = true;
                            }
                        }
                        
                        if (beastCount <= 0 || target == noone || !instance_exists(target)) {
                            moveScoreVal = -9999;
                        } else {
                            var tg = variable_instance_exists(target, "genre") ? string_lower(string(target.genre)) : "";
                            tg = string_replace_all(tg, "ê", "e");
                            if (tg != "bete") {
                                moveScoreVal = -9999;
                            } else {
                                var base = 250;
                                if (hasWarWolf) base += 300;
                                if (target.object_index == oLoupGuerreGueuleRoche) base += 700;
                                moveScoreVal += base;
                            }
                        }
                    }
                 }
            }
            // Si une règle personnalisée existe, on l'utilise et on ignore la logique standard
            // Sinon, la logique standard écraserait le score personnalisé
            if (rule == undefined) {
                switch (effectType) {
                    case "search_deck":
                        moveScoreVal = 100 * p_tutor;
                        break;

                    case "pillage":
                        // Voler des cartes (Hand ou Deck)
                        // "Voler un maximum de carte a l'adversaire"
                        moveScoreVal = 300 * p_manual; // Score de base très élevé
                        
                        // Si on peut voler, on le fait !
                        // On pourrait vérifier s'il reste des cartes dans le deck/main adverse,
                        // mais pour l'instant on suppose que c'est toujours bon sauf fin de partie.
                        break;

                    case "draw_cards":
                        // Piocher est toujours bon, surtout si main vide
                        moveScoreVal = 100 * p_draw; 
                        break;
                    
                    case "destroy_target":
                    case "banish_target":
                    case "return_to_hand":
                    case "entrave":
                    case "damage_target":
                        if (target != noone) {
                            var targetVal = AI_GetCardScore(target);
                            var cOwner = (is_struct(move.card) && variable_struct_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : ((variable_instance_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : undefined);
                            var tOwner = (is_struct(target) && variable_struct_exists(target, "isHeroOwner")) ? target.isHeroOwner : ((variable_instance_exists(target, "isHeroOwner")) ? target.isHeroOwner : undefined);
                            var isAlly = (cOwner != undefined && tOwner != undefined && cOwner == tOwner);
                            
                            if (isAlly) {
                                moveScoreVal = -targetVal * 2; // Penalize targeting ally
                            } else {
                                // On veut détruire les grosses menaces adverses
                                moveScoreVal = targetVal * p_removal;
                            }
                        }
                        break;
                        
                    case "buff":
                    case "set_attack":
                    case "equip_select_target":
                        if (target != noone) {
                            var cOwner = (is_struct(move.card) && variable_struct_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : ((variable_instance_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : undefined);
                            var tOwner = (is_struct(target) && variable_struct_exists(target, "isHeroOwner")) ? target.isHeroOwner : ((variable_instance_exists(target, "isHeroOwner")) ? target.isHeroOwner : undefined);
                            var isAlly = (cOwner != undefined && tOwner != undefined && cOwner == tOwner);
                            
                            if (isAlly) {
                                // On veut buffer nos propres monstres forts ou ceux qui vont attaquer
                                var targetAtk = variable_instance_exists(target, "attack") ? target.attack : 0;
                                var canAttack = (variable_instance_exists(target, "orientation") && target.orientation == "Attack");
                                
                                moveScoreVal = 50 + (targetAtk * 0.5);
                                if (canAttack) moveScoreVal += 200 * p_direct; // Bonus si agressif
                            } else {
                                // Ne pas buffer l'ennemi
                                moveScoreVal = -100;
                            }
                        }
                        break;
                        
                    case "heal_target":
                        if (target != noone) {
                            var cOwner = (is_struct(move.card) && variable_struct_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : ((variable_instance_exists(move.card, "isHeroOwner")) ? move.card.isHeroOwner : undefined);
                            var tOwner = (is_struct(target) && variable_struct_exists(target, "isHeroOwner")) ? target.isHeroOwner : ((variable_instance_exists(target, "isHeroOwner")) ? target.isHeroOwner : undefined);
                            var isAlly = (cOwner != undefined && tOwner != undefined && cOwner == tOwner);
                            
                            if (isAlly) {
                                var maxHP = variable_instance_exists(target, "max_hp") ? target.max_hp : 0;
                                var curHP = variable_instance_exists(target, "current_hp") ? target.current_hp : 0;
                                var damageTaken = maxHP - curHP;
                                
                                if (damageTaken > 0) {
                                    moveScoreVal = damageTaken * 2; // 1 PV soigné = 2 points
                                } else {
                                    moveScoreVal = -100; // Inutile de soigner si full vie
                                }
                            } else {
                                moveScoreVal = -200; // Ne pas soigner l'ennemi
                            }
                        }
                        break;
                        
                    case "destroy_all":
                        // Destruction de masse (Dark Hole)
                        // Score = (Valeur Totale Ennemis) - (Valeur Totale Alliés)
                        var valEnemies = 0;
                        var valAllies = 0;
                        
                        if (instance_exists(oFieldMonsterHero)) {
                            var enemies = oFieldMonsterHero.cards;
                            for (var e = 0; e < array_length(enemies); e++) valEnemies += AI_GetCardScore(enemies[e]);
                        }
                        if (instance_exists(oFieldMonsterEnemy)) {
                            var allies = oFieldMonsterEnemy.cards;
                            for (var a = 0; a < array_length(allies); a++) valAllies += AI_GetCardScore(allies[a]);
                        }
                        
                        moveScoreVal = (valEnemies - valAllies) * p_removal;
                        break;
                        
                    default:
                        moveScoreVal = 20; // Valeur par défaut faible pour tester
                }
            }
            
            // --- BONUS MANUAL EFFECT ---
            // Si c'est un effet activé manuellement, on applique le bonus manual_effect_weight
            // Cela permet aux bots comme James (Pillage) de prioriser ces actions
            moveScoreVal = moveScoreVal * p_manual;
            
            // 2. Coût d'opportunité (Optionnel : vérifier Mana si système de mana existe)
            
        } else if (move.type == "attack") {
            var attacker = move.attacker;
            var target = move.target;
            var isDirect = move.isDirect;
            
            var attackerVal = AI_GetCardScore(attacker);
            
            // --- CUSTOM RULES FOR ATTACK ---
            var customRules = variable_struct_exists(profile, "custom_rules") ? profile.custom_rules : undefined;
            if (customRules != undefined) {
                var aName = variable_instance_exists(attacker, "name") ? attacker.name : "";
                
                // 1. Protected Card (Never Attack)
                if (variable_struct_exists(customRules, "protect_card")) {
                    var protName = customRules.protect_card;
                    if (string_pos(protName, aName) > 0) {
                        moveScoreVal = -999999; // Forbidden
                        continue; // Skip logic
                    }
                }
                
                // 2. Stealth Lethal Only (OTK Style)
                if (variable_struct_exists(customRules, "stealth_lethal_only") && customRules.stealth_lethal_only) {
                    var isStealth = (variable_instance_exists(attacker, "isCamouflage") && attacker.isCamouflage) || (variable_instance_exists(attacker, "effects_text") && string_pos("Camouflage", attacker.effects_text) > 0);
                    
                    if (isStealth) {
                        var isLethal = false;
                        var isFreeKill = false;
                        var dmg = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                        
                        if (isDirect) {
                            var enemyLP = 0;
                            var lpInst = instance_find(oLP_Hero, 0);
                            if (lpInst != noone) enemyLP = lpInst.nbLP;
                            if (dmg >= enemyLP) isLethal = true;
                        } else {
                            var enemyAtk = variable_instance_exists(target, "effective_attack") ? target.effective_attack : target.attack;
                            var enemyHP = variable_instance_exists(target, "current_hp") ? target.current_hp : (variable_instance_exists(target, "PV") ? target.PV : 0);
                            var myHP = variable_instance_exists(attacker, "current_hp") ? attacker.current_hp : (variable_instance_exists(attacker, "PV") ? attacker.PV : 0);
                            
                            var myKill = (dmg >= enemyHP);
                            var iDie = (enemyAtk >= myHP);
                            if (myKill && !iDie) isFreeKill = true;
                        }
                        
                        if (!isLethal && !isFreeKill && !isDirect) {
                            moveScoreVal = -500; 
                            continue;
                        } else {
                            moveScoreVal += 500; 
                        }
                    }
                }
            }
            
            if (isDirect) {
                // FORCE RECOMPUTE
                if (script_exists(asset_get_index("buffRecompute"))) {
                    buffRecompute(attacker);
                }
                
                var dmg = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                moveScoreVal = dmg * 2 * p_direct; 
                
                // --- AGGRO / LETHAL LOGIC ---
                var enemyLP = 0;
                var lpInst = instance_find(oLP_Hero, 0);
                if (lpInst != noone) enemyLP = lpInst.nbLP;
                
                // 1. LETHAL CHECK (Absolute Priority)
                if (dmg >= enemyLP) {
                    moveScoreVal += 1000000; // MUST DO
                } else {
                    // 2. AGGRO PRESSURE (Low HP -> Push Face)
                    // If enemy has low HP (<15), increase face priority significantly
                    if (enemyLP < 15) {
                        moveScoreVal += (15 - enemyLP) * 50; 
                    }
                    
                    // 3. TWO-TURN LETHAL SETUP
                    // If enemy is within range of 2 attacks, push harder
                    if (enemyLP <= dmg * 2) {
                        moveScoreVal += 500;
                    }
                }
                
            } else {
                // Combat contre monstre
                moveScoreVal = 0;
                var targetVal = AI_GetCardScore(target);
                
                // FORCE RECOMPUTE
                if (script_exists(asset_get_index("buffRecompute"))) {
                    buffRecompute(attacker);
                    buffRecompute(target);
                }

                var myAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                var enemyAtk = variable_instance_exists(target, "effective_attack") ? target.effective_attack : target.attack;
                var enemyHP = variable_instance_exists(target, "current_hp") ? target.current_hp : (variable_instance_exists(target, "PV") ? target.PV : 0);
                var myHP = variable_instance_exists(attacker, "current_hp") ? attacker.current_hp : (variable_instance_exists(attacker, "PV") ? attacker.PV : 0);
                
                // SIMULATION COMBAT SIMULTANE
                var enemyDies = (myAtk >= enemyHP);
                var iDie = (enemyAtk >= myHP);
                
                // Poison Logic
                var myHasPoison = (variable_instance_exists(attacker, "effects_text") && string_pos("Poison", attacker.effects_text) > 0);
                var enemyHasPoison = (variable_instance_exists(target, "effects_text") && string_pos("Poison", target.effects_text) > 0);
                if (myHasPoison) enemyDies = true;
                if (enemyHasPoison) iDie = true;
                
                // --- CUSTOM: Poison Sacrifice Logic (Bot 3) ---
                if (customRules != undefined && variable_struct_exists(customRules, "poison_sacrifice_logic") && customRules.poison_sacrifice_logic) {
                    if (myHasPoison && enemyDies) {
                         var tAtk = variable_instance_exists(target, "attack") ? target.attack : 0;
                         var tHP = variable_instance_exists(target, "current_hp") ? target.current_hp : (variable_instance_exists(target, "PV") ? target.PV : 0);
                         
                         // Target is "Strong" (Worth sacrificing for)
                         // Example: 4+ ATK or 5+ HP
                         if (tAtk >= 4 || tHP >= 5) {
                             moveScoreVal += 1000; // HUGE BONUS to ensure trade
                         }
                    }
                }
                
                // --- SMART TRADE SCORING ---
                
                if (enemyDies) {
                    // Base Reward: We removed a threat
                    moveScoreVal += (targetVal + 100) * p_removal; 
                    
                    // VALUE TRADE: Did we trade up? (Low value unit kills High value unit)
                    if (iDie) {
                        var valueDiff = targetVal - attackerVal;
                        if (valueDiff > 0) {
                            moveScoreVal += valueDiff * 2; // Great trade!
                        } else {
                            moveScoreVal -= abs(valueDiff); // Bad trade (we lost more value)
                        }
                    } else {
                        // FREE KILL: We killed them and survived
                        moveScoreVal += 500 + (targetVal * 0.5); // Huge bonus
                        
                        // Check if we are left with very low HP (vulnerable to ping)
                        var remainingHP = myHP - enemyAtk;
                        if (remainingHP == 1) moveScoreVal -= 50; // Slight penalty if left at 1 HP
                    }
                } else {
                    // We didn't kill them.
                    
                    // --- ATTRITION LOGIC (FIX FOR TANK PASSIVITY) ---
                    // Is the target a blocker? (Taunt or Frontline 0-3)
                    var isBlocker = (variable_instance_exists(target, "has_taunt") && target.has_taunt) 
                                    || (variable_instance_exists(target, "fieldPosition") && target.fieldPosition <= 3);

                    if (isBlocker) {
                        // C'est un obstacle, il faut taper dedans !
                        // Bonus pour chaque point de dégât infligé (préparation du terrain pour les autres)
                        moveScoreVal += (myAtk * 20); 
                        
                        // Si l'IA ne prend presque pas de dégâts en retour (ex: Tortue a 1 ATQ), on encourage encore plus
                        if (enemyAtk <= 1) moveScoreVal += 50;
                    } else {
                        // Cible non prioritaire qu'on ne tue pas : on garde la pénalité
                        moveScoreVal -= 100; 
                    }
                    
                    // Penalty for damage taken
                    if (iDie) {
                        moveScoreVal -= attackerVal; // We threw away our unit
                    } else {
                        var dmgTaken = enemyAtk;
                        moveScoreVal -= (dmgTaken * 2);
                    }
                }
                
                // On évite les attaques suicides inutiles (sauf si Taunt nous oblige, mais le scoring filtrera)
                var iSurvive = !iDie;
                if (!iSurvive && !enemyDies) {
                    // Si on meurt sans tuer l'ennemi
                    
                    // Exception: Si c'est un Taunt/Bloqueur qu'on doit affaiblir
                     var isBlocker = (variable_instance_exists(target, "has_taunt") && target.has_taunt) 
                                    || (variable_instance_exists(target, "fieldPosition") && target.fieldPosition <= 3);
                                    
                    if (isBlocker) {
                         // On accepte le sacrifice SEULEMENT si on fait des dégâts significatifs ou si c'est nécessaire
                         if (myAtk >= 2) {
                             moveScoreVal = -50; // Pénalité légère au lieu de -999999
                         } else {
                             moveScoreVal = -200; // Inutile de se suicider pour 1 dégât
                         }
                    } else {
                        moveScoreVal = -999999;
                    }
                }
            }
        }

        if (moveScoreVal > bestScore) {
            bestScore = moveScoreVal;
            bestMove = move;
        }
    }

    // Seuil minimal pour agir (éviter les moves négatifs)
    if (bestScore < 0 && bestMove != noone) {
        // Parfois ne rien faire est mieux
        // Sauf si on veut être agressif.
        // Pour l'instant on filtre les très mauvais coups
        if (bestScore < -100) return noone;
    }

    return bestMove;
}

/// @function AI_ExecuteMove(move)
/// @description Exécute le coup choisi
function AI_ExecuteMove(move) {
    if (move == noone) {
        show_debug_message("### AI_ExecuteMove: No move provided");
        return false;
    }
    
    show_debug_message("### AI_ExecuteMove: Executing move type " + move.type);
    
    if (move.type == "summon") {
        var card = move.card;
        
        // Gérer les sacrifices
        if (variable_struct_exists(move, "sacrifices") && array_length(move.sacrifices) > 0) {
            // Utiliser la fonction globale de sacrifice
            performSacrifices(move.sacrifices, false); // false = Enemy (IA)
        }
        
        // Invocation
        var posInfo = -1;

        // [TUTORIAL PATCH] Support pour le placement forcé
        if (variable_struct_exists(move, "force_slot")) {
             var forcedSlot = move.force_slot;
             if (instance_exists(oFieldManagerEnemy)) {
                 var loc = oFieldManagerEnemy.getPosLocation(card.type, forcedSlot);
                 if (is_array(loc) && array_length(loc) >= 2) {
                     posInfo = [loc[0], loc[1], forcedSlot];
                 }
             }
        }

        if (posInfo == -1 && instance_exists(oFieldManagerEnemy)) {
             posInfo = oFieldManagerEnemy.getCardPositionAvailableIA(card);
        }
        
        if (is_array(posInfo)) {
            if (instance_exists(oHandEnemy)) {
                // HEARTHSTONE MODE: Toujours en attaque
                var payloadSummon = {
                    card: card,
                    xy: posInfo,
                    summon_mode: "Summon"
                };
                if (variable_instance_exists(card, "instance_uid")) {
                    payloadSummon.card_uid = card.instance_uid;
                }
                if (variable_struct_exists(move, "effect_target")) {
                    payloadSummon.target = move.effect_target;
                }
                
                // Utiliser RequestGameAction pour consommer le mana et appliquer le mal d'invocation
                if (instance_exists(card)) {
                    card.isHeroOwner = false;
                }
                RequestGameAction(ACTION_SUMMON, payloadSummon);
                return true;
            }
        }
        
    } else if (move.type == "activate" || move.type == "activate_effect") {
        var card = move.card;
        var effectIndex = variable_struct_exists(move, "effect_index") ? move.effect_index : -1;
        var target = variable_struct_exists(move, "target") ? move.target : noone;
        
        // 1. Si la carte est en main, il faut la jouer sur le terrain d'abord
        var isOnField = (variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"));
        
        if (!isOnField) {
            var posInfo = -1;
            if (instance_exists(oFieldManagerEnemy)) {
                 posInfo = oFieldManagerEnemy.getCardPositionAvailableIA(card); 
            }
            
            if (is_array(posInfo) && instance_exists(oHandEnemy)) {
                // Utiliser RequestGameAction pour consommer le mana (comme pour une invocation)
                var payloadSummon = {
                    card: card,
                    xy: posInfo,
                    summon_mode: "Summon"
                };
                if (variable_instance_exists(card, "instance_uid")) {
                    payloadSummon.card_uid = card.instance_uid;
                }
                if (instance_exists(card)) {
                    card.isHeroOwner = false;
                }
                RequestGameAction(ACTION_SUMMON, payloadSummon);
                // Note: L'effet sera exécuté via la suite du script si nécessaire, 
                // mais pour une Magie Normale, le summon déclenche souvent l'effet via oHand.summon -> executeEffect
            } else {
                return false; // Pas de slot disponible
            }
        }
        
        // 2. Exécuter l'effet si nécessaire (pour les cartes avec effet d'activation)
        // Si c'est "continuous_placement", on s'arrête là (déjà posée)
        var effectType = variable_struct_exists(move, "effect_type") ? move.effect_type : "";
        if (effectType == "continuous_placement") return true;

        // Récupération de l'effet
        var effect = noone;
        if (effectIndex != -1 && variable_instance_exists(card, "effects") && is_array(card.effects)) {
            if (effectIndex < array_length(card.effects)) {
                effect = card.effects[effectIndex];
            }
        }
        
        // Fallback: chercher le premier effet d'activation
        if (effect == noone && variable_instance_exists(card, "effects")) {
             for (var k = 0; k < array_length(card.effects); k++) {
                 var eff = card.effects[k];
                 var trig = variable_struct_exists(eff, "trigger") ? eff.trigger : "";
                 if (trig == "activate" || trig == "") {
                     effect = eff;
                     effectIndex = k;
                     break;
                 }
             }
        }
        
        if (effect != noone) {
            if (variable_instance_exists(card, "instance_uid") && effectIndex != -1) {
                var payload = {
                    source_uid: card.instance_uid,
                    effect_index: effectIndex
                };
                if (target != noone && instance_exists(target) && variable_instance_exists(target, "instance_uid")) {
                    payload.target_uid = target.instance_uid;
                }
                RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
                return true;
            } else {
                var context = { 
                    target: target,
                    owner_is_hero: false 
                };
                
                var resolved = executeEffect(card, effect, context);
                
                if (resolved) {
                     var genre = (variable_instance_exists(card, "genre") ? card.genre : "");
                     var isDirect = (genre == "Sort" || genre == "Direct");
                     if (isDirect && !is_undefined(consumeSpellIfNeeded)) {
                         consumeSpellIfNeeded(card, effect);
                     }
                     
                     if (!is_undefined(markEffectAsUsed)) {
                         markEffectAsUsed(card, effect);
                     }
                     return true;
                 }
                 
                 if (!isOnField) return true;
                 return false;
            }
        }
        
        // Si on a posé la carte mais qu'il n'y avait pas d'effet à activer (cas étrange mais possible), c'est un succès partiel (pose réussie)
        if (!isOnField) return true; 

    } else if (move.type == "set_card") {
        var card = move.card;
        // Poser une carte (Secret) face cachée
        
        var posInfo = -1;
        if (instance_exists(oFieldManagerEnemy)) {
             posInfo = oFieldManagerEnemy.getCardPositionAvailableIA(card); 
        }
        
        if (is_array(posInfo) && instance_exists(oHandEnemy)) {
            // oHand.summon gère automatiquement le mode "Set" si le genre est Secret
            if (!oHandEnemy.summon(card, posInfo)) return false;
            return true;
        }

    } else if (move.type == "attack") {
        var attacker = move.attacker;
        var target = move.target;
        var isDirect = move.isDirect;
        
        // Phase 1.5: Migration Command Pattern pour l'attaque IA
        if (variable_instance_exists(attacker, "instance_uid")) {
            var payload = {
                attacker_uid: attacker.instance_uid
            };
            
            if (isDirect) {
                payload.target_type = "direct_lp";
            } else if (target != noone && instance_exists(target) && variable_instance_exists(target, "instance_uid")) {
                payload.target_uid = target.instance_uid;
            }
            
            RequestGameAction(ACTION_ATTACK, payload);
            return true;
        } else {
            // Fallback Legacy
            if (instance_exists(oDamageManager)) {
                if (isDirect) {
                    with (oDamageManager) {
                        initiateAttackDirectEnemy(attacker);
                    }
                } else {
                    with (oDamageManager) {
                        initiateAttackMonsterEnemy(attacker, target);
                    }
                }
                
                // Note: Mise à jour des compteurs (attacksUsedThisTurn, camouflage) gérée dans initiate... 
                // pour supporter les délais d'animation FX sans double compte.
                
                return true;
            }
        }
    }
    return false;
}

function AI_CardHasAbyssienSynergy(card) {
    if (!variable_instance_exists(card, "effects") || !is_array(card.effects)) return false;
    for (var i = 0; i < array_length(card.effects); i++) {
        var eff = card.effects[i];
        if (!is_struct(eff)) continue;
        if (variable_struct_exists(eff, "conditions")) {
            var conds = eff.conditions;
            if (variable_struct_exists(conds, "source_name_contains")) {
                if (string(conds.source_name_contains) == "Abyssien") return true;
            }
        }
        if (variable_struct_exists(eff, "criteria")) {
            var crit = eff.criteria;
            if (variable_struct_exists(crit, "name_contains")) {
                if (string(crit.name_contains) == "Abyssien") return true;
            }
        }
    }
    return false;
}

function AI_HasAbyssienSynergyOnField() {
    if (instance_exists(oFieldMagicTrapEnemy)) {
        var mt = oFieldMagicTrapEnemy.cards;
        for (var i = 0; i < array_length(mt); i++) {
            var c = mt[i];
            if (c != 0 && instance_exists(c)) {
                if (AI_CardHasAbyssienSynergy(c)) return true;
            }
        }
    }
    if (instance_exists(oFieldMonsterEnemy)) {
        var mm = oFieldMonsterEnemy.cards;
        for (var j = 0; j < array_length(mm); j++) {
            var c2 = mm[j];
            if (c2 != 0 && instance_exists(c2)) {
                if (AI_CardHasAbyssienSynergy(c2)) return true;
            }
        }
    }
    return false;
}
