// oDamageManager - Gestionnaire des dégâts et combats
// Version corrigée - structure unifiée

// Fonction principale de gestion des attaques
tryAttack = function(target) {
    // Vérifications de base
    if (!(instance_exists(game) && game.phase[game.phase_current] == "Attack")) {
        var allow = (variable_instance_exists(cardEnemy, "effect_force_direct_attack") && cardEnemy.effect_force_direct_attack);
        if (!allow) { return; }
    }
    // Règle: pas d'attaque au tour 1 du duel
    if (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1) {
        return;
    }

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
    // Vérifier l'orientation
    if (attacker.orientation != "Attack") {
        return;
    }

    // Déterminer le défenseur depuis le paramètre 'target' (carte cliquée)
    var defender = noone;
    if (target != noone && instance_exists(target)) {
        if (variable_instance_exists(target, "isHeroOwner") && !target.isHeroOwner &&
            variable_instance_exists(target, "zone") && target.zone == "Field" &&
            variable_instance_exists(target, "type") && target.type == "Monster") {
            if (variable_instance_exists(target, "isCamouflage") && target.isCamouflage) {
                var enemyHasNonCamo = false;
                if (instance_exists(fieldManagerEnemy)) {
                    var arrEnemy = fieldMonsterEnemy.cards;
                    for (var ie = 0; ie < array_length(arrEnemy); ie++) {
                        var em = arrEnemy[ie];
                        if (em != 0 && instance_exists(em)) {
                            var camo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
                            if (!camo) { enemyHasNonCamo = true; break; }
                        }
                    }
                }
                if (!enemyHasNonCamo) {
                    defender = noone;
                } else {
                    return;
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
            resolveAttackDirect(attacker);
        } else {
            resolveAttackMonster(attacker, defender);
        }
    }
}

// Résolution d'attaque contre un monstre
resolveAttackMonster = function(cardHero, cardEnemy) {
    // Début de résolution (debug supprimé)
    
    // Phase guard
    if (!(instance_exists(game) && game.phase[game.phase_current] == "Attack")) {
        return;
    }
    
    // Trouver les instances LP
    var LP_Hero_Instance = instance_find(oLP_Hero, 0);
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    
    if (LP_Hero_Instance == noone) {
        return;
    }
    
    if (LP_Enemy_Instance == noone) {
        return;
    }
    
    
    // Révéler la carte ennemie si elle est face cachée
    if (cardEnemy != noone && instance_exists(cardEnemy) && variable_instance_exists(cardEnemy, "isFaceDown") && cardEnemy.isFaceDown) {
        cardEnemy.isFaceDown = false;
        if (cardEnemy.orientation == "Defense") cardEnemy.orientation = "DefenseVisible";
        cardEnemy.image_index = 0;
        cardEnemy.image_angle = (cardEnemy.isHeroOwner ? 90 : 270);
    }
    
    // Enregistrer les événements de combat
    registerTriggerEvent(TRIGGER_ON_ATTACK, cardHero, { 
        attacker: cardHero, 
        defender: cardEnemy, 
        defender_orientation: cardEnemy.orientation, 
        direct_attack: false 
    });
    
    // Activer les secrets
    activateSecretsOnAttack(cardHero, cardEnemy);

    if (cardHero == noone || !instance_exists(cardHero) || cardEnemy == noone || !instance_exists(cardEnemy)) {
        if (instance_exists(cardHero)) {
            cardHero.attacksUsedThisTurn = (variable_instance_exists(cardHero, "attacksUsedThisTurn") ? cardHero.attacksUsedThisTurn : 0) + 1;
            cardHero.lastTurnAttack = game.nbTurn;
            if (instance_exists(oSelectManager)) { selectManager.unSelect(cardHero); }
        }
        return;
    }
    
    // Combat selon l'orientation de l'ennemi
    if (cardEnemy != noone && instance_exists(cardEnemy) && cardEnemy.orientation == "Attack") {
        var effHeroAtk = variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack;
        var effEnemyAtk = variable_struct_exists(cardEnemy, "effective_attack") ? cardEnemy.effective_attack : cardEnemy.attack;
        var isPois = (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner);
        if (isPois) {
            if (effHeroAtk > effEnemyAtk) {
                var damage = effHeroAtk - effEnemyAtk;
                LP_Enemy_Instance.nbLP -= damage;
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardEnemy, cardHero);
            } else if (effHeroAtk == effEnemyAtk) {
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardHero, cardEnemy);
                destroyCard(cardEnemy, cardHero);
            } else {
                var damage2 = effEnemyAtk - effHeroAtk;
                LP_Hero_Instance.nbLP -= damage2;
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardHero, cardEnemy);
                destroyCard(cardEnemy, cardHero);
            }
        } else {
            resolveAttackVsAttack(cardHero, cardEnemy, LP_Hero_Instance, LP_Enemy_Instance);
        }
    } else if (cardEnemy != noone && instance_exists(cardEnemy) && (cardEnemy.orientation == "Defense" || cardEnemy.orientation == "DefenseVisible")) {
        var effHeroAtk2 = variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack;
        var effEnemyDef = variable_struct_exists(cardEnemy, "effective_defense") ? cardEnemy.effective_defense : cardEnemy.defense;
        var isPois2 = (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner);
        if (isPois2) {
            if (effHeroAtk2 > effEnemyDef) {
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardEnemy, cardHero);
            } else if (effHeroAtk2 == effEnemyDef) {
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardEnemy, cardHero);
            } else {
                var damage3 = effEnemyDef - effHeroAtk2;
                LP_Hero_Instance.nbLP -= damage3;
                spawnPoisonFX(cardEnemy, cardHero);
                destroyCard(cardEnemy, cardHero);
            }
        } else {
            resolveAttackVsDefense(cardHero, cardEnemy, LP_Hero_Instance, LP_Enemy_Instance);
        }
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

// Combat Attaque vs Attaque
resolveAttackVsAttack = function(cardHero, cardEnemy, LP_Hero_Instance, LP_Enemy_Instance) {
    var effHeroAtk = variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack;
    var effEnemyAtk = variable_struct_exists(cardEnemy, "effective_attack") ? cardEnemy.effective_attack : cardEnemy.attack;
    
    // Debug ATK Héros/ATK Ennemi supprimé
    
    if (effHeroAtk > effEnemyAtk) {
        // Héros gagne - Ennemi détruit, dégâts aux LP ennemis
        var damage = effHeroAtk - effEnemyAtk;
        
        LP_Enemy_Instance.nbLP -= damage;
        
        if (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner) {
            spawnPoisonFX(cardEnemy, cardHero);
        }
        destroyCard(cardEnemy, cardHero);
        
    } else if (effHeroAtk == effEnemyAtk) {
        // Égalité
        var isPoisoner = (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner);
        if (isPoisoner) {
            // Empoisonneur: défenseur détruit par poison, attaquant survit
            
            spawnPoisonFX(cardEnemy, cardHero);
            destroyCard(cardEnemy, cardHero);
        } else {
            // Cas normal: destruction mutuelle
            
            destroyCard(cardHero, cardEnemy);
            destroyCard(cardEnemy, cardHero);
        }
        
    } else {
        // Héros perd - Héros détruit, dégâts aux LP du héros
        var damage = effEnemyAtk - effHeroAtk;
        
        LP_Hero_Instance.nbLP -= damage;
        
        destroyCard(cardHero, cardEnemy);
        if (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner) {
            spawnPoisonFX(cardEnemy, cardHero);
            destroyCard(cardEnemy, cardHero);
        }
    }

    // Déclencher l'événement post-attaque même si le défenseur a été détruit
    if (instance_exists(cardHero)) {
        var defExists1 = instance_exists(cardEnemy);
        registerTriggerEvent(TRIGGER_AFTER_ATTACK, cardHero, {
            attacker: cardHero,
            defender: defExists1 ? cardEnemy : noone,
            target: defExists1 ? cardEnemy : noone,
            defender_orientation: (defExists1 && variable_instance_exists(cardEnemy, "orientation")) ? cardEnemy.orientation : "unknown",
            direct_attack: false
        });
    }
}

// Combat Attaque vs Défense
resolveAttackVsDefense = function(cardHero, cardEnemy, LP_Hero_Instance, LP_Enemy_Instance) {
    var effHeroAtk = variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack;
    var effEnemyDef = variable_struct_exists(cardEnemy, "effective_defense") ? cardEnemy.effective_defense : cardEnemy.defense;
    
    // Debug ATK/DEF supprimé
    
    if (effHeroAtk > effEnemyDef) {
        // Héros gagne - Ennemi détruit, pas de dégâts aux LP
        
        destroyCard(cardEnemy, cardHero);
        
    } else if (effHeroAtk == effEnemyDef) {
        // Égalité - Pas de destruction (sauf poison)
        
        if (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner) {
            spawnPoisonFX(cardEnemy, cardHero);
            destroyCard(cardEnemy, cardHero);
        }
        
    } else {
        // Héros perd - Dégâts aux LP du héros
        var damage = effEnemyDef - effHeroAtk;
        
        LP_Hero_Instance.nbLP -= damage;
        
        
        // Poison si applicable
        if (variable_struct_exists(cardHero, "isPoisoner") && cardHero.isPoisoner) {
            spawnPoisonFX(cardEnemy, cardHero);
            destroyCard(cardEnemy, cardHero);
        }
    }

    // Déclencher l'événement post-attaque même si le défenseur a été détruit
    if (instance_exists(cardHero)) {
        var defExists2 = instance_exists(cardEnemy);
        registerTriggerEvent(TRIGGER_AFTER_ATTACK, cardHero, {
            attacker: cardHero,
            defender: defExists2 ? cardEnemy : noone,
            target: defExists2 ? cardEnemy : noone,
            defender_orientation: (defExists2 && variable_instance_exists(cardEnemy, "orientation")) ? cardEnemy.orientation : "unknown",
            direct_attack: false
        });
    }
}



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
    
    var damage = variable_struct_exists(cardHero, "effective_attack") ? cardHero.effective_attack : cardHero.attack;
    LP_Enemy_Instance.nbLP -= damage;
    
    
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
    
    // Note: On ne vérifie PLUS le nombre d'attaques ici car initiateAttackMonsterEnemy
    // l'a déjà incémenté AVANT l'animation.
    // var _limitE = 1; if (variable_instance_exists(attacker, "isAmbidextrous") && attacker.isAmbidextrous) { _limitE = 2; }
    // if (variable_instance_exists(attacker, "attacksUsedThisTurn") && attacker.attacksUsedThisTurn >= _limitE) { return; }
    
    if (!(instance_exists(game) && game.phase[game.phase_current] == "Attack")) {

        return;
    }
    
    var LP_Hero_Instance = instance_find(oLP_Hero, 0);
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Hero_Instance == noone || LP_Enemy_Instance == noone) {
        return;
    }
    
    show_debug_message("### resolveAttackMonsterEnemy: entry attacker=" + string(attacker) + " defender=" + string(defender));
    
    // Révéler le défenseur si face cachée
    if (defender != noone && instance_exists(defender) && variable_instance_exists(defender, "isFaceDown") && defender.isFaceDown) {
        defender.isFaceDown = false;
        if (defender.orientation == "Defense") defender.orientation = "DefenseVisible";
        defender.image_index = 0;
        defender.image_angle = (defender.isHeroOwner ? 90 : 270);
        
    }
    
    registerTriggerEvent(TRIGGER_ON_ATTACK, attacker, { attacker: attacker, defender: defender, defender_orientation: (defender != noone ? defender.orientation : "unknown"), direct_attack: false });
    activateSecretsOnAttack(attacker, defender);
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
    if (attacker == noone || !instance_exists(attacker)) {
        return;
    }
    
    if (defender == noone || !instance_exists(defender)) {
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
    
    if (defender != noone && instance_exists(defender) && defender.orientation == "Attack") {
        var effEnemyAtk = variable_struct_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
        var effHeroAtk  = variable_struct_exists(defender, "effective_attack") ? defender.effective_attack : defender.attack;
        var isPoisE = (variable_struct_exists(attacker, "isPoisoner") && attacker.isPoisoner);
        if (isPoisE) {
            if (effEnemyAtk > effHeroAtk) {
                var damage = effEnemyAtk - effHeroAtk;
                LP_Hero_Instance.nbLP -= damage;
                show_debug_message("### resolveAttackMonsterEnemy: vsAtk heroLP-=" + string(damage) + " now=" + string(LP_Hero_Instance.nbLP));
                spawnPoisonFX(defender, attacker);
                destroyCard(defender, attacker);
            } else if (effEnemyAtk == effHeroAtk) {
                spawnPoisonFX(defender, attacker);
                destroyCard(attacker, defender);
                destroyCard(defender, attacker);
            } else {
                var damage2 = effHeroAtk - effEnemyAtk;
                LP_Enemy_Instance.nbLP -= damage2;
                show_debug_message("### resolveAttackMonsterEnemy: vsAtk enemyLP-=" + string(damage2) + " now=" + string(LP_Enemy_Instance.nbLP));
                spawnPoisonFX(defender, attacker);
                destroyCard(attacker, defender);
                destroyCard(defender, attacker);
            }
        } else {
            if (effEnemyAtk > effHeroAtk) {
                var damage = effEnemyAtk - effHeroAtk;
                LP_Hero_Instance.nbLP -= damage;
                show_debug_message("### resolveAttackMonsterEnemy: vsAtk heroLP-=" + string(damage) + " now=" + string(LP_Hero_Instance.nbLP));
                destroyCard(defender, attacker);
            } else if (effEnemyAtk == effHeroAtk) {
                destroyCard(attacker, defender);
                destroyCard(defender, attacker);
            } else {
                var damage = effHeroAtk - effEnemyAtk;
                LP_Enemy_Instance.nbLP -= damage;
                show_debug_message("### resolveAttackMonsterEnemy: vsAtk enemyLP-=" + string(damage) + " now=" + string(LP_Enemy_Instance.nbLP));
                destroyCard(attacker, defender);
            }
        }
    } else if (defender != noone && instance_exists(defender) && (defender.orientation == "Defense" || defender.orientation == "DefenseVisible")) {
        var effEnemyAtk2 = variable_struct_exists(attacker, "effective_attack") ? attacker.effective_attack : attacker.attack;
        var effHeroDef  = variable_struct_exists(defender, "effective_defense") ? defender.effective_defense : defender.defense;
        var isPoisE2 = (variable_struct_exists(attacker, "isPoisoner") && attacker.isPoisoner);
        if (isPoisE2) {
            if (effEnemyAtk2 > effHeroDef) {
                spawnPoisonFX(defender, attacker);
                destroyCard(defender, attacker);
            } else if (effEnemyAtk2 == effHeroDef) {
                spawnPoisonFX(defender, attacker);
                destroyCard(defender, attacker);
            } else {
                var damage3 = effHeroDef - effEnemyAtk2;
                LP_Enemy_Instance.nbLP -= damage3;
                show_debug_message("### resolveAttackMonsterEnemy: vsDef enemyLP-=" + string(damage3) + " now=" + string(LP_Enemy_Instance.nbLP));
                spawnPoisonFX(defender, attacker);
                destroyCard(defender, attacker);
            }
        } else {
            var effEnemyAtk = effEnemyAtk2;
            if (effEnemyAtk > effHeroDef) {
                destroyCard(defender, attacker);
            } else if (effEnemyAtk == effHeroDef) {
                if (variable_struct_exists(attacker, "isPoisoner") && attacker.isPoisoner) {
                    spawnPoisonFX(defender, attacker);
                    destroyCard(defender, attacker);
                }
            } else {
                var damage = effHeroDef - effEnemyAtk;
                LP_Enemy_Instance.nbLP -= damage;
                show_debug_message("### resolveAttackMonsterEnemy: vsDef enemyLP-=" + string(damage) + " now=" + string(LP_Enemy_Instance.nbLP));
                if (variable_struct_exists(attacker, "isPoisoner") && attacker.isPoisoner) {
                    spawnPoisonFX(defender, attacker);
                    destroyCard(defender, attacker);
                }
            }
        }
    }
    
    // Marquer l'attaque côté ennemi - DÉPLACÉ DANS initiateAttackMonsterEnemy
    // (pour éviter double compte lors des animations)


    // Déclencher l'événement post-attaque côté ennemi avec la cible (défenseur héros)
    if (instance_exists(attacker)) {
        var defExists3 = instance_exists(defender);
        registerTriggerEvent(TRIGGER_AFTER_ATTACK, attacker, {
            attacker: attacker,
            defender: defExists3 ? defender : noone,
            target: defExists3 ? defender : noone,
            defender_orientation: (defExists3 && variable_instance_exists(defender, "orientation")) ? defender.orientation : "unknown",
            direct_attack: false
        });
    }
};

// Version pour l'ennemi (si nécessaire)
resolveAttackDirectEnemy = function(cardEnemy) {
    if (cardEnemy == noone || !instance_exists(cardEnemy)) return;
    
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
    LP_Hero_Instance.nbLP -= damage;
    show_debug_message("### resolveAttackDirectEnemy: LP_Hero now=" + string(LP_Hero_Instance.nbLP));
    
    // Marquer l'attaque côté ennemi - DÉPLACÉ DANS initiateAttackDirectEnemy

};


