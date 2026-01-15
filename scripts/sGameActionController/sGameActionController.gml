// sGameActionController.gml
// Ce script gère toutes les actions de jeu de manière centralisée.
// Il sert d'intermédiaire entre l'UI (Clics) et la logique de jeu.

// === CONSTANTES D'ACTIONS ===
#macro ACTION_NEXT_PHASE "NEXT_PHASE"
#macro ACTION_SUMMON "SUMMON"
#macro ACTION_ATTACK "ATTACK"
#macro ACTION_ACTIVATE_EFFECT "ACTIVATE_EFFECT"
#macro ACTION_SWITCH_POSITION "SWITCH_POSITION"
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
                if (currentIndex != localIndex) {
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

        case ACTION_SWITCH_POSITION:
            if (variable_struct_exists(newP, "card") && instance_exists(newP.card)) {
                newP.card_uid = getUID(newP.card);
                variable_struct_remove(newP, "card");
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
        
        case ACTION_SUMMON:
            _execute_Summon(payload);
            break;
        
        case ACTION_ATTACK:
            _execute_Attack(payload);
            break;
            
        case ACTION_ACTIVATE_EFFECT:
            _execute_ActivateEffect(payload);
            break;

        case ACTION_SWITCH_POSITION:
            _execute_SwitchPosition(payload);
            break;

        default:
            show_debug_message("Action inconnue : " + string(actionType));
            break;
    }
}

// === SOUS-FONCTIONS D'EXECUTION (LOGIQUE PURE) ===

function _execute_NextPhase(payload) {
    with (oGame) {
        // Appelle la méthode existante qui gère déjà toute la complexité
        // (changement de phase, de tour, triggers, reset orientation, etc.)
        nextPhase();
        
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
    
    var xy = undefined;
    if (variable_struct_exists(payload, "xy")) {
        xy = payload.xy;
    }
    if (is_undefined(xy)) {
        show_debug_message("ERREUR: payload SUMMON sans coordonnées XY");
        return;
    }
    
    var desiredOrientation = "";
    if (variable_struct_exists(payload, "desired_orientation")) {
        desiredOrientation = payload.desired_orientation;
    }
    
    var effectTarget = noone;
    if (variable_struct_exists(payload, "effect_target")) {
        effectTarget = payload.effect_target;
    }
    
    var ownerIsHero = true;
    if (variable_instance_exists(card, "isHeroOwner")) {
        ownerIsHero = card.isHeroOwner;
    }
    
    var handInst = ownerIsHero ? handHero : handEnemy;
    if (!instance_exists(handInst)) {
        show_debug_message("ERREUR: instance de main introuvable pour SUMMON");
        return;
    }
    
    handInst.summon(card, xy, desiredOrientation, effectTarget);
}

function _findCardByInstanceUID(uid) {
    var result = noone;
    var count = instance_number(oCardParent);
    for (var i = 0; i < count; i++) {
        var c = instance_find(oCardParent, i);
        if (instance_exists(c) && variable_instance_exists(c, "instance_uid")) {
            if (c.instance_uid == uid) {
                result = c;
                break;
            }
        }
    }
    return result;
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
                        if (!isCamo) {
                            enemyHasBlockingMonsters = true;
                            break;
                        }
                    }
                }
            }
            
            var allowThrough = (variable_struct_exists(attacker, "canAttackDirectAlways") && attacker.canAttackDirectAlways);
            if (enemyHasBlockingMonsters && allowThrough) enemyHasBlockingMonsters = false;
            
            if (enemyHasBlockingMonsters) {
                 show_debug_message("### Attaque directe impossible : monstres ennemis présents");
                 return;
            }
            
            if (instance_exists(oGame) && oGame.nbTurn == 1) {
                 show_debug_message("### Attaque directe interdite au tour 1 du duel");
                 return;
            }
            
            with (dm) tryAttack(noone);
        } else {
            with (dm) tryAttack(target);
        }
    } else {
        if (isDirect) {
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
        
        if (orientation == "Defense") {
            // Defense (Caché) -> Attaque
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
        if (script_exists(asset_get_index("consumeSpellIfNeeded"))) {
            consumeSpellIfNeeded(card, effect);
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
