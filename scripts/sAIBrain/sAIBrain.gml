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
    var botID = (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) ? global.selected_bot_deck_id : "Invasion_Geule_Roche";
    var profile = AI_Config_GetBotProfile(botID);
    
    var p_summon = (profile != undefined) ? (profile.summon_weight / 50.0) : 1.0;
    var p_direct = (profile != undefined) ? (profile.direct_damage_bias / 50.0) : 1.0;
    var p_removal = (profile != undefined) ? (profile.removal_weight / 50.0) : 1.0;
    var p_sac = (profile != undefined) ? (profile.sacrifice_tolerance / 50.0) : 1.0;
    var p_manual = (profile != undefined) ? (profile.manual_effect_weight / 50.0) : 1.0;
    var p_continuous = (profile != undefined) ? (profile.continuous_weight / 50.0) : 1.0;
    var p_draw = (profile != undefined) ? (profile.draw_weight / 50.0) : 1.0;
    var p_tutor = (profile != undefined) ? (profile.tutor_weight / 50.0) : 1.0;
    var p_risk = (profile != undefined && variable_struct_exists(profile, "risk_tolerance")) ? (profile.risk_tolerance / 50.0) : 1.0;

    for (var i = 0; i < array_length(moves); i++) {
        var move = moves[i];
        var moveScoreVal = -999999;

        // --- HEURISTIQUES DE SCORING ---
        
        if (move.type == "summon") {
            // Score = Valeur de la carte invoquée - Valeur des sacrifices
            // On estime la valeur qu'aura la carte sur le terrain
            var cardVal = AI_GetCardScore_Predicted(move.card);
            
            var sacrificeCost = 0;
            if (variable_struct_exists(move, "sacrifices")) {
                for (var s = 0; s < array_length(move.sacrifices); s++) {
                    // Le coût du sacrifice dépend de la tolérance (plus on tolère, moins c'est "cher")
                    sacrificeCost += AI_GetCardScore(move.sacrifices[s]) * (1.0 / p_sac);
                }
            }
            
            moveScoreVal = cardVal - sacrificeCost;
            
            // --- CHECK PRIORITY MONSTERS (From Profile Custom Rules) ---
            var customRules = variable_struct_exists(profile, "custom_rules") ? profile.custom_rules : undefined;
            if (customRules != undefined) {
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
                             if (variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && location == "Board") {
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
            
            // 1. Scoring par type d'effet
            switch (effectType) {
                case "draw_cards":
                    // Piocher est toujours bon, surtout si main vide
                    moveScoreVal = 100 * p_draw; 
                    break;
                
                case "continuous_placement":
                    moveScoreVal = 150 * p_continuous; 

                    // --- CUSTOM PROFILE RULES ---
                    
                    // 1. Max Copies Limit (e.g. for Abyssien Deck)
                    var customRules = variable_struct_exists(profile, "custom_rules") ? profile.custom_rules : undefined;
                    
                    if (customRules != undefined && variable_struct_exists(customRules, "max_same_continuous")) {
                        var maxC = customRules.max_same_continuous;
                        var myObj = move.card.object_index;
                        var currentCount = 0;
                        
                        // Count existing copies on AI board
                        with (oCardParent) {
                            if (object_index == myObj && variable_instance_exists(id, "isHeroOwner") && !isHeroOwner && location == "Board") {
                                currentCount++;
                            }
                        }
                        
                        if (currentCount >= maxC) {
                            moveScoreVal = -1000; // Block placement if limit reached
                        }
                    }
                    
                    // 2. Synergy Boost (Generic) - replaces hardcoded Abyssien check
                    if (moveScoreVal > 0 && variable_struct_exists(profile, "synergy_tag")) {
                        var tag = profile.synergy_tag;
                        var hasSynergyInHand = false;
                        
                        // Check if we have cards in hand that benefit from this setup
                        if (instance_exists(oHandEnemy)) {
                             var hCards = oHandEnemy.cards;
                             var hLen = (is_array(hCards)) ? array_length(hCards) : ds_list_size(hCards);
                             for (var h = 0; h < hLen; h++) {
                                 var hCard = (is_array(hCards)) ? hCards[h] : ds_list_find_value(hCards, h);
                                 if (hCard != noone && instance_exists(hCard)) {
                                     var hName = (variable_instance_exists(hCard, "name") ? hCard.name : "");
                                     if (string_pos(tag, hName) > 0) {
                                         hasSynergyInHand = true;
                                         break;
                                     }
                                 }
                             }
                        }
                        
                        if (hasSynergyInHand) {
                            moveScoreVal += 2000; // High priority for synergy setup
                        }
                    }

                    if (p_summon > 1.0) moveScoreVal += 10;
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
                    // Check if attacker is stealthy (has Camouflage)
                    var isStealth = (variable_instance_exists(attacker, "isCamouflage") && attacker.isCamouflage) || (variable_instance_exists(attacker, "effects_text") && string_pos("Camouflage", attacker.effects_text) > 0);
                    
                    if (isStealth) {
                        // Only attack if:
                        // A. Lethal to Hero (Direct Attack)
                        // B. Free Kill on Monster (Very favorable trade)
                        
                        var isLethal = false;
                        var isFreeKill = false;
                        
                        var dmg = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                        
                        if (isDirect) {
                            var enemyLP = 0;
                            var lpInst = instance_find(oLP_Hero, 0);
                            if (lpInst != noone) enemyLP = lpInst.nbLP;
                            if (dmg >= enemyLP) isLethal = true;
                        } else {
                            // Monster Trade Analysis
                            var targetPos = (variable_instance_exists(target, "orientation") && target.orientation == "Attack") ? "Attack" : "Defense";
                            var enemyStats = (targetPos == "Attack") ? (variable_instance_exists(target, "effective_attack") ? target.effective_attack : target.attack) : (variable_instance_exists(target, "effective_defense") ? target.effective_defense : target.defense);
                            
                            // Free kill if we kill them AND take 0 damage (or survive with margin)
                            // Here user said "seulement si il detruise l'adversaire". We interpret as "Kill without dying" or "Worth it".
                            // But user also said "Wait for opportun moment".
                            // Let's go with: Only attack monster if we kill it and survive.
                            
                            var myKill = (dmg > enemyStats) || (dmg == enemyStats && targetPos == "Attack");
                            var iDie = false;
                            
                            if (targetPos == "Attack") {
                                var enemyAtk = variable_instance_exists(target, "effective_attack") ? target.effective_attack : target.attack;
                                if (enemyAtk >= dmg) iDie = true; // Simplified
                            }
                            
                            if (myKill && !iDie) isFreeKill = true;
                        }
                        
                        if (!isLethal && !isFreeKill && !isDirect) {
                            moveScoreVal = -500; // Prefer waiting
                            continue;
                        } else {
                            moveScoreVal += 500; // Go for it!
                        }
                    }
                }
            }
            
            if (isDirect) {
                // Attaque directe = Pression sur les PV
                
                // FORCE RECOMPUTE
                if (script_exists(asset_get_index("buffRecompute"))) {
                    buffRecompute(attacker);
                }
                
                // Score = Dégâts * Multiplicateur
                var dmg = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                moveScoreVal = dmg * 2 * p_direct; 
                
                // Bonus si létal (calcul approximatif)
                var enemyLP = 0;
                var lpInst = instance_find(oLP_Hero, 0);
                if (lpInst != noone) enemyLP = lpInst.nbLP;
                if (dmg >= enemyLP) moveScoreVal += 100000;
                
            } else {
                // Combat contre monstre
                moveScoreVal = 0;
                var targetVal = AI_GetCardScore(target);
                
                // FORCE RECOMPUTE: Ensure stats are up-to-date (fixes stale buffs/base stats)
                if (script_exists(asset_get_index("buffRecompute"))) {
                    buffRecompute(attacker);
                    buffRecompute(target);
                }

                // Récupération des stats effectives (incluant boosts)
                var myAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
                
                var isFaceDown = (variable_instance_exists(target, "isFaceDown") && target.isFaceDown);
                
                // Si la cible est face cachée, l'IA ne connait pas ses stats
                if (isFaceDown) {
                    // Stratégie incertaine (Risque vs Récompense)
                    // On suppose que c'est de la Défense
                    
                    moveScoreVal = 30 * p_risk; // Envie de base de révéler/détruire modifiée par le risque
                    
                    // On préfère attaquer avec une ATK élevée pour minimiser le risque de prendre des dégâts sur une grosse DEF
                    if (myAtk >= 1800) {
                        moveScoreVal += 80; // Très sûr
                    } else if (myAtk >= 1400) {
                        moveScoreVal += 40 * p_risk; // Raisonnable (plus envie si risque élevé)
                    } else if (myAtk < 1000) {
                        moveScoreVal -= 60 / p_risk; // Trop risqué (pénalité réduite si tolérance au risque élevée)
                    }
                    
                    // Bonus si on a Poison (potentiel kill gratuit)
                    if (variable_instance_exists(attacker, "isPoisoner") && attacker.isPoisoner) {
                        moveScoreVal += 50;
                    }
                    
                } else {
                    // Cible VISIBLE : Calculs exacts
                    var enemyAtk = variable_instance_exists(target, "effective_attack") ? target.effective_attack : target.attack;
                    var enemyDef = variable_instance_exists(target, "effective_defense") ? target.effective_defense : target.defense;

                
                // --- Prise en compte des Boosts "au moment de l'attaque" ---
                // Certains effets s'activent uniquement lors de l'attaque (ex: "Gagne +500 ATK si attaque")
                // Il faut scanner les effets de la carte attaquante
                if (variable_instance_exists(attacker, "effects")) {
                    // Logique simplifiée : si on détecte un mot-clé de boost conditionnel, on l'ajoute virtuellement
                    // TODO: Idéalement, parser les effets. Ici on fait une estimation si des flags existent ou par convention
                }
                
                // --- Prise en compte de l'effet POISON ---
                // Si l'attaquant a Poison, il tue n'importe quoi (sauf immunité)
                // ATTENTION: Selon règles utilisateur, Poison ne s'active QUE lors de l'attaque.
                // Donc si l'ennemi a Poison mais qu'il DÉFEND, l'effet ne s'applique pas.
                
                var myHasPoison = false;
                var enemyHasPoison = false; // Reste false car Poison ne proc pas en défense
                
                // Vérification Poison Attaquant (Actif)
                if (variable_instance_exists(attacker, "effects_text") && string_pos("Poison", attacker.effects_text) > 0) myHasPoison = true;
                
                // Vérification Poison Défenseur (Inactif en défense selon règle)
                // if (variable_instance_exists(target, "effects_text") && string_pos("Poison", target.effects_text) > 0) enemyHasPoison = true; 
                
                // Note : Le poison s'applique APRÈS le calcul des dégâts, mais garantit la mort.
                
                var targetPos = (variable_instance_exists(target, "orientation") && target.orientation == "Attack") ? "Attack" : "Defense";
                
                // Simulation simplifiée du combat
                var iSurvive = true;
                var enemyDies = false;
                
                if (targetPos == "Attack") {
                    if (myAtk > enemyAtk) {
                        enemyDies = true;
                        iSurvive = true;
                    } else if (myAtk == enemyAtk) {
                        enemyDies = true;
                        iSurvive = false; // Suicide mutuel
                        // Pénalité pour éviter le suicide systématique en cas d'égalité
                        // Modulée par la tolérance au risque (p_risk autour de 1.0)
                        // Si p_risk est bas (prudent), on pénalise plus. Si haut (tête brulée), on pénalise moins.
                        var tradePenalty = 300 * (2.0 - p_risk);
                        moveScoreVal -= max(50, tradePenalty); 
                    } else {
                        enemyDies = false;
                        iSurvive = false; // Suicide inutile
                    }
                } else { // Defense
                    if (myAtk > enemyDef) {
                        enemyDies = true;
                        iSurvive = true;
                    } else if (myAtk == enemyDef) {
                        enemyDies = false;
                        iSurvive = true;
                    } else {
                        enemyDies = false;
                        iSurvive = true; // On survit généralement en tapant une def trop haute (sauf règle spéciale)
                        // PÉNALITÉ SIGNIFICATIVE : On prend des dégâts LP pour rien.
                        // On doit éviter ça sauf si c'est la seule façon de gagner (ce qui n'arrive pas ici)
                        moveScoreVal -= 500; 
                    }
                }
                
                // Application de la logique POISON
                if (myHasPoison && !enemyDies) {
                    // Le poison tue la cible même si l'attaque a échoué en dégâts (sauf si pas de dégâts infligés ? Dépend des règles)
                    // Règle classique : Si on inflige des dégâts de combat > 0 ou si c'est "Toucher mortel".
                    // Supposons "Toucher mortel" (Deathtouch) : Toujours mortel si combat a lieu.
                    enemyDies = true;
                    // Bonus massif au score car on élimine une menace peu importe ses stats
                    moveScoreVal += 500; 
                }
                
                if (enemyHasPoison && iSurvive) {
                    // Si l'ennemi a poison, je meurs même si j'ai gagné le combat
                    iSurvive = false;
                    moveScoreVal -= attackerVal; // Pénalité car je perds mon monstre
                }
                
                if (enemyDies) moveScoreVal += (targetVal + 100) * p_removal; // Bonus pour kill pondéré par removal_weight
                if (!iSurvive) moveScoreVal -= attackerVal;
                
                // On évite les attaques suicides sauf si trade très favorable
                if (!iSurvive && !enemyDies) moveScoreVal = -999999;
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
        var slotIndex = -1;
        if (instance_exists(oFieldManagerEnemy)) {
             slotIndex = oFieldManagerEnemy.getCardPositionAvailableIA(card);
        }
        
        if (slotIndex != -1) {
            if (instance_exists(oHandEnemy)) {
                // Déterminer l'orientation optimale
                var atk = variable_instance_exists(card, "attack") ? card.attack : 0;
                var def = variable_instance_exists(card, "defense") ? card.defense : 0;
                
                // Analyse du terrain adverse pour la prise de décision (Control)
                var strongestEnemyAtk = 0;
                var enemyCount = 0;
                if (instance_exists(oFieldMonsterHero)) {
                    var enemies = oFieldMonsterHero.cards;
                    for (var e = 0; e < array_length(enemies); e++) {
                        var enemy = enemies[e];
                        if (enemy != 0 && instance_exists(enemy)) {
                             // FORCE RECOMPUTE for accurate threat assessment
                             if (script_exists(asset_get_index("buffRecompute"))) {
                                 buffRecompute(enemy);
                             }
                             
                             // On prend l'attaque visible (effective) des monstres adverses
                             var eAtk = variable_instance_exists(enemy, "effective_attack") ? enemy.effective_attack : (variable_instance_exists(enemy, "attack") ? enemy.attack : 0);
                             if (eAtk > strongestEnemyAtk) strongestEnemyAtk = eAtk;
                             enemyCount++;
                        }
                    }
                }

                var orientation = "Attack";
                
                if (variable_struct_exists(move, "force_orientation")) {
                    orientation = move.force_orientation;
                } else {
                    var profile = AI_Config_GetActiveProfile();
                    var riskTolerance = (variable_struct_exists(profile, "risk_tolerance")) ? profile.risk_tolerance : 50;

                    // 1. Logique de base : Stats
                    if (def > atk) orientation = "Defense";
                    
                    // 2. Opportunisme : Si on dépasse la menace adverse, on attaque (même si DEF > ATK)
                    // Cela signifie qu'on "contrôle" le terrain ou qu'on peut le reprendre.
                    if (atk > strongestEnemyAtk) {
                        orientation = "Attack";
                    }
                    
                    // 3. Champ libre : Si aucun ennemi, on attaque pour la pression (sauf si ATK très faible)
                    if (enemyCount == 0 && atk > 500) {
                        orientation = "Attack";
                    }
                    
                    // 4. Prudence : Si on est dominé par l'ennemi (ATK < MaxEnnemi)
                    if (atk < strongestEnemyAtk) {
                        orientation = "Defense";
                        
                        // EXCEPTIONS AGRESSIVES
                        
                        // 1. Camouflage : Si on est intouchable, on reste en attaque pour menacer
                        if (variable_instance_exists(card, "isCamouflage") && card.isCamouflage) {
                            orientation = "Attack";
                        }
                        // 2. Agressivité : Si le bot prend des risques (Risk > 65), il ignore la prudence
                        // MAIS seulement si l'écart n'est pas suicidaire (ATK doit être au moins 80% de la menace ou écart < 2)
                        else if (riskTolerance >= 65) {
                             if (atk >= strongestEnemyAtk * 0.80 || (strongestEnemyAtk - atk) <= 1) {
                                orientation = "Attack";
                             }
                        }
                    }
                    // Cas d'égalité : Si on peut tanker, on le fait. Sinon on reste en Attaque pour dissuader.
                    else if (atk == strongestEnemyAtk && def > strongestEnemyAtk) {
                        orientation = "Defense";
                        
                        if (variable_instance_exists(card, "isCamouflage") && card.isCamouflage) {
                            orientation = "Attack";
                        }
                    }
                    
                    // DEBUG: Trace summon decision
                    var cName = variable_instance_exists(card, "name") ? card.name : "Unknown";
                    show_debug_message("AI SUMMON DECISION: Card=" + cName + " Atk=" + string(atk) + " Def=" + string(def) + " StrongestEnemy=" + string(strongestEnemyAtk) + " Risk=" + string(riskTolerance) + " -> " + orientation);
                    
                    if (variable_instance_exists(card, "effects") && is_array(card.effects)) {
                        for(var i=0; i<array_length(card.effects); i++) {
                            var ef = card.effects[i];
                            if (variable_struct_exists(ef, "trigger") && ef.trigger == "flip") {
                                orientation = "Defense";
                                break;
                            }
                        }
                    }
                    // --- CUSTOM RULE: Force Attack Abyssien Condition ---
                    var customRules = variable_struct_exists(profile, "custom_rules") ? profile.custom_rules : undefined;
                    if (customRules != undefined && variable_struct_exists(customRules, "force_attack_abyssien_condition") && customRules.force_attack_abyssien_condition) {
                         var nStr = variable_instance_exists(card, "name") ? card.name : "";
                         if (is_string(nStr) && string_pos("Abyssien", nStr) > 0) {
                             var conditionMet = false;
                             
                             // 1. Check for Ruisselier on board
                             if (instance_exists(oFieldMonsterEnemy)) {
                                 var mm = oFieldMonsterEnemy.cards;
                                 for (var j = 0; j < array_length(mm); j++) {
                                     var c2 = mm[j];
                                     if (c2 != 0 && instance_exists(c2)) {
                                         var cName = variable_instance_exists(c2, "name") ? c2.name : "";
                                         if (string_pos("Ruisselier", cName) > 0) {
                                             conditionMet = true;
                                             break;
                                         }
                                     }
                                 }
                             }
                             
                             // 2. Check for Continuous Magic (at least 1)
                             if (!conditionMet && instance_exists(oFieldMagicTrapEnemy)) {
                                 var mt = oFieldMagicTrapEnemy.cards;
                                 for (var i = 0; i < array_length(mt); i++) {
                                     var c = mt[i];
                                     if (c != 0 && instance_exists(c)) {
                                         var genre = variable_instance_exists(c, "genre") ? c.genre : "";
                                         if (genre == "Continue" || genre == "Continu" || genre == "Terrain" || genre == "Field") {
                                             conditionMet = true;
                                             break;
                                         }
                                     }
                                 }
                             }
                             
                             if (conditionMet) {
                                 orientation = "Attack";
                             }
                         }
                    }
                    else if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id == 2) {
                        var nStr = "";
                        if (variable_instance_exists(card, "name")) {
                            nStr = card.name;
                        }
                        if (is_string(nStr) && string_pos("Abyssien", nStr) > 0) {
                            if (AI_HasAbyssienSynergyOnField()) {
                                orientation = "Attack";
                            }
                        }
                    }
                }
                
                var effectTarget = variable_struct_exists(move, "effect_target") ? move.effect_target : noone;
                oHandEnemy.summon(card, slotIndex, orientation, effectTarget);
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
            var slotIndex = -1;
            if (instance_exists(oFieldManagerEnemy)) {
                 slotIndex = oFieldManagerEnemy.getCardPositionAvailableIA(card); 
            }
            
            if (slotIndex != -1 && instance_exists(oHandEnemy)) {
                oHandEnemy.summon(card, slotIndex);
                // Note: oHandEnemy.summon gère l'ajout au manager et l'animation.
                // Pour une magie Continue sans effet actif, c'est tout ce qu'il y a à faire.
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
                     var isDirect = (variable_instance_exists(card, "genre") && card.genre == "Direct");
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
        
        var slotIndex = -1;
        if (instance_exists(oFieldManagerEnemy)) {
             slotIndex = oFieldManagerEnemy.getCardPositionAvailableIA(card); 
        }
        
        if (slotIndex != -1 && instance_exists(oHandEnemy)) {
            // oHand.summon gère automatiquement le mode "Set" si le genre est Secret
            if (!oHandEnemy.summon(card, slotIndex)) return false;
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
