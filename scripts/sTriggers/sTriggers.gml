// === Script des Déclencheurs d'Effets de Monstres ===

// Ce script contient tous les déclencheurs possibles pour les effets de cartes



// === CONSTANTES DES DÉCLENCHEURS ===



// Déclencheurs de base

#macro TRIGGER_ON_SUMMON "on_summon"                    // Quand la carte est invoquée

#macro TRIGGER_ON_DESTROY "on_destroy"                  // Quand la carte est détruite

#macro TRIGGER_ON_ATTACK "on_attack"                    // Quand la carte attaque

#macro TRIGGER_ON_DEFENSE "on_defense"                  // Quand la carte se défend

#macro TRIGGER_ON_DAMAGE "on_damage"                    // Quand la carte subit des dégâts

#macro TRIGGER_ON_HEAL "on_heal"                        // Quand la carte est soignée



// Déclencheurs de phase

#macro TRIGGER_START_TURN "start_turn"                  // Début du tour

#macro TRIGGER_END_TURN "end_turn"                      // Fin du tour

#macro TRIGGER_DRAW_PHASE "draw_phase"                  // Phase de pioche

#macro TRIGGER_MAIN_PHASE "main_phase"                  // Phase principale

#macro TRIGGER_BATTLE_PHASE "battle_phase"              // Phase de combat

#macro TRIGGER_END_PHASE "end_phase"                    // Phase de fin



// Déclencheurs d'interaction

#macro TRIGGER_ON_TARGET "on_target"                    // Quand la carte est ciblée

#macro TRIGGER_ON_EQUIP "on_equip"                      // Quand un équipement est attaché

#macro TRIGGER_ON_UNEQUIP "on_unequip"                  // Quand un équipement est retiré

#macro TRIGGER_ON_FLIP "on_flip"                        // Quand la carte est retournée



// Déclencheurs de zone

#macro TRIGGER_ENTER_FIELD "enter_field"                // Entre sur le terrain

#macro TRIGGER_LEAVE_FIELD "leave_field"                // Quitte le terrain

#macro TRIGGER_ENTER_HAND "enter_hand"                  // Entre dans la main

#macro TRIGGER_LEAVE_HAND "leave_hand"                  // Quitte la main

#macro TRIGGER_ENTER_GRAVEYARD "enter_graveyard"        // Entre dans le cimetière

#macro TRIGGER_LEAVE_GRAVEYARD "leave_graveyard"        // Quitte le cimetière



// Ajouts: déclencheurs de combat dédiés

#macro TRIGGER_AFTER_ATTACK "after_attack"              // Apres la resolution dune attaque

#macro TRIGGER_AFTER_DEFENSE "after_defense"            // Apres la resolution dune PV



// Déclencheurs conditionnels

#macro TRIGGER_ON_LP_CHANGE "on_lp_change"              // Quand les LP changent

#macro TRIGGER_ON_CARD_DRAW "on_card_draw"              // Quand une carte est piochée

#macro TRIGGER_ON_SPELL_CAST "on_spell_cast"            // Quand un sort est lancé

#macro TRIGGER_ON_MONSTER_SUMMON "on_monster_summon"    // Quand un monstre est invoqué
#macro TRIGGER_ON_MONSTER_SENT_TO_GRAVEYARD "on_monster_sent_to_graveyard" // Quand un monstre est envoyé au cimetière (global)



// Déclencheurs spéciaux

#macro TRIGGER_ONCE_PER_TURN "once_per_turn"            // Une fois par tour

#macro TRIGGER_CONTINUOUS "continuous"                   // Effet continu
#macro TRIGGER_PASSIVE "passive"

#macro TRIGGER_QUICK_EFFECT "quick_effect"              // Effet rapide

#macro TRIGGER_COUNTER "counter"                        // Effet de contre



// === FONCTION PRINCIPALE DE GESTION DES DÉCLENCHEURS ===



/// @function checkTrigger(card, triggerType, context)

/// @description Vérifie si un déclencheur doit être activé pour une carte

/// @param {struct} card - La carte à vérifier

/// @param {string} triggerType - Le type de déclencheur

/// @param {struct} context - Le contexte de l'événement

/// @returns {bool} - True si le déclencheur doit être activé

function checkTrigger(card, triggerType, context = {}) {
    
    // Vérifier si la carte a des effets
    
    if (!variable_instance_exists(card, "effects") || array_length(card.effects) == 0) {
        
        return false;
        
    }

    

    // Parcourir tous les effets de la carte
    for (var i = 0; i < array_length(card.effects); i++) {
        var effect = card.effects[i];

        // Vérifier si l'effet a le bon déclencheur
        if (variable_struct_exists(effect, "trigger")) {
            if (effect.trigger == triggerType) {
                // Vérifier les conditions supplémentaires
                if (checkTriggerConditions(card, effect, context)) {
                    return true;
                }
            }
        }
    }

    

    return false;

}



/// @function checkTriggerConditions(card, effect, context)

/// @description Vérifie les conditions spécifiques d'un déclencheur

/// @param {struct} card - La carte

/// @param {struct} effect - L'effet à vérifier

/// @param {struct} context - Le contexte

/// @returns {bool} - True si les conditions sont remplies

function checkTriggerConditions(card, effect, context) {
    if (is_struct(effect) && variable_struct_exists(effect, "negated") && effect.negated) {
        return false;
    }

    if (((variable_instance_exists(card, "type") && string_lower(card.type) == "monster")
        || object_is_ancestor(card.object_index, oCardMonster))
        && variable_instance_exists(card, "zone")
        && (card.zone == "Field" || card.zone == "FieldSelected")
        && variable_instance_exists(card, "isFaceDown")
        && card.isFaceDown) {
        return false;
    }

    if (variable_struct_exists(effect, "trigger")) {
        var trig = effect.trigger;
        var needsOwnerGate = (trig == TRIGGER_START_TURN) || (trig == TRIGGER_END_TURN) || (trig == TRIGGER_MAIN_PHASE);
        if (needsOwnerGate) {
            var hasSpecifiedOwner = false;
            if (variable_struct_exists(effect, "conditions")) {
                var cnd0 = effect.conditions;
                hasSpecifiedOwner = (variable_struct_exists(cnd0, "owner_turn") && cnd0.owner_turn)
                                    || (variable_struct_exists(cnd0, "opponent_turn") && cnd0.opponent_turn);
            }
            if (!hasSpecifiedOwner) {
                if (!instance_exists(game)) { return false; }
                var currentPlayer3 = game.player[game.player_current];
                
                var localIndex3 = (variable_instance_exists(game, "local_player_index")) ? game.local_player_index : 0;
                var cardOwnerIndex3 = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner) ? localIndex3 : (1 - localIndex3);
                var cardOwner3 = game.player[cardOwnerIndex3];
                
                if (currentPlayer3 != cardOwner3) { return false; }
            }
            if (trig == TRIGGER_MAIN_PHASE) {
                if (!instance_exists(game)) { return false; }
                var currentPhase = game.phase[game.phase_current];
                if (currentPhase != "Main") { return false; }
            }
        }
    }

    // Vérifier les conditions de base

    if (variable_struct_exists(effect, "conditions")) {

        var conditions = effect.conditions;

        

        // Vérifier la condition "once_per_turn"

        if (variable_struct_exists(conditions, "once_per_turn") && conditions.once_per_turn) {

            var turnStr = variable_global_exists("current_turn") ? string(global.current_turn) : (instance_exists(oGame) ? string(oGame.nbTurn) : "0");

            var effectId = string(card.id) + "_" + string(effect.id) + "_turn_" + turnStr;

            if (variable_global_exists("used_effects") && ds_list_find_index(global.used_effects, effectId) != -1) {

                return false;

            }

        }

        

        // Vérifier la condition de LP minimum

        if (variable_struct_exists(conditions, "min_lp")) {

            if (global.hero_lp < conditions.min_lp) {

                return false;

            }

        }

        

        // Vérifier la condition de LP maximum

        if (variable_struct_exists(conditions, "max_lp")) {

            if (global.hero_lp > conditions.max_lp) {

                return false;

            }

        }

        

        // Vérifier la condition de nombre de cartes en main

        if (variable_struct_exists(conditions, "hand_size")) {

            var handSize = getHandSize();

            if (handSize != conditions.hand_size) {

                return false;

            }

        }

        

        // Vérifier la condition de type de carte ciblée
        if (variable_struct_exists(conditions, "target_type") && variable_struct_exists(context, "target")) {
            var targetType = variable_instance_exists(context.target, "type") ? context.target.type : "unknown";
            show_debug_message("### Checking target_type: expected=" + string(conditions.target_type) + ", actual=" + string(targetType));
            if (targetType != conditions.target_type) {
                show_debug_message("### target_type check failed");
                return false;
            }
        }
        // Vérifier la condition de genre de la carte ciblée (ex: "Dragon")
        if (variable_struct_exists(conditions, "target_genre") && variable_struct_exists(context, "target")) {
            var targetGenre = variable_instance_exists(context.target, "genre") ? context.target.genre : "unknown";
            show_debug_message("### Checking target_genre: expected=" + string(conditions.target_genre) + ", actual=" + string(targetGenre));
            if (targetGenre != conditions.target_genre) {
                show_debug_message("### target_genre check failed");
                return false;
            }
        }

        // Restreindre le déclenchement aux attaques initiées par cette carte
        if (variable_struct_exists(conditions, "attacker_is_self") && conditions.attacker_is_self) {
            if (!variable_struct_exists(context, "attacker") || context.attacker == noone || context.attacker != card) {
                show_debug_message("### attacker_is_self check failed");
                return false;
            }
        }
        if (variable_struct_exists(conditions, "defender_is_self") && conditions.defender_is_self) {
            if (!variable_struct_exists(context, "defender") || context.defender == noone || context.defender != card) {
                return false;
            }
        }
        if (variable_struct_exists(conditions, "attacker_is_equipped_target") && conditions.attacker_is_equipped_target) {
            var atk_eq = variable_struct_exists(context, "attacker") ? context.attacker : noone;
            var eq_tgt = (instance_exists(card) && variable_instance_exists(card, "equipped_target")) ? card.equipped_target : noone;
            if (atk_eq == noone || !instance_exists(atk_eq) || eq_tgt == noone || !instance_exists(eq_tgt) || atk_eq != eq_tgt) {
                return false;
            }
        }
        if (variable_struct_exists(conditions, "requires_defender_monster") && conditions.requires_defender_monster) {
            var def_req = variable_struct_exists(context, "defender") ? context.defender : noone;
            if (def_req == noone || !instance_exists(def_req)) { return false; }
            var isMonReq = object_is_ancestor(def_req.object_index, oCardMonster) || (variable_instance_exists(def_req, "type") && string_lower(def_req.type) == "monster");
            if (!isMonReq) { return false; }
        }
        // Orientation du défenseur (ex: "PV" ou "DefenseVisible")
        if (variable_struct_exists(conditions, "defender_orientation") || variable_struct_exists(conditions, "defender_orientation_in")) {
            if (!variable_struct_exists(context, "defender_orientation")) { return false; }
            var dOri = string(context.defender_orientation);
            if (variable_struct_exists(conditions, "defender_orientation")) {
                if (dOri != string(conditions.defender_orientation)) { return false; }
            } else if (variable_struct_exists(conditions, "defender_orientation_in")) {
                var arrOr = conditions.defender_orientation_in;
                var okOri = false;
                if (is_array(arrOr)) {
                    for (var oi = 0; oi < array_length(arrOr); oi++) { if (dOri == string(arrOr[oi])) { okOri = true; break; } }
                }
                if (!okOri) { return false; }
            }
        }

        // Check defender field position
        if (variable_struct_exists(conditions, "defender_field_position_in") && variable_struct_exists(context, "defender")) {
            var def_pos = context.defender;
            if (instance_exists(def_pos) && variable_instance_exists(def_pos, "fieldPosition")) {
                var pos = def_pos.fieldPosition;
                var allowedPos = conditions.defender_field_position_in;
                var match = false;
                if (is_array(allowedPos)) {
                    for (var i = 0; i < array_length(allowedPos); i++) {
                        if (pos == allowedPos[i]) { match = true; break; }
                    }
                } else {
                    if (pos == allowedPos) match = true;
                }
                if (!match) return false;
            } else {
                return false;
            }
        }
        

        // Vérifier la condition de phase

        if (variable_struct_exists(conditions, "phase")) {

            if (!variable_global_exists("current_phase") || global.current_phase != conditions.phase) {

                return false;

            }

        }


        // Source owner relative to card owner (ally/enemy)
        if (variable_struct_exists(conditions, "source_owner")) {
            var ow_src = string_lower(conditions.source_owner);
            var srcHero = variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : undefined;
            var cardHero = (variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : undefined;
            if (is_undefined(srcHero) || is_undefined(cardHero)) { return false; }
            var isAllySrc = (srcHero == cardHero);
            if (ow_src == "ally" && !isAllySrc) { return false; }
            if (ow_src == "enemy" && isAllySrc) { return false; }
        }

        // Source name contains substring
        if (variable_struct_exists(conditions, "source_name_contains")) {
            if (!variable_struct_exists(context, "source")) { return false; }
            var src = context.source;
            if (src == noone || !instance_exists(src)) { return false; }
            var nmSrc = variable_instance_exists(src, "name") ? string(src.name) : object_get_name(src.object_index);
            var wantSub = string(conditions.source_name_contains);
            if (string_pos(wantSub, nmSrc) <= 0) { return false; }
        }
        
        // Source type equals (ex: "Monster")
        if (variable_struct_exists(conditions, "source_type")) {
            if (!variable_struct_exists(context, "source")) { return false; }
            var srcT = context.source;
            if (srcT == noone || !instance_exists(srcT)) { return false; }
            var srcType = variable_instance_exists(srcT, "type") ? string(srcT.type) : "";
            if (string_lower(srcType) != string_lower(string(conditions.source_type))) { return false; }
        }

        // Source genre equals
        if (variable_struct_exists(conditions, "source_genre")) {
            if (!variable_struct_exists(context, "source")) { return false; }
            var src2 = context.source;
            if (src2 == noone || !instance_exists(src2)) { return false; }
            var gSrc = variable_instance_exists(src2, "genre") ? string(src2.genre) : "";
            var wantG = string(conditions.source_genre);
            if (gSrc != wantG) { return false; }
        }

        if (variable_struct_exists(conditions, "source_object_not")) {
            if (!variable_struct_exists(context, "source")) { return false; }
            var src3 = context.source;
            if (src3 == noone || !instance_exists(src3)) { return false; }
            var objName = object_get_name(src3.object_index);
            var wantNot = string(conditions.source_object_not);
            if (string_lower(objName) == string_lower(wantNot)) { return false; }
        }

        if (variable_struct_exists(conditions, "source_is_not_self") && conditions.source_is_not_self) {
            if (!variable_struct_exists(context, "source")) { return false; }
            var src4 = context.source;
            if (src4 == noone || !instance_exists(src4)) { return false; }
            
            // Check reference and ID equality
            if (src4 == card || src4.id == card.id) { return false; }
            
            // Extra safety: check if it's the same object at the same position (handles potential copy/proxy cases)
            if (src4.object_index == card.object_index && floor(src4.x) == floor(card.x) && floor(src4.y) == floor(card.y)) { return false; }
        }

        // Vérifier le propriétaire si précisé ("Hero" ou "Enemy")

        if (variable_struct_exists(conditions, "owner")) {

            var wantHero = (conditions.owner == "Hero");

            if (!variable_instance_exists(card, "isHeroOwner") || card.isHeroOwner != wantHero) {

                return false;

            }

        }



        // Vérifier la zone attendue (ex: "Hand", "Field")

        if (variable_struct_exists(conditions, "zone")) {

            if (!variable_instance_exists(card, "zone")) {

                return false;

            }

            var expectedZone = conditions.zone;

            var cardZone = card.zone;

            // Autoriser les états de sélection comme équivalents

            if ((cardZone == "HandSelected" && expectedZone == "Hand") ||

                (cardZone == "FieldSelected" && expectedZone == "Field")) {

                // ok

            } else if (cardZone != expectedZone) {

                return false;

            }

        }



        // Condition: seulement au tour adverse par rapport au propriétaire de la carte

        if (variable_struct_exists(conditions, "opponent_turn") && conditions.opponent_turn) {

            if (!instance_exists(game)) {

                return false;

            }

            var currentPlayer = game.player[game.player_current];

            var localIndex = (variable_instance_exists(game, "local_player_index")) ? game.local_player_index : 0;
            var cardOwnerIndex = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner) ? localIndex : (1 - localIndex);
            var cardOwner = game.player[cardOwnerIndex];

            if (currentPlayer == cardOwner) {

                return false;

            }

        }



        // Condition: seulement au tour du propriétaire de la carte

        if (variable_struct_exists(conditions, "owner_turn") && conditions.owner_turn) {
            if (!instance_exists(game)) {
                return false;
            }
            var currentPlayer2 = game.player[game.player_current];
            
            var localIndex2 = (variable_instance_exists(game, "local_player_index")) ? game.local_player_index : 0;
            var cardOwnerIndex2 = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner) ? localIndex2 : (1 - localIndex2);
            var cardOwner2 = game.player[cardOwnerIndex2];
            
            if (currentPlayer2 != cardOwner2) {
                return false;
            }
        }

        // Vérifier la présence d'une race sur le terrain du héros
        if (variable_struct_exists(conditions, "has_race_on_field")) {
            var race_cond = conditions.has_race_on_field;
            if (!has_race_monster_on_field(true, race_cond)) {
                return false;
            }
        }

        // Vérifier la présence d'un genre sur le terrain du propriétaire de la carte
        if (variable_struct_exists(conditions, "has_genre_on_field")) {
            var gn = conditions.has_genre_on_field;
            var isHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (!has_genre_monster_on_field(isHero, gn)) {
                return false;
            }
        }

        // Vérifier un minimum de cartes d'un genre sur le terrain (ex: au moins 2 Bêtes)
        if (variable_struct_exists(conditions, "min_genre_count_on_field")) {
            var cfg = conditions.min_genre_count_on_field;
            
            // Normalize genre target (lower case + remove common accents)
            var gn2 = variable_struct_exists(cfg, "genre") ? string_lower(string(cfg.genre)) : "";
            gn2 = string_replace_all(gn2, "ê", "e");
            gn2 = string_replace_all(gn2, "é", "e");
            gn2 = string_replace_all(gn2, "è", "e");

            var ownStr = variable_struct_exists(cfg, "owner") ? string_lower(cfg.owner) : "ally";
            var req = variable_struct_exists(cfg, "count") ? max(1, cfg.count) : 1;
            var cardOwnerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            var targetIsHero = (ownStr == "ally") ? cardOwnerIsHero : !cardOwnerIsHero;
            var arrX = targetIsHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
            var cntX = 0;
            
            for (var ix = 0; ix < array_length(arrX); ix++) {
                var cx = arrX[ix];
                if (cx != 0 && instance_exists(cx)) {
                    var zX = variable_instance_exists(cx, "zone") ? string_lower(cx.zone) : "";
                    if (zX == "field" || zX == "fieldselected") {
                        var gX = variable_instance_exists(cx, "genre") ? string_lower(string(cx.genre)) : "";
                        // Normalize card genre too
                        gX = string_replace_all(gX, "ê", "e");
                        gX = string_replace_all(gX, "é", "e");
                        gX = string_replace_all(gX, "è", "e");
                        
                        if (gX == gn2) { cntX += 1; }
                    }
                }
            }
            
            if (cntX < req) { return false; }
        }

        // Vérifier la présence d'un sort ennemi sur le terrain
        if (variable_struct_exists(conditions, "has_enemy_spell_on_field") && conditions.has_enemy_spell_on_field) {
            var ownerIsHero_es = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            // Si conditions.owner spécifie explicitement Hero/Enemy, l'utiliser pour déterminer le côté propriétaire
            if (variable_struct_exists(conditions, "owner")) {
                var ow_es = string_lower(conditions.owner);
                if (ow_es == "hero") ownerIsHero_es = true; else if (ow_es == "enemy") ownerIsHero_es = false;
            }
            if (!hasEnemySpellOnField(ownerIsHero_es)) {
                return false;
            }
        }

        // Vérifier la présence minimale de cartes en main du bon propriétaire
        // Supporte deux formes: conditions.has_card_in_hand (bool) et conditions.min_hand_size (nombre)
        var requireHandCheck = (variable_struct_exists(conditions, "has_card_in_hand") && conditions.has_card_in_hand)
                               || variable_struct_exists(conditions, "min_hand_size");
        if (requireHandCheck) {
            var ownerIsHero_hand = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            // Si conditions.owner est défini, prendre ce côté comme référence
            if (variable_struct_exists(conditions, "owner")) {
                var ow_hand = string_lower(conditions.owner);
                if (ow_hand == "hero") ownerIsHero_hand = true; else if (ow_hand == "enemy") ownerIsHero_hand = false;
            }
            var handInstCheck = ownerIsHero_hand ? handHero : handEnemy;
            if (!instance_exists(handInstCheck)) { return false; }
            var handSize = 0;
            if (is_array(handInstCheck.cards)) handSize = array_length(handInstCheck.cards); else handSize = ds_list_size(handInstCheck.cards);
            var minReq = variable_struct_exists(conditions, "min_hand_size") ? conditions.min_hand_size : 1;
            if (handSize < minReq) { return false; }
        }

        // Condition sur le mode d'invocation (ex: "Summon" vs "SpecialSummon").
        // Accepte une chaîne (égalité stricte) ou un tableau de chaînes (appartenance).
        if (variable_struct_exists(conditions, "summon_mode")) {
            if (!variable_struct_exists(context, "summon_mode")) {
                return false;
            }
            var cm = context.summon_mode;
            var sm = conditions.summon_mode;
            if (is_array(sm)) {
                var ok = false;
                for (var i = 0; i < array_length(sm); i++) {
                    if (sm[i] == cm) { ok = true; break; }
                }
                if (!ok) { return false; }
            } else {
                if (sm != cm) { return false; }
            }
        }

    }



    // Bloquer certains triggers pendant un sacrifice manuel si demandé
    if (variable_struct_exists(effect, "conditions")
        && variable_struct_exists(effect.conditions, "ignore_when_sacrifice")
        && effect.conditions.ignore_when_sacrifice) {
        if (variable_struct_exists(context, "from_sacrifice") && context.from_sacrifice) {
            var sacfor = variable_struct_exists(context, "sacrifice_for") ? context.sacrifice_for : noone;
            if (sacfor != noone && sacfor == card) {
                return false;
            }
        }
    }

        if (variable_struct_exists(effect, "conditions")
        && variable_struct_exists(effect.conditions, "ignore_when_discard")
        && effect.conditions.ignore_when_discard) {
            if (variable_struct_exists(context, "from_discard") && context.from_discard) {
                var tgt2 = variable_struct_exists(context, "target") ? context.target : noone;
                if (tgt2 != noone && tgt2 == card) {
                    return false;
                }
            }
        }

        if (variable_struct_exists(effect, "conditions")
            && variable_struct_exists(effect.conditions, "only_when_discard")
            && effect.conditions.only_when_discard) {
            if (!variable_struct_exists(context, "from_discard") || !context.from_discard) {
                return false;
            }
        }

    // Règle globale: par défaut, ON_SUMMON ne se déclenche que sur "Summon" (invocation normale/avec sacrifice).

    // Pour autoriser l'invocation spéciale, préciser conditions.summon_mode: "SpecialSummon" (ou un tableau incluant "SpecialSummon").

    var hasConds = variable_struct_exists(effect, "conditions");

    var hasSummonModeCond = hasConds && variable_struct_exists(effect.conditions, "summon_mode");

    if (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_ON_SUMMON) {

        if (!hasSummonModeCond) {

            if (variable_struct_exists(context, "summon_mode") && context.summon_mode != "Summon") {

                return false;

            }

        }

    }

    

    return true;

}



/// @function hasEffectAvailable(card, effect_type)

/// @description Vérifie si une carte possède un effet d'un type donné activable selon ses conditions

/// @param {struct} card - La carte

/// @param {string} effect_type - Type d'effet à rechercher

/// @returns {bool}

function hasEffectAvailable(card, effect_type) {

    if (!variable_instance_exists(card, "effects") || array_length(card.effects) == 0) return false;

    for (var i = 0; i < array_length(card.effects); i++) {

        var effect = card.effects[i];

        if (variable_struct_exists(effect, "effect_type") && effect.effect_type == effect_type) {

            // Si un trigger est défini, vérifier ses conditions

            if (!variable_struct_exists(effect, "trigger") || checkTriggerConditions(card, effect, {})) {

                return true;

            }

        }

    }

    return false;

}



/// @function getAvailableEffect(card)

/// @description Retourne le premier effet activable manuellement selon les conditions (phase/owner/etc.)

/// @param {struct} card - La carte

/// @returns {struct|noone} - L'effet disponible ou noone

function getAvailableEffect(card) {
    if (!variable_instance_exists(card, "effects") || array_length(card.effects) == 0) return noone;

    // Rassembler tous les effets manuels disponibles (conditions OK)
    var eligible = [];
    var isSort = (variable_instance_exists(card, "genre") && (card.genre == "Sort" || card.genre == "Direct"));

    for (var i = 0; i < array_length(card.effects); i++) {
        var effect = card.effects[i];
        var hasManualTrigger = !variable_struct_exists(effect, "trigger") 
            || effect.trigger == TRIGGER_MAIN_PHASE 
            || effect.trigger == TRIGGER_QUICK_EFFECT
            || (isSort && (effect.trigger == TRIGGER_ON_SPELL_CAST || effect.trigger == TRIGGER_ON_SUMMON));

        if (hasManualTrigger) {
            if (checkTriggerConditions(card, effect, {})) {
                array_push(eligible, effect);
            }
        }
    }
    if (array_length(eligible) == 0) return noone;

    // Priorité pour les Artéfacts: privilégier la sélection de cible (equip_select_target)
    var isArtifact = (variable_instance_exists(card, "genre") && card.genre == "Artéfact");
    if (isArtifact) {
        for (var j = 0; j < array_length(eligible); j++) {
            var e = eligible[j];
            if (variable_struct_exists(e, "effect_type") && e.effect_type == EFFECT_EQUIP_SELECT_TARGET) {
                return e;
            }
        }
    }

    // Sinon, retourner le premier éligible (comportement précédent)
    return eligible[0];
}


/// @function activateTrigger(card, triggerType, context)
/// @description Active tous les déclencheurs correspondants d'une carte
/// @param {struct} card - La carte
/// @param {string} triggerType - Le type de déclencheur
/// @param {struct} context - Le contexte de l'événement
/// @param {struct} context - Le contexte de l'événement
function activateTrigger(card, triggerType, context = {}) {
    // Garde d'existence: ignorer si la carte est manquante ou détruite
    if (card == noone || !instance_exists(card)) {
        return;
    }
    var cardName = variable_instance_exists(card, "name") ? card.name : "unknown";
    

    if (!variable_instance_exists(card, "effects")) return;

    

    for (var i = 0; i < array_length(card.effects); i++) {
        // Si la carte a été détruite pendant une itération précédente, sortir immédiatement
        if (!instance_exists(card)) { break; }

        var effect = card.effects[i];
        
        // Ignorer les effets annulés/purgés (Silence)
        if (variable_struct_exists(effect, "negated") && effect.negated) { continue; }

        if (variable_struct_exists(effect, "trigger") && effect.trigger == triggerType) {
            var effectTypeStr = variable_struct_exists(effect, "effect_type") ? string(effect.effect_type) : "unknown";
            // show_debug_message("### Found matching trigger for effect: " + effectTypeStr);
            if (checkTriggerConditions(card, effect, context)) {
                // show_debug_message("### Conditions passed, executing effect");

                // Marquer l'effet comme utilisé sera fait après exécution réussie

                

                // Debug: activation du trigger

                var cname = variable_instance_exists(card, "name") ? card.name : object_get_name(card.object_index);

                var etype = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "(none)";

                // show_debug_message("### activateTrigger: " + string(triggerType) + " on " + cname + " effect=" + string(etype));

                

                // Aura uniquement pour activation manuelle/phases visibles (éviter destruction/cimetière/dégâts)

                var allowAura = (triggerType == TRIGGER_MAIN_PHASE 

                    || triggerType == TRIGGER_START_TURN 

                    || triggerType == TRIGGER_END_TURN 

                    || triggerType == TRIGGER_QUICK_EFFECT);

                // Contexte peut demander la suppression explicite

                if (variable_struct_exists(context, "suppress_fx_aura") && context.suppress_fx_aura) {

                    allowAura = false;

                }

                // Option d'effet pour contrôler l'aura (forcer ou supprimer)
                if (variable_struct_exists(effect, "show_aura")) {
                    allowAura = effect.show_aura;
                }

                

                if (allowAura) {

                    requestFXAura(

                        card.sprite_index,

                        card.image_index,

                        card.image_xscale,

                        card.image_yscale,

                        card.image_angle,

                        600,

                        18,

                        10,

                        1.50, // ovalisation largeur, légèrement moins marqué

                        0.80, // ovalisation hauteur, légèrement moins aplati

                        card.x,

                        card.y

                    );

                }

                // Activer l'effet et savoir s'il a réussi
                var effectSucceeded = executeEffect(card, effect, context);
                // Marquer l'effet comme utilisé si la résolution a réussi
                if (effectSucceeded) {
                    markEffectAsUsed(card, effect);
                }

                // Consommer les sorts Direct (non-continus) uniquement si la résolution a réussi
                if (effectSucceeded && !is_undefined(consumeSpellIfNeeded)) {
                    consumeSpellIfNeeded(card, effect);
                    // Si la consommation a détruit la carte, arrêter l'itération pour éviter les accès invalides
                    if (!instance_exists(card)) { break; }
                }

            }

        }

    }

}



/// @function markEffectAsUsed(card, effect)

/// @description Marque un effet comme utilisé pour ce tour

/// @param {struct} card - La carte

/// @param {struct} effect - L'effet

function markEffectAsUsed(card, effect) {

    if (variable_struct_exists(effect, "conditions") && 

        variable_struct_exists(effect.conditions, "once_per_turn") && 

        effect.conditions.once_per_turn) {

        

        if (!variable_global_exists("used_effects")) {

            global.used_effects = ds_list_create();

        }

        

        var turnStr = variable_global_exists("current_turn") ? string(global.current_turn) : (instance_exists(oGame) ? string(oGame.nbTurn) : "0");

    var effectId = string(card.id) + "_" + string(effect.id) + "_turn_" + turnStr;

    ds_list_add(global.used_effects, effectId);

    }

}



/// @function resetTurnEffects()

/// @description Remet à zéro les effets "une fois par tour"

function resetTurnEffects() {

    if (variable_global_exists("used_effects")) {

        ds_list_clear(global.used_effects);

    }

}



/// @function getHandSize()

/// @description Retourne le nombre de cartes en main

/// @returns {real} - Nombre de cartes en main

function getHandSize() {

    // Adapte selon le type de structure utilisé pour la main

    if (instance_exists(oHand)) {

        if (is_array(oHand.cards)) {

            return array_length(oHand.cards);

        } else {

            return ds_list_size(oHand.cards);

        }

    }

    return 0;

}



/// @function registerTriggerEvent(triggerType, sourceCard, context)

/// @description Enregistre un événement de déclencheur pour toutes les cartes sur le terrain

/// @param {string} triggerType - Le type de déclencheur

/// @param {struct} sourceCard - La carte source de l'événement (optionnel)

/// @param {struct} context - Le contexte de l'événement

function registerTriggerEvent(triggerType, sourceCard = noone, context = {}) {
    // Debug global supprimé: garder la console focalisée sur les artéfacts
    
    if (triggerType == TRIGGER_START_TURN) {
        if (!variable_global_exists("minions_died_this_turn")) global.minions_died_this_turn = 0;
        global.minions_died_this_turn = 0;
    }

    // Source sûre (sourceCard valide ou carte détruite fournie dans le contexte)
    var srcCardSafe = noone;
    if (sourceCard != noone && instance_exists(sourceCard)) {
        srcCardSafe = sourceCard;
    } else if (variable_struct_exists(context, "destroyed_card") && instance_exists(context.destroyed_card)) {
        srcCardSafe = context.destroyed_card;
    }



    // Ajouter la carte source au contexte et déclencher directement sur elle

    if (srcCardSafe != noone) {

        context.source = srcCardSafe;
        if (!variable_struct_exists(context, "owner_is_hero") && variable_instance_exists(srcCardSafe, "isHeroOwner")) {
            context.owner_is_hero = srcCardSafe.isHeroOwner;
        }

        // Désactiver l'aura pour les triggers liés à la destruction/cimetière

        if (triggerType == TRIGGER_ENTER_GRAVEYARD || triggerType == TRIGGER_ON_DESTROY) {

            context.suppress_fx_aura = true;

        }

        // Protection artefacts: au moment du placement/cast, marquer l'équipement comme en ciblage
        if (srcCardSafe != noone && instance_exists(srcCardSafe)) {
            var isArtifact = (variable_instance_exists(srcCardSafe, "genre") && string_lower(srcCardSafe.genre) == string_lower("Artéfact"));
            var hasEquipSelect = false;
            if (isArtifact && variable_instance_exists(srcCardSafe, "effects") && is_array(srcCardSafe.effects)) {
                for (var ei = 0; ei < array_length(srcCardSafe.effects); ei++) {
                    var effi = srcCardSafe.effects[ei];
                    if (is_struct(effi) && variable_struct_exists(effi, "effect_type") && effi.effect_type == EFFECT_EQUIP_SELECT_TARGET) { hasEquipSelect = true; break; }
                }
            }
            if (hasEquipSelect) {
                if (!variable_instance_exists(srcCardSafe, "equip_pending")) srcCardSafe.equip_pending = false;
                // Si pas encore équipée à une cible, empêcher le cleanup destructif
                if (!variable_instance_exists(srcCardSafe, "equipped_target") || srcCardSafe.equipped_target == noone) {
                    srcCardSafe.equip_pending = true;
                }
            }
        }
        // Si la carte source est face cachée, ne pas déclencher certains triggers immédiats
        var isFD = (variable_instance_exists(srcCardSafe, "isFaceDown") && srcCardSafe.isFaceDown);
        if (!(isFD && (triggerType == TRIGGER_ENTER_FIELD || triggerType == TRIGGER_ON_SUMMON))) {
            // Déclenche l'effet sur la carte source même si elle quitte le terrain
            activateTrigger(srcCardSafe, triggerType, context);
        }

    }



    // Événements centrés sur la carte source: ne pas diffuser aux autres cartes

    // - ENTER_GRAVEYARD et ON_DESTROY sont déjà non diffusés

    // - ON_SUMMON et ENTER_FIELD doivent s'appliquer uniquement à la carte qui vient d'entrer

    if (triggerType == TRIGGER_ENTER_GRAVEYARD 

        || triggerType == TRIGGER_ON_DESTROY 

        || triggerType == TRIGGER_ON_SUMMON 

        || triggerType == TRIGGER_ENTER_FIELD) {

        return;

    }

    

    // Spécifique: activer les Secrets lors de l’invocation d’un monstre
    if (triggerType == TRIGGER_ON_MONSTER_SUMMON) {
        if (sourceCard != noone && instance_exists(sourceCard)) {
            activateSecretsOnMonsterSummon(sourceCard);
        }
    }
    
    // Spécifique: activer les Secrets lors du lancement d'un sort
    if (triggerType == TRIGGER_ON_SPELL_CAST) {
        if (sourceCard != noone && instance_exists(sourceCard) && script_exists(asset_get_index("activateSecretsOnSpellCast"))) {
            activateSecretsOnSpellCast(sourceCard, context);
        }
    }

    if (triggerType == TRIGGER_END_TURN) {
        var activeIsHero3 = true;
        if (instance_exists(game)) {
             var localIdx = (variable_instance_exists(game, "local_player_index")) ? game.local_player_index : 0;
             activeIsHero3 = (game.player_current == localIdx);
        }
        
        if (!variable_global_exists("end_turn_queue") || !is_array(global.end_turn_queue)) { global.end_turn_queue = []; }
        global.end_turn_queue = [];
        global.end_turn_ptr = 0;
        global.end_turn_processing = true;
        global.end_turn_waiting = false;
        
        // Define Active and Inactive fields
        var fmActive = activeIsHero3 ? fieldMonsterHero : fieldMonsterEnemy;
        var fspActive = activeIsHero3 ? fieldMagicTrapHero : fieldMagicTrapEnemy;
        var fmInactive = activeIsHero3 ? fieldMonsterEnemy : fieldMonsterHero;
        var fspInactive = activeIsHero3 ? fieldMagicTrapEnemy : fieldMagicTrapHero;

        // 1. Process Active Player's Monsters (Entrave decrement + Triggers)
        if (instance_exists(fmActive)) {
            for (var i0 = 0; i0 < array_length(fmActive.cards); i0++) {
                var c0 = fmActive.cards[i0];
                if (c0 != 0 && instance_exists(c0)) {
                    // Entrave decrement (only for active player at end of their turn)
                    if (variable_instance_exists(c0, "entrave_turns_remaining") && c0.entrave_turns_remaining > 0) {
                        c0.entrave_turns_remaining -= 1;
                        if (c0.entrave_turns_remaining <= 0) {
                            if (variable_instance_exists(c0, "entrave_block_attack")) c0.entrave_block_attack = false;
                            if (variable_instance_exists(c0, "entrave_block_position")) c0.entrave_block_position = false;
                        }
                    }
                    // Check triggers
                    if (variable_instance_exists(c0, "effects") && is_array(c0.effects)) {
                        for (var e0 = 0; e0 < array_length(c0.effects); e0++) {
                            var eff0 = c0.effects[e0];
                            if (is_struct(eff0) && variable_struct_exists(eff0, "trigger") && eff0.trigger == TRIGGER_END_TURN) {
                                if (checkTriggerConditions(c0, eff0, context)) { array_push(global.end_turn_queue, { card: c0, effect: eff0 }); }
                            }
                        }
                    }
                }
            }
        }
        
        // 2. Process Inactive Player's Monsters (Triggers ONLY)
        if (instance_exists(fmInactive)) {
            for (var i1 = 0; i1 < array_length(fmInactive.cards); i1++) {
                var c1 = fmInactive.cards[i1];
                if (c1 != 0 && instance_exists(c1)) {
                    // NO Entrave decrement for inactive player
                    if (variable_instance_exists(c1, "effects") && is_array(c1.effects)) {
                        for (var e1 = 0; e1 < array_length(c1.effects); e1++) {
                            var eff1 = c1.effects[e1];
                            if (is_struct(eff1) && variable_struct_exists(eff1, "trigger") && eff1.trigger == TRIGGER_END_TURN) {
                                if (checkTriggerConditions(c1, eff1, context)) { array_push(global.end_turn_queue, { card: c1, effect: eff1 }); }
                            }
                        }
                    }
                }
            }
        }

        // 3. Process Active Player's Spells/Traps
        if (instance_exists(fspActive)) {
            for (var j0 = 0; j0 < array_length(fspActive.cards); j0++) {
                var s0 = fspActive.cards[j0];
                if (s0 != 0 && instance_exists(s0)) {
                    if (variable_instance_exists(s0, "effects") && is_array(s0.effects)) {
                        for (var f0 = 0; f0 < array_length(s0.effects); f0++) {
                            var se0 = s0.effects[f0];
                            if (is_struct(se0) && variable_struct_exists(se0, "trigger") && se0.trigger == TRIGGER_END_TURN) {
                                if (checkTriggerConditions(s0, se0, context)) { array_push(global.end_turn_queue, { card: s0, effect: se0 }); }
                            }
                        }
                    }
                }
            }
        }
        
        // 4. Process Inactive Player's Spells/Traps
        if (instance_exists(fspInactive)) {
            for (var j1 = 0; j1 < array_length(fspInactive.cards); j1++) {
                var s1 = fspInactive.cards[j1];
                if (s1 != 0 && instance_exists(s1)) {
                    if (variable_instance_exists(s1, "effects") && is_array(s1.effects)) {
                        for (var f1 = 0; f1 < array_length(s1.effects); f1++) {
                            var se1 = s1.effects[f1];
                            if (is_struct(se1) && variable_struct_exists(se1, "trigger") && se1.trigger == TRIGGER_END_TURN) {
                                if (checkTriggerConditions(s1, se1, context)) { array_push(global.end_turn_queue, { card: s1, effect: se1 }); }
                            }
                        }
                    }
                }
            }
        }
        if (variable_global_exists("endTurnSequencerNext") && !is_undefined(global.endTurnSequencerNext)) { global.endTurnSequencerNext(); } else {
            global.endTurnSequencerNext = function() {
                if (!variable_global_exists("end_turn_queue") || !is_array(global.end_turn_queue)) { global.end_turn_processing = false; return; }
                if (!variable_global_exists("end_turn_ptr")) { global.end_turn_ptr = 0; }
                if (global.end_turn_ptr >= array_length(global.end_turn_queue)) {
                    global.end_turn_processing = false;
                    global.end_turn_waiting = false;
                    if (variable_global_exists("resetTemporaryEffects") && !is_undefined(global.resetTemporaryEffects)) { global.resetTemporaryEffects(); }
                    else if (script_exists(asset_get_index("resetTemporaryEffects"))) { resetTemporaryEffects(); }
                    return;
                }
                var it = global.end_turn_queue[global.end_turn_ptr];
                var cd = variable_struct_exists(it, "card") ? it.card : noone;
                var ef = variable_struct_exists(it, "effect") ? it.effect : noone;
                if (cd == noone || ef == noone || !instance_exists(cd)) { global.end_turn_ptr += 1; global.endTurnSequencerNext(); return; }
                var ctxX = { owner_is_hero: (variable_instance_exists(cd, "isHeroOwner") ? cd.isHeroOwner : true) };
                var okx = executeEffect(cd, ef, ctxX);
                if (!variable_global_exists("anim_fx_list") || !is_array(global.anim_fx_list) || array_length(global.anim_fx_list) == 0) {
                    global.end_turn_ptr += 1;
                    global.endTurnSequencerNext();
                } else {
                    global.end_turn_waiting = true;
                }
            };
            global.endTurnSequencerNext();
        }
        return;
    }

    
    // Vérifier tous les monstres sur le terrain
    with (oCardMonster) {
        if (zone == "Field") {
            // Gating: Only owner’s cards receive START/END turn triggers
            if (triggerType == TRIGGER_START_TURN || triggerType == TRIGGER_END_TURN) {
                if (triggerType == TRIGGER_END_TURN) {
                    if (variable_instance_exists(self, "entrave_turns_remaining") && self.entrave_turns_remaining > 0) {
                        self.entrave_turns_remaining -= 1;
                        if (self.entrave_turns_remaining <= 0) {
                            if (variable_instance_exists(self, "entrave_block_attack")) self.entrave_block_attack = false;
                            if (variable_instance_exists(self, "entrave_block_position")) self.entrave_block_position = false;
                        }
                    }
                }
                // Restriction: seulement face visible
                if (variable_instance_exists(self, "isFaceDown") && self.isFaceDown) {
                    continue;
                }
            }
            activateTrigger(self, triggerType, context);
        }
    }

    

    // Vérifier les cartes magiques continues

    with (oCardMagic) {
        var g = variable_instance_exists(self, "genre") ? string_lower(self.genre) : "";
        var isArtifact2 = (g == "artéfact" || g == "artefact");
        var isContinuousByType = (variable_instance_exists(self, "type") && self.type == "Continuous");
        var isContinuousByGenre = (variable_instance_exists(self, "genre") && (string_lower(self.genre) == "continue" || string_lower(self.genre) == "continu"));

        if (zone == "Field" && (isContinuousByType || isContinuousByGenre || isArtifact2)) {
            // Gating: seulement cartes du joueur actif et face visible
            if (triggerType == TRIGGER_START_TURN || triggerType == TRIGGER_END_TURN) {
                if (variable_instance_exists(self, "isFaceDown") && self.isFaceDown) {
                    continue;
                }
            }
            activateTrigger(self, triggerType, context);
            // Auto-destruction générique des Artéfacts si la cible équipée quitte le terrain
            if (triggerType == TRIGGER_LEAVE_FIELD) {
                if (isArtifact2 && variable_instance_exists(self, "equipped_target") && self.equipped_target != noone) {
                    var srcLv = variable_struct_exists(context, "source") ? context.source : noone;
                    if (srcLv != noone && instance_exists(srcLv) && self.equipped_target == srcLv) {
                        show_debug_message("### Artifact cleanup: Target " + string(srcLv.name) + " left field. Destroying " + string(self.name));
                        if (!is_undefined(destroyCard)) { destroyCard(self.id); }
                    }
                }
            }
        }
    }



    // Diffuser aux cartes en main pour les triggers globaux pertinents
    if (triggerType == TRIGGER_ON_MONSTER_SENT_TO_GRAVEYARD) {
        with (oCardMonster) {
            if (zone == "Hand" || zone == "HandSelected") {
                activateTrigger(self, triggerType, context);
            }
        }
    }
}



// === FONCTIONS UTILITAIRES ===



// getTriggerName centralisé dans scripts/sTriggerLabels/sTriggerLabels.gml

// Utiliser directement getTriggerName(triggerType) depuis le script centralisé.



/// @function getTriggerLabel(triggerId)

/// @description Retourne le libellé court en FR pour un déclencheur donné

/// @param {string} triggerId - Macro TRIGGER_*

/// @returns {string}

// getTriggerLabel centralisé dans scripts/sTriggerLabels/sTriggerLabels.gml



/// @function getTriggerDetailedDescription(triggerId)

/// @description Retourne une description détaillée en FR pour un déclencheur donné

/// @param {string} triggerId - Macro TRIGGER_*

/// @returns {string}

// getTriggerDetailedDescription centralisé dans scripts/sTriggerLabels/sTriggerLabels.gml

    // (garde ignore_when_sacrifice déplacée dans checkTriggerConditions)


