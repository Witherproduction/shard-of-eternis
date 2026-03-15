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

        // --- MANA CHECK (Hearthstone Style) ---
        var manaCost = variable_instance_exists(card, "mana_cost") ? card.mana_cost : ((variable_instance_exists(card, "mana_cost")) ? card.mana_cost : 0);
        var currentMana = (variable_global_exists("mana_enemy")) ? global.mana_enemy : 0;
        
        if (manaCost > currentMana) continue; // Pas assez de mana

        // --- CAS MONSTRE ---
        if (variable_instance_exists(card, "type") && card.type == "Monster") {
            // Pas de limite d'invocation par tour en HS, juste le Mana
            // Vérifier s'il y a de la place sur le board (Max 7 en général, 5 ici ?)
            var myBoard = oFieldMonsterEnemy.cards;
            var emptySlots = 0;
            for (var k = 0; k < array_length(myBoard); k++) {
                if (myBoard[k] == 0) emptySlots++;
            }
            
            if (emptySlots > 0) {
                // --- GESTION DES EFFETS "ON SUMMON" (Battlecry) ---
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
                        sacrifices: [] // Plus de sacrifices
                    });
                } else {
                    // Invocation avec Battlecry (simplifié : premier effet)
                    var effect = onSummonEffects[0];
                    var eType = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";
                    var targets = [];
                    var targetScope = "none";
                    
                    // Priority to explicit owner defined in effect
                    var explicitOwner = variable_struct_exists(effect, "owner") ? effect.owner : "";
                    
                    if (explicitOwner == "enemy" || explicitOwner == "opponent") {
                        targetScope = "enemy";
                    } else if (explicitOwner == "ally" || explicitOwner == "self") {
                        targetScope = "ally";
                    } else {
                        // Définition de la portée de la cible (Inférence par type)
                        if (eType == "destroy_target" || eType == "banish_target" || eType == "return_to_hand" || eType == "damage_target" || eType == "entrave") {
                            targetScope = "enemy";
                        } else if (eType == "buff" || eType == "heal_target" || eType == "equip_select_target") {
                            targetScope = "ally";
                        }
                    }

                    // Recherche des cibles
                    if (targetScope == "enemy") {
                        if (instance_exists(oFieldMonsterHero)) {
                             var enemies = oFieldMonsterHero.cards;
                             for (var t=0; t<array_length(enemies); t++) {
                                 if (enemies[t] != 0 && instance_exists(enemies[t])) {
                                     // Check Stealth (Camouflage) - Cannot target stealth enemies
                                     var isStealth = (variable_instance_exists(enemies[t], "isCamouflage") && enemies[t].isCamouflage);
                                     if (!isStealth) array_push(targets, enemies[t]);
                                 }
                             }
                        }
                    } else if (targetScope == "ally") {
                         var allies = oFieldMonsterEnemy.cards;
                         for (var t=0; t<array_length(allies); t++) {
                             if (allies[t] != 0 && instance_exists(allies[t])) array_push(targets, allies[t]);
                         }
                         // La carte elle-même (self) si buff possible ? (Battlecry happens after summon usually, but targeting logic varies)
                         // En général Battlecry ne cible pas self.
                    }

                    if (array_length(targets) > 0) {
                        for (var t=0; t<array_length(targets); t++) {
                            array_push(moves, {
                                type: "summon",
                                card: card,
                                sacrifices: [],
                                effect_target: targets[t],
                                effect_type: eType,
                                has_on_summon_effect: true
                            });
                        }
                    } else {
                        // Pas de cible valide ou effet global
                         array_push(moves, {
                            type: "summon",
                            card: card,
                            sacrifices: [],
                            effect_type: eType,
                            has_on_summon_effect: true
                        });
                    }
                }
            }
        }
        
        // --- CAS MAGIE (MAIN) ---
        else if (variable_instance_exists(card, "type") && card.type == "Magic") {
             // Traitement Magie (inchangé sauf Mana check déjà fait au début)
             var movesCountBefore = array_length(moves);
             AI_AddEffectMoves(card, moves, "hand");
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
    var effectsList = undefined;
    
    // Support hybride : Card peut être une Struct (Hand) ou une Instance (Field)
    if (is_struct(card)) {
        if (variable_struct_exists(card, "effects")) effectsList = card.effects;
    } else if (instance_exists(card)) {
        if (variable_instance_exists(card, "effects")) effectsList = card.effects;
    }

    if (!is_array(effectsList)) return;
    
    var len = 0;
    try {
        len = array_length(effectsList);
    } catch(e) {
        show_debug_message("AI_AddEffectMoves ERROR: array_length failed. " + string(e));
        return;
    }

    if (!is_real(len)) len = 0;

    var k = 0;
    while (k < len) {
        var effect = effectsList[k];
        
        // Attention: la variable k doit être différente de la variable ki utilisée dans la boucle interne (ligne 288)
        // J'ai vérifié, la boucle interne utilise 'ki', donc pas de conflit.
        
        var effectType = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";
        
        // --- PATCH IA LOOP FIX ---
        // Si l'effet est d'équiper et qu'on est déjà équipé, on ignore cet effet pour éviter une boucle infinie
        var isEquipped = false;
        if (is_struct(card)) {
            if (variable_struct_exists(card, "equipped_target") && card.equipped_target != noone) isEquipped = true;
        } else if (instance_exists(card)) {
            if (variable_instance_exists(card, "equipped_target") && card.equipped_target != noone && instance_exists(card.equipped_target)) isEquipped = true;
        }
        
        if (effectType == "equip_select_target" && isEquipped) {
             k++;
             continue;
        }

        var trigger = variable_struct_exists(effect, "trigger") ? effect.trigger : "";
        
        // Filtres de contexte
        if (trigger == "on_summon" || trigger == "on_play") {
            k++;
            continue;
        }
        
        var isMagicActivate = (card.type == "Magic" && (trigger == "activate" || trigger == "" || trigger == "main_phase" || trigger == "quick_effect"));
        var isMonsterActivate = (card.type == "Monster" && (trigger == "activate" || trigger == "ignition" || trigger == "main_phase" || trigger == "quick_effect"));
        
        if (context == "hand") {
             if (!isMagicActivate) {
                 k++;
                 continue;
             }
        }
        if (context == "field") {
             if (!isMagicActivate && !isMonsterActivate) {
                 k++;
                 continue;
             }
        }

        // Validation Générique (Conditions d'activation & Cibles valides)
        // On utilise les scripts partagés sEffectMisc pour garantir que l'IA respecte les mêmes règles que le joueur
        if (!is_undefined(asset_get_index("isEffectActivatable"))) {
            if (!isEffectActivatable(card, effect)) {
                k++;
                continue;
            }
        }

        // --- LOGIQUE DE CIBLAGE ---
        var needsTarget = false;
        var potentialTargets = [];
        var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
        var isMass = (scope == "all");
        var isRandom = (variable_struct_exists(effect, "random_select") && effect.random_select);
        
        // --- PATCH IA : Traduction des cibles relatives (ally/enemy) en absolues (hero/enemy) ---
        var filterStruct = {};
        
        // Copie des champs pertinents pour le filtre
        var keysToCopy = ["target_zone", "include_hand", "include_graveyard", "monster_type", "criteria", "genre", "type", "scope", "random_select", "only_camouflaged"];
        for(var ki=0; ki<array_length(keysToCopy); ki++) {
            var k_prop = keysToCopy[ki];
            if (variable_struct_exists(effect, k_prop)) variable_struct_set(filterStruct, k_prop, variable_struct_get(effect, k_prop));
        }

        // Cas particuliers (Pillage, etc.) : Mapping source_zone -> target_zone pour le filtre
        if (effectType == "pillage") {
             if (!variable_struct_exists(filterStruct, "target_zone") && variable_struct_exists(effect, "source_zone")) {
                 variable_struct_set(filterStruct, "target_zone", variable_struct_get(effect, "source_zone"));
             }
        }
        
        // Gestion de l'owner
        var rawOwner = "both";
        if (variable_struct_exists(effect, "owner")) rawOwner = string_lower(effect.owner);
        else if (effectType == "pillage") rawOwner = "enemy"; // Default for pillage

        if (variable_struct_exists(effect, "ally_only") && effect.ally_only) rawOwner = "ally";
        
        // Traduction pour l'IA (qui est "enemy")
        if (rawOwner == "ally") {
            filterStruct.owner = "enemy"; // L'allié de l'IA est le camp "enemy" (isHeroOwner=false)
        } else if (rawOwner == "enemy") {
            filterStruct.owner = "hero";  // L'ennemi de l'IA est le camp "hero" (isHeroOwner=true)
        } else {
            filterStruct.owner = rawOwner;
        }

        // Si ce n'est pas un effet de zone, on vérifie les cibles (Ciblé ou Aléatoire)
        if (!isMass) {
            // On vérifie s'il y a un filtre explicite ou si le type d'effet nécessite des cibles
            var hasFilter = (variable_struct_exists(filterStruct, "target_zone") || variable_struct_exists(filterStruct, "criteria") || variable_struct_exists(filterStruct, "monster_type"));
            var checkTargets = hasFilter;
            
            // Types nécessitant impérativement une cible (même sans filtre explicite = field par défaut)
            var mustTarget = (effectType == "destroy_target" || effectType == "banish_target" || effectType == "return_to_hand" || effectType == "equip_select_target" || (effectType == "buff" && scope == "single") || effectType == "damage_target" || effectType == "heal_target" || effectType == "entrave" || effectType == "pillage" || effectType == "camouflage" || effectType == "deck_reorder_top3" || effectType == "purge" || (effectType == "summon" && variable_struct_exists(effect, "summon_mode") && effect.summon_mode == "copy_target"));
            if (mustTarget) checkTargets = true;

            if (checkTargets && !is_undefined(asset_get_index("getTargetsByFilter"))) {
                var targetsFound = getTargetsByFilter(filterStruct);
                if (array_length(targetsFound) > 0) {
                    if (isRandom) {
                        // Pour un effet aléatoire, l'existence de cibles suffit à valider le coup.
                        // On ne définit PAS needsTarget=true car on ne veut pas générer N coups.
                    } else {
                        potentialTargets = targetsFound;
                        needsTarget = true;
                    }
                } else {
                    // Si aucune cible n'est trouvée et que c'est aléatoire (mais avec filtre requis), on bloque.
                    if (isRandom) {
                        k++;
                        continue;
                    }
                    if (mustTarget) {
                        k++;
                        continue;
                    }
                }
            }
        }
        else if (isMass) {
             // Pour les effets de masse (ex: Buff de zone), on vérifie qu'il y a au moins une cible valide
             // pour éviter que l'IA ne boucle en essayant de jouer une carte inutile.
             var checkMassTargets = (effectType == "buff"); 
             
             if (checkMassTargets && !is_undefined(asset_get_index("getTargetsByFilter"))) {
                 var targetsFound = getTargetsByFilter(filterStruct);
                 if (array_length(targetsFound) == 0) {
                     k++;
                     continue; // Pas de cibles pour le buff de zone -> on skip
                 }

                 // Règle spécifique : Si le buff ne concerne que les camouflés ("Attaque furtive"), on exige au moins 2 cibles pour rentabiliser
                 if (variable_struct_exists(filterStruct, "only_camouflaged") && filterStruct.only_camouflaged) {
                     if (array_length(targetsFound) < 2) {
                         k++;
                         continue;
                     }
                 }
             }
        }
        
        // Si on a besoin de cible mais qu'on en a pas trouvé (alors que isEffectActivatable a dit oui),
        // c'est peut-être que l'effet ne nécessite pas de cible explicite (ex: Draw, Heal Self).
        // On vérifie si c'est un type d'effet qui DOIT cibler.
        if (needsTarget && array_length(potentialTargets) == 0) {
             var etype = effectType;
             var mustTarget = (etype == "destroy_target" || etype == "banish_target" || etype == "return_to_hand" || etype == "equip_select_target" || (etype == "buff" && scope == "single") || etype == "damage_target" || etype == "heal_target" || etype == "entrave" || etype == "pillage" || etype == "camouflage" || etype == "deck_reorder_top3" || etype == "purge" || (etype == "summon" && variable_struct_exists(effect, "summon_mode") && effect.summon_mode == "copy_target"));
             
             if (mustTarget) {
                 k++;
                 continue; // Pas de cible -> pas de move
             }
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
                var cOwner = (is_struct(card) && variable_struct_exists(card, "isHeroOwner")) ? card.isHeroOwner : ((variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : undefined);
                var tOwner = (is_struct(tCard) && variable_struct_exists(tCard, "isHeroOwner")) ? tCard.isHeroOwner : ((variable_instance_exists(tCard, "isHeroOwner")) ? tCard.isHeroOwner : undefined);
                var isEnemyTarget = (cOwner != undefined && tOwner != undefined && cOwner != tOwner);
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
        
        k++;
    }
}

/// @function AI_GetLegalMoves_Attack()
/// @description Retourne une liste d'attaques possibles (Hearthstone Rules)
function AI_GetLegalMoves_Attack() {
    var moves = [];
    
    if (!instance_exists(oFieldMonsterEnemy) || !instance_exists(oFieldMonsterHero)) return moves;

    var myMonsters = oFieldMonsterEnemy.cards;
    var enemyMonsters = oFieldMonsterHero.cards;
    
    // --- 1. Identify Valid Targets (Taunt & Stealth Rules) ---
    var tauntTargets = [];
    var normalTargets = [];
    var hasActiveTaunt = false;

    // Filter enemy monsters
    for (var j = 0; j < array_length(enemyMonsters); j++) {
        var target = enemyMonsters[j];
        if (target != 0 && instance_exists(target)) {
            // Check Stealth (Camouflage)
            var isStealth = (variable_instance_exists(target, "isCamouflage") && target.isCamouflage);
            if (!isStealth && variable_instance_exists(target, "effects_text") && string_pos("Camouflage", target.effects_text) > 0) isStealth = true;
            
            if (!isStealth) {
                // Check Taunt OR Main Line Blocker (Slots 0-3)
                var isTaunt = (variable_instance_exists(target, "has_taunt") && target.has_taunt);
                // Les monstres sur la ligne principale (0-3) agissent comme des Taunts (bloquent l'accès au héros)
                var isMainLine = (variable_instance_exists(target, "fieldPosition") && target.fieldPosition >= 0 && target.fieldPosition <= 3);
                
                if (isTaunt || isMainLine) {
                    array_push(tauntTargets, target);
                    hasActiveTaunt = true;
                } else {
                    array_push(normalTargets, target);
                }
            }
        }
    }

    var validTargets = hasActiveTaunt ? tauntTargets : normalTargets;

    // --- 2. Generate Moves for Each Attacker ---
    for (var i = 0; i < array_length(myMonsters); i++) {
        var attacker = myMonsters[i];
        if (attacker == 0 || !instance_exists(attacker)) continue;

        // Ensure stats are up-to-date
        if (script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(attacker);
        }

        // Check Entrave
        if (variable_instance_exists(attacker, "entrave_block_attack") && attacker.entrave_block_attack) {
             var turns = variable_instance_exists(attacker, "entrave_turns_remaining") ? attacker.entrave_turns_remaining : 0;
             if (turns > 0) continue;
        }
        
        // Check Summoning Sickness (Charge)
        var isSummonedThisTurn = (variable_instance_exists(attacker, "summonedThisTurn") && attacker.summonedThisTurn);
        var hasCharge = (variable_instance_exists(attacker, "has_charge") && attacker.has_charge);
        
        if (isSummonedThisTurn && !hasCharge) continue;

        // Check Attacks per Turn (Windfury)
        var limit = 1; 
        if (variable_instance_exists(attacker, "isAmbidextrous") && attacker.isAmbidextrous) limit = 2;
        var used = variable_instance_exists(attacker, "attacksUsedThisTurn") ? attacker.attacksUsedThisTurn : 0;
        
        if (used < limit) {
            // 2.1 Attack Minions
            for (var k = 0; k < array_length(validTargets); k++) {
                var target = validTargets[k];
                
                array_push(moves, {
                    type: "attack",
                    attacker: attacker,
                    target: target,
                    isDirect: false
                });
            }

            // 2.2 Attack Direct (Hero) - Only if NO Active Taunt
            if (!hasActiveTaunt) {
                array_push(moves, {
                    type: "attack",
                    attacker: attacker,
                    target: noone,
                    isDirect: true
                });
            }
        }
    }

    return moves;
}

function AI_CountEnemyContinuousByObjectName(objName) {
    var count = 0;
    if (instance_exists(oFieldMagicTrapEnemy)) {
        var boardS = oFieldMagicTrapEnemy.cards;
        for (var i = 0; i < array_length(boardS); i++) {
            var card = boardS[i];
            if (card != 0 && instance_exists(card)) {
                var cname = object_get_name(card.object_index);
                if (cname == objName) {
                    count++;
                }
            }
        }
    }
    return count;
}
