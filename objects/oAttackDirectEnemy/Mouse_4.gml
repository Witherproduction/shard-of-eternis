// Left pressed (clic gauche)
// Vérifier si on est dans la room de duel
if (room != rDuel) {
    exit;
}

if (global.isGraveyardViewerOpen) exit;

// Vérifier si on est en mode attaque avec une carte sélectionnée
if (selectManager.attackMode && selectManager.selected != noone) {
    var card = selectManager.selected;
    
    var isMyTurn = false;
    if (instance_exists(game)) {
        if (variable_instance_exists(game, "local_player_index")) {
            isMyTurn = (game.player_current == game.local_player_index);
        } else {
            isMyTurn = (game.player_current == 0);
        }
    }

    if (card != noone && instance_exists(game) && isMyTurn && (game.phase[game.phase_current] == "Attack" || game.phase[game.phase_current] == "Main")
        && card.zone == "FieldSelected") {
        var atk_lim = (variable_instance_exists(card, "isAmbidextrous") && card.isAmbidextrous) ? 2 : 1;
        var atk_used = (variable_instance_exists(card, "attacksUsedThisTurn") ? card.attacksUsedThisTurn : 0);
        if (atk_used >= atk_lim) {
            show_debug_message("### oAttackDirectEnemy: limite d'attaques atteinte");
            // Nettoyer l'UI et sortir du mode attaque
            image_alpha = 0;
            selectManager.attackMode = false;
            if (instance_exists(oAttack)) { instance_destroy(oAttack); }
            exit;
        }
        // Règle: pas d'attaque directe au tour 1 du duel
        if (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1) {
            show_debug_message("### oAttackDirectEnemy: Attaque directe interdite au tour 1 du duel");
            image_alpha = 0;
            selectManager.attackMode = false;
            if (instance_exists(oAttack)) { instance_destroy(oAttack); }
            exit;
        }
        
        // Vérifier qu'il n'y a pas de défenseur ennemi valide (Taunt ou Front Line)
        var enemyHasMonsters = false;
        var enemyMonsters = fieldMonsterEnemy.cards;
        
        for (var i = 0; i < array_length(enemyMonsters); i++) {
            var em = enemyMonsters[i];
            if (em != 0 && instance_exists(em)) {
                var isCamo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
                
                // Nouvelle Règle: Seuls Taunt ou Front Line (0-3) bloquent
                var isTaunt = (variable_instance_exists(em, "has_taunt") && em.has_taunt);
                var isFrontLine = (variable_instance_exists(em, "fieldPosition") && em.fieldPosition >= 0 && em.fieldPosition <= 3);
                var isDefender = (isTaunt || isFrontLine);
                
                if (!isCamo && isDefender) {
                    enemyHasMonsters = true;
                    show_debug_message("### oAttackDirectEnemy: Défenseur valide trouvé (FrontLine/Taunt) - attaque directe impossible");
                    break;
                }
            }
        }
        
        var allowThrough = (variable_struct_exists(card, "canAttackDirectAlways") && card.canAttackDirectAlways);
        if (enemyHasMonsters && allowThrough) enemyHasMonsters = false;
        
        if(!enemyHasMonsters) {
            // Blocage générique: la carte ne peut pas attaquer directement si cannotAttackDirect
            if (variable_struct_exists(card, "cannotAttackDirect") && card.cannotAttackDirect) {
                show_debug_message("### oAttackDirectEnemy: Attaque directe impossible (cannotAttackDirect)");
                // Nettoyer l'UI et sortir du mode attaque
                image_alpha = 0;
                selectManager.attackMode = false;
                if (instance_exists(oAttack)) {
                    instance_destroy(oAttack);
                }
                exit;
            }
            // MIGRATION PHASE 1.4: Utilisation du Command Pattern
            // La logique d'exécution (FX, résolution) est gérée par le contrôleur et oDamageManager
            RequestGameAction(ACTION_ATTACK, {
                attacker_uid: card.instance_uid,
                target_type: "direct_lp"
            });
            
            // UI Feedback immédiat
            if (variable_instance_exists(selectManager, "destroyTargetingArrow")) {
                selectManager.destroyTargetingArrow();
            }
            image_alpha = 0;
            selectManager.attackMode = false;
            if (instance_exists(oAttack)) {
                instance_destroy(oAttack);
            }
        } else {
            show_debug_message("### oAttackDirectEnemy: Attaque directe impossible - monstres ennemis présents");
        }
    }
} else {
    show_debug_message("### oAttackDirectEnemy: Pas en mode attaque ou aucune carte sélectionnée");
}