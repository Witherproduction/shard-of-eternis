// oDamageManager - Gestionnaire des dégâts et combats
// Version corrigée - structure unifiée

// Fonction principale de gestion des attaques
tryAttack = function(target) {
    // Vérifications de base
    if (!(instance_exists(game) && (game.phase[game.phase_current] == "Main" || game.phase[game.phase_current] == "Attack"))) {
        var allow = (variable_instance_exists(cardEnemy, "effect_force_direct_attack") && cardEnemy.effect_force_direct_attack);
        if (!allow) { return; }
    }
    // Règle: pas d'attaque au tour 1 du duel - REMOVED FOR HS
    // if (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1) {
    //     return;
    // }

    // Déterminer l'attaquant depuis le SelectManager
    var sm = noone;
    if (instance_exists(oSelectManager) && instance_exists(selectManager)) {
        sm = selectManager;
    } else {
        sm = instance_find(oSelectManager, 0);
    }
    var attacker = noone;
    if (sm != noone && variable_instance_exists(sm, "selected")) {
        attacker = sm.selected;
    }
    if (attacker == noone || attacker == "" || !instance_exists(attacker)) {
        return;
    }
    // Garde type/owner: seules les cartes Monstre du héros peuvent attaquer
    if (!(variable_instance_exists(attacker, "type") && attacker.type == "Monster")) {
        return;
    }
    if (!(variable_instance_exists(attacker, "isHeroOwner") && attacker.isHeroOwner)) {
        return;
    }

    var _limit = 1;
    if (variable_instance_exists(attacker, "isAmbidextrous") && attacker.isAmbidextrous) { _limit = 2; }
    if (variable_instance_exists(attacker, "attacksUsedThisTurn") && attacker.attacksUsedThisTurn >= _limit) {
        return;
    }
    // Vérifier l'orientation - REMOVED FOR HS (Always Attack)
    // if (attacker.orientation != "Attack") {
    //     return;
    // }

    // Déterminer le défenseur depuis le paramètre 'target' (carte cliquée)
    var defender = noone;
    if (target != noone && instance_exists(target)) {
        if (variable_instance_exists(target, "isHeroOwner") && !target.isHeroOwner &&
            variable_instance_exists(target, "zone") && target.zone == "Field" &&
            variable_instance_exists(target, "type") && target.type == "Monster") {
            
            // 1. Check Stealth/Camouflage (Cannot target Stealth)
            if (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) {
                show_debug_message("Target is Stealth - Cannot attack.");
                return;
            }
            
            // 2. Check Taunt/Provocation AND Front Line (m0-m3)
            var targetHasTaunt = (variable_instance_exists(target, "has_taunt") && target.has_taunt);
            var targetIsFrontLine = (variable_instance_exists(target, "fieldPosition") && target.fieldPosition >= 0 && target.fieldPosition <= 3);
            var targetIsDefender = (targetHasTaunt || targetIsFrontLine);
            
            // If target is NOT a Defender, check if a Defender exists elsewhere
            if (!targetIsDefender) {
                 var defenderBlockerExists = false;
                 if (instance_exists(fieldManagerEnemy)) {
                    var arrEnemy = fieldMonsterEnemy.cards;
                    for (var ie = 0; ie < array_length(arrEnemy); ie++) {
                        var em = arrEnemy[ie];
                        if (em != 0 && instance_exists(em)) {
                            var emTaunt = (variable_instance_exists(em, "has_taunt") && em.has_taunt);
                            var emFrontLine = (variable_instance_exists(em, "fieldPosition") && em.fieldPosition >= 0 && em.fieldPosition <= 3);
                            var emIsDefender = (emTaunt || emFrontLine);
                            
                            var emCamo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
                            
                            // A blocker must be a Defender AND NOT be Stealth
                            if (emIsDefender && !emCamo) {
                                defenderBlockerExists = true;
                                break;
                            }
                        }
                    }
                 }
                 
                 if (defenderBlockerExists) {
                     // Percée (isPercee) allows bypassing Front Line/Taunt
                     var allowBypass = (variable_instance_exists(attacker, "isPercee") && attacker.isPercee);
                     if (!allowBypass) {
                         show_debug_message("Must attack Defender minion (Taunt or Front Line)!");
                         return;
                     }
                 }
            }
            
            defender = target;
        }
    }

    // Combat: démarrage (debug supprimé)

    // Effet visuel de combat si activé
    if (variable_global_exists("USE_COMBAT_FX") && global.USE_COMBAT_FX) {
        var fx = instance_create_layer(attacker.x, attacker.y, "Instances", FX_Combat);
        if (fx != noone) {
            fx.attacker = attacker;
            fx.defender = defender;
            fx.mode = (defender != noone) ? "vsMonster" : "direct";
        }
    } else {
        // Résolution directe sans FX
        if (defender == noone) {
            // Check Taunt/FrontLine for Direct Attack
            var defenderBlockerExists = false;
            if (instance_exists(fieldManagerEnemy)) {
                var arrEnemy = fieldMonsterEnemy.cards;
                for (var ie = 0; ie < array_length(arrEnemy); ie++) {
                    var em = arrEnemy[ie];
                    if (em != 0 && instance_exists(em)) {
                        var emTaunt = (variable_instance_exists(em, "has_taunt") && em.has_taunt);
                        var emFrontLine = (variable_instance_exists(em, "fieldPosition") && em.fieldPosition >= 0 && em.fieldPosition <= 3);
                        var emIsDefender = (emTaunt || emFrontLine);
                        
                        var emCamo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
                        
                        // Stealth disables Taunt/Defender status for blocking
                        if (emIsDefender && !emCamo) {
                            defenderBlockerExists = true;
                            break;
                        }
                    }
                }
            }
            
            if (defenderBlockerExists) {
                // Percée logic for Direct Attack
                var allowBypass = (variable_instance_exists(attacker, "isPercee") && attacker.isPercee);
                var allowAlways = (variable_instance_exists(attacker, "canAttackDirectAlways") && attacker.canAttackDirectAlways);
                
                if (!allowBypass && !allowAlways) {
                    show_debug_message("Direct Attack Blocked by Defender (Taunt or Front Line)");
                    return;
                }
            }

            resolveAttackDirect(attacker);
        } else {
            resolveAttackMonster(attacker, defender);
        }
    }
}

// Résolution d'attaque contre un monstre
resolveAttackMonster = function(cardHero, cardEnemy) {
    // Début de résolution (debug supprimé)
    
    // Phase guard (HS Main Phase or Legacy Attack Phase)
    var is_tutorial = instance_exists(oTutorielManager);
    if (!(instance_exists(game) && (game.phase[game.phase_current] == "Main" || game.phase[game.phase_current] == "Attack" || is_tutorial))) {
        return;
    }
    
    // Trouver les instances LP (optionnel en HS minion vs minion, mais gardons les refs)
    var LP_Hero_Instance = instance_find(oLP_Hero, 0);
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    
    // Révéler la carte ennemie si elle est face cachée (HS n'a pas de face cachée, mais on garde pour compatibilité)
    if (cardEnemy != noone && instance_exists(cardEnemy) && variable_instance_exists(cardEnemy, "isFaceDown") && cardEnemy.isFaceDown) {
        cardEnemy.isFaceDown = false;
        cardEnemy.orientation = "Attack"; // Force Attack
        cardEnemy.image_index = 0;
        cardEnemy.image_angle = (cardEnemy.isHeroOwner ? 90 : 270);
    }
    
    var defenderFieldPos = (cardEnemy != noone && instance_exists(cardEnemy) && variable_instance_exists(cardEnemy, "fieldPosition")) ? cardEnemy.fieldPosition : -1;
    
    // Enregistrer les événements de combat
    registerTriggerEvent(TRIGGER_ON_ATTACK, cardHero, { 
        attacker: cardHero, 
        defender: cardEnemy, 
        defender_orientation: "Attack", 
        defender_field_position: defenderFieldPos,
        direct_attack: false 
    });
    
    // Activer les secrets
    activateSecretsOnAttack(cardHero, cardEnemy);
    
    if (variable_global_exists("combat_attack_blocked") && global.combat_attack_blocked) {
        show_debug_message("### resolveAttackMonster: Attack blocked by secret");
        if (instance_exists(cardHero)) {
            cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
            cardHero.lastTurnAttack = game.nbTurn;
            if (instance_exists(oSelectManager)) { selectManager.unSelect(cardHero); }
        }
        return;
    }

    if (cardHero == noone || !instance_exists(cardHero) || cardEnemy == noone || !instance_exists(cardEnemy)) {
        if (instance_exists(cardHero)) {
            cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
            cardHero.lastTurnAttack = game.nbTurn;
            if (instance_exists(oSelectManager)) { selectManager.unSelect(cardHero); }
        }
        return;
    }
    
    // --- HEARTHSTONE COMBAT LOGIC ---
    // Correction: Use variable_instance_exists for instances to ensure correct property retrieval
    var effHeroAtk = (variable_instance_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack);
    var effEnemyAtk = (variable_instance_exists(cardEnemy, "effective_attack") ? cardEnemy.effective_attack : cardEnemy.attack);
    
    show_debug_message("### resolveAttackMonster: Hero=" + string(cardHero) + " Atk=" + string(effHeroAtk) + " Enemy=" + string(cardEnemy));

    // 1. Dégâts simultanés (Persistent Damage)
    // On utilise damageCard qui gère current_hp -= amount et la destruction si <= 0
    if (effHeroAtk > 0) {
        var bonusDmgE = (!is_undefined(getAttackDamageTakenBonus)) ? getAttackDamageTakenBonus(cardEnemy) : 0;
        damageCard(cardEnemy, effHeroAtk + bonusDmgE, cardHero);
    }
    if (effEnemyAtk > 0) {
        var bonusDmgH = (!is_undefined(getAttackDamageTakenBonus)) ? getAttackDamageTakenBonus(cardHero) : 0;
        damageCard(cardHero, effEnemyAtk + bonusDmgH, cardEnemy);
    }

    // Repoussement: si l'attaquant a le mot-clé, décale la cible de la front line vers la ligne de retrait (même colonne) si un slot est libre
    if (instance_exists(cardHero) && instance_exists(cardEnemy) && effHeroAtk > 0 && !is_undefined(tryRepoussement) && !is_undefined(cardHasRepoussement) && cardHasRepoussement(cardHero)) {
        tryRepoussement(cardHero, cardEnemy);
    }

    
    // 2. Gestion du Poison (si dégâts > 0 et survivant)
    var heroIsPoisoner = (variable_instance_exists(cardHero, "isPoisoner") && cardHero.isPoisoner);
    if (instance_exists(cardEnemy) && effHeroAtk > 0 && heroIsPoisoner) {
         show_debug_message("### Poison Triggered by Hero");
         spawnPoisonFX(cardEnemy, cardHero);
         destroyCard(cardEnemy, cardHero);
    }
    
    var enemyIsPoisoner = (variable_instance_exists(cardEnemy, "isPoisoner") && cardEnemy.isPoisoner);
    if (instance_exists(cardHero) && effEnemyAtk > 0 && enemyIsPoisoner) {
         show_debug_message("### Poison Triggered by Enemy");
         spawnPoisonFX(cardHero, cardEnemy);
         destroyCard(cardHero, cardEnemy);
    }
    // --------------------------------
    
    if (instance_exists(cardHero)) {
        var defExistsAfter = instance_exists(cardEnemy);
        registerTriggerEvent(TRIGGER_AFTER_ATTACK, cardHero, {
            attacker: cardHero,
            defender: defExistsAfter ? cardEnemy : noone,
            target: defExistsAfter ? cardEnemy : noone,
            defender_orientation: "Attack",
            defender_field_position: defenderFieldPos,
            direct_attack: false
        });
    }
    
    // Marquer l'attaque comme utilisée
    if (instance_exists(cardHero)) {
        cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
        cardHero.lastTurnAttack = game.nbTurn;
        if (variable_instance_exists(cardHero, "isCamouflage") && cardHero.isCamouflage) {
            var keepCamoThisTurn = (variable_instance_exists(cardHero, "keepCamouflageTurn") && instance_exists(game) && variable_instance_exists(game, "nbTurn") && cardHero.keepCamouflageTurn == game.nbTurn);
            if (!keepCamoThisTurn) { cardHero.isCamouflage = false; }
        }
    }
    
    // Désélectionner la carte
    if (instance_exists(oSelectManager)) {
        selectManager.unSelect(cardHero);
    }
}


// Legacy functions (resolveAttackVsAttack, resolveAttackVsDefense) removed for Hearthstone combat style.




// Attaque directe
resolveAttackDirect = function(cardHero) {
    // Debug attaque directe supprimé
    // Triggers & Secrets (attaque directe contre l’ennemi)
    registerTriggerEvent(TRIGGER_ON_ATTACK, cardHero, { attacker: cardHero, defender: noone, direct_attack: true });
    
    // Initialisation de la redirection (via globale pour support Command Pattern)
    global.combat_redirect_defender = noone;
    var redirectedDefender = noone;
    
    if (!is_undefined(activateSecretsOnDirectAttack)) {
        // La fonction ne retourne plus directement la redirection si elle passe par Command Pattern,
        // mais elle déclenche l'effet qui remplit global.combat_redirect_defender via le Controller.
        // Pour rétro-compatibilité immédiate, on garde le return si la fonction le fait encore,
        // mais on vérifie aussi la globale.
        var res = activateSecretsOnDirectAttack(cardHero);
        if (res != noone && instance_exists(res)) redirectedDefender = res;
    }
    
    if (variable_global_exists("combat_attack_blocked") && global.combat_attack_blocked) {
        show_debug_message("### resolveAttackDirect: Attack blocked by secret");
        if (instance_exists(cardHero)) {
            cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
            cardHero.lastTurnAttack = game.nbTurn;
            if (instance_exists(oSelectManager)) { selectManager.unSelect(cardHero); }
        }
        return;
    }
    
    if (global.combat_redirect_defender != noone && instance_exists(global.combat_redirect_defender)) {
        redirectedDefender = global.combat_redirect_defender;
    }

    // Si un Secret adverse a redirigé l’attaque vers une invocation, résoudre comme une attaque vs monstre
    if (redirectedDefender != noone && instance_exists(redirectedDefender)) {
        resolveAttackMonster(cardHero, redirectedDefender);
        return;
    }
    
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Enemy_Instance == noone) {
        return;
    }
    
    var damage = (variable_instance_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack);
    var didDamage = false;
    if (!is_undefined(loseLPFor)) {
        didDamage = loseLPFor(false, damage);
    } else {
        LP_Enemy_Instance.nbLP = max(0, LP_Enemy_Instance.nbLP - damage);
        didDamage = (damage > 0);
    }
    if (!is_undefined(cardHasPonction) && !is_undefined(gainLPFor) && didDamage && damage > 0 && cardHasPonction(cardHero)) {
        gainLPFor(true, damage);
    }
    
    
    // Marquer l'attaque comme utilisée
    if (instance_exists(cardHero)) {
        cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
        cardHero.lastTurnAttack = game.nbTurn;
        if (variable_instance_exists(cardHero, "effect_force_direct_attack") && cardHero.effect_force_direct_attack) {
            cardHero.effect_force_direct_attack = false;
        }
        if (variable_instance_exists(cardHero, "isCamouflage") && cardHero.isCamouflage) {
            var keepCamoDT = (variable_instance_exists(cardHero, "keepCamouflageTurn") && instance_exists(game) && variable_instance_exists(game, "nbTurn") && cardHero.keepCamouflageTurn == game.nbTurn);
            if (!keepCamoDT) { cardHero.isCamouflage = false; }
        }
    }
    
    // Désélectionner
    if (instance_exists(oSelectManager)) {
        selectManager.unSelect(cardHero);
    }
}

// Initiate Enemy Monster Attack (with FX)
initiateAttackMonsterEnemy = function(attacker, defender) {
    if (attacker == noone || !instance_exists(attacker)) return;
    var _limitE = 1; if (variable_instance_exists(attacker, "isAmbidextrous") && attacker.isAmbidextrous) { _limitE = 2; }
    if (variable_instance_exists(attacker, "attacksUsedThisTurn") && attacker.attacksUsedThisTurn >= _limitE) { return; }
    
    // Mark attack as used immediately
    attacker.attacksUsedThisTurn = (variable_instance_exists(attacker, "attacksUsedThisTurn") ? attacker.attacksUsedThisTurn : 0) + 1;
    if (instance_exists(game)) attacker.lastTurnAttack = game.nbTurn;
    
    if (variable_instance_exists(attacker, "isCamouflage") && attacker.isCamouflage) {
        var keepCamoE = (variable_instance_exists(attacker, "keepCamouflageTurn") && instance_exists(game) && variable_instance_exists(game, "nbTurn") && attacker.keepCamouflageTurn == game.nbTurn);
        if (!keepCamoE) { attacker.isCamouflage = false; }
    }
    
    // FX check
    if (variable_global_exists("USE_COMBAT_FX") && global.USE_COMBAT_FX) {
        var fx = instance_create_layer(attacker.x, attacker.y, "Instances", FX_Combat);
        if (fx != noone) {
            fx.attacker = attacker;
            fx.defender = defender;
            fx.mode = "vsMonster";
        }
    } else {
        resolveAttackMonsterEnemy(attacker, defender);
    }
};

// Initiate Enemy Direct Attack (with FX)
initiateAttackDirectEnemy = function(cardEnemy) {
    if (cardEnemy == noone || !instance_exists(cardEnemy)) return;

    // Vérification Entrave
    if (variable_instance_exists(cardEnemy, "entrave_block_attack") && cardEnemy.entrave_block_attack) {
        var turns = variable_instance_exists(cardEnemy, "entrave_turns_remaining") ? cardEnemy.entrave_turns_remaining : 0;
        if (turns > 0) return;
    }

    var _limitED = 1; if (variable_instance_exists(cardEnemy, "isAmbidextrous") && cardEnemy.isAmbidextrous) { _limitED = 2; }
    if (variable_instance_exists(cardEnemy, "attacksUsedThisTurn") && cardEnemy.attacksUsedThisTurn >= _limitED) { return; }
    
    // Mark attack as used immediately
    cardEnemy.attacksUsedThisTurn = (variable_instance_exists(cardEnemy, "attacksUsedThisTurn") ? cardEnemy.attacksUsedThisTurn : 0) + 1;
    if (instance_exists(game)) cardEnemy.lastTurnAttack = game.nbTurn;
    
    if (variable_instance_exists(cardEnemy, "effect_force_direct_attack") && cardEnemy.effect_force_direct_attack) {
        cardEnemy.effect_force_direct_attack = false;
    }
    if (variable_instance_exists(cardEnemy, "isCamouflage") && cardEnemy.isCamouflage) {
        var keepCamoDE = (variable_instance_exists(cardEnemy, "keepCamouflageTurn") && instance_exists(game) && variable_instance_exists(game, "nbTurn") && cardEnemy.keepCamouflageTurn == game.nbTurn);
        if (!keepCamoDE) { cardEnemy.isCamouflage = false; }
    }
    
    // FX check
    if (variable_global_exists("USE_COMBAT_FX") && global.USE_COMBAT_FX) {
        var fx = instance_create_layer(cardEnemy.x, cardEnemy.y, "Instances", FX_Combat);
        if (fx != noone) {
            fx.attacker = cardEnemy;
            fx.defender = noone;
            fx.mode = "direct";
        }
    } else {
        resolveAttackDirectEnemy(cardEnemy);
    }
};

// Version pour l'ennemi (si nécessaire)
resolveAttackMonsterEnemy = function(attacker, defender) {
    if (attacker == noone || !instance_exists(attacker)) return;
    
    // Phase guard (HS Main Phase or Legacy Attack Phase)
    if (!(instance_exists(game) && (game.phase[game.phase_current] == "Main" || game.phase[game.phase_current] == "Attack"))) {
        return;
    }
    
    var LP_Hero_Instance = instance_find(oLP_Hero, 0);
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    
    // Révéler le défenseur si face cachée (HS n'a pas de face cachée, mais on garde pour compatibilité)
    if (defender != noone && instance_exists(defender) && variable_instance_exists(defender, "isFaceDown") && defender.isFaceDown) {
        defender.isFaceDown = false;
        defender.orientation = "Attack"; // Force Attack
        defender.image_index = 0;
        defender.image_angle = (defender.isHeroOwner ? 90 : 270);
    }
    
    registerTriggerEvent(TRIGGER_ON_ATTACK, attacker, { attacker: attacker, defender: defender, defender_orientation: "Attack", direct_attack: false });
    activateSecretsOnAttack(attacker, defender);
    
    if (variable_global_exists("combat_attack_blocked") && global.combat_attack_blocked) {
        show_debug_message("### resolveAttackMonsterEnemy: Attack blocked by secret");
        if (instance_exists(attacker)) {
            attacker.attacksUsedThisTurn = (variable_instance_exists(attacker, "attacksUsedThisTurn") ? attacker.attacksUsedThisTurn : 0) + 1;
            attacker.lastTurnAttack = game.nbTurn;
        }
        return;
    }

    if (attacker == noone || !instance_exists(attacker) || defender == noone || !instance_exists(defender)) {
        if (instance_exists(attacker)) {
            attacker.attacksUsedThisTurn = (variable_instance_exists(attacker, "attacksUsedThisTurn") ? attacker.attacksUsedThisTurn : 0) + 1;
            attacker.lastTurnAttack = game.nbTurn;
        }
        return;
    }

    // Déclencher l'événement de défense côté héros avant la résolution
    if (defender != noone && instance_exists(defender)) {
        registerTriggerEvent(TRIGGER_ON_DEFENSE, defender, {
            attacker: attacker,
            defender: defender,
            target: defender,
            direct_attack: false
        });
    }
    
    if (attacker == noone || !instance_exists(attacker) || defender == noone || !instance_exists(defender)) {
        return;
    }
    
    if (variable_instance_exists(defender, "isCamouflage") && defender.isCamouflage) {
        var heroHasNonCamo = false;
        var arrHero = fieldMonsterHero.cards;
        for (var ih = 0; ih < array_length(arrHero); ih++) {
            var ch = arrHero[ih];
            if (ch != 0 && instance_exists(ch)) {
                var camoH = (variable_instance_exists(ch, "isCamouflage") && ch.isCamouflage);
                if (!camoH) { heroHasNonCamo = true; break; }
            }
        }
        if (!heroHasNonCamo) {
            resolveAttackDirectEnemy(attacker);
        }
        return;
    }
    
    // --- HEARTHSTONE COMBAT LOGIC (Enemy vs Hero Monster) ---
    var effAttackerAtk = variable_struct_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
    var effDefenderAtk = variable_struct_exists(defender, "effective_attack") ? defender.effective_attack : defender.attack;
    
    // 1. Dégâts simultanés (Persistent Damage)
    if (effAttackerAtk > 0) damageCard(defender, effAttackerAtk, attacker);
    if (effDefenderAtk > 0) damageCard(attacker, effDefenderAtk, defender);
    
    // 2. Gestion du Poison
    if (instance_exists(defender) && effAttackerAtk > 0 && variable_struct_exists(attacker, "isPoisoner") && attacker.isPoisoner) {
         spawnPoisonFX(defender, attacker);
         destroyCard(defender, attacker);
    }
    
    if (instance_exists(attacker) && effDefenderAtk > 0 && variable_struct_exists(defender, "isPoisoner") && defender.isPoisoner) {
         spawnPoisonFX(attacker, defender);
         destroyCard(attacker, defender);
    }
    // --------------------------------------------------------
    
    // Déclencher l'événement post-attaque côté ennemi avec la cible (défenseur héros)
    if (instance_exists(attacker)) {
        var defExists3 = instance_exists(defender);
        registerTriggerEvent(TRIGGER_AFTER_ATTACK, attacker, {
            attacker: attacker,
            defender: defExists3 ? defender : noone,
            target: defExists3 ? defender : noone,
            defender_orientation: "Attack",
            direct_attack: false
        });
    }
};

// Version pour l'ennemi (si nécessaire)
resolveAttackDirectEnemy = function(cardEnemy) {
    if (cardEnemy == noone || !instance_exists(cardEnemy)) return;
    
    // Phase guard (HS Main Phase or Legacy Attack Phase)
    if (!(instance_exists(game) && (game.phase[game.phase_current] == "Main" || game.phase[game.phase_current] == "Attack"))) {
        return;
    }
    
    // Note: On ne vérifie PLUS le nombre d'attaques ici car initiateAttackDirectEnemy
    // l'a déjà incémenté AVANT l'animation.
    // var _limitED = 1; if (variable_instance_exists(cardEnemy, "isAmbidextrous") && cardEnemy.isAmbidextrous) { _limitED = 2; }
    // if (variable_instance_exists(cardEnemy, "attacksUsedThisTurn") && cardEnemy.attacksUsedThisTurn >= _limitED) { return; }
    
    // Triggers & Secrets (attaque directe contre le héros)
    registerTriggerEvent(TRIGGER_ON_ATTACK, cardEnemy, { attacker: cardEnemy, defender: noone, direct_attack: true });
    var redirectedDefender = noone;
    if (!is_undefined(activateSecretsOnDirectAttack)) {
        redirectedDefender = activateSecretsOnDirectAttack(cardEnemy);
    }
    
    if (variable_global_exists("combat_attack_blocked") && global.combat_attack_blocked) {
        show_debug_message("### resolveAttackDirectEnemy: Attack blocked by secret");
        if (instance_exists(cardEnemy)) {
            cardEnemy.attacksUsedThisTurn = (variable_instance_exists(cardEnemy, "attacksUsedThisTurn") ? cardEnemy.attacksUsedThisTurn : 0) + 1;
            cardEnemy.lastTurnAttack = game.nbTurn;
        }
        return;
    }
    
    show_debug_message("### resolveAttackDirectEnemy: entry attacker=" + string(cardEnemy) + " redirected=" + string(instance_exists(redirectedDefender)));
    // Si un Secret a redirigé l’attaque vers une invocation, résoudre comme une attaque vs monstre
    if (redirectedDefender != noone && instance_exists(redirectedDefender)) {
        show_debug_message("### resolveAttackDirectEnemy: redirected to defender=" + string(redirectedDefender));
        if (variable_instance_exists(id, "resolveAttackMonsterEnemy")) {
            with (id) resolveAttackMonsterEnemy(cardEnemy, redirectedDefender);
        } else {
            // Fallback minimal si l’API n’existe pas: pas de dégâts directs, marquer l’attaque
            if (instance_exists(cardEnemy)) {
                cardEnemy.attacksUsedThisTurn = (variable_instance_exists(cardEnemy, "attacksUsedThisTurn") ? cardEnemy.attacksUsedThisTurn : 0) + 1;
                cardEnemy.lastTurnAttack = game.nbTurn;
            }
        }
        return;
    }
    var LP_Hero_Instance = instance_find(oLP_Hero, 0);
    if (LP_Hero_Instance == noone && instance_exists(LP_Hero)) {
        LP_Hero_Instance = LP_Hero;
    }
    if (LP_Hero_Instance == noone) {
        show_debug_message("### resolveAttackDirectEnemy: oLP_Hero introuvable, dégâts non appliqués");
        return;
    }
    var effEnemyAtk = (variable_struct_exists(cardEnemy, "effective_attack") ? cardEnemy.effective_attack : (variable_instance_exists(cardEnemy, "attack") ? cardEnemy.attack : 0));
    var damage = max(0, effEnemyAtk);
    show_debug_message("### resolveAttackDirectEnemy: ATK=" + string(effEnemyAtk) + " dmg=" + string(damage));
    var didDamage = false;
    if (!is_undefined(loseLPFor)) {
        didDamage = loseLPFor(true, damage);
    } else {
        LP_Hero_Instance.nbLP = max(0, LP_Hero_Instance.nbLP - damage);
        didDamage = (damage > 0);
    }
    show_debug_message("### resolveAttackDirectEnemy: LP_Hero now=" + string(LP_Hero_Instance.nbLP));
    if (!is_undefined(cardHasPonction) && !is_undefined(gainLPFor) && didDamage && damage > 0 && cardHasPonction(cardEnemy)) {
        gainLPFor(false, damage);
    }
    
    // Marquer l'attaque côté ennemi - DÉPLACÉ DANS initiateAttackDirectEnemy

};


