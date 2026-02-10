// sGameActionController.gml
// Ce script gère toutes les actions de jeu de manière centralisée.
// Il sert d'intermédiaire entre l'UI (Clics) et la logique de jeu.

// === CONSTANTES D'ACTIONS ===
#macro ACTION_NEXT_PHASE "NEXT_PHASE"
#macro ACTION_SUMMON "SUMMON"
#macro ACTION_DRAW "DRAW"
#macro ACTION_SYNC_LP "SYNC_LP"
#macro ACTION_ATTACK "ATTACK"
#macro ACTION_ACTIVATE_EFFECT "ACTIVATE_EFFECT"
#macro ACTION_SURRENDER "SURRENDER"
#macro MSG_HELLO "HELLO"
#macro MSG_GAME_START "GAME_START"
#macro MSG_GAME_ACTION "GAME_ACTION"
#macro MSG_LOBBY_STATE "LOBBY_STATE"
#macro MSG_SYNC "SYNC"

/// @function RequestGameAction(actionType, payload)
/// @description Point d'entrée pour demander une action (depuis UI ou Réseau)
/// @param {string} actionType Le type d'action (ex: ACTION_NEXT_PHASE)
/// @param {struct} payload Les données associées (ex: {card_id: "M_01"})
function RequestGameAction(actionType, payload) {
    
    // 1. Validation de base
    if (!instance_exists(oGame)) {
        show_debug_message("ERREUR: oGame introuvable pour l'action " + string(actionType));
        return false;
    }
    
    var isOnline = false;
    if (variable_global_exists("NET_MODE")) {
        isOnline = (global.NET_MODE != "offline");
    }
    if (isOnline) {
        var gameInst = instance_find(oGame, 0);
        if (instance_exists(gameInst)) {
            if (variable_instance_exists(gameInst, "local_player_index") && variable_instance_exists(gameInst, "player_current")) {
                var localIndex = gameInst.local_player_index;
                var currentIndex = gameInst.player_current;
                
                // Exception pour le Surrender: on peut le faire hors de son tour
                if (actionType != ACTION_SURRENDER && currentIndex != localIndex) {
                    show_debug_message("Action rejetée: tour du joueur distant pour " + string(actionType));
                    return false;
                }
            }
        }
    }
    if (isOnline) {
        if (script_exists(asset_get_index("Network_SendGameAction"))) {
            var serialPayload = SerializeGameActionPayload(actionType, payload);
            var msg = BuildGameActionMessage(actionType, serialPayload);
            Network_SendGameAction(msg);
        } else {
            show_debug_message("ERREUR: Network_SendGameAction introuvable, execution locale");
        }
    }
    ExecuteGameAction(actionType, payload);
    return true;
}

/// @function SerializeGameActionPayload(actionType, payload)
/// @description Prépare le payload pour le réseau (Conversion instances -> UIDs/Strings)
function SerializeGameActionPayload(actionType, payload) {
    var newP = variable_clone(payload);
    
    // Helper pour récupérer l'UID
    var getUID = function(inst) {
        if (instance_exists(inst) && variable_instance_exists(inst, "instance_uid")) return inst.instance_uid;
        return noone;
    };
    
    // Helper pour récupérer le nom de l'objet
    var getObjName = function(inst) {
        if (instance_exists(inst)) return object_get_name(inst.object_index);
        return "";
    };

    switch (actionType) {
        case ACTION_SUMMON:
            // Convertir 'card' instance en asset name + uid
            if (variable_struct_exists(newP, "card") && instance_exists(newP.card)) {
                newP.card_asset_name = getObjName(newP.card);
                newP.card_uid = getUID(newP.card);
                // On retire la référence d'instance qui ne survit pas au réseau
                variable_struct_remove(newP, "card");
            }
            break;
            
        case ACTION_ATTACK:
            if (variable_struct_exists(newP, "attacker") && instance_exists(newP.attacker)) {
                newP.attacker_uid = getUID(newP.attacker);
                variable_struct_remove(newP, "attacker");
            }
            if (variable_struct_exists(newP, "target") && instance_exists(newP.target)) {
                newP.target_uid = getUID(newP.target);
                variable_struct_remove(newP, "target");
            }
            break;
            
        case ACTION_ACTIVATE_EFFECT:
            // source_uid et target_uid sont déjà souvent utilisés, mais on vérifie
            if (variable_struct_exists(newP, "target") && instance_exists(newP.target)) {
                newP.target_uid = getUID(newP.target);
                variable_struct_remove(newP, "target");
            }
            break;
    }
    return newP;
}

/// @function ExecuteGameAction(actionType, payload)
/// @description Exécute l'action pour de vrai (Modification de l'état du jeu)
/// @param {string} actionType
/// @param {struct} payload
function ExecuteGameAction(actionType, payload) {
    show_debug_message(">>> EXECUTE ACTION: " + string(actionType));
    
    switch (actionType) {
        
        case ACTION_NEXT_PHASE:
            _execute_NextPhase(payload);
            break;

        case ACTION_DRAW:
            _execute_Draw(payload);
            break;
            
        case ACTION_SYNC_LP:
            _execute_SyncLP(payload);
            break;
        
        case ACTION_SUMMON:
            _execute_Summon(payload);
            break;
        
        case ACTION_ATTACK:
            _execute_Attack(payload);
            break;
            
        case ACTION_ACTIVATE_EFFECT:
            _execute_ActivateEffect(payload);
            break;

        case ACTION_SURRENDER:
            _execute_Surrender(payload);
            break;

        default:
            show_debug_message("Action inconnue : " + string(actionType));
            break;
    }
}

// === SOUS-FONCTIONS D'EXECUTION (LOGIQUE PURE) ===

function _execute_SyncLP(payload) {
    // Si on est l'hôte, on ignore notre propre message de sync (redondant)
    if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST) return;
    
    if (!is_struct(payload)) return;
    
    // Le client est le Joueur 1 (Enemy du point de vue de l'hôte)
    // p0_lp = LP du Joueur 0 (Hôte). Pour le client, c'est l'Ennemi (oLP_Enemy).
    // p1_lp = LP du Joueur 1 (Client). Pour le client, c'est le Héros (oLP_Hero).
    
    if (variable_struct_exists(payload, "p0_lp")) {
        var hostLP = payload.p0_lp;
        if (instance_exists(oLP_Enemy)) {
            if (oLP_Enemy.nbLP != hostLP) {
                oLP_Enemy.nbLP = hostLP;
            }
        }
    }
    
    if (variable_struct_exists(payload, "p1_lp")) {
        var clientLP = payload.p1_lp;
        if (instance_exists(oLP_Hero)) {
            if (oLP_Hero.nbLP != clientLP) {
                oLP_Hero.nbLP = clientLP;
            }
        }
    }
}

function _execute_Draw(payload) {
    if (!is_struct(payload)) return;
    
    var pIndex = -1;
    if (variable_struct_exists(payload, "player_index")) {
        pIndex = payload.player_index;
    }
    
    // Si pas de player_index, on suppose le joueur courant
    if (pIndex == -1 && instance_exists(oGame)) {
        pIndex = oGame.player_current;
    }

    var isLocalPlayer = false;
    if (instance_exists(oGame) && variable_instance_exists(oGame, "local_player_index")) {
        isLocalPlayer = (pIndex == oGame.local_player_index);
    } else {
        // Fallback offline (joueur 0 est toujours local/hero)
        isLocalPlayer = (pIndex == 0);
    }
    
    show_debug_message("EXECUTE DRAW for Player " + string(pIndex) + " (IsLocal=" + string(isLocalPlayer) + ")");

    if (isLocalPlayer) {
        // C'est MOI (ou le Héros offline) qui pioche
        if (instance_exists(deckHero)) {
            deckHero.pick();
            
            if (variable_struct_exists(payload, "trigger_next_phase") && payload.trigger_next_phase) {
                if (instance_exists(oGame)) oGame.nextPhase();
                if (instance_exists(oNextStep)) oNextStep.image_index = 0;
            }
        }
    } else {
        // C'est l'ADVERSAIRE qui pioche
        if (instance_exists(deckEnemy)) {
             // deckEnemy.pick() ajoute à handEnemy
             deckEnemy.pick();
             
             if (variable_struct_exists(payload, "trigger_next_phase") && payload.trigger_next_phase) {
                if (instance_exists(oGame)) oGame.nextPhase();
                if (instance_exists(oNextStep)) oNextStep.image_index = 0;
            }
        }
    }
}

function _execute_NextPhase(payload) {
    with (oGame) {
        // Appelle la méthode existante qui gère déjà toute la complexité
        nextPhase();
        
        // Correction de sync forcée (si payload fourni)
        if (is_struct(payload)) {
            show_debug_message("SYNC CHECK: Current Phase=" + string(phase_current) + " Player=" + string(player_current));
            
            var need_refresh = false;

            if (variable_struct_exists(payload, "target_phase_index")) {
                if (phase_current != payload.target_phase_index) {
                    show_debug_message("SYNC CORRECTION: Phase " + string(phase_current) + " -> " + string(payload.target_phase_index));
                    phase_current = payload.target_phase_index;
                    global.current_phase = phase[phase_current];
                    need_refresh = true;
                }
            }
            if (variable_struct_exists(payload, "target_player_index")) {
                 if (player_current != payload.target_player_index) {
                    show_debug_message("SYNC CORRECTION: Player " + string(player_current) + " -> " + string(payload.target_player_index));
                    player_current = payload.target_player_index;
                    is_local_turn = (player_current == local_player_index);
                    need_refresh = true;
                 }
            }
            if (variable_struct_exists(payload, "target_turn")) {
                if (nbTurn != payload.target_turn) {
                    show_debug_message("SYNC CORRECTION: Turn " + string(nbTurn) + " -> " + string(payload.target_turn));
                    nbTurn = payload.target_turn;
                    need_refresh = true;
                }
            }
            
            // Force update visuals if corrected
            if (need_refresh) {
                global.current_phase = phase[phase_current];
                is_local_turn = (player_current == local_player_index);
            }
        }
        
        // On désélectionne tout visuellement (UI pure)
        if (instance_exists(selectManager)) {
            selectManager.unSelectAll();
        }
    }
}

function _execute_Summon(payload) {
    if (!is_struct(payload)) {
        show_debug_message("ERREUR: payload SUMMON invalide (struct attendu)");
        return;
    }
    
    // Debug log pour vérifier le mode reçu
    if (variable_struct_exists(payload, "summon_mode")) {
        show_debug_message("SUMMON ACTION RECEIVED: Mode=" + string(payload.summon_mode));
    } else {
        show_debug_message("SUMMON ACTION RECEIVED: No Mode (Default Attack)");
    }
    
    var card = noone;
    if (variable_struct_exists(payload, "card")) {
        card = payload.card;
    } else if (variable_struct_exists(payload, "card_uid")) {
        card = _findCardByInstanceUID(payload.card_uid);
    }
    
    // Gestion de l'invocation distante (Création depuis Asset Name)
    if ((card == noone || !instance_exists(card)) && variable_struct_exists(payload, "card_asset_name")) {
        var objIdx = asset_get_index(payload.card_asset_name);
        if (objIdx != -1) {
            card = instance_create_layer(-3000, -3000, "Instances", objIdx);
            if (variable_struct_exists(payload, "card_uid")) {
                card.instance_uid = payload.card_uid;
            }
            
            // Déterminer le propriétaire en fonction du tour actuel
            if (instance_exists(oGame)) {
                var isLocalTurn = (oGame.player_current == oGame.local_player_index);
                card.isHeroOwner = isLocalTurn;
            }
        }
    }

    if (card == noone || !instance_exists(card)) {
        show_debug_message("ERREUR: payload SUMMON sans carte valide");
        return;
    }
    
    // Mise à jour de la position (Terrain, Zone...)
    // ... La logique de placement est gérée par les scripts oGame / FieldManager
    // Mais on peut avoir besoin de l'info dans le payload
    
    var fieldPos = -1;
    if (variable_struct_exists(payload, "xy") && is_array(payload.xy) && array_length(payload.xy) > 2) {
        fieldPos = payload.xy[2];
    }
    
    // Appel à la main appropriée pour invoquer (Correction du crash oGame.summonCard)
    var ownerIsHero = variable_instance_exists(card, "isHeroOwner") ? card.isHeroOwner : true;
    
    // --- HEARTHSTONE MANA CHECK (Phase 3) ---
    var currentMana = ownerIsHero ? global.mana_hero : global.mana_enemy;
    var cost = variable_instance_exists(card, "mana_cost") ? card.mana_cost : 0;
    
    if (currentMana < cost) {
        show_debug_message("ERREUR: Mana insuffisant pour invoquer " + object_get_name(card.object_index) + " (" + string(currentMana) + "/" + string(cost) + ")");
        return;
    }
    
    // Consommation du Mana
    if (ownerIsHero) {
        global.mana_hero -= cost;
    } else {
        global.mana_enemy -= cost;
    }
    show_debug_message("### Mana consumed: " + string(cost) + ". Remaining: " + string(ownerIsHero ? global.mana_hero : global.mana_enemy));
    // ----------------------------------------
    
    // Récupération des instances de gestion
    var hand = ownerIsHero ? handHero : handEnemy;
    var fm = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
    
    // Détermination de l'orientation souhaitée à partir du payload
    // --- HEARTHSTONE MODE (Phase 3) ---
    // Force Attack mode (Face Up) for all summons. No PV mode.
    var desiredOrientation = "Attack";
    // ----------------------------------
    
    if ((fieldPos != -1 || card.type == "Magic") && instance_exists(hand) && instance_exists(fm)) {
        // Recalcul des coordonnées locales précises
        var posXY = [0, 0];
        if (fieldPos != -1) {
            posXY = fm.getPosLocation(card.type, fieldPos);
        }
        
        // Récupération de la cible d'effet (si présente) pour les Sorts ciblés
        var effectTarget = noone;
        if (variable_struct_exists(payload, "target")) {
            effectTarget = payload.target;
        } else if (variable_struct_exists(payload, "target_uid")) {
            effectTarget = _findCardByInstanceUID(payload.target_uid);
        }

        // Exécution de l'invocation via le gestionnaire de main
        // Note: summon attend [x, y, slotIndex, desiredOrientation, effectTarget]
        // Legacy: remove desiredOrientation argument if summon() doesn't support it anymore, but currently hand.summon uses it.
        // For HS, we force "Attack" orientation internally in hand.summon or here.
        hand.summon(card, [posXY[0], posXY[1], fieldPos], desiredOrientation, effectTarget);
        
        // --- HEARTHSTONE SUMMONING SICKNESS (Phase 3) ---
        // Appliquer le mal d'invocation immédiatement après le placement
        if (instance_exists(card) && card.type == "Monster") {
            var hasCharge = variable_instance_exists(card, "has_charge") && card.has_charge;
            if (hasCharge) {
                card.attacksUsedThisTurn = 0;
            } else {
                // Bloque l'attaque pour ce tour (reset au prochain tour via oGame/triggers)
                card.attacksUsedThisTurn = 99; 
            }
        }
        // -----------------------------------------------
        
    } else {
        show_debug_message("ERREUR: Impossible d'invoquer (Hand/FieldManager introuvable ou Position invalide)");
    }
}

function _execute_Attack(payload) {
    if (!is_struct(payload)) {
        show_debug_message("ERREUR: payload ATTACK invalide (struct attendu)");
        return;
    }
    
    var attacker = noone;
    if (variable_struct_exists(payload, "attacker")) {
        attacker = payload.attacker;
    } else if (variable_struct_exists(payload, "attacker_uid")) {
        attacker = _findCardByInstanceUID(payload.attacker_uid);
    }
    
    if (attacker == noone || !instance_exists(attacker)) {
        show_debug_message("ERREUR: Attaquant introuvable ou invalide pour ATTACK");
        return;
    }

    var attackerIsHero = true;
    if (variable_instance_exists(attacker, "isHeroOwner")) {
        attackerIsHero = attacker.isHeroOwner;
    }
    
    // Mise à jour du SelectManager pour que oDamageManager trouve l'attaquant
    if (instance_exists(oSelectManager)) {
        selectManager.set(attacker);
    }
    
    var target = noone;
    var isDirect = false;
    
    if (variable_struct_exists(payload, "target_type") && payload.target_type == "direct_lp") {
        isDirect = true;
    } else if (variable_struct_exists(payload, "target")) {
        target = payload.target;
    } else if (variable_struct_exists(payload, "target_uid")) {
        target = _findCardByInstanceUID(payload.target_uid);
    }
    
    var dm = instance_find(oDamageManager, 0);
    if (dm == noone) {
        show_debug_message("ERREUR: oDamageManager introuvable pour ATTACK");
        return;
    }
    
    if (attackerIsHero) {
        if (isDirect) {
            var enemyHasBlockingMonsters = false;
            var fmE = instance_find(oFieldMonsterEnemy, 0);
            if (fmE != noone) {
                var enemyMonsters = fmE.cards;
                for (var i = 0; i < array_length(enemyMonsters); i++) {
                    var em = enemyMonsters[i];
                    if (em != 0 && instance_exists(em)) {
                        var isCamo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
                        // HS Logic: Taunt OR Front Line (0-3) blocks direct attacks
                        var isTaunt = (variable_instance_exists(em, "has_taunt") && em.has_taunt);
                        var isFrontLine = (variable_instance_exists(em, "fieldPosition") && em.fieldPosition >= 0 && em.fieldPosition <= 3);
                        var isDefender = (isTaunt || isFrontLine);
                        
                        if (!isCamo && isDefender) {
                            enemyHasBlockingMonsters = true;
                            break;
                        }
                    }
                }
            }
            
            var allowThrough = (variable_struct_exists(attacker, "canAttackDirectAlways") && attacker.canAttackDirectAlways);
            var allowPercee = (variable_struct_exists(attacker, "isPercee") && attacker.isPercee);
            
            if (enemyHasBlockingMonsters && (allowThrough || allowPercee)) enemyHasBlockingMonsters = false;
            
            if (enemyHasBlockingMonsters) {
                 show_debug_message("### Attaque directe impossible : Provocation (Taunt) présente");
                 return;
            }
            
            // Turn 1 check removed for HS (Summoning Sickness handles it)
            
            with (dm) tryAttack(noone);
        } else {
            with (dm) tryAttack(target);
        }
    } else {
        if (isDirect) {
            // Check for Hero Blockers (Front Line or Taunt)
            var heroHasBlockingMonsters = false;
            var fmH = instance_find(oFieldMonsterHero, 0);
            if (fmH != noone) {
                var heroMonsters = fmH.cards;
                for (var i = 0; i < array_length(heroMonsters); i++) {
                    var hm = heroMonsters[i];
                    if (hm != 0 && instance_exists(hm)) {
                         var isCamo = (variable_instance_exists(hm, "isCamouflage") && hm.isCamouflage);
                         var isTaunt = (variable_instance_exists(hm, "has_taunt") && hm.has_taunt);
                         var isFrontLine = (variable_instance_exists(hm, "fieldPosition") && hm.fieldPosition >= 0 && hm.fieldPosition <= 3);
                         var isDefender = (isTaunt || isFrontLine);
                         
                         if (!isCamo && isDefender) {
                             heroHasBlockingMonsters = true;
                             break;
                         }
                    }
                }
            }
            
            if (heroHasBlockingMonsters) {
                 show_debug_message("### AI Attaque directe impossible : Défenseur présent");
                 return;
            }
            
            with (dm) initiateAttackDirectEnemy(attacker);
        } else {
            if (target == noone || !instance_exists(target)) {
                show_debug_message("ERREUR: Cible invalide pour ATTACK IA (vs monstre)");
                return;
            }
            with (dm) initiateAttackMonsterEnemy(attacker, target);
        }
    }
}

function _execute_SwitchPosition(payload) {
    if (!is_struct(payload)) {
        show_debug_message("ERREUR: payload SWITCH_POSITION invalide");
        return;
    }

    var cardUID = variable_struct_exists(payload, "card_uid") ? payload.card_uid : noone;
    var card = _findCardByInstanceUID(cardUID);

    if (card == noone || !instance_exists(card)) {
        show_debug_message("ERREUR: Carte introuvable pour SWITCH_POSITION (UID: " + string(cardUID) + ")");
        return;
    }
    
    // Paramètres optionnels
    var immediate = variable_struct_exists(payload, "immediate") ? payload.immediate : false;

    with (card) {
        // Vérification des règles (déjà fait partiellement dans UI, mais sécurité ici)
        if (variable_instance_exists(id, "orientationChangedThisTurn") && orientationChangedThisTurn) {
             show_debug_message("Action rejetée: Orientation déjà changée ce tour");
             return;
        }
        
        if (variable_instance_exists(id, "entrave_turns_remaining") && entrave_turns_remaining > 0 && variable_instance_exists(id, "entrave_block_position") && entrave_block_position) {
             show_debug_message("Action rejetée: Bloqué par Entrave");
             return;
        }

        // Configuration de l'animation
        position_anim_active = true;
        anim_rotate_speed = (variable_global_exists("ANIM_ROTATE_SPEED") ? global.ANIM_ROTATE_SPEED : 6);
        anim_flip_speed = (variable_global_exists("ANIM_FLIP_SPEED") ? global.ANIM_FLIP_SPEED : 0.03);
        anim_flip_orig_scale = image_xscale;
        anim_pre_delay_frames = (variable_global_exists("ANIM_ROTATE_PRE_DELAY_FRAMES") ? global.ANIM_ROTATE_PRE_DELAY_FRAMES : 6);
        
        var isHero = (variable_instance_exists(id, "isHeroOwner") && isHeroOwner);
        var atk_angle = isHero ? 0 : 180;
        var def_vis_angle = isHero ? 90 : 270;
        
        if (orientation == "PV") {
            // PV (Caché) -> Attaque
            image_index = 0; // Pré-reveal
            if (variable_instance_exists(id, "isFaceDown")) isFaceDown = false;
            anim_phase = "flip_in";
            target_angle = atk_angle;
            target_orientation = "Attack";
        }
        else if (orientation == "Attack") {
            // Attaque -> Défense Visible
            anim_phase = "rotate";
            target_angle = def_vis_angle;
            target_orientation = "DefenseVisible";
            image_index = 0;
            if (variable_instance_exists(id, "isFaceDown")) isFaceDown = false;
        }
        else if (orientation == "DefenseVisible") {
            // Défense Visible -> Attaque
            anim_phase = "rotate";
            target_angle = atk_angle;
            target_orientation = "Attack";
            image_index = 0;
            if (variable_instance_exists(id, "isFaceDown")) isFaceDown = false;
        }

        // Reset animation si déjà en cours (rare)
        if (anim_phase == "rotate") {
            if (variable_instance_exists(id, "anim_init_rotate")) anim_init_rotate = false;
        }
        
        // Mise à jour immédiate si demandée (ex: IA)
        if (immediate) {
            orientation = target_orientation;
            orientationChangedThisTurn = true;
        }
        
        // Note: Si !immediate, orientationChangedThisTurn sera mis à true à la fin de l'anim par le Step event
    }
}

function _execute_ActivateEffect(payload) {
    if (!is_struct(payload)) {
        show_debug_message("ERREUR: payload ACTIVATE_EFFECT invalide");
        return;
    }

    var sourceUID = variable_struct_exists(payload, "source_uid") ? payload.source_uid : noone;
    var effectIndex = variable_struct_exists(payload, "effect_index") ? payload.effect_index : -1;
    var targetUID = variable_struct_exists(payload, "target_uid") ? payload.target_uid : noone;

    var card = _findCardByInstanceUID(sourceUID);
    if (card == noone || !instance_exists(card)) {
        show_debug_message("ERREUR: Carte source introuvable pour ACTIVATE_EFFECT (UID: " + string(sourceUID) + ")");
        return;
    }

    if (!variable_instance_exists(card, "effects") || !is_array(card.effects) || effectIndex < 0 || effectIndex >= array_length(card.effects)) {
        show_debug_message("ERREUR: Index d'effet invalide pour ACTIVATE_EFFECT");
        return;
    }

    var effect = card.effects[effectIndex];
    var context = {};
    
    // Résolution de la cible
    if (targetUID != noone) {
        var targetCard = _findCardByInstanceUID(targetUID);
        if (targetCard != noone && instance_exists(targetCard)) {
            context.target = targetCard;
        } else {
            show_debug_message("ATTENTION: Cible introuvable pour ACTIVATE_EFFECT (UID: " + string(targetUID) + ")");
            // On continue, certains effets peuvent gérer l'absence de cible ou utiliser une cible par défaut
        }
    }

    // Exécution de l'effet
    // Note: executeEffect gère la logique interne. Si le ciblage est requis et manquant, il retournera false.
    // Mais ici, via Command Pattern, on suppose que le ciblage est déjà fait (si présent dans payload).
    var resolved = executeEffect(card, effect, context);
    
    if (resolved) {
        // Gestion des conséquences post-résolution (marquage, consommation)
        if (script_exists(asset_get_index("markEffectAsUsed"))) {
            markEffectAsUsed(card, effect);
        }
        
        // FIX: Cache properties before potential destruction
        var isSecret = (variable_instance_exists(card, "genre") && string_lower(card.genre) == "secret");
        var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
        
        if (script_exists(asset_get_index("consumeSpellIfNeeded"))) {
            consumeSpellIfNeeded(card, effect);
        }
        
        // FIX: Always ensure secret is removed from active list after activation
        // This handles cases where consumeSpellIfNeeded is deferred (animation) or fails to update list
        if (isSecret) {
             var secretList = ownerIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
             if (variable_global_exists("activeSecretsHero") && ds_exists(secretList, ds_type_list)) {
                 var idx = ds_list_find_index(secretList, card);
                 if (idx != -1) {
                     ds_list_delete(secretList, idx);
                     show_debug_message("### _execute_ActivateEffect: Forced removal of secret from list (Fix). ID=" + string(card));
                 }
             }
        }
        
        // Phase 1.5: Support Redirection Attaque (Secrets)
        // Si l'effet activé redirige l'attaque (ex: Invocation surprise), on stocke la cible dans une globale
        if (variable_struct_exists(effect, "redirect_attack_to_summoned") && effect.redirect_attack_to_summoned) {
             if (variable_struct_exists(context, "summoned") && context.summoned != noone && instance_exists(context.summoned)) {
                 global.combat_redirect_defender = context.summoned;
             }
        }
    }
}

function _execute_Surrender(payload) {
    if (instance_exists(oGame)) {
        var winner_is_me = false;
        
        // Déterminer qui a gagné en fonction de qui a abandonné/quitté
        if (variable_struct_exists(payload, "winner_index")) {
            winner_is_me = (payload.winner_index == oGame.local_player_index);
        } else if (variable_struct_exists(payload, "quitter_index")) {
            // Si le quitter n'est PAS moi, alors JE gagne
            winner_is_me = (payload.quitter_index != oGame.local_player_index);
        }
        
        // Forcer la fin de partie si ce n'est pas déjà fait
        if (!variable_instance_exists(oGame, "gameEnded") || !oGame.gameEnded) {
            oGame.gameEnded = true;
            var gameOverScreen = instance_create_layer(0, 0, "UI", oGameOverScreen);
            gameOverScreen.isVictory = winner_is_me;
            
            show_debug_message("### ACTION_SURRENDER exécutée. Victoire locale = " + string(winner_is_me));
        }
    }
}

function BuildGameActionMessage(actionType, payload) {
    var msg = {
        msg_type: MSG_GAME_ACTION,
        action: actionType,
        payload: payload
    };
    return msg;
}

function ProcessRemoteGameAction(msg) {
    if (!is_struct(msg)) {
        return;
    }
    var actionType = "";
    if (variable_struct_exists(msg, "action")) {
        actionType = msg.action;
    }
    if (actionType == "") {
        return;
    }
    var payload = undefined;
    if (variable_struct_exists(msg, "payload")) {
        payload = msg.payload;
    }
    ExecuteGameAction(actionType, payload);
}

// Helper pour trouver une carte par UID (utilisé par plusieurs fonctions)
function _findCardByInstanceUID(uid) {
    if (uid == noone) return noone;
    
    with (oCardParent) {
        if (variable_instance_exists(id, "instance_uid") && instance_uid == uid) {
            return id;
        }
    }
    return noone;
}

