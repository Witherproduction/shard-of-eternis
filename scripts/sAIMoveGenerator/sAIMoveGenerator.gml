/// sAIMoveGenerator.gml
/// Génère les actions légales possibles pour l'IA

/// @function AI_GetLegalMoves_Summon()
/// @description Retourne une liste de coups possibles pour la phase d'invocation (Main Phase)
function AI_GetLegalMoves_Summon() {
    var moves = [];
    
    // 1. Accès à la main de l'IA
    if (!instance_exists(oHandEnemy)) return moves;
    
    var handList = oHandEnemy.cards;
    var handSize = 0;
    var isList = false;
    
    if (ds_exists(handList, ds_type_list)) {
        handSize = ds_list_size(handList);
        isList = true;
    } else if (is_array(handList)) {
        handSize = array_length(handList);
        isList = false;
    } else {
        return moves;
    }

    // 2. Analyser chaque carte en main
    for (var i = 0; i < handSize; i++) {
        var card = noone;
        if (isList) {
            card = ds_list_find_value(handList, i);
        } else {
            card = handList[i];
        }
        
        if (card == 0 || !instance_exists(card)) continue;

        // --- CAS MONSTRE ---
        if (variable_instance_exists(card, "type") && card.type == "Monster") {
            // Vérifier la limite d'invocation (1 par tour pour l'IA/Enemy)
            if (instance_exists(oGame) && oGame.hasSummonedThisTurn[1]) continue;

            var star = variable_instance_exists(card, "star") ? card.star : 1;
            var sacrificesNeeded = getSacrificeLevel(star);
            
            var myBoard = oFieldMonsterEnemy.cards; // Array
            var myMonsters = [];
            var emptySlots = 0;

            // Compter les monstres et les slots vides
            for (var k = 0; k < array_length(myBoard); k++) {
                var c = myBoard[k];
                if (c == 0) {
                    emptySlots++;
                } else if (instance_exists(c)) {
                    // Ensure stats are up-to-date before evaluating for sacrifice
                    if (script_exists(asset_get_index("buffRecompute"))) {
                        buffRecompute(c);
                    }
                    array_push(myMonsters, c);
                }
            }

            var potentialSacrifices = [];
            var canSummon = false;

            // Vérifier si invocation possible
            if (sacrificesNeeded == 0) {
                if (emptySlots > 0) canSummon = true;
            } else {
                if (array_length(myMonsters) >= sacrificesNeeded) {
                    // Stratégie simple : sacrifier les plus faibles
                    // Trier myMonsters par valeur croissante (Effective ATK)
                    array_sort(myMonsters, function(a, b) {
                        var atk1 = variable_instance_exists(a, "effective_attack") ? a.effective_attack : (variable_instance_exists(a, "attack") ? a.attack : 0);
                        var atk2 = variable_instance_exists(b, "effective_attack") ? b.effective_attack : (variable_instance_exists(b, "attack") ? b.attack : 0);
                        return atk1 - atk2;
                    });

                    for (var s = 0; s < sacrificesNeeded; s++) {
                        array_push(potentialSacrifices, myMonsters[s]);
                    }
                    canSummon = true;
                }
            }
            
            if (canSummon) {
                // --- GESTION DES EFFETS "ON SUMMON" ---
                var onSummonEffects = [];
                if (variable_instance_exists(card, "effects") && is_array(card.effects)) {
                    for (var e = 0; e < array_length(card.effects); e++) {
                        var eff = card.effects[e];
                        var trig = variable_struct_exists(eff, "trigger") ? eff.trigger : "";
                        if (trig == "on_summon" || trig == "on_play") {
                            array_push(onSummonEffects, eff);
                        }
                    }
                }

                if (array_length(onSummonEffects) == 0) {
                    // Invocation standard sans effet déclenché
                    array_push(moves, {
                        type: "summon",
                        card: card,
                        sacrifices: potentialSacrifices
                    });
                } else {
                    // Invocation avec effet déclenché
                    // On gère le premier effet trouvé pour simplifier
                    var effect = onSummonEffects[0];
                    var eType = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";
                    var targets = [];
                    var targetScope = "none";
                    
                    // Définition de la portée de la cible
                    if (eType == "destroy_target" || eType == "banish_target" || eType == "return_to_hand" || eType == "damage_target" || eType == "entrave") {
                        targetScope = "enemy";
                    } else if (eType == "buff" || eType == "heal_target" || eType == "equip_select_target") {
                        targetScope = "ally";
                    }

                    // Recherche des cibles
                    if (targetScope == "enemy") {
                        if (instance_exists(oFieldMonsterHero)) {
                             var enemies = oFieldMonsterHero.cards;
                             for (var t=0; t<array_length(enemies); t++) {
                                 if (enemies[t] != 0 && instance_exists(enemies[t])) array_push(targets, enemies[t]);
                             }
                        }
                    } else if (targetScope == "ally") {
                         // Alliés existants (non sacrifiés)
                         for (var t=0; t<array_length(myMonsters); t++) {
                             var m = myMonsters[t];
                             var isSacrificed = false;
                             for (var s=0; s<array_length(potentialSacrifices); s++) {
                                 if (potentialSacrifices[s] == m) isSacrificed = true;
                             }
                             if (!isSacrificed) array_push(targets, m);
                         }
                         // La carte elle-même (self)
                         array_push(targets, card); 
                    }

                    if (array_length(targets) > 0) {
                        // Générer un move pour chaque cible possible
                        for (var t=0; t<array_length(targets); t++) {
                            array_push(moves, {
                                type: "summon",
                                card: card,
                                sacrifices: potentialSacrifices,
                                effect_target: targets[t],
                                effect_type: eType,
                                has_on_summon_effect: true
                            });
                        }
                    } else {
                        // Effet global ou sans cible valide (ex: Draw, ou Board vide)
                         array_push(moves, {
                            type: "summon",
                            card: card,
                            sacrifices: potentialSacrifices,
                            effect_type: eType,
                            has_on_summon_effect: true
                        });
                    }
                }
            }
        }
        
        // --- CAS MAGIE (MAIN) ---
        else if (variable_instance_exists(card, "type") && card.type == "Magic") {
             if (variable_instance_exists(card, "genre") && card.genre == "Secret") {
                 array_push(moves, {
                     type: "set_card",
                     card: card,
                     target: noone
                 });
             } else {
                 var movesCountBefore = array_length(moves);
                 AI_AddEffectMoves(card, moves, "hand");
                 
                 // Si c'est une magie Continue (ou similaire) sans effet d'activation direct (effets passifs/déclenchés),
                 // on doit quand même pouvoir la jouer.
                 if (array_length(moves) == movesCountBefore) {
                     var genre = variable_instance_exists(card, "genre") ? card.genre : "";
                     var isContinuous = (genre == "Continue" || genre == "Continu" || genre == "Terrain" || genre == "Field");
                     
                     if (isContinuous) {
                         array_push(moves, {
                             type: "activate", // "activate" ici signifie "jouer la carte"
                             card: card,
                             target: noone,
                             effect_type: "continuous_placement"
                         });
                     }
                 }
             }
        }
    }
    
    // 3. Analyser les cartes sur le terrain (Monstres et Magies)
    if (instance_exists(oFieldMonsterEnemy)) {
        var boardM = oFieldMonsterEnemy.cards;
        for (var i = 0; i < array_length(boardM); i++) {
            var card = boardM[i];
            if (card != 0 && instance_exists(card)) {
                AI_AddEffectMoves(card, moves, "field");
            }
        }
    }
    
    if (instance_exists(oFieldMagicTrapEnemy)) {
        var boardS = oFieldMagicTrapEnemy.cards;
        for (var i = 0; i < array_length(boardS); i++) {
            var card = boardS[i];
            if (card != 0 && instance_exists(card)) {
                var isSecret = (variable_instance_exists(card, "genre") && card.genre == "Secret");
                if (!isSecret) {
                    AI_AddEffectMoves(card, moves, "field");
                }
            }
        }
    }
    
    return moves;
}

/// @function AI_AddEffectMoves(card, moves, context)
/// @description Helper pour ajouter les moves d'effets activables (Hand ou Field)
function AI_AddEffectMoves(card, moves, context) {
    if (!variable_instance_exists(card, "effects") || !is_array(card.effects)) return;

    for (var k = 0; k < array_length(card.effects); k++) {
        var effect = card.effects[k];
        var effectType = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";
        var trigger = variable_struct_exists(effect, "trigger") ? effect.trigger : "";
        
        // Filtres de contexte
        if (trigger == "on_summon" || trigger == "on_play") continue;
        
        var isMagicActivate = (card.type == "Magic" && (trigger == "activate" || trigger == ""));
        var isMonsterActivate = (card.type == "Monster" && (trigger == "activate" || trigger == "ignition"));
        
        if (context == "hand") {
             if (!isMagicActivate) continue; 
        }
        if (context == "field") {
             if (!isMagicActivate && !isMonsterActivate) continue;
        }

        // Validation Générique (Conditions d'activation & Cibles valides)
        // On utilise les scripts partagés sEffectMisc pour garantir que l'IA respecte les mêmes règles que le joueur
        if (!is_undefined(asset_get_index("isEffectActivatable"))) {
            if (!isEffectActivatable(card, effect)) continue;
        }

        // --- LOGIQUE DE CIBLAGE ---
        var needsTarget = false;
        var potentialTargets = [];
        var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
        var isMass = (scope == "all");
        var isRandom = (variable_struct_exists(effect, "random_select") && effect.random_select);
        
        // Si ce n'est pas un effet de zone ou aléatoire, on cherche les cibles spécifiques
        if (!isMass && !isRandom) {
            if (!is_undefined(asset_get_index("getTargetsByFilter"))) {
                var targetsFound = getTargetsByFilter(effect);
                if (array_length(targetsFound) > 0) {
                    potentialTargets = targetsFound;
                    needsTarget = true;
                }
            } else {
                // Fallback manuel si le script n'existe pas (ne devrait pas arriver)
                // ... (Ancienne logique simplifiée conservée au cas où, ou juste on skip)
            }
        }
        
        // Si on a besoin de cible mais qu'on en a pas trouvé (alors que isEffectActivatable a dit oui),
        // c'est peut-être que l'effet ne nécessite pas de cible explicite (ex: Draw, Heal Self).
        // On vérifie si c'est un type d'effet qui DOIT cibler.
        if (needsTarget && array_length(potentialTargets) == 0) {
             var etype = effectType;
             var mustTarget = (etype == "destroy_target" || etype == "banish_target" || etype == "return_to_hand" || etype == "equip_select_target" || (etype == "buff" && scope == "single") || etype == "damage_target" || etype == "heal_target" || etype == "entrave");
             
             if (mustTarget) continue; // Pas de cible -> pas de move
             needsTarget = false; // Sinon, c'est un effet sans cible (ex: Draw)
        }
        
        if (needsTarget) {
            for (var pt = 0; pt < array_length(potentialTargets); pt++) {
                var tCard = potentialTargets[pt];
                
                // Vérifications de sécurité ultimes
                if (!instance_exists(tCard)) continue;
                
                // Untargetable (Immunité au ciblage)
                if (variable_instance_exists(tCard, "untargetable") && tCard.untargetable) continue;
                
                // Camouflage (Si ennemi)
                var isEnemyTarget = (variable_instance_exists(tCard, "isHeroOwner") && variable_instance_exists(card, "isHeroOwner") && tCard.isHeroOwner != card.isHeroOwner);
                if (isEnemyTarget && variable_instance_exists(tCard, "isCamouflage") && tCard.isCamouflage) continue;

                array_push(moves, {
                    type: "activate_effect", 
                    card: card,
                    target: tCard,
                    effect_index: k, 
                    effect_type: effectType,
                    is_monster_effect: (card.type == "Monster"),
                    is_equip: (effectType == "equip_select_target")
                });
            }
        } else {
            array_push(moves, {
                type: "activate_effect",
                card: card,
                target: noone,
                effect_index: k,
                effect_type: effectType,
                is_monster_effect: (card.type == "Monster")
            });
        }
    }
}

/// @function AI_GetLegalMoves_Attack()
/// @description Retourne une liste d'attaques possibles
function AI_GetLegalMoves_Attack() {
    var moves = [];
    
    if (!instance_exists(oFieldMonsterEnemy) || !instance_exists(oFieldMonsterHero)) return moves;

    var myMonsters = oFieldMonsterEnemy.cards;
    var enemyMonsters = oFieldMonsterHero.cards;
    
    // Identifier les cibles valides (Taunt / Camouflage)
    var validTargets = [];
    var hasTaunt = false; // A implémenter si la mécanique existe
    var enemyHasNonCamo = false;

    // Filtrer les monstres adverses
    for (var j = 0; j < array_length(enemyMonsters); j++) {
        var target = enemyMonsters[j];
        if (target != 0 && instance_exists(target)) {
            // Vérif Camouflage
            if (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) {
                // Ne peut pas être ciblé si d'autres non-camo existent (Règle standard?)
                // oDamageManager dit: si cible camo et qu'il y a non-camo, interdit.
            } else {
                enemyHasNonCamo = true;
            }
            array_push(validTargets, target);
        }
    }

    // Si on a des cibles camo mais qu'il existe des non-camo, on retire les camo de la liste ?
    // Simplification : On liste tout, le scoring pénalisera ou oDamageManager bloquera.
    // Mieux : Répliquer la logique oDamageManager.
    // Si enemyHasNonCamo est true, on ne peut attaquer QUE les non-camo.
    if (enemyHasNonCamo) {
        var filteredTargets = [];
        for (var t = 0; t < array_length(validTargets); t++) {
            var _t = validTargets[t];
            if (!variable_instance_exists(_t, "isCamouflage") || !_t.isCamouflage) {
                array_push(filteredTargets, _t);
            }
        }
        validTargets = filteredTargets;
    }


    // Pour chaque attaquant potentiel
    for (var i = 0; i < array_length(myMonsters); i++) {
        var attacker = myMonsters[i];
        if (attacker == 0 || !instance_exists(attacker)) continue;

        // Ensure stats are up-to-date (Buffs/Debuffs)
        if (script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(attacker);
        }

        // Vérifications de base (Attack Position, Pas encore attaqué)
        if (variable_instance_exists(attacker, "orientation") && attacker.orientation == "Attack") {
            var limit = 1; 
            if (variable_instance_exists(attacker, "isAmbidextrous") && attacker.isAmbidextrous) limit = 2;
            var used = variable_instance_exists(attacker, "attacksUsedThisTurn") ? attacker.attacksUsedThisTurn : 0;
            
            if (used < limit) {
                // 1. Attaque sur Monstres
                for (var k = 0; k < array_length(validTargets); k++) {
                    array_push(moves, {
                        type: "attack",
                        attacker: attacker,
                        target: validTargets[k],
                        isDirect: false
                    });
                }

                // 2. Attaque Directe (Si pas de monstres non-camo ?)
                // Règle oDamageManager : Si enemyHasNonCamo == false, on peut attaquer direct ?
                // Non, en général TCG : Si pas de monstres, Direct Attack.
                // Si monstres Camo SEULEMENT : Direct Attack autorisée ? (Check oDamageManager)
                // oDamageManager: "if (!heroHasNonCamo) { resolveAttackDirectEnemy(attacker); }"
                
                var canAttackDirect = (array_length(validTargets) == 0); 
                // Si validTargets est vide, ça veut dire soit 0 monstres, soit que des cibles intouchables qui autorisent le direct.
                
                // Vérifions s'il y a des monstres "Taunt" qui obligent l'attaque sur eux (pas implémenté ici mais prévu)
                
                if (canAttackDirect) {
                    array_push(moves, {
                        type: "attack",
                        attacker: attacker,
                        target: noone,
                        isDirect: true
                    });
                }
            }
        }
    }

    return moves;
}
