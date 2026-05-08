// === Script des Effets Possibles ===
// Ce script contient tous les effets possibles pour les cartes

// === CONSTANTES DES TYPES D'EFFETS ===

// Effets de base
#macro EFFECT_DRAW_CARDS "draw_cards"                   // Piocher des cartes
#macro TARGET_ENEMY_MONSTER "target_enemy_monster"      // Cible un monstre adverse


#macro EFFECT_DISCARD "discard"                          // Effet unifié de défausse paramétrable
#macro EFFECT_TEMPO "tempo"                              // Étape de délai/tempo pour les flows


// Effets de combat
#macro EFFECT_LOSE_ATTACK "lose_attack"                 // Perdre de l'ATK
#macro EFFECT_LOSE_DEFENSE "lose_defense"               // Perdre de la PV
#macro EFFECT_LOSE_ATTACK_PERMANENT "lose_attack_permanent" // Perdre de l'ATK de façon permanente
#macro EFFECT_SET_ATTACK "set_attack"                   // Définir l'ATK
#macro EFFECT_SET_DEFENSE "set_defense"                 // Définir la PV
#macro EFFECT_BUFF "buff"
#macro EFFECT_POISON "poison"
#macro EFFECT_STEALTH "stealth"
#macro EFFECT_PONCTION "ponction"
#macro EFFECT_INCREASE_HAND_COST "increase_hand_cost"
#macro EFFECT_SET_NEXT_PLAYED_MONSTER_COST_BONUS "set_next_played_monster_cost_bonus"
#macro EFFECT_TERRAIN_TICK "terrain_tick"
#macro EFFECT_EGIDE "egide"
#macro EFFECT_PERCEE "percee"
#macro EFFECT_REPOUSSEMENT "repoussement"
#macro EFFECT_TARGET_FACING "target_facing"
#macro EFFECT_APPLY_DOT "apply_dot"
#macro EFFECT_DOT_TICK "dot_tick"
#macro EFFECT_TRACK_GRAVEYARD_PRESENCE "track_graveyard_presence"
#macro EFFECT_SET_SELF_BUFF_CONTRIB "set_self_buff_contrib"
#macro EFFECT_CONDITIONAL_FLOW "conditional_flow"
#macro EFFECT_REMOVE_SELF_BUFF_CONTRIBS "remove_self_buff_contribs"
#macro EFFECT_MARK_ATTACK_DAMAGE "mark_attack_damage"
#macro EFFECT_ADD_RANDOM_TO_HAND "add_random_to_hand"
#macro EFFECT_DAMAGE_ALL_PER_ALLY_COUNT "damage_all_per_ally_count"
#macro EFFECT_RANDOM_PROJECTILES "random_projectiles"
#macro EFFECT_TRACK_FIELD_PRESENCE "track_field_presence"
#macro EFFECT_TRACK_SELF_PROPERTY_BOOL "track_self_property_bool"
#macro EFFECT_CLEAVE_ADJACENT "cleave_adjacent"
#macro EFFECT_SET_SELF_ATTACK_PER_GRAVEYARD_COUNT "set_self_attack_per_graveyard_count"
#macro EFFECT_COUNT_APPLY "count_apply"
#macro EFFECT_MARK_DRAW_ON_DEATH_THIS_TURN "mark_draw_on_death_this_turn"
#macro EFFECT_MARK_DRAW_ON_KILL_THIS_TURN "mark_draw_on_kill_this_turn"
#macro EFFECT_MARK_DRAW_ON_DAMAGE "mark_draw_on_damage"

// Effets de ciblage
#macro EFFECT_DESTROY_TARGET "destroy_target"           // Détruire une cible
#macro EFFECT_DAMAGE_TARGET "damage_target"             // Dégâts à une cible
#macro EFFECT_HEAL_TARGET "heal_target"                 // Soigner une cible
#macro EFFECT_DESTROY_SELF "destroy_self"               // Se détruire
#macro EFFECT_DESTROY "destroy"                         // Effet générique de destruction par critères
#macro EFFECT_BANISH_TARGET "banish_target"             // Bannir une cible
#macro EFFECT_RETURN_TO_HAND "return_to_hand"           // Renvoyer en main
#macro EFFECT_REVEAL_HAND "reveal_hand"

// Effets de zone
#macro EFFECT_DESTROY_ALL "destroy_all"                 // Détruire tous les monstres
#macro EFFECT_DAMAGE_ALL "damage_all"                   // Dégâts à tous
#macro EFFECT_DAMAGE_ALL_REPEAT_PER_DEATHS_THIS_TURN "damage_all_repeat_per_deaths_this_turn"
#macro EFFECT_HEAL_ALL "heal_all"                       // Soins à tous

// Effets de manipulation de deck

#macro EFFECT_SHUFFLE_DECK "shuffle_deck"               // Mélanger le deck
#macro EFFECT_ADD_TO_DECK "add_to_deck"                 // Ajouter au deck
#macro EFFECT_ADD_TO_HAND "add_to_hand"                 // Ajouter en main (création si absente)

// Effets de manipulation de cimetière
#macro EFFECT_REVIVE "revive"                           // Ressusciter du cimetière
#macro EFFECT_BANISH_FROM_GRAVEYARD "banish_graveyard"  // Bannir du cimetière
#macro EFFECT_SHUFFLE_GRAVEYARD "shuffle_graveyard"     // Mélanger le cimetière dans le deck

// Effets spéciaux
#macro EFFECT_SEARCH "search"                        // Effet générique de recherche (deck, cimetière, main, terrain vers destination)
#macro EFFECT_SUMMON "summon"                        // Effet générique d'invocation (token, self, nommé, source, spell)

#macro EFFECT_CHANGE_TYPE "change_type"                 // Changer le type
#macro EFFECT_CHANGE_ATTRIBUTE "change_attribute"       // Changer l'attribut
#macro EFFECT_NEGATE_EFFECT "negate_effect"             // Annuler un effet
#macro EFFECT_PURGE "purge"                             // Purger (Silence) une unité
#macro EFFECT_COPY_EFFECT "copy_effect"                 // Copier un effet
#macro EFFECT_END_DISCARD_DESTROY_ENEMY_SPELL "end_discard_destroy_enemy_spell" // Finalisation : défausser 1, détruire 1 Magie adverse


// Effets de contrôle
#macro EFFECT_SKIP_TURN "skip_turn"                     // Passer le tour
#macro EFFECT_EXTRA_TURN "extra_turn"                   // Tour supplémentaire
#macro EFFECT_CHANGE_PHASE "change_phase"               // Changer de phase
#macro EFFECT_END_BATTLE "end_battle"                   // Terminer la phase de combat

// Effets de protection
#macro EFFECT_IMMUNITY "immunity"                       // Immunité
#macro EFFECT_PROTECTION "protection"                   // Protection
#macro EFFECT_INDESTRUCTIBLE "indestructible"           // Indestructible
#macro EFFECT_UNTARGETABLE "untargetable"               // Non-ciblable
#macro EFFECT_ENTRAVE "entrave"
#macro EFFECT_CAMOUFLAGE "camouflage"
#macro EFFECT_ILLUSION "illusion"

// Effet combiné: défausser cette carte de la main pour chercher par archétype



// Effets d’équipement (nouveaux)
#macro EFFECT_EQUIP_SELECT_TARGET "equip_select_target"   // Sélectionner une cible et équiper
#macro EFFECT_EQUIP_CLEANUP "equip_cleanup"               // Nettoyer à la destruction (réinitialiser la cible)

// Effets d’aura de champ (nouveaux)
#macro EFFECT_AURA_ALL_MONSTERS_DEBUFF "aura_all_monsters_debuff"   // Aura: debuff ATK/PV pour tous les monstres sur le terrain
#macro EFFECT_AURA_CLEANUP_SOURCE "aura_cleanup_source"   // Nettoyage d’aura: retirer les contributions d’une source
#macro EFFECT_AURA_DAMAGE_REDUCTION "aura_damage_reduction"
#macro EFFECT_AURA_DAMAGE_TAKEN_BONUS "aura_damage_taken_bonus"
#macro EFFECT_POINTS "points_effect"
#macro EFFECT_ATTACK_DIRECT "attack_direct"
#macro EFFECT_DECK_REORDER_TOP3 "deck_top3_reorder"
#macro EFFECT_PILLAGE "pillage"
#macro EFFECT_GENERIC_FLOW "generic_flow"
#macro EFFECT_SACRIFICE_TARGET "sacrifice_target"

// === FONCTION PRINCIPALE D'EXÉCUTION DES EFFETS ===

/// @function isTargetingRequired(effect)
/// @description Vérifie si un effet nécessite un ciblage manuel
/// @param {struct} effect
/// @returns {bool}
function isTargetingRequired(effect) {
    if (!is_struct(effect)) return false;
    if (!variable_struct_exists(effect, "effect_type")) return false;
    
    var etype = effect.effect_type;
    
    // Liste des effets nécessitant une cible manuelle
    if (etype == EFFECT_DESTROY_TARGET ||
        etype == EFFECT_SACRIFICE_TARGET ||
        etype == EFFECT_EQUIP_SELECT_TARGET ||
        etype == EFFECT_ENTRAVE ||
        etype == EFFECT_RETURN_TO_HAND ||
        etype == EFFECT_BANISH_TARGET ||
        etype == EFFECT_DAMAGE_TARGET ||
        etype == EFFECT_HEAL_TARGET ||
        etype == EFFECT_PURGE ||
        (etype == EFFECT_SUMMON && variable_struct_exists(effect, "summon_mode") && string_lower(effect.summon_mode) == "copy_target")) {
        return true;
    }
    
    // Pour les buffs, vérifier le scope
    if (etype == EFFECT_BUFF) {
        var scope = "single";
        if (variable_struct_exists(effect, "scope")) scope = effect.scope;
        if (scope == "single" || scope == "select") return true;
    }
    
    // Pour le changement de contrôle, vérifier s'il existe (non standardisé encore)
    if (variable_struct_exists(effect, "target_required") && effect.target_required) return true;
    
    // Si select_mode est random, pas de ciblage manuel
    if (variable_struct_exists(effect, "select_mode") && effect.select_mode == "random") return false;
    
    return false;
}

function _countFieldByCriteria(fieldCardsArray, includeFaceDown, criteria, objectNames) {
    var count = 0;
    if (!is_array(fieldCardsArray)) return 0;
    var hasCrit = is_struct(criteria) && script_exists(asset_get_index("_cardMatchesCriteria"));
    var hasNames = is_array(objectNames) && array_length(objectNames) > 0;
    for (var i = 0; i < array_length(fieldCardsArray); i++) {
        var c0 = fieldCardsArray[i];
        if (c0 == 0 || !instance_exists(c0)) continue;
        var z0 = variable_instance_exists(c0, "zone") ? string_lower(c0.zone) : "";
        if (!(z0 == "field" || z0 == "fieldselected")) continue;
        if (!includeFaceDown && variable_instance_exists(c0, "isFaceDown") && c0.isFaceDown) continue;
        
        var ok = true;
        if (hasNames) {
            ok = false;
            var on0 = object_get_name(c0.object_index);
            for (var j = 0; j < array_length(objectNames); j++) {
                if (on0 == string(objectNames[j])) { ok = true; break; }
            }
        }
        if (ok && hasCrit) {
            if (!_cardMatchesCriteria(c0, criteria)) ok = false;
        }
        if (ok) count += 1;
    }
    return count;
}

function _countGraveyardByCriteria(graveyardArray, criteria, objectNames) {
    var count = 0;
    if (!is_array(graveyardArray)) return 0;
    var hasCrit = is_struct(criteria) && script_exists(asset_get_index("_cardMatchesCriteria"));
    var hasNames = is_array(objectNames) && array_length(objectNames) > 0;
    for (var i = 0; i < array_length(graveyardArray); i++) {
        var g0 = graveyardArray[i];
        if (g0 == noone) continue;
        var ok = true;
        if (hasNames) {
            ok = false;
            if (variable_struct_exists(g0, "object_index")) {
                var on0 = object_get_name(g0.object_index);
                for (var j = 0; j < array_length(objectNames); j++) {
                    if (on0 == string(objectNames[j])) { ok = true; break; }
                }
            }
        }
        if (ok && hasCrit) {
            if (!_cardMatchesCriteria(g0, criteria)) ok = false;
        }
        if (ok) count += 1;
    }
    return count;
}

function checkCondition(condition, card, context) {
    if (condition == "control_camouflaged") {
        var checkHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
        var mgr = checkHero ? (instance_exists(oFieldManagerHero) ? oFieldManagerHero : noone) : (instance_exists(oFieldManagerEnemy) ? oFieldManagerEnemy : noone);
        if (mgr != noone) {
            var fM = mgr.getField("Monster");
            if (fM != noone) {
                for (var im = 0; im < array_length(fM.cards); im++) {
                    var cm = fM.cards[im];
                    if (cm != 0 && instance_exists(cm) && variable_instance_exists(cm, "isCamouflage") && cm.isCamouflage) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    return true;
}

function getEffectIndex(card, effect) {
    if (card == noone || !instance_exists(card)) return -1;
    if (!variable_instance_exists(card, "effects") || !is_array(card.effects)) return -1;
    var len = array_length(card.effects);
    for (var i = 0; i < len; i++) {
        var e = card.effects[i];
        if (e == effect) return i;
    }
    if (is_struct(effect) && variable_struct_exists(effect, "id")) {
        var eid = effect.id;
        for (var j = 0; j < len; j++) {
            var e2 = card.effects[j];
            if (is_struct(e2) && variable_struct_exists(e2, "id") && e2.id == eid) {
                return j;
            }
        }
    }
    return -1;
}

/// @function executeEffect(card, effect, context)
/// @description Exécute un effet spécifique
/// @param {struct} card - La carte qui active l'effet
/// @param {struct} effect - L'effet à exécuter
/// @param {struct} context - Le contexte de l'activation
function executeEffect(card, effect, context = {}) {
    if (!variable_struct_exists(effect, "effect_type")) {
        show_debug_message("Erreur : Effet sans type défini");
        return false;
    }

    // Vérification des conditions de trigger (Unified Trigger System)
    // Cela permet de bloquer l'exécution si les prérequis (ex: min_genre_count) ne sont pas satisfaits
    // même si l'effet est exécuté manuellement via oHand
    if (script_exists(asset_get_index("checkTriggerConditions"))) {
        if (!checkTriggerConditions(card, effect, context)) {
            return false;
        }
    }
    
    // Vérification de condition d'exécution (ex: Combo)
    if (variable_struct_exists(effect, "condition")) {
        if (!checkCondition(effect.condition, card, context)) {
            // Condition non remplie, on ignore l'effet
            return false;
        }
    }
    
    var effectType = effect.effect_type;
    // Utiliser la valeur du contexte si elle existe, sinon celle de l'effet
    var value = variable_struct_exists(context, "value") ? context.value 
                : (variable_struct_exists(effect, "value") ? effect.value : 0);
    var target = variable_struct_exists(context, "target") ? context.target : noone;
    // Résoudre/forcer la cible à partir de target_source si l'effet le demande
    if (variable_struct_exists(effect, "target_source")) {
        var tsrc = effect.target_source;
        if (tsrc == "attacker" && variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) {
            target = context.attacker;
        } else if (tsrc == "defender" && variable_struct_exists(context, "defender") && instance_exists(context.defender)) {
            target = context.defender;
        } else if (tsrc == "summoned" && variable_struct_exists(context, "summoned") && instance_exists(context.summoned)) {
            target = context.summoned;
        } else if (tsrc == "source" && variable_struct_exists(context, "source") && instance_exists(context.source)) {
            target = context.source;
        }
    }
    
    // Log de l'effet pour debug (détaillé)
    var effTrigger = variable_struct_exists(effect, "trigger") ? effect.trigger : "";
    // Sécuriser la récupération du nom de la carte, même si l'instance n'existe plus
    var cardName = "unknown";
    if (card != noone) {
        if (instance_exists(card)) {
            if (variable_instance_exists(card, "name")) {
                cardName = card.name;
            } else if (variable_instance_exists(card, "object_index")) {
                cardName = object_get_name(card.object_index);
            }
        } else if (is_struct(card) && variable_struct_exists(card, "object_index")) {
            cardName = object_get_name(card.object_index);
        }
    }
    var targetDesc = "aucune cible";
    if (target != noone) {
        if (instance_exists(target)) {
            if (variable_instance_exists(target, "name")) {
                targetDesc = target.name;
            } else if (variable_instance_exists(target, "object_index")) {
                targetDesc = object_get_name(target.object_index);
            } else {
                targetDesc = "cible inconnue";
            }
        } else if (is_struct(target) && variable_struct_exists(target, "name")) {
            targetDesc = target.name;
        }
    }
    var valueStr = variable_struct_exists(effect, "value") ? ("valeur=" + string(value)) : "valeur=nd";
    var cardZone = "unknown";
    if (card != noone && instance_exists(card) && variable_instance_exists(card, "zone")) {
        cardZone = card.zone;
    } else if (is_struct(card) && variable_struct_exists(card, "zone")) {
        cardZone = card.zone;
    }
    // Réduire le spam: ignorer les logs pour les effets continus
    if (effTrigger != TRIGGER_CONTINUOUS) {
        show_debug_message("### Effet: type=" + string(effectType) + " trig=" + string(effTrigger) + " card=" + string(cardName) + " zone=" + string(cardZone) + " " + valueStr + " cible=" + string(targetDesc));
    }
    
    // Ciblage manuel si aucune cible fournie pour les effets ciblés
    var scope_for_target = string_lower(variable_struct_exists(effect, "scope") ? effect.scope : "single");
    var needsTarget = (
                       effectType == EFFECT_DESTROY_TARGET
                       || effectType == EFFECT_SACRIFICE_TARGET
                       || effectType == EFFECT_BANISH_TARGET
                       || effectType == EFFECT_DAMAGE_TARGET
                       || effectType == EFFECT_RETURN_TO_HAND
                       || effectType == EFFECT_EQUIP_SELECT_TARGET
                       || effectType == EFFECT_MARK_ATTACK_DAMAGE
                       || (effectType == EFFECT_SUMMON && string_lower(variable_struct_exists(effect, "summon_mode") ? effect.summon_mode : "") == "copy_target")
                       || (effectType == EFFECT_BUFF && scope_for_target == "single")
                       || (effectType == EFFECT_ENTRAVE && scope_for_target == "single")
                       || (effectType == EFFECT_POINTS && string_lower(variable_struct_exists(effect, "scope") ? effect.scope : "lp") == "card" && string_lower(variable_struct_exists(effect, "select_mode") ? effect.select_mode : "filter") == "target")
                       || effectType == EFFECT_PURGE
                       );
    
    if (!((effectType == EFFECT_BUFF) && (scope_for_target == "single") && !variable_struct_exists(effect, "owner") && !variable_struct_exists(effect, "criteria")) && needsTarget && target == noone) {
        // Activation manuelle uniquement (phase principale ou effet rapide) et uniquement côté Héros (jamais IA)
        var isManualActivation = (!variable_struct_exists(effect, "trigger")
                                  || effect.trigger == TRIGGER_MAIN_PHASE
                                  || effect.trigger == TRIGGER_QUICK_EFFECT
                                  || effect.trigger == TRIGGER_ON_SUMMON);
        var ownerIsHero_ctx = (variable_struct_exists(context, "owner_is_hero")) ? context.owner_is_hero
                              : ((card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true);
        
        if (isManualActivation && ownerIsHero_ctx && instance_exists(oSelectManager)) {
            var hasValidTarget = true;
            if (effectType == EFFECT_BUFF) {
                var scopeS = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
                if (scopeS == "single") {
                    hasValidTarget = false;
                    var ow = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
                    var crit = variable_struct_exists(effect, "criteria") ? effect.criteria : noone;
                    var excludeSelf = (is_struct(crit) && variable_struct_exists(crit, "exclude_self")) ? crit.exclude_self : false;
                    var arr = (ow == "ally") ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
                    for (var ii = 0; ii < array_length(arr); ii++) {
                        var c2 = arr[ii];
                        if (c2 != 0 && instance_exists(c2)) {
                            var zc = variable_instance_exists(c2, "zone") ? string_lower(c2.zone) : "";
                            if (zc == "field" || zc == "fieldselected") {
                                var ok2 = true;
                                if (excludeSelf && c2 == card) ok2 = false;
                                if (is_struct(crit)) {
                                    if (variable_struct_exists(crit, "type")) {
                                        var wt2 = string_lower(crit.type);
                                        var isMon2 = object_is_ancestor(c2.object_index, oCardMonster) || (variable_instance_exists(c2, "type") && string_lower(c2.type) == "monster");
                                        if (wt2 == "monster" && !isMon2) ok2 = false;
                                    }
                                    if (ok2 && variable_struct_exists(crit, "genre")) {
                                        var wg2 = string_lower(string(crit.genre));
                                        var tg2 = variable_instance_exists(c2, "genre") ? string_lower(string(c2.genre)) : "";
                                        if (wg2 != "" && tg2 != wg2) ok2 = false;
                                    }
                                    if (ok2 && variable_struct_exists(crit, "archetype")) {
                                        var wa2 = string_lower(string(crit.archetype));
                                        var ta2 = variable_instance_exists(c2, "archetype") ? string_lower(string(c2.archetype)) : "";
                                        if (wa2 != "" && ta2 != wa2) ok2 = false;
                                    }
                                }
                                if (ok2) { hasValidTarget = true; break; }
                            }
                        }
                    }
                }
            } else if (effectType == EFFECT_SACRIFICE_TARGET) {
                hasValidTarget = false;
                var critS = variable_struct_exists(effect, "criteria") ? effect.criteria : noone;
                var hasCritS = is_struct(critS) && script_exists(asset_get_index("_cardMatchesCriteria"));
                var ownS = string_lower(variable_struct_exists(effect, "owner") ? effect.owner : "ally");
                var wantHeroS = undefined;
                if (ownS == "ally" || ownS == "self" || ownS == "hero") wantHeroS = ownerIsHero_ctx;
                else if (ownS == "enemy") wantHeroS = !ownerIsHero_ctx;
                
                var _scanArrForSacrifice = function(arrScan) {
                    if (!is_array(arrScan)) return false;
                    for (var iiS = 0; iiS < array_length(arrScan); iiS++) {
                        var cS = arrScan[iiS];
                        if (cS == 0 || !instance_exists(cS)) continue;
                        var zS = variable_instance_exists(cS, "zone") ? string_lower(cS.zone) : "";
                        if (!(zS == "field" || zS == "fieldselected")) continue;
                        if (variable_instance_exists(cS, "isTerrain") && cS.isTerrain) continue;
                        if (hasCritS) { if (!_cardMatchesCriteria(cS, critS)) continue; }
                        return true;
                    }
                    return false;
                };
                
                if (is_bool(wantHeroS)) {
                    hasValidTarget = _scanArrForSacrifice(wantHeroS ? fieldMonsterHero.cards : fieldMonsterEnemy.cards);
                } else {
                    hasValidTarget = _scanArrForSacrifice(fieldMonsterHero.cards) || _scanArrForSacrifice(fieldMonsterEnemy.cards);
                }
            } else if (effectType == EFFECT_DESTROY_TARGET || effectType == EFFECT_BANISH_TARGET || effectType == EFFECT_RETURN_TO_HAND || effectType == EFFECT_DAMAGE_TARGET || effectType == EFFECT_PURGE || (effectType == EFFECT_SUMMON && string_lower(variable_struct_exists(effect, "summon_mode") ? effect.summon_mode : "") == "copy_target")) {
                hasValidTarget = false;
                // Utiliser la fonction centralisée qui a été corrigée pour gérer correctement "both" et copy_target
                if (script_exists(asset_get_index("hasValidTargetForEffect"))) {
                    hasValidTarget = hasValidTargetForEffect(card, effect, context);
                } else if (script_exists(getTargetsByFilter)) {
                    var arrT = getTargetsByFilter(effect);
                    hasValidTarget = (is_array(arrT) && array_length(arrT) > 0);
                }
                
                // Failsafe pour EFFECT_PURGE: si le filtre standard échoue mais qu'il y a des cibles potentielles, on force l'activation
                if (effectType == EFFECT_PURGE && !hasValidTarget) {
                    var ownerF = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "enemy";
                    
                    // 1. Vérifier les ennemis (si owner est enemy ou both)
                    if ((ownerF == "enemy" || ownerF == "both") && instance_exists(oFieldManagerEnemy)) {
                         var fM = oFieldManagerEnemy.getField("Monster");
                         if (fM != noone && variable_struct_exists(fM, "cards")) {
                             var cardsE = fM.cards;
                             for (var k = 0; k < array_length(cardsE); k++) {
                                 var cE = cardsE[k];
                                 if (cE != 0 && instance_exists(cE)) {
                                     // Ignorer camouflage si c'est un ennemi
                                     if (variable_instance_exists(cE, "isCamouflage") && cE.isCamouflage) continue;
                                     hasValidTarget = true;
                                     show_debug_message("### DEBUG PURGE: Forced hasValidTarget=true via failsafe (Enemy)");
                                     break;
                                 }
                             }
                         }
                    }
                    
                    // 2. Vérifier les alliés (si owner est ally ou both)
                    if (!hasValidTarget && (ownerF == "ally" || ownerF == "both") && instance_exists(oFieldManagerHero)) {
                         var fM_H = oFieldManagerHero.getField("Monster");
                         if (fM_H != noone && variable_struct_exists(fM_H, "cards")) {
                             var cardsH = fM_H.cards;
                             for (var k = 0; k < array_length(cardsH); k++) {
                                 var cH = cardsH[k];
                                 if (cH != 0 && instance_exists(cH)) {
                                     hasValidTarget = true;
                                     show_debug_message("### DEBUG PURGE: Forced hasValidTarget=true via failsafe (Ally)");
                                     break;
                                 }
                             }
                         }
                    }
                }
            } else if (effectType == EFFECT_ENTRAVE) {
                hasValidTarget = false;
                var ownSel = string_lower(variable_struct_exists(effect, "owner") ? effect.owner : "enemy");
                var arrSel = (ownSel == "ally") ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
                for (var kk = 0; kk < array_length(arrSel); kk++) {
                    var c3 = arrSel[kk];
                    if (c3 != 0 && instance_exists(c3)) {
                        var z3 = variable_instance_exists(c3, "zone") ? string_lower(c3.zone) : "";
                        if (z3 == "field" || z3 == "fieldselected") { hasValidTarget = true; break; }
                    }
                }
            }
            if (!hasValidTarget) { return false; }
            // Attacher la carte source à l'effet pour l'utiliser dans le callback
            effect.source_card = card;
            effect._pending_owner_is_hero = ownerIsHero_ctx;
            effect._pending_summon_mode = (variable_struct_exists(context, "summon_mode") ? context.summon_mode : "");
            
            // (Effet Floraison obsolète supprimé)
            
            // Définir le callback de sélection de cible (utilise self = struct de l'effet)
            effect.onTargetSelected = function(cardTarget) {
                var eff = (instance_exists(selectManager)) ? selectManager.targetingEffectId : noone;
                var src = (is_struct(eff) && variable_struct_exists(eff, "source_card")) ? eff.source_card : noone;
                var zTarget = (cardTarget != noone && instance_exists(cardTarget) && variable_instance_exists(cardTarget, "zone")) ? cardTarget.zone : "";
                if (cardTarget != noone && instance_exists(cardTarget) && (zTarget == "Field" || zTarget == "FieldSelected")) {
                    var okSel = true;
                    if (is_struct(eff)) {
                        if (variable_struct_exists(eff, "criteria")) {
                            var crit = eff.criteria;
                            if (script_exists(_cardMatchesCriteria)) { if (!_cardMatchesCriteria(cardTarget, crit)) okSel = false; }
                            if (okSel && is_struct(crit) && variable_struct_exists(crit, "exclude_self") && crit.exclude_self) {
                                if (src != noone && instance_exists(src) && cardTarget == src) okSel = false;
                            }
                        }
                        if (okSel && variable_struct_exists(eff, "owner") && src != noone && instance_exists(src) && variable_instance_exists(cardTarget, "isHeroOwner") && variable_instance_exists(src, "isHeroOwner")) {
                            var own = string_lower(eff.owner);
                            if (own == "ally" || own == "hero") { if (cardTarget.isHeroOwner != src.isHeroOwner) okSel = false; }
                            else if (own == "enemy") { if (cardTarget.isHeroOwner == src.isHeroOwner) okSel = false; }
                        }
                        if (okSel && src != noone && instance_exists(src) && variable_instance_exists(src, "isHeroOwner") && variable_instance_exists(cardTarget, "isHeroOwner") && variable_instance_exists(cardTarget, "isCamouflage") && cardTarget.isCamouflage) {
                            var isEnemyTarget = (cardTarget.isHeroOwner != src.isHeroOwner);
                            if (isEnemyTarget) okSel = false;
                        }
                    }
                    if (!okSel) { return false; }
                    
                    // Phase 1.5: Migration Command Pattern
                    // Au lieu d'exécuter directement, on demande une action au contrôleur
                    var effIdx = getEffectIndex(src, eff);
                    if (effIdx != -1 && variable_instance_exists(src, "instance_uid") && variable_instance_exists(cardTarget, "instance_uid")) {
                        var owner_ctx = (is_struct(eff) && variable_struct_exists(eff, "_pending_owner_is_hero")) ? eff._pending_owner_is_hero
                                        : ((src != noone && instance_exists(src) && variable_instance_exists(src, "isHeroOwner")) ? src.isHeroOwner : true);
                        var summon_mode_ctx = (is_struct(eff) && variable_struct_exists(eff, "_pending_summon_mode")) ? eff._pending_summon_mode : "";
                        RequestGameAction(ACTION_ACTIVATE_EFFECT, {
                            source_uid: src.instance_uid,
                            effect_index: effIdx,
                            target_uid: cardTarget.instance_uid,
                            owner_is_hero: owner_ctx,
                            summon_mode: summon_mode_ctx
                        });
                        
                        // Nettoyage UI local immédiat (anticipation)
                        clearTargetingMarkers();
                    } else {
                        // Fallback pour compatibilité si UIDs manquants (ne devrait pas arriver en Phase 1.5)
                        var resolved = executeEffect(src, eff, { target: cardTarget });
                        if (resolved) {
                            clearTargetingMarkers();
                            if (!is_undefined(markEffectAsUsed)) { markEffectAsUsed(src, eff); }
                            if (!is_undefined(consumeSpellIfNeeded)) { consumeSpellIfNeeded(src, eff); }
                        }
                    }
                } else {
                    var etype = (is_struct(eff) && variable_struct_exists(eff, "effect_type")) ? eff.effect_type : "unknown";
                    show_debug_message("### Cible invalide pour l'effet: " + string(etype));
                }
            };
            // Marquer l'équipement comme en cours de ciblage pour éviter destruction prématurée
            if (effectType == EFFECT_EQUIP_SELECT_TARGET && instance_exists(card)) {
                if (!variable_instance_exists(card, "equip_pending")) card.equip_pending = false;
                card.equip_pending = true;
            }
            // Activer le mode ciblage et afficher la flèche depuis la carte source
            selectManager.startTargeting(effect);
            if (instance_exists(card)) {
                // show_debug_message("### sEffects: Force creation of targeting arrow for " + string(card.id));
                selectManager.createTargetingArrow(card);
            }
            // Le processus est lancé; l'application se fera après la sélection
            // Important: ne pas signaler une réussite immédiate pour éviter la consommation prématurée des sorts Direct
            return false;
        }
    }
    
    switch(effectType) {
        // Effet de flux générique (pour les cartes comme Ferveur du marais)
        case EFFECT_GENERIC_FLOW:
        {
            var ownerIsHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                               : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            
            if (card != noone && instance_exists(card)) {
                var flowPending = variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending;
                if (flowPending) {
                    return true;
                }
            }
            
            if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                var L = array_length(effect.flow);
                var idx = 0;
                while (idx < L) {
                    var stepEff = effect.flow[idx];
                    if (is_struct(stepEff) && variable_struct_exists(stepEff, "effect_type")) {
                        if (stepEff.effect_type == EFFECT_TEMPO) {
                            var frames = 0;
                            if (variable_struct_exists(stepEff, "frames")) {
                                frames = max(0, stepEff.frames);
                            } else if (variable_struct_exists(stepEff, "ms")) {
                                frames = max(0, round((stepEff.ms / 1000.0) * game_get_speed(gamespeed_fps)));
                            }
                            if (frames > 0) {
                                var was_pending = (instance_exists(card) && variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending);
                                if (was_pending) { 
                                    break; 
                                }

                                var remaining_count = L - (idx + 1);
                                var remaining = array_create(remaining_count);
                                var r = 0;
                                for (var j = idx + 1; j < L; j++) { remaining[r++] = effect.flow[j]; }
                                var owner_flag = ownerIsHero;
                                
                                card._flow_remaining_steps = remaining;
                                card._flow_owner_is_hero = owner_flag;
                                card._flow_effect_id = (is_struct(effect) && variable_struct_exists(effect, "id")) ? effect.id : -1;
                                card._flow_tempo_pending = true;
                                
                                call_later(frames, time_source_units_frames, method(card, function() {
                                    if (!instance_exists(self)) {
                                        return;
                                    }
                                    if (!variable_instance_exists(self, "_flow_tempo_pending") || !self._flow_tempo_pending) {
                                        return;
                                    }
                                    self._flow_tempo_pending = false;
                                    
                                    var remaining_local = variable_instance_exists(self, "_flow_remaining_steps") ? self._flow_remaining_steps : undefined;
                                    var owner_flag_local = variable_instance_exists(self, "_flow_owner_is_hero") ? self._flow_owner_is_hero : undefined;
                                    
                                    if (is_array(remaining_local) && array_length(remaining_local) > 0) {
                                        // Ré-invoquer le flux générique pour gérer les étapes restantes (et les tempos futurs)
                                        var next_flow = {
                                            effect_type: EFFECT_GENERIC_FLOW,
                                            flow: remaining_local
                                        };
                                        executeEffect(self, next_flow, { owner_is_hero: owner_flag_local });
                                    }
                                    
                                    // Si un nouveau tempo a été programmé (pending=true), on NE nettoie PAS les variables de flux
                                    // car elles contiennent les étapes pour le prochain callback.
                                    var new_pending = (variable_instance_exists(self, "_flow_tempo_pending") && self._flow_tempo_pending);
                                    
                                    if (!new_pending) {
                                        if (variable_instance_exists(self, "_flow_remaining_steps")) self._flow_remaining_steps = undefined;
                                        if (variable_instance_exists(self, "_flow_owner_is_hero")) self._flow_owner_is_hero = undefined;
                                        if (variable_instance_exists(self, "_flow_effect_id")) self._flow_effect_id = undefined;
                                    }
                                    
                                    if (variable_instance_exists(self, "_consume_after_flow") && self._consume_after_flow) {
                                        self._consume_after_flow = false;
                                        if (!is_undefined(consumeSpellIfNeeded)) { consumeSpellIfNeeded(self, undefined); }
                                    }
                                }));
                                break;
                            }
                        } else {
                            executeEffect(card, stepEff, { owner_is_hero: ownerIsHero });
                        }
                    }
                    idx++;
                }
            }
            return true;
        }

        // Effets de base
        case EFFECT_DRAW_CARDS:
        {
            var ownerIsHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                               : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            var ok = drawCardsFor(ownerIsHero, value);
            // Chaînage générique: exécuter les étapes du flow après la pioche
            // Support de la tempo: si une étape EFFECT_TEMPO est rencontrée,
            // les étapes restantes sont différées via call_later.
            if (ok && variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                var L = array_length(effect.flow);
                var idx = 0;
                while (idx < L) {
                    var stepEff = effect.flow[idx];
                    if (is_struct(stepEff) && variable_struct_exists(stepEff, "effect_type")) {
                        if (stepEff.effect_type == EFFECT_TEMPO) {
                            var frames = 0;
                            if (variable_struct_exists(stepEff, "frames")) {
                                frames = max(0, stepEff.frames);
                            } else if (variable_struct_exists(stepEff, "ms")) {
                                frames = max(0, round((stepEff.ms / 1000.0) * game_get_speed(gamespeed_fps)));
                            }
                            if (frames > 0) {
                                // Garde: éviter de replanifier si une tempo est déjà en attente (par carte)
                                var was_pending = (instance_exists(card) && variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending);
                                var cname_dbg = (card != noone && instance_exists(card) && variable_instance_exists(card, "name")) ? card.name : "unknown";
                                var effId_dbg = (is_struct(effect) && variable_struct_exists(effect, "id")) ? effect.id : -1;
                                show_debug_message("### EFFECT_TEMPO: tentative de planif pour " + cname_dbg + " effect_id=" + string(effId_dbg) + " pending=" + string(was_pending));
                                if (was_pending) {
                                    show_debug_message("### EFFECT_TEMPO: garde -> planif ignorée (déjà en attente)");
                                    break;
                                }

                                // Capturer le reste des étapes après la tempo
                                var remaining_count = L - (idx + 1);
                                var remaining = array_create(remaining_count);
                                var r = 0;
                                for (var j = idx + 1; j < L; j++) { remaining[r++] = effect.flow[j]; }
                                var owner_flag = ownerIsHero;
                                // Stocker l'état du flow sur l'instance carte
                                card._flow_remaining_steps = remaining;
                                card._flow_owner_is_hero = owner_flag;
                                card._flow_effect_id = effId_dbg;
                                card._flow_tempo_pending = true;
                                show_debug_message("### EFFECT_TEMPO: planifié pour " + string(frames) + " frames; étapes restantes=" + string(array_length(remaining)));
                                // Reprendre en re-liant le contexte à l'instance carte
                                call_later(frames, time_source_units_frames, method(card, function() {
                                    if (!instance_exists(self)) {
                                        show_debug_message("### EFFECT_TEMPO: instance carte détruite avant reprise du flow, abandon.");
                                        return;
                                    }
                                    if (!variable_instance_exists(self, "_flow_tempo_pending") || !self._flow_tempo_pending) {
                                        show_debug_message("### EFFECT_TEMPO: callback ignoré (déjà traité)");
                                        return;
                                    }
                                    self._flow_tempo_pending = false;
                                    var remaining_local = variable_instance_exists(self, "_flow_remaining_steps") ? self._flow_remaining_steps : undefined;
                                    var owner_flag_local = variable_instance_exists(self, "_flow_owner_is_hero") ? self._flow_owner_is_hero : undefined;
                                    var effId_local = variable_instance_exists(self, "_flow_effect_id") ? self._flow_effect_id : -1;
                                    var cname_local = (variable_instance_exists(self, "name")) ? self.name : "unknown";
                                    show_debug_message("### EFFECT_TEMPO: reprise du flow pour " + cname_local + " effect_id=" + string(effId_local) + ", étapes=" + string(is_array(remaining_local) ? array_length(remaining_local) : -1));
                                    if (is_array(remaining_local)) {
                                        for (var r2 = 0; r2 < array_length(remaining_local); r2++) {
                                            var step2 = remaining_local[r2];
                                            if (is_struct(step2) && variable_struct_exists(step2, "effect_type")) {
                                                show_debug_message("### EFFECT_TEMPO: exécution étape " + string(r2) + " type=" + string(step2.effect_type));
                                                executeEffect(self, step2, { owner_is_hero: owner_flag_local });
                                            }
                                        }
                                    } else {
                                        show_debug_message("### EFFECT_TEMPO: aucune étape restante trouvée.");
                                    }
                                    // Nettoyage
                                    if (variable_instance_exists(self, "_flow_remaining_steps")) self._flow_remaining_steps = undefined;
                                    if (variable_instance_exists(self, "_flow_owner_is_hero")) self._flow_owner_is_hero = undefined;
                                    if (variable_instance_exists(self, "_flow_effect_id")) self._flow_effect_id = undefined;
                                    // Destruction différée: si demandé, détruire l'instance maintenant
                                    if (variable_instance_exists(self, "_wait_destroy_on_tempo") && self._wait_destroy_on_tempo) {
                                        self._wait_destroy_on_tempo = false;
                                        if (instance_exists(self)) { instance_destroy(self); }
                                    }
                                    if (variable_instance_exists(self, "_consume_after_flow") && self._consume_after_flow) {
                                        self._consume_after_flow = false;
                                        if (!is_undefined(consumeSpellIfNeeded)) { consumeSpellIfNeeded(self, undefined); }
                                    }
                                }));
                                break; // Stopper le traitement immédiat au niveau de la tempo
                            } else {
                                // Tempo nulle: ignorer et continuer
                            }
                        } else {
                            // Étape immédiate
                            var subCtx = { owner_is_hero: ownerIsHero };
                            if (variable_struct_exists(context, "target")) subCtx.target = context.target;
                            if (variable_struct_exists(context, "summoned")) subCtx.summoned = context.summoned;
                            if (variable_struct_exists(context, "source")) subCtx.source = context.source;
                            executeEffect(card, stepEff, subCtx);
                        }
                    }
                    idx++;
                }
            }
            return ok;
        }
        
        
        
        
            

            
        
            
        // Effets de combat
        
        case EFFECT_POISON:
            if (card != noone && instance_exists(card)) {
                card.isPoisoner = true;
                return true;
            }
            return false;

        case EFFECT_STEALTH:
            if (card != noone && instance_exists(card)) {
                card.is_stealth = true;
                return true;
            }
            return false;

        case EFFECT_PONCTION:
            if (card != noone && instance_exists(card)) {
                card.hasPonction = true;
                return true;
            }
            return false;

        case EFFECT_EGIDE:
        {
            if (card == noone || !instance_exists(card)) return false;
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
            var crit = variable_struct_exists(effect, "criteria") ? effect.criteria : noone;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            if (scope == "all") {
                var arr = (ownerSide == "enemy") ? (srcHero ? fieldMonsterEnemy.cards : fieldMonsterHero.cards)
                                                 : (srcHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards);
                var applied = false;
                for (var i = 0; i < array_length(arr); i++) {
                    var c0 = arr[i];
                    if (c0 == 0 || !instance_exists(c0)) continue;
                    var z0 = variable_instance_exists(c0, "zone") ? string_lower(c0.zone) : "";
                    if (!(z0 == "field" || z0 == "fieldselected")) continue;
                    if (is_struct(crit) && script_exists(asset_get_index("_cardMatchesCriteria"))) {
                        if (!_cardMatchesCriteria(c0, crit)) continue;
                    }
                    c0.hasEgide = true;
                    applied = true;
                }
                return applied;
            }
            
            var tgt = (variable_struct_exists(context, "target") && instance_exists(context.target)) ? context.target : card;
            if (is_struct(crit) && script_exists(asset_get_index("_cardMatchesCriteria"))) {
                if (!_cardMatchesCriteria(tgt, crit)) return false;
            }
            tgt.hasEgide = true;
            return true;
        }
            
        case EFFECT_PERCEE:
            if (card != noone && instance_exists(card)) {
                card.isPercee = true;
                return true;
            }
            return false;
            
        case EFFECT_REPOUSSEMENT:
        {
            if (card == noone || !instance_exists(card)) return false;
            var defender = variable_struct_exists(context, "defender") ? context.defender : noone;
            if (defender != noone && instance_exists(defender) && !is_undefined(tryRepoussement)) {
                return tryRepoussement(card, defender);
            }
            card.hasRepoussement = true;
            return true;
        }

        case EFFECT_CLEAVE_ADJACENT:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (is_undefined(damageCard)) return false;
            if (variable_struct_exists(context, "direct_attack") && context.direct_attack) return false;
            
            var dmg = variable_struct_exists(effect, "value") ? effect.value
                      : (variable_struct_exists(effect, "damage") ? effect.damage : 1);
            dmg = max(0, dmg);
            if (dmg <= 0) return true;
            
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "enemy";
            var targetHero = srcHero;
            if (ownerSide == "ally") targetHero = srcHero;
            else if (ownerSide == "enemy") targetHero = !srcHero;
            
            var arr = targetHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
            var pos = -1;
            if (variable_struct_exists(context, "defender_field_position")) {
                pos = context.defender_field_position;
            } else if (variable_struct_exists(context, "defender")) {
                var def = context.defender;
                if (def != noone && instance_exists(def) && variable_instance_exists(def, "fieldPosition")) {
                    pos = def.fieldPosition;
                }
            }
            if (pos < 0) return false;
            var row = floor(pos / 4);
            var col = pos mod 4;
            if (col < 0) col = 0;
            
            var any = false;
            if (col > 0) {
                var pL = row * 4 + (col - 1);
                if (pL >= 0 && pL < array_length(arr)) {
                    var tL = arr[pL];
                    if (tL != 0 && instance_exists(tL)) { damageCard(tL, dmg, card); any = true; }
                }
            }
            if (col < 3) {
                var pR = row * 4 + (col + 1);
                if (pR >= 0 && pR < array_length(arr)) {
                    var tR = arr[pR];
                    if (tR != 0 && instance_exists(tR)) { damageCard(tR, dmg, card); any = true; }
                }
            }
            return any;
        }

        case EFFECT_SET_SELF_ATTACK_PER_GRAVEYARD_COUNT:
        {
            if (card == noone || !instance_exists(card)) return false;
            
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var countCrit = variable_struct_exists(effect, "count_criteria") ? effect.count_criteria : noone;
            if (!is_struct(countCrit)) return false;
            
            var graveyard = srcHero ? graveyardHero : graveyardEnemy;
            var garr = (instance_exists(graveyard) && variable_instance_exists(graveyard, "cards")) ? graveyard.cards : [];
            var countObjNames = variable_struct_exists(effect, "count_object_names") ? effect.count_object_names : [];
            var count = _countGraveyardByCriteria(garr, countCrit, countObjNames);
            
            var per = variable_struct_exists(effect, "per") ? effect.per : (variable_struct_exists(effect, "value") ? effect.value : 1);
            var base = variable_struct_exists(effect, "base_attack") ? effect.base_attack : (variable_struct_exists(effect, "base") ? effect.base : (variable_struct_exists(card, "original_attack") ? card.original_attack : card.attack));
            per = max(0, per);
            base = max(0, base);
            
            var newAtk = base + (per * count);
            card.attack = newAtk;
            if (!is_undefined(buffRecompute)) buffRecompute(card);
            return true;
        }
        
        case EFFECT_COUNT_APPLY:
        {
            if (card == noone || !instance_exists(card)) return false;
            
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var countSource = variable_struct_exists(effect, "count_source") ? string_lower(string(effect.count_source)) : "field";
            var countOwner = variable_struct_exists(effect, "count_owner") ? string_lower(string(effect.count_owner)) : "ally";
            var countHero = srcHero;
            if (countOwner == "ally") countHero = srcHero;
            else if (countOwner == "enemy") countHero = !srcHero;
            
            var countCrit = variable_struct_exists(effect, "count_criteria") ? effect.count_criteria : noone;
            var countObjNames = variable_struct_exists(effect, "count_object_names") ? effect.count_object_names : [];
            var includeFD = variable_struct_exists(effect, "include_face_down_in_count") ? effect.include_face_down_in_count : false;
            
            var count = 0;
            if (countSource == "graveyard") {
                var graveyard = countHero ? graveyardHero : graveyardEnemy;
                var garr = (instance_exists(graveyard) && variable_instance_exists(graveyard, "cards")) ? graveyard.cards : [];
                count = _countGraveyardByCriteria(garr, countCrit, countObjNames);
            } else {
                var arr = countHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
                count = _countFieldByCriteria(arr, includeFD, countCrit, countObjNames);
            }
            
            var per = variable_struct_exists(effect, "per") ? effect.per : (variable_struct_exists(effect, "value") ? effect.value : 1);
            var base = variable_struct_exists(effect, "base") ? effect.base
                       : (variable_struct_exists(effect, "base_value") ? effect.base_value
                       : (variable_struct_exists(effect, "base_attack") ? effect.base_attack : 0));
            per = max(0, per);
            base = max(0, base);
            var total = base + (per * count);
            
            var applyMode = variable_struct_exists(effect, "apply_mode") ? string_lower(string(effect.apply_mode)) : "damage_all";
            if (applyMode == "set_self_attack") {
                card.attack = total;
                if (!is_undefined(buffRecompute)) buffRecompute(card);
                return true;
            }
            
            if (applyMode == "damage_all") {
                if (total <= 0) return true;
                if (is_undefined(damageAllMonsters)) return false;
                var dmgSpec = {
                    owner: (variable_struct_exists(effect, "owner") ? effect.owner : "enemy"),
                    target_zone: (variable_struct_exists(effect, "target_zone") ? effect.target_zone : "field"),
                    monster_type: (variable_struct_exists(effect, "monster_type") ? effect.monster_type : "Monster"),
                    criteria: (variable_struct_exists(effect, "criteria") ? effect.criteria : noone),
                    source_card: card
                };
                if (variable_struct_exists(effect, "visual_fx")) dmgSpec.visual_fx = effect.visual_fx;
                if (variable_struct_exists(effect, "element")) dmgSpec.element = effect.element;
                return damageAllMonsters(total, dmgSpec);
            }
            
            return false;
        }
        
        case EFFECT_TARGET_FACING:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (!variable_instance_exists(card, "fieldPosition")) return false;
            var pos = card.fieldPosition;
            if (pos < 0) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            var fmOpp = srcHero ? instance_find(oFieldManagerEnemy, 0) : instance_find(oFieldManagerHero, 0);
            if (fmOpp == noone || !instance_exists(fmOpp) || !variable_instance_exists(fmOpp, "getField")) return false;
            var fieldOpp = fmOpp.getField("Monster");
            if (fieldOpp == noone || !instance_exists(fieldOpp) || !variable_struct_exists(fieldOpp, "cards")) return false;
            var col = pos mod 4;
            if (col < 0) col = 0;
            var idxFront = col;
            var idxBack = col + 4;
            if (idxFront >= array_length(fieldOpp.cards)) return false;
            var tgt = fieldOpp.cards[idxFront];
            if ((tgt == 0 || !instance_exists(tgt)) && idxBack < array_length(fieldOpp.cards)) {
                tgt = fieldOpp.cards[idxBack];
            }
            
            if (tgt == 0 || !instance_exists(tgt)) {
                if (variable_struct_exists(effect, "fallback_flow")) {
                    var ctxF = { owner_is_hero: (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : srcHero), attacker: card, defender: noone, target: noone };
                    var flowF = effect.fallback_flow;
                    if (is_array(flowF)) {
                        for (var fi = 0; fi < array_length(flowF); fi++) {
                            var stf = flowF[fi];
                            if (is_struct(stf) && variable_struct_exists(stf, "effect_type")) executeEffect(card, stf, ctxF);
                        }
                    } else if (is_struct(flowF) && variable_struct_exists(flowF, "effect_type")) {
                        executeEffect(card, flowF, ctxF);
                    }
                    return true;
                }
                return false;
            }
            
            var ctx2 = { owner_is_hero: (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : srcHero), target: tgt, defender: tgt, attacker: card };
            var flow = variable_struct_exists(effect, "flow") ? effect.flow : noone;
            if (is_array(flow)) {
                for (var i = 0; i < array_length(flow); i++) {
                    var st = flow[i];
                    if (is_struct(st) && variable_struct_exists(st, "effect_type")) executeEffect(card, st, ctx2);
                }
            } else if (is_struct(flow) && variable_struct_exists(flow, "effect_type")) {
                executeEffect(card, flow, ctx2);
            }
            return true;
        }
        
        case EFFECT_APPLY_DOT:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (!variable_struct_exists(context, "target") || context.target == noone || !instance_exists(context.target)) return false;
            var tgt = context.target;
            if (!variable_instance_exists(tgt, "effects") || !is_array(tgt.effects)) tgt.effects = [];
            
            var dmg = 1;
            if (variable_struct_exists(effect, "value")) dmg = effect.value;
            else if (variable_struct_exists(effect, "damage")) dmg = effect.damage;
            else if (variable_struct_exists(effect, "amount")) dmg = effect.amount;
            dmg = max(0, dmg);
            
            var turns = 1;
            if (variable_struct_exists(effect, "turns")) turns = effect.turns;
            else if (variable_struct_exists(effect, "duration")) turns = effect.duration;
            else if (variable_struct_exists(effect, "count")) turns = effect.count;
            turns = max(0, turns);
            
            if (!variable_global_exists("dot_effect_next_id")) global.dot_effect_next_id = 1000;
            var dotKey = string(card.id) + ":" + string(global.dot_effect_next_id);
            global.dot_effect_next_id += 1;
            
            if (!is_undefined(dotAdd)) dotAdd(tgt, dotKey, dmg, turns, card);
            
            array_push(tgt.effects, { id: global.dot_effect_next_id + 1, trigger: TRIGGER_END_TURN, effect_type: EFFECT_DOT_TICK, dot_key: dotKey, conditions: { owner_turn: true } });
            global.dot_effect_next_id += 1;
            return true;
        }
        
        case EFFECT_DOT_TICK:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (!variable_struct_exists(effect, "dot_key")) { effect.negated = true; return false; }
            if (is_undefined(dotTick)) { effect.negated = true; return false; }
            var rem = dotTick(card, effect.dot_key);
            if (rem <= 0) { effect.negated = true; }
            return (rem >= 0);
        }
        
        case EFFECT_TRACK_GRAVEYARD_PRESENCE:
        {
            if (card == noone || !instance_exists(card)) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            if (is_undefined(_findInGraveyard)) return false;
            
            var trackerKey = variable_struct_exists(effect, "tracker_key") ? string(effect.tracker_key) : "tracker";
            var checks = variable_struct_exists(effect, "checks") ? effect.checks : [];
            if (!is_array(checks) || array_length(checks) <= 0) return false;
            
            if (!variable_instance_exists(card, "tracker_flags") || !is_struct(card.tracker_flags)) card.tracker_flags = {};
            var flags = {};
            for (var i = 0; i < array_length(checks); i++) {
                var chk = checks[i];
                if (!is_struct(chk)) continue;
                var key = variable_struct_exists(chk, "key") ? string(chk.key) : "";
                var obj = variable_struct_exists(chk, "object_name") ? string(chk.object_name) : "";
                if (key == "" || obj == "") continue;
                flags[$ key] = (_findInGraveyard(srcHero, { object_name: obj }) != noone);
            }
            card.tracker_flags[$ trackerKey] = flags;
            
            var ids = variable_struct_exists(effect, "activate_effect_ids") ? effect.activate_effect_ids : [];
            if (is_array(ids) && variable_instance_exists(card, "effects") && is_array(card.effects)) {
                for (var j = 0; j < array_length(ids); j++) {
                    var wantId = ids[j];
                    var effFound = noone;
                    for (var k = 0; k < array_length(card.effects); k++) {
                        var e0 = card.effects[k];
                        if (is_struct(e0) && variable_struct_exists(e0, "id") && e0.id == wantId) { effFound = e0; break; }
                    }
                    if (!is_struct(effFound)) continue;
                    var active = true;
                    if (variable_struct_exists(effFound, "presence_key")) {
                        var pkey = string(effFound.presence_key);
                        active = (variable_struct_exists(flags, pkey) && flags[$ pkey]);
                    } else if (variable_struct_exists(effFound, "presence_all_keys")) {
                        var allK = effFound.presence_all_keys;
                        if (is_array(allK)) {
                            for (var a = 0; a < array_length(allK); a++) {
                                var ak = string(allK[a]);
                                if (!(variable_struct_exists(flags, ak) && flags[$ ak])) { active = false; break; }
                            }
                        }
                    } else if (variable_struct_exists(effFound, "presence_any_keys")) {
                        var anyK = effFound.presence_any_keys;
                        active = false;
                        if (is_array(anyK)) {
                            for (var b = 0; b < array_length(anyK); b++) {
                                var bk = string(anyK[b]);
                                if (variable_struct_exists(flags, bk) && flags[$ bk]) { active = true; break; }
                            }
                        }
                    }
                    executeEffect(card, effFound, { owner_is_hero: srcHero, active: active, tracker_key: trackerKey, tracker_flags: flags });
                }
            }
            return true;
        }

        case EFFECT_TRACK_FIELD_PRESENCE:
        {
            if (card == noone || !instance_exists(card)) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var trackerKey = variable_struct_exists(effect, "tracker_key") ? string(effect.tracker_key) : "tracker";
            var checks = variable_struct_exists(effect, "checks") ? effect.checks : [];
            if (!is_array(checks) || array_length(checks) <= 0) return false;
            
            if (!variable_instance_exists(card, "tracker_flags") || !is_struct(card.tracker_flags)) card.tracker_flags = {};
            var flags = {};
            
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "ally";
            var checkHero = (ownerSide == "enemy") ? !srcHero : srcHero;
            var arr = checkHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
            
            for (var i = 0; i < array_length(checks); i++) {
                var chk = checks[i];
                if (!is_struct(chk)) continue;
                var key = variable_struct_exists(chk, "key") ? string(chk.key) : "";
                var obj = variable_struct_exists(chk, "object_name") ? string(chk.object_name) : "";
                if (key == "" || obj == "") continue;
                
                var found = false;
                for (var j = 0; j < array_length(arr); j++) {
                    var c0 = arr[j];
                    if (c0 == 0 || !instance_exists(c0)) continue;
                    var z0 = variable_instance_exists(c0, "zone") ? string_lower(c0.zone) : "";
                    if (!(z0 == "field" || z0 == "fieldselected")) continue;
                    if (object_get_name(c0.object_index) == obj) { found = true; break; }
                }
                flags[$ key] = found;
            }
            
            card.tracker_flags[$ trackerKey] = flags;
            
            var ids = variable_struct_exists(effect, "activate_effect_ids") ? effect.activate_effect_ids : [];
            if (is_array(ids) && variable_instance_exists(card, "effects") && is_array(card.effects)) {
                for (var jj = 0; jj < array_length(ids); jj++) {
                    var wantId = ids[jj];
                    var effFound = noone;
                    for (var k = 0; k < array_length(card.effects); k++) {
                        var e0 = card.effects[k];
                        if (is_struct(e0) && variable_struct_exists(e0, "id") && e0.id == wantId) { effFound = e0; break; }
                    }
                    if (!is_struct(effFound)) continue;
                    var active = true;
                    if (variable_struct_exists(effFound, "presence_key")) {
                        var pkey = string(effFound.presence_key);
                        active = (variable_struct_exists(flags, pkey) && flags[$ pkey]);
                    } else if (variable_struct_exists(effFound, "presence_all_keys")) {
                        var allK = effFound.presence_all_keys;
                        if (is_array(allK)) {
                            for (var a = 0; a < array_length(allK); a++) {
                                var ak = string(allK[a]);
                                if (!(variable_struct_exists(flags, ak) && flags[$ ak])) { active = false; break; }
                            }
                        }
                    } else if (variable_struct_exists(effFound, "presence_any_keys")) {
                        var anyK = effFound.presence_any_keys;
                        active = false;
                        if (is_array(anyK)) {
                            for (var b = 0; b < array_length(anyK); b++) {
                                var bk = string(anyK[b]);
                                if (variable_struct_exists(flags, bk) && flags[$ bk]) { active = true; break; }
                            }
                        }
                    }
                    executeEffect(card, effFound, { owner_is_hero: srcHero, active: active, tracker_key: trackerKey, tracker_flags: flags });
                }
            }
            
            return true;
        }

        case EFFECT_TRACK_SELF_PROPERTY_BOOL:
        {
            if (card == noone || !instance_exists(card)) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var trackerKey = variable_struct_exists(effect, "tracker_key") ? string(effect.tracker_key) : "tracker";
            var prop = variable_struct_exists(effect, "property") ? string(effect.property) : "";
            if (prop == "") return false;
            var flagKey = variable_struct_exists(effect, "key") ? string(effect.key) : prop;
            
            var val = false;
            if (variable_instance_exists(card, prop)) {
                val = variable_instance_get(card, prop);
            }
            val = (val == true);
            
            if (!variable_instance_exists(card, "tracker_flags") || !is_struct(card.tracker_flags)) card.tracker_flags = {};
            var flags = {};
            flags[$ flagKey] = val;
            card.tracker_flags[$ trackerKey] = flags;
            
            var ids = variable_struct_exists(effect, "activate_effect_ids") ? effect.activate_effect_ids : [];
            if (is_array(ids) && variable_instance_exists(card, "effects") && is_array(card.effects)) {
                for (var jj = 0; jj < array_length(ids); jj++) {
                    var wantId = ids[jj];
                    var effFound = noone;
                    for (var k = 0; k < array_length(card.effects); k++) {
                        var e0 = card.effects[k];
                        if (is_struct(e0) && variable_struct_exists(e0, "id") && e0.id == wantId) { effFound = e0; break; }
                    }
                    if (!is_struct(effFound)) continue;
                    var active = val;
                    if (variable_struct_exists(effFound, "presence_key")) {
                        var pkey = string(effFound.presence_key);
                        active = (variable_struct_exists(flags, pkey) && flags[$ pkey]);
                    }
                    executeEffect(card, effFound, { owner_is_hero: srcHero, active: active, tracker_key: trackerKey, tracker_flags: flags });
                }
            }
            
            return true;
        }
        
        case EFFECT_SET_SELF_BUFF_CONTRIB:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (is_undefined(buffSetContribution) || is_undefined(buffRemoveContribution) || is_undefined(buffRecompute)) return false;
            var active = variable_struct_exists(context, "active") ? context.active : true;
            if (!variable_struct_exists(context, "active") && variable_struct_exists(effect, "active_if_self_property")) {
                var prop = string(effect.active_if_self_property);
                if (prop != "" && variable_instance_exists(card, prop)) {
                    active = variable_instance_get(card, prop);
                } else {
                    active = false;
                }
            }
            var baseKey = variable_struct_exists(effect, "contrib_key") ? string(effect.contrib_key) : "contrib";
            var atk = variable_struct_exists(effect, "atk") ? effect.atk : (variable_struct_exists(effect, "value") ? effect.value : 0);
            var pv = variable_struct_exists(effect, "PV") ? effect.PV : (variable_struct_exists(effect, "def") ? effect.def : 0);
            var key = baseKey + ":" + string(card.id);
            if (active) buffSetContribution(card, key, atk, pv); else buffRemoveContribution(card, key);
            buffRecompute(card);
            return true;
        }

        case EFFECT_CONDITIONAL_FLOW:
        {
            if (card == noone || !instance_exists(card)) return false;
            var cond = variable_struct_exists(effect, "cond") ? effect.cond : noone;
            var ok = true;
            if (is_struct(cond) && variable_struct_exists(cond, "type")) {
                var t = string_lower(string(cond.type));
                if (t == "context_active") {
                    ok = variable_struct_exists(context, "active") && context.active;
                }
                if (t == "target_alive") {
                    if (!variable_struct_exists(context, "target") || context.target == noone || !instance_exists(context.target)) {
                        ok = false;
                    } else {
                        var t0 = context.target;
                        if (variable_instance_exists(t0, "current_hp")) ok = (t0.current_hp > 0);
                        else if (variable_instance_exists(t0, "nbLP")) ok = (t0.nbLP > 0);
                        else ok = true;
                    }
                }
                if (t == "target_genre") {
                    if (!variable_struct_exists(context, "target") || context.target == noone || !instance_exists(context.target)) {
                        ok = false;
                    } else {
                        var tg = variable_instance_exists(context.target, "genre") ? string(context.target.genre) : "";
                        var wantg = variable_struct_exists(cond, "genre") ? string(cond.genre) : "";
                        ok = (string_lower(tg) == string_lower(wantg));
                    }
                }
                if (t == "tracker_flags") {
                    if (!variable_instance_exists(card, "tracker_flags") || !is_struct(card.tracker_flags)) ok = false;
                    var tk = variable_struct_exists(cond, "tracker_key") ? string(cond.tracker_key) : "";
                    if (ok && (tk == "" || !variable_struct_exists(card.tracker_flags, tk))) ok = false;
                    var flags = ok ? card.tracker_flags[$ tk] : {};
                    if (ok && variable_struct_exists(cond, "all")) {
                        var allArr = cond.all;
                        if (is_array(allArr)) {
                            for (var i = 0; i < array_length(allArr); i++) {
                                var k = string(allArr[i]);
                                if (!(variable_struct_exists(flags, k) && flags[$ k])) { ok = false; break; }
                            }
                        }
                    }
                    if (ok && variable_struct_exists(cond, "any")) {
                        var anyArr = cond.any;
                        ok = false;
                        if (is_array(anyArr)) {
                            for (var j = 0; j < array_length(anyArr); j++) {
                                var k2 = string(anyArr[j]);
                                if (variable_struct_exists(flags, k2) && flags[$ k2]) { ok = true; break; }
                            }
                        }
                    }
                }
            }
            var flow = noone;
            if (ok) {
                flow = variable_struct_exists(effect, "flow") ? effect.flow : noone;
            } else {
                flow = variable_struct_exists(effect, "else_flow") ? effect.else_flow : noone;
                if (flow == noone) return false;
            }
            var ctx2 = context;
            if (is_array(flow)) {
                for (var f = 0; f < array_length(flow); f++) {
                    var st = flow[f];
                    if (is_struct(st) && variable_struct_exists(st, "effect_type")) executeEffect(card, st, ctx2);
                }
            } else if (is_struct(flow) && variable_struct_exists(flow, "effect_type")) {
                executeEffect(card, flow, ctx2);
            }
            return true;
        }
        
        case EFFECT_REMOVE_SELF_BUFF_CONTRIBS:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (is_undefined(buffRemoveContribution) || is_undefined(buffRecompute)) return false;
            var keys = variable_struct_exists(effect, "contrib_keys") ? effect.contrib_keys : [];
            if (is_array(keys)) {
                for (var i = 0; i < array_length(keys); i++) {
                    buffRemoveContribution(card, string(keys[i]) + ":" + string(card.id));
                }
            }
            buffRecompute(card);
            return true;
        }
        
        case EFFECT_MARK_ATTACK_DAMAGE:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (!variable_struct_exists(context, "target") || context.target == noone || !instance_exists(context.target)) return false;
            if (!instance_exists(game)) return false;
            var tgt = context.target;
            
            var amount = variable_struct_exists(effect, "value") ? effect.value
                        : (variable_struct_exists(effect, "amount") ? effect.amount : 1);
            amount = max(0, amount);
            if (amount == 0) return true;
            
            var srcHero = (variable_struct_exists(context, "owner_is_hero"))
                          ? context.owner_is_hero
                          : ((variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner) ? true : false);
            var localIndex = variable_instance_exists(game, "local_player_index") ? game.local_player_index : 0;
            var srcOwnerIndex = srcHero ? localIndex : (1 - localIndex);
            
            var expireDelta = -1;
            if (variable_struct_exists(effect, "expire_turn_delta")) {
                expireDelta = max(0, effect.expire_turn_delta);
            } else if (variable_struct_exists(effect, "duration_mode")) {
                var mode = string_lower(string(effect.duration_mode));
                if (mode == "until_next_owner_turn") {
                    expireDelta = (game.player_current == srcOwnerIndex) ? 2 : 1;
                } else if (mode == "until_end_of_next_owner_turn") {
                    expireDelta = (game.player_current == srcOwnerIndex) ? 3 : 2;
                } else if (mode == "until_end_of_turn" || mode == "until_end_of_current_turn") {
                    expireDelta = 1;
                }
            }
            if (expireDelta < 0) {
                expireDelta = (game.player_current == srcOwnerIndex) ? 2 : 1;
            }
            var expireTurn = game.nbTurn + expireDelta;
            
            if (!variable_instance_exists(tgt, "attack_damage_bonus_sources") || !is_array(tgt.attack_damage_bonus_sources)) tgt.attack_damage_bonus_sources = [];
            var key = "mark_attack:" + string(card.id) + ":" + string(variable_struct_exists(effect, "id") ? effect.id : 0);
            var found = false;
            for (var i = 0; i < array_length(tgt.attack_damage_bonus_sources); i++) {
                var s = tgt.attack_damage_bonus_sources[i];
                if (is_struct(s) && variable_struct_exists(s, "key") && string(s.key) == key) {
                    s.amount = max(s.amount, amount);
                    s.expire_turn = max(s.expire_turn, expireTurn);
                    tgt.attack_damage_bonus_sources[i] = s;
                    found = true;
                    break;
                }
            }
            if (!found) array_push(tgt.attack_damage_bonus_sources, { key: key, amount: amount, expire_turn: expireTurn });
            return true;
        }

        case EFFECT_MARK_DRAW_ON_DEATH_THIS_TURN:
        {
            if (!instance_exists(game)) return false;
            var tgt = noone;
            if (variable_struct_exists(context, "target") && context.target != noone && instance_exists(context.target)) {
                tgt = context.target;
            }
            if (tgt == noone || !instance_exists(tgt)) return false;

            var ownerIsHeroMark = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                                : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);

            tgt.mark_draw_on_death_turn = game.nbTurn;
            tgt.mark_draw_on_death_owner_is_hero = ownerIsHeroMark;
            return true;
        }

        case EFFECT_MARK_DRAW_ON_KILL_THIS_TURN:
        {
            if (!instance_exists(game)) return false;
            var tgtKill = noone;
            if (variable_struct_exists(context, "target") && context.target != noone && instance_exists(context.target)) {
                tgtKill = context.target;
            }
            if (tgtKill == noone || !instance_exists(tgtKill)) return false;

            var ownerIsHeroKill = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                                  : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);

            tgtKill.mark_draw_on_kill_turn = game.nbTurn;
            tgtKill.mark_draw_on_kill_owner_is_hero = ownerIsHeroKill;
            return true;
        }

        case EFFECT_MARK_DRAW_ON_DAMAGE:
        {
            var tgtDmg = noone;
            if (variable_struct_exists(context, "target") && context.target != noone && instance_exists(context.target)) {
                tgtDmg = context.target;
            }
            if (tgtDmg == noone || !instance_exists(tgtDmg)) return false;

            var ownerIsHeroDmg = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                                 : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            tgtDmg.mark_draw_on_damage_owner_is_hero = ownerIsHeroDmg;
            return true;
        }
        
        case EFFECT_ADD_RANDOM_TO_HAND:
        {
            var ownerIsHero_h = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                                 : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            var handInst_h = ownerIsHero_h ? handHero : handEnemy;
            if (!instance_exists(handInst_h)) return false;
            
            var candidates = variable_struct_exists(effect, "object_names") ? effect.object_names : [];
            if (!is_array(candidates) || array_length(candidates) <= 0) return false;
            var pick = candidates[irandom(array_length(candidates) - 1)];
            var idx_on = asset_get_index(pick);
            if (idx_on == -1) return false;
            
            var inst = instance_create_layer(handInst_h.x, handInst_h.y, layer_get_id("Instances"), idx_on);
            if (inst == noone) return false;
            inst.isHeroOwner = ownerIsHero_h;
            inst.image_angle = ownerIsHero_h ? 0 : 180;
            if (variable_instance_exists(inst, "zone")) inst.zone = "Hand"; else inst.zone = "Hand";
            handInst_h.addCard(inst);
            var ctx_h = { owner_is_hero: ownerIsHero_h };
            registerTriggerEvent(TRIGGER_ENTER_HAND, inst, ctx_h);
            return true;
        }
        
        case EFFECT_DAMAGE_ALL_PER_ALLY_COUNT:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (is_undefined(damageAllMonsters)) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var countOwner = variable_struct_exists(effect, "count_owner") ? string_lower(string(effect.count_owner)) : "ally";
            var countHero = srcHero;
            if (countOwner == "ally") countHero = srcHero;
            else if (countOwner == "enemy") countHero = !srcHero;
            var arr = countHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
            
            var includeFD = variable_struct_exists(effect, "include_face_down_in_count") ? effect.include_face_down_in_count : false;
            var countCrit = variable_struct_exists(effect, "count_criteria") ? effect.count_criteria : noone;
            var countObjNames = variable_struct_exists(effect, "count_object_names") ? effect.count_object_names : [];
            var count = _countFieldByCriteria(arr, includeFD, countCrit, countObjNames);
            
            var per = variable_struct_exists(effect, "value") ? effect.value : 1;
            var base = variable_struct_exists(effect, "base_value") ? effect.base_value : 0;
            per = max(0, per);
            base = max(0, base);
            var total = base + (per * count);
            if (total <= 0) return true;
            
            var dmgSpec = {
                owner: (variable_struct_exists(effect, "owner") ? effect.owner : "enemy"),
                target_zone: (variable_struct_exists(effect, "target_zone") ? effect.target_zone : "field"),
                monster_type: (variable_struct_exists(effect, "monster_type") ? effect.monster_type : "Monster"),
                criteria: (variable_struct_exists(effect, "criteria") ? effect.criteria : noone),
                source_card: card
            };
            if (variable_struct_exists(effect, "visual_fx")) dmgSpec.visual_fx = effect.visual_fx;
            if (variable_struct_exists(effect, "element")) dmgSpec.element = effect.element;
            
            return damageAllMonsters(total, dmgSpec);
        }

        case EFFECT_RANDOM_PROJECTILES:
        {
            if (card == noone || !instance_exists(card)) return false;
            if (is_undefined(animEffectRequestProjectileTarget)) return false;
            if (is_undefined(damageCard)) return false;
            if (!instance_exists(game)) return false;

            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            var enemyHero = srcHero ? instance_find(oLP_Enemy, 0) : instance_find(oLP_Hero, 0);

            var dmg = variable_struct_exists(effect, "damage") ? effect.damage
                      : (variable_struct_exists(effect, "value") ? effect.value : 1);
            dmg = max(0, dmg);
            if (dmg <= 0) return true;

            var count = variable_struct_exists(effect, "count") ? effect.count
                       : (variable_struct_exists(effect, "projectiles") ? effect.projectiles : 1);
            if (variable_struct_exists(effect, "use_context_def_value_as_count") && effect.use_context_def_value_as_count) {
                if (variable_struct_exists(context, "def_value")) count = context.def_value;
            }
            count = max(0, count);
            if (count <= 0) return true;

            var bonus = 0;
            if (variable_struct_exists(effect, "bonus_count")) bonus = effect.bonus_count;
            else if (variable_struct_exists(effect, "bonus_projectiles")) bonus = effect.bonus_projectiles;
            bonus = max(0, bonus);

            if (bonus > 0 && variable_struct_exists(effect, "bonus_if_ally_object_names")) {
                var names = effect.bonus_if_ally_object_names;
                if (is_array(names) && array_length(names) > 0) {
                    var arr = srcHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
                    var found = false;
                    for (var i = 0; i < array_length(arr); i++) {
                        var c0 = arr[i];
                        if (c0 == 0 || !instance_exists(c0)) continue;
                        var z0 = variable_instance_exists(c0, "zone") ? string_lower(c0.zone) : "";
                        if (!(z0 == "field" || z0 == "fieldselected")) continue;
                        var on0 = object_get_name(c0.object_index);
                        for (var j = 0; j < array_length(names); j++) {
                            if (on0 == string(names[j])) { found = true; break; }
                        }
                        if (found) break;
                    }
                    if (found) count += bonus;
                }
            }
            
            var bonusDmg = 0;
            if (variable_struct_exists(effect, "bonus_damage")) bonusDmg = effect.bonus_damage;
            else if (variable_struct_exists(effect, "bonus_value")) bonusDmg = effect.bonus_value;
            bonusDmg = max(0, bonusDmg);
            if (bonusDmg > 0 && variable_struct_exists(effect, "bonus_damage_if_ally_object_names")) {
                var namesD = effect.bonus_damage_if_ally_object_names;
                if (is_array(namesD) && array_length(namesD) > 0) {
                    var arrD = srcHero ? fieldMonsterHero.cards : fieldMonsterEnemy.cards;
                    var foundD = false;
                    for (var di = 0; di < array_length(arrD); di++) {
                        var cd = arrD[di];
                        if (cd == 0 || !instance_exists(cd)) continue;
                        var zd = variable_instance_exists(cd, "zone") ? string_lower(cd.zone) : "";
                        if (!(zd == "field" || zd == "fieldselected")) continue;
                        var onD = object_get_name(cd.object_index);
                        for (var dj = 0; dj < array_length(namesD); dj++) {
                            if (onD == string(namesD[dj])) { foundD = true; break; }
                        }
                        if (foundD) break;
                    }
                    if (foundD) dmg += bonusDmg;
                }
            }

            var element = variable_struct_exists(effect, "element") ? effect.element : "feu";

            for (var p = 0; p < count; p++) {
                var targets = [];

                var arrE = srcHero ? fieldMonsterEnemy.cards : fieldMonsterHero.cards;
                for (var k = 0; k < array_length(arrE); k++) {
                    var t0 = arrE[k];
                    if (t0 == 0 || !instance_exists(t0)) continue;
                    var zt = variable_instance_exists(t0, "zone") ? string_lower(t0.zone) : "";
                    if (!(zt == "field" || zt == "fieldselected")) continue;
                    array_push(targets, t0);
                }

                if (variable_struct_exists(effect, "include_enemy_hero") ? effect.include_enemy_hero : true) {
                    if (enemyHero != noone && instance_exists(enemyHero)) array_push(targets, enemyHero);
                }

                if (array_length(targets) <= 0) break;
                var tgt = targets[irandom(array_length(targets) - 1)];
                if (tgt == noone || !instance_exists(tgt)) continue;

                var cb = method({ s: card, t: tgt, a: dmg, h: enemyHero, sh: srcHero }, function() {
                    if (!instance_exists(s) || !instance_exists(t)) return;
                    if (t == h && instance_exists(game)) {
                        var lpInst = sh ? instance_find(oLP_Enemy, 0) : instance_find(oLP_Hero, 0);
                        if (lpInst != noone && instance_exists(lpInst) && variable_instance_exists(lpInst, "nbLP")) {
                            lpInst.nbLP -= a;
                        }
                    } else {
                        damageCard(t, a, s);
                    }
                });

                animEffectRequestProjectileTarget(string(element), card, tgt, dmg, cb);
            }

            return true;
        }

        case EFFECT_INCREASE_HAND_COST:
        {
            if (card == noone || !instance_exists(card)) return false;
            var srcHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;

            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "enemy";
            var targetIsHero = !srcHero;
            if (ownerSide == "ally") targetIsHero = srcHero;
            else if (ownerSide == "enemy") targetIsHero = !srcHero;

            var handInst = targetIsHero ? handHero : handEnemy;
            if (!instance_exists(handInst)) return false;
            if (!variable_instance_exists(handInst, "cards")) return false;
            if (!ds_exists(handInst.cards, ds_type_list)) return false;

            var sz = ds_list_size(handInst.cards);
            if (sz <= 0) return false;

            var amount = 1;
            if (variable_struct_exists(effect, "value")) amount = effect.value;
            else if (variable_struct_exists(effect, "amount")) amount = effect.amount;
            else if (variable_struct_exists(effect, "cost_increase")) amount = effect.cost_increase;
            amount = max(0, amount);
            if (amount == 0) return true;

            var randomTarget = ds_list_find_value(handInst.cards, irandom(sz - 1));
            if (randomTarget == noone || !instance_exists(randomTarget)) return false;

            if (variable_instance_exists(randomTarget, "mana_cost")) randomTarget.mana_cost += amount;
            if (variable_instance_exists(randomTarget, "cost")) randomTarget.cost = randomTarget.mana_cost;
            if (variable_instance_exists(handInst, "updateDisplay")) handInst.updateDisplay();
            return true;
        }

        case EFFECT_SET_NEXT_PLAYED_MONSTER_COST_BONUS:
        {
            if (!instance_exists(game)) return false;
            var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "enemy";
            var targetIsHero = !srcHero;
            if (ownerSide == "ally") targetIsHero = srcHero;
            else if (ownerSide == "enemy") targetIsHero = !srcHero;
            else if (ownerSide == "both") { }
            
            var amount = 1;
            if (variable_struct_exists(effect, "value")) amount = effect.value;
            else if (variable_struct_exists(effect, "amount")) amount = effect.amount;
            amount = max(0, amount);
            
            var applyCostBonusTo = function(tgtHero) {
                if (tgtHero) {
                    if (!variable_global_exists("next_played_monster_cost_bonus_hero")) global.next_played_monster_cost_bonus_hero = 0;
                    if (!variable_global_exists("next_played_monster_cost_bonus_hero_turn")) global.next_played_monster_cost_bonus_hero_turn = 0;
                    if (!variable_global_exists("next_played_monster_cost_bonus_hero_used")) global.next_played_monster_cost_bonus_hero_used = false;
                    global.next_played_monster_cost_bonus_hero = max(global.next_played_monster_cost_bonus_hero, amount);
                    global.next_played_monster_cost_bonus_hero_turn = game.nbTurn;
                    global.next_played_monster_cost_bonus_hero_used = false;
                } else {
                    if (!variable_global_exists("next_played_monster_cost_bonus_enemy")) global.next_played_monster_cost_bonus_enemy = 0;
                    if (!variable_global_exists("next_played_monster_cost_bonus_enemy_turn")) global.next_played_monster_cost_bonus_enemy_turn = 0;
                    if (!variable_global_exists("next_played_monster_cost_bonus_enemy_used")) global.next_played_monster_cost_bonus_enemy_used = false;
                    global.next_played_monster_cost_bonus_enemy = max(global.next_played_monster_cost_bonus_enemy, amount);
                    global.next_played_monster_cost_bonus_enemy_turn = game.nbTurn;
                    global.next_played_monster_cost_bonus_enemy_used = false;
                }
            };
            
            if (ownerSide == "both") {
                applyCostBonusTo(true);
                applyCostBonusTo(false);
                return true;
            }
            applyCostBonusTo(targetIsHero);
            return true;
        }

        case EFFECT_TERRAIN_TICK:
        {
            if (card == noone || !instance_exists(card)) return false;
            var initTurns = variable_struct_exists(effect, "turns") ? effect.turns : (variable_struct_exists(effect, "value") ? effect.value : 3);
            initTurns = max(1, initTurns);
            if (!variable_instance_exists(card, "terrain_turns_remaining") || card.terrain_turns_remaining == undefined) {
                card.terrain_turns_remaining = initTurns;
                return true;
            }
            card.terrain_turns_remaining = max(0, card.terrain_turns_remaining - 1);
            if (card.terrain_turns_remaining <= 0) {
                return destroyCard(card);
            }
            return true;
        }
            
        case EFFECT_LOSE_ATTACK:
        {
            var t = target;
            if (t == noone && variable_struct_exists(effect, "select_mode") && effect.select_mode == "random") {
                if (script_exists(getTargetsByFilter)) {
                    var candidates = getTargetsByFilter(effect);
                    if (is_array(candidates) && array_length(candidates) > 0) {
                        t = candidates[irandom(array_length(candidates) - 1)];
                    }
                }
            }
            if (t == noone) t = card;
            if (t == noone) return false;
            return modifyAttack(t, -value, true);
        }
            
        // Débuff permanent d'ATK (peut cibler la carte ou la cible fournie)
        case EFFECT_LOSE_ATTACK_PERMANENT:
        {
            var t = (target != noone) ? target : card;
            if (t == noone) return false;
            return modifyAttack(t, -value, false);
        }
            
        

        
            
        case EFFECT_LOSE_DEFENSE:
            return modifyDefense(card, -value, true);
            
        case EFFECT_SET_ATTACK:
            return setAttack(card, value);

        case EFFECT_SET_DEFENSE:
            return setDefense(card, value);

        case EFFECT_BUFF:
        {
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
            var mode = variable_struct_exists(effect, "mode") ? string_lower(effect.mode) : "add";
            var ownerSideB = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
            var srcHeroB = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            var agg = (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_CONTINUOUS) || (variable_struct_exists(effect, "aggregate") && effect.aggregate);
            var atkVal = 0;
            var defVal = 0;
            var ignoreCtx = variable_struct_exists(effect, "ignore_context_stats") ? effect.ignore_context_stats : false;
            if (!ignoreCtx && variable_struct_exists(context, "atk_value")) atkVal = context.atk_value; else if (variable_struct_exists(effect, "atk")) atkVal = effect.atk; else atkVal = value;
            if (!ignoreCtx && variable_struct_exists(context, "def_value")) defVal = context.def_value; else if (variable_struct_exists(effect, "PV")) defVal = effect.PV; else defVal = value;

            // Gestion du bonus conditionnel (ex: Combo)
            if (variable_struct_exists(effect, "bonus_condition") && checkCondition(effect.bonus_condition, card, context)) {
                if (variable_struct_exists(effect, "bonus_atk")) atkVal += effect.bonus_atk;
                else if (variable_struct_exists(effect, "bonus_value")) atkVal += effect.bonus_value;
                
                if (variable_struct_exists(effect, "bonus_PV")) defVal += effect.bonus_PV;
            }

            if (variable_struct_exists(effect, "per_genre")) {
                var perG = string_lower(string(effect.per_genre));
                var perZone = variable_struct_exists(effect, "per_zone") ? string_lower(effect.per_zone) : "field";
                var perOwner = variable_struct_exists(effect, "per_owner") ? string_lower(effect.per_owner) : "both";
                var perAtk = variable_struct_exists(effect, "per_amount_atk") ? effect.per_amount_atk : 0;
                var perDef = variable_struct_exists(effect, "per_amount_def") ? effect.per_amount_def : 0;
                var excludeSelfG = variable_struct_exists(effect, "exclude_self_in_per_count") ? effect.exclude_self_in_per_count : false;
                var excludeFDG = variable_struct_exists(effect, "exclude_face_down_in_per_count") ? effect.exclude_face_down_in_per_count : false;
                var count = 0;
                // Héros
                var arrH = fieldMonsterHero.cards;
                for (var hi2 = 0; hi2 < array_length(arrH); hi2++) {
                    var ch2 = arrH[hi2];
                    if (ch2 != 0 && instance_exists(ch2)) {
                        var z2 = variable_instance_exists(ch2, "zone") ? string_lower(ch2.zone) : "";
                        var okZone2 = (perZone == "all") || (perZone == "field" && (z2 == "field" || z2 == "fieldselected")) || (perZone == z2);
                        if (!okZone2) continue;
                        if (excludeFDG && variable_instance_exists(ch2, "isFaceDown") && ch2.isFaceDown) continue;
                        var g2 = variable_instance_exists(ch2, "genre") ? string_lower(string(ch2.genre)) : "";
                        if (g2 != perG) continue;
                        if (excludeSelfG && instance_exists(card) && ch2 == card) continue;
                        // Owner filter
                        if (perOwner == "enemy") continue;
                        count += 1;
                    }
                }
                // Ennemi
                var arrE2 = fieldMonsterEnemy.cards;
                for (var ei2 = 0; ei2 < array_length(arrE2); ei2++) {
                    var ce2 = arrE2[ei2];
                    if (ce2 != 0 && instance_exists(ce2)) {
                        var z3 = variable_instance_exists(ce2, "zone") ? string_lower(ce2.zone) : "";
                        var okZone3 = (perZone == "all") || (perZone == "field" && (z3 == "field" || z3 == "fieldselected")) || (perZone == z3);
                        if (!okZone3) continue;
                        if (excludeFDG && variable_instance_exists(ce2, "isFaceDown") && ce2.isFaceDown) continue;
                        var g3 = variable_instance_exists(ce2, "genre") ? string_lower(string(ce2.genre)) : "";
                        if (g3 != perG) continue;
                        if (excludeSelfG && instance_exists(card) && ce2 == card) continue;
                        if (perOwner == "ally") continue;
                        count += 1;
                    }
                }
                atkVal += perAtk * count;
                defVal += perDef * count;

                if (excludeSelfG && instance_exists(card)) {
                    var zSelfG = variable_instance_exists(card, "zone") ? string_lower(card.zone) : "";
                    var okZSg = (perZone == "all") || (perZone == "field" && (zSelfG == "field" || zSelfG == "fieldselected")) || (perZone == zSelfG);
                    if (okZSg) {
                        var gSelf = variable_instance_exists(card, "genre") ? string_lower(string(card.genre)) : "";
                        if (gSelf == perG) {
                            count = max(0, count - 1);
                            // Recalculer les contributions suites à l'exclusion
                            atkVal = (variable_struct_exists(effect, "per_amount_atk") ? effect.per_amount_atk : 0) * count;
                            defVal = (variable_struct_exists(effect, "per_amount_def") ? effect.per_amount_def : 0) * count;
                        }
                    }
                }

                if (variable_struct_exists(effect, "apply_only_if_per_genre_count_is_zero") && effect.apply_only_if_per_genre_count_is_zero) {
                    if (count == 0) {
                        var zeroAtk = variable_struct_exists(effect, "per_zero_bonus_atk") ? effect.per_zero_bonus_atk : 0;
                        var zeroDef = variable_struct_exists(effect, "per_zero_bonus_def") ? effect.per_zero_bonus_def : 0;
                        atkVal += zeroAtk;
                        defVal += zeroDef;
                    }
                }
            }

            if (variable_struct_exists(effect, "per_name")) {
                var perN = string(effect.per_name);
                var perZoneN = variable_struct_exists(effect, "per_zone") ? string_lower(effect.per_zone) : "field";
                var perOwnerN = variable_struct_exists(effect, "per_owner") ? string_lower(effect.per_owner) : "both";
                var perAtkN = variable_struct_exists(effect, "per_amount_atk") ? effect.per_amount_atk : 0;
                var perDefN = variable_struct_exists(effect, "per_amount_def") ? effect.per_amount_def : 0;
                var excludeSelfN = variable_struct_exists(effect, "exclude_self_in_per_count") ? effect.exclude_self_in_per_count : true;
                var excludeFDN = variable_struct_exists(effect, "exclude_face_down_in_per_count") ? effect.exclude_face_down_in_per_count : false;
                var countN = 0;
                var arrHN = fieldMonsterHero.cards;
                for (var hni = 0; hni < array_length(arrHN); hni++) {
                    var chN = arrHN[hni];
                    if (chN != 0 && instance_exists(chN)) {
                        var zHN = variable_instance_exists(chN, "zone") ? string_lower(chN.zone) : "";
                        var okZH = (perZoneN == "all") || (perZoneN == "field" && (zHN == "field" || zHN == "fieldselected")) || (perZoneN == zHN);
                        if (!okZH) continue;
                        if (excludeFDN && variable_instance_exists(chN, "isFaceDown") && chN.isFaceDown) continue;
                        var nmH = variable_instance_exists(chN, "name") ? string(chN.name) : object_get_name(chN.object_index);
                        if (nmH != perN) continue;
                        if (excludeSelfN && instance_exists(card) && chN == card) continue;
                        if (perOwnerN == "enemy") continue;
                        countN += 1;
                    }
                }
                var arrEN = fieldMonsterEnemy.cards;
                for (var eni = 0; eni < array_length(arrEN); eni++) {
                    var ceN = arrEN[eni];
                    if (ceN != 0 && instance_exists(ceN)) {
                        var zEN = variable_instance_exists(ceN, "zone") ? string_lower(ceN.zone) : "";
                        var okZE = (perZoneN == "all") || (perZoneN == "field" && (zEN == "field" || zEN == "fieldselected")) || (perZoneN == zEN);
                        if (!okZE) continue;
                        if (excludeFDN && variable_instance_exists(ceN, "isFaceDown") && ceN.isFaceDown) continue;
                        var nmE = variable_instance_exists(ceN, "name") ? string(ceN.name) : object_get_name(ceN.object_index);
                        if (nmE != perN) continue;
                        if (excludeSelfN && instance_exists(card) && ceN == card) continue;
                        if (perOwnerN == "ally") continue;
                        countN += 1;
                    }
                }
                atkVal += perAtkN * countN;
                defVal += perDefN * countN;
                if (excludeSelfN && instance_exists(card)) {
                    var zSelf = variable_instance_exists(card, "zone") ? string_lower(card.zone) : "";
                    var okZS = (perZoneN == "all") || (perZoneN == "field" && (zSelf == "field" || zSelf == "fieldselected")) || (perZoneN == zSelf);
                    if (okZS) {
                        var nmSelf = variable_instance_exists(card, "name") ? string(card.name) : object_get_name(card.object_index);
                        if (nmSelf == perN) {
                            var dec = (perOwnerN == "both") ? 1 : 1;
                            atkVal -= perAtkN * dec;
                            defVal -= perDefN * dec;
                        }
                    }
                }
            }

        var applyTo = function(tgt2, eff, ownerSideP, srcHeroP, aggP, scopeP, modeP, baseAtk, baseDef, srcCard) {
            if (tgt2 == noone || !instance_exists(tgt2)) return false;
            
            // DEBUG: Trace applyTo
            var tName = (variable_instance_exists(tgt2, "name")) ? tgt2.name : "Unknown";
            show_debug_message("### applyTo: Target=" + tName + " ATK=" + string(baseAtk) + " DEF=" + string(baseDef));

            if (variable_struct_exists(eff, "exclude_face_down_targets") && eff.exclude_face_down_targets) {
                if (variable_instance_exists(tgt2, "isFaceDown") && tgt2.isFaceDown) {
                    show_debug_message("### applyTo: Rejected (FaceDown)");
                    return false;
                }
            }
            var okc = true;
            
            // DEBUG: Trace filtering for specific card
            var debug_trace = true; // Force trace for now
            if (debug_trace) show_debug_message("--- DEBUG EFFECT FILTER: " + string(tName) + " ---");

            if (variable_struct_exists(eff, "criteria")) {
                var critB = eff.criteria;
                var isTerrain = (variable_instance_exists(tgt2, "isTerrain") && tgt2.isTerrain);
                if (variable_struct_exists(critB, "is_terrain")) {
                    var wantTerrain = critB.is_terrain;
                    if (wantTerrain && !isTerrain) okc = false;
                    if (!wantTerrain && isTerrain) okc = false;
                }
                if (variable_struct_exists(critB, "type")) {
                    var wt = string_lower(critB.type);
                    var isMon = (object_is_ancestor(tgt2.object_index, oCardMonster) || (variable_instance_exists(tgt2, "type") && string_lower(tgt2.type) == "monster")) && !isTerrain;
                    if (debug_trace) show_debug_message("Type Check: Wanted=" + wt + " IsMon=" + string(isMon));
                    if (wt == "monster" && !isMon) okc = false;
                }
                if (variable_struct_exists(critB, "genre")) {
                    var wg = string_lower(string(critB.genre));
                    var tg = variable_instance_exists(tgt2, "genre") ? string_lower(string(tgt2.genre)) : "";
                    
                    // Relaxed check: Handle Bête/Bete and strict equality
                    var match = (wg == "" || tg == wg);
                    if (!match) {
                        // Fallback for accents (basic)
                        var wg_clean = string_replace_all(wg, "ê", "e");
                        var tg_clean = string_replace_all(tg, "ê", "e");
                        if (wg_clean == tg_clean) match = true;
                        if (debug_trace) show_debug_message("Genre Accent Check: WG=" + wg_clean + " TG=" + tg_clean + " Match=" + string(match));
                    } else {
                        if (debug_trace) show_debug_message("Genre Direct Match: WG=" + wg + " TG=" + tg);
                    }
                    
                    if (!match) okc = false;
                }
                if (variable_struct_exists(critB, "archetype")) {
                    var wa = string_lower(string(critB.archetype));
                    var ta = variable_instance_exists(tgt2, "archetype") ? string_lower(string(tgt2.archetype)) : "";
                    if (debug_trace) show_debug_message("Archetype Check: Wanted=" + wa + " Got=" + ta);
                    if (wa != "" && ta != wa) okc = false;
                }
                if (variable_struct_exists(critB, "race")) {
                    var wr = string_lower(string(critB.race));
                    var tr = variable_instance_exists(tgt2, "race") ? string_lower(string(tgt2.race)) : "";
                    if (wr != "" && tr != wr) okc = false;
                }
                if (variable_struct_exists(critB, "name_contains")) {
                    var wn = string_lower(string(critB.name_contains));
                    var tn = variable_instance_exists(tgt2, "name") ? string_lower(string(tgt2.name)) : "";
                    if (debug_trace) show_debug_message("NameContains Check: Wanted=" + wn + " Got=" + tn);
                    if (wn != "" && string_pos(wn, tn) == 0) okc = false;
                }
            }
            if (!okc) {
                show_debug_message("### applyTo: Rejected by Criteria");
                return false;
            }
            // Filtre supplémentaire: n'appliquer qu'aux cibles camouflées
            if (okc && variable_struct_exists(eff, "only_camouflaged") && eff.only_camouflaged) {
                var isCamo = (variable_instance_exists(tgt2, "isCamouflage") && tgt2.isCamouflage);
                if (!isCamo) okc = false;
            }
            if (variable_struct_exists(eff, "owner")) {
                var tgtHero = (instance_exists(tgt2) && variable_instance_exists(tgt2, "isHeroOwner")) ? tgt2.isHeroOwner : srcHeroP;
                if (ownerSideP == "ally" && (tgtHero != srcHeroP)) { okc = false; show_debug_message("### applyTo: Rejected by Owner (Wanted Ally)"); }
                if (ownerSideP == "enemy" && (tgtHero == srcHeroP)) { okc = false; show_debug_message("### applyTo: Rejected by Owner (Wanted Enemy)"); }
            }
            if (variable_struct_exists(eff, "target_zone")) {
                var tz = string_lower(eff.target_zone);
                var z = variable_instance_exists(tgt2, "zone") ? string_lower(tgt2.zone) : "";
                if (tz == "field" && z != "field" && z != "fieldselected") okc = false;
                if (tz == "hand" && z != "hand") okc = false;
            }
            if (!okc) return false;
            
            show_debug_message("### applyTo: Accepted. Applying Buff...");
            var laAtk = baseAtk;
            var laDef = baseDef;
            var gotBonus = false;
            if (variable_struct_exists(eff, "bonus_if_names")) {
                var namesB = eff.bonus_if_names;
                var oname = object_get_name(tgt2.object_index);
                if (is_array(namesB)) {
                    for (var bi = 0; bi < array_length(namesB); bi++) { if (oname == namesB[bi]) { gotBonus = true; break; } }
                } else if (is_string(namesB)) { gotBonus = (oname == namesB); }
            }
            if (!gotBonus && variable_struct_exists(eff, "bonus_if_archetype")) {
                var wantedA = string_lower(string(eff.bonus_if_archetype));
                var ta2 = variable_instance_exists(tgt2, "archetype") ? string_lower(string(tgt2.archetype)) : "";
                if (wantedA != "" && ta2 == wantedA) gotBonus = true;
            }
            if (!gotBonus && variable_struct_exists(eff, "bonus_if_genre")) {
                var wantedG = string_lower(string(eff.bonus_if_genre));
                var tg2 = variable_instance_exists(tgt2, "genre") ? string_lower(string(tgt2.genre)) : "";
                if (wantedG != "" && tg2 == wantedG) gotBonus = true;
            }
            if (gotBonus) {
                var extraAdd = variable_struct_exists(eff, "extra_buff") ? eff.extra_buff : 0;
                var extraAtk = variable_struct_exists(eff, "atk_bonus") ? eff.atk_bonus : extraAdd;
                var extraDef = variable_struct_exists(eff, "def_bonus") ? eff.def_bonus : extraAdd;
                laAtk += extraAtk;
                laDef += extraDef;
            }
            if (modeP == "set") {
                if (variable_struct_exists(eff, "set_atk")) setAttack(tgt2, eff.set_atk);
                if (variable_struct_exists(eff, "set_def")) setDefense(tgt2, eff.set_def);
                return true;
            }
            if (aggP) {
                var srcId = (srcCard != noone && instance_exists(srcCard)) ? srcCard.id : -1;
                var srcKeyB = "effect:" + string(eff.effect_type) + ":" + string(srcId) + ":" + string(variable_struct_exists(eff, "id") ? eff.id : -1);
                if (scopeP == "equip") { srcKeyB = "equip:" + string(srcId); }
                else if (scopeP == "aura") { srcKeyB = "aura:" + string(srcId); }
                buffSetContribution(tgt2, srcKeyB, laAtk, laDef);
                buffRecompute(tgt2);
                if (variable_struct_exists(eff, "grant_ambidextrous") && eff.grant_ambidextrous) {
                    tgt2.isAmbidextrous = true;
                }
                if (variable_struct_exists(eff, "grant_camouflage") && eff.grant_camouflage) {
                    tgt2.isCamouflage = true;
                }
                if (variable_struct_exists(eff, "grant_poison") && eff.grant_poison) {
                    tgt2.isPoisoner = true;
                }
                if (variable_struct_exists(eff, "keep_camouflage_this_turn") && eff.keep_camouflage_this_turn) {
                    if (instance_exists(tgt2)) {
                        var curT = (instance_exists(game) && variable_instance_exists(game, "nbTurn")) ? game.nbTurn : 0;
                        tgt2.keepCamouflageTurn = curT;
                    }
                }
                return true;
            } else {
                var isTempP = variable_struct_exists(eff, "temporary") ? eff.temporary : false;
                if (laAtk != 0) modifyAttack(tgt2, laAtk, isTempP);
                if (laDef != 0) modifyDefense(tgt2, laDef, isTempP);
                if (variable_struct_exists(eff, "grant_ambidextrous") && eff.grant_ambidextrous) {
                    tgt2.isAmbidextrous = true;
                }
                if (variable_struct_exists(eff, "grant_camouflage") && eff.grant_camouflage) {
                    tgt2.isCamouflage = true;
                }
                if (variable_struct_exists(eff, "grant_poison") && eff.grant_poison) {
                    tgt2.isPoisoner = true;
                }
                if (variable_struct_exists(eff, "keep_camouflage_this_turn") && eff.keep_camouflage_this_turn) {
                    if (instance_exists(tgt2)) {
                        var curT2 = (instance_exists(game) && variable_instance_exists(game, "nbTurn")) ? game.nbTurn : 0;
                        tgt2.keepCamouflageTurn = curT2;
                    }
                }
                return true;
            }
        };


            if (scope == "single" || scope == "self") {
                var tgt;
                if (scope == "self") {
                    tgt = card;
                } else if (target != noone) {
                    tgt = target;
                } else {
                    var excludeSelfC = (variable_struct_exists(effect, "criteria") && variable_struct_exists(effect.criteria, "exclude_self")) ? effect.criteria.exclude_self : false;
                    tgt = excludeSelfC ? noone : card;
                    
                    if (variable_struct_exists(effect, "select_mode") && effect.select_mode == "random") {
                        tgt = noone;
                        if (script_exists(getTargetsByFilter)) {
                            var candidatesB = getTargetsByFilter(effect);
                            if (is_array(candidatesB) && array_length(candidatesB) > 0) {
                                tgt = candidatesB[irandom(array_length(candidatesB) - 1)];
                            }
                        }
                    }
                    
                    // Auto-ciblage IA: si aucune cible fournie pour un buff "single", choisir une cible valide sur le terrain
                    // (utile pour les sorts de buff joués par l'IA qui sinon tentent de se cibler eux-mêmes)
                    var owner_ctx = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner"))
                                    ? card.isHeroOwner
                                    : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                    if (!owner_ctx && (variable_struct_exists(effect, "criteria") && is_struct(effect.criteria)) && script_exists(asset_get_index("_cardMatchesCriteria"))) {
                        var critAuto = effect.criteria;
                        var arraysToCheck = [];
                        var os = ownerSideB;
                        if (os == "hero") os = "ally";
                        if (os == "ally") {
                            arraysToCheck = [ srcHeroB ? fieldMonsterHero.cards : fieldMonsterEnemy.cards ];
                        } else if (os == "enemy") {
                            arraysToCheck = [ srcHeroB ? fieldMonsterEnemy.cards : fieldMonsterHero.cards ];
                        } else {
                            arraysToCheck = [ fieldMonsterHero.cards, fieldMonsterEnemy.cards ];
                        }
                        for (var ai = 0; ai < array_length(arraysToCheck); ai++) {
                            var arrAuto = arraysToCheck[ai];
                            for (var ii = 0; ii < array_length(arrAuto); ii++) {
                                var cAuto = arrAuto[ii];
                                if (cAuto == 0 || !instance_exists(cAuto)) continue;
                                var zcAuto = variable_instance_exists(cAuto, "zone") ? string_lower(cAuto.zone) : "";
                                if (zcAuto != "field" && zcAuto != "fieldselected") continue;
                                if (excludeSelfC && instance_exists(card) && cAuto == card) continue;
                                if (_cardMatchesCriteria(cAuto, critAuto)) {
                                    tgt = cAuto;
                                    ai = array_length(arraysToCheck);
                                    break;
                                }
                            }
                        }
                    }
                }
                if (tgt == noone) { return false; }

                // [Pre-Check Conditions Logic]
                // Certains effets (ex: Combo) nécessitent de vérifier la condition AVANT l'application du buff
                // car le buff lui-même pourrait valider la condition (auto-validation indésirable).
                var flowPreResults = [];
                var hasFlowArray = (variable_struct_exists(effect, "flow") && is_array(effect.flow));
                var hasFlowStruct = (variable_struct_exists(effect, "flow") && is_struct(effect.flow));
                
                if (hasFlowArray) {
                    var Lpre = array_length(effect.flow);
                    flowPreResults = array_create(Lpre, undefined);
                    for (var kpre = 0; kpre < Lpre; kpre++) {
                        var stepPre = effect.flow[kpre];
                        if (is_struct(stepPre) && variable_struct_exists(stepPre, "condition") && variable_struct_exists(stepPre, "check_condition_before") && stepPre.check_condition_before) {
                             var owner_flag_pre = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
                             if (script_exists(asset_get_index("checkCondition"))) {
                                 flowPreResults[kpre] = checkCondition(stepPre.condition, card, { owner_is_hero: owner_flag_pre });
                             }
                        }
                    }
                } else if (hasFlowStruct) {
                    flowPreResults = array_create(1, undefined);
                    var stepPre = effect.flow;
                    if (is_struct(stepPre) && variable_struct_exists(stepPre, "condition") && variable_struct_exists(stepPre, "check_condition_before") && stepPre.check_condition_before) {
                         var owner_flag_pre = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
                         if (script_exists(asset_get_index("checkCondition"))) {
                             flowPreResults[0] = checkCondition(stepPre.condition, card, { owner_is_hero: owner_flag_pre });
                         }
                    }
                }
                // [End Pre-Check]

                var resBuff = applyTo(tgt, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card);
                if (resBuff) {
                    // Exposer la cible réellement affectée pour les flows/consommateurs externes (ex: Secrets de redirection)
                    context.target = tgt;
                    var owner_flag = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner"))
                                     ? card.isHeroOwner
                                     : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                    var ctxb = { from_buff: true, owner_is_hero: owner_flag };
                    if (hasFlowArray) {
                        var Lb = array_length(effect.flow);
                        for (var kb = 0; kb < Lb; kb++) {
                             var stepB = effect.flow[kb];
                             if (is_struct(stepB) && variable_struct_exists(stepB, "effect_type")) {
                                 var condMet = true;
                                 // Check pre-calculated result
                                 if (kb < array_length(flowPreResults) && !is_undefined(flowPreResults[kb])) {
                                     condMet = flowPreResults[kb];
                                 } else if (variable_struct_exists(stepB, "condition") && script_exists(asset_get_index("checkCondition"))) {
                                     if (!checkCondition(stepB.condition, card, ctxb)) condMet = false;
                                 }
                                 if (condMet) executeEffect(card, stepB, ctxb);
                             }
                        }
                    } else if (hasFlowStruct) {
                         var stepB = effect.flow;
                         var condMet = true;
                         // Check pre-calculated result
                         if (array_length(flowPreResults) > 0 && !is_undefined(flowPreResults[0])) {
                             condMet = flowPreResults[0];
                         } else if (variable_struct_exists(stepB, "condition") && script_exists(asset_get_index("checkCondition"))) {
                             if (!checkCondition(stepB.condition, card, ctxb)) condMet = false;
                         }
                         if (condMet) executeEffect(card, stepB, ctxb);
                    } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                        executeEffect(card, effect.flow_next, ctxb);
                    }
                }
                return resBuff;
            } else if (scope == "equip") {
                var tEquip = (variable_instance_exists(card, "equipped_target")) ? card.equipped_target : noone;
                return applyTo(tEquip, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card);
            } else if (scope == "all" || scope == "aura" || scope == "all_allies" || scope == "all_enemies") {
                show_debug_message("### sEffects: Processing scope=" + scope);
                var applied = false;
                var heroArr = fieldMonsterHero.cards;
                for (var hi = 0; hi < array_length(heroArr); hi++) {
                    var ch = heroArr[hi];
                    if (ch != 0 && instance_exists(ch)) {
                        var z1 = variable_instance_exists(ch, "zone") ? string_lower(ch.zone) : "";
                        if (z1 == "field" || z1 == "fieldselected") {
                            // Filtrage propriétaire
                            var okOwnH = true;
                            var effOwner = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "";
                            if (scope == "all_allies") effOwner = "ally";
                            if (scope == "all_enemies") effOwner = "enemy";
                            
                            if (effOwner != "") {
                                var isHeroLocalH = variable_instance_exists(ch, "isHeroOwner") ? ch.isHeroOwner : undefined;
                                if (effOwner == "ally" && isHeroLocalH != srcHeroB) okOwnH = false;
                                if (effOwner == "enemy" && isHeroLocalH == srcHeroB) okOwnH = false;
                            }
                            if (!okOwnH) { 
                                show_debug_message("### sEffects: Skip " + string(ch) + " due to owner filter (Hero Loop)");
                                continue; 
                            }
                            
                            if (applyTo(ch, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card)) applied = true;
                        }
                    }
                }
                var enemyArr = fieldMonsterEnemy.cards;
                for (var ei = 0; ei < array_length(enemyArr); ei++) {
                    var ce = enemyArr[ei];
                    if (ce != 0 && instance_exists(ce)) {
                        var z2 = variable_instance_exists(ce, "zone") ? string_lower(ce.zone) : "";
                        if (z2 == "field" || z2 == "fieldselected") {
                            // Filtrage propriétaire
                            var okOwnE = true;
                            var effOwnerE = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "";
                            if (scope == "all_allies") effOwnerE = "ally";
                            if (scope == "all_enemies") effOwnerE = "enemy";
                            
                            if (effOwnerE != "") {
                                var isHeroLocalE = variable_instance_exists(ce, "isHeroOwner") ? ce.isHeroOwner : undefined;
                                if (effOwnerE == "ally" && isHeroLocalE != srcHeroB) okOwnE = false;
                                if (effOwnerE == "enemy" && isHeroLocalE == srcHeroB) okOwnE = false;
                            }
                            if (!okOwnE) { 
                                show_debug_message("### sEffects: Skip " + string(ce) + " due to owner filter (Enemy Loop)");
                                continue; 
                            }

                            if (applyTo(ce, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card)) applied = true;
                        }
                    }
                }
                return applied;
            } else if (scope == "graveyard") {
                var totalBoost = 0;
                if (variable_struct_exists(effect, "archetype")) {
                    var arch = effect.archetype;
                    var per = variable_struct_exists(effect, "boost_per_card") ? effect.boost_per_card : 500;
                    var cnt = 0;
                    if (instance_exists(graveyardHero)) {
                        var gyh = graveyardHero.cards;
                        for (var i = 0; i < array_length(gyh); i++) { var cd = gyh[i]; if (is_struct(cd) && object_is_ancestor(cd.object_index, oCardMonster) && variable_struct_exists(cd, "archetype") && string_lower(cd.archetype) == string_lower(arch)) cnt++; }
                    }
                    if (instance_exists(graveyardEnemy)) {
                        var gye = graveyardEnemy.cards;
                        for (var j = 0; j < array_length(gye); j++) { var cd2 = gye[j]; if (is_struct(cd2) && object_is_ancestor(cd2.object_index, oCardMonster) && variable_struct_exists(cd2, "archetype") && string_lower(cd2.archetype) == string_lower(arch)) cnt++; }
                    }
                    totalBoost = cnt * per;
                    atkVal = totalBoost;
                } else if (variable_struct_exists(effect, "genre")) {
                    var gen = effect.genre;
                    var per2 = variable_struct_exists(effect, "boost_per_card") ? effect.boost_per_card : 100;
                    var gyInst = srcHeroB ? graveyardHero : graveyardEnemy;
                    var cnt2 = 0;
                    if (instance_exists(gyInst)) {
                        var gyc = gyInst.cards;
                        for (var k = 0; k < array_length(gyc); k++) { var cd3 = gyc[k]; if (is_struct(cd3) && object_is_ancestor(cd3.object_index, oCardMonster) && variable_struct_exists(cd3, "genre") && string_lower(cd3.genre) == string_lower(gen)) cnt2++; }
                    }
                    totalBoost = cnt2 * per2;
                    atkVal = totalBoost;
                }
                var tgtG = card;
                if (object_is_ancestor(card.object_index, oCardMagic) && variable_instance_exists(card, "equipped_target")) { tgtG = card.equipped_target; }
                if (agg) {
                    var srcKeyG = "effect:" + string(effect.effect_type) + ":" + string(card.id) + ":" + string(variable_struct_exists(effect, "id") ? effect.id : -1);
                    if (object_is_ancestor(card.object_index, oCardMagic)) { srcKeyG = "equip:" + string(card.id); }
                    buffSetContribution(tgtG, srcKeyG, atkVal, defVal);
                    buffRecompute(tgtG);
                    return true;
                } else {
                    if (atkVal != 0) modifyAttack(tgtG, atkVal, false);
                    if (defVal != 0) modifyDefense(tgtG, defVal, false);
                    return true;
                }
            }
            return false;
        }
            
        case EFFECT_DISCARD:
            // Effet unifié de défausse (main uniquement) avec critères et options
            if (is_undefined(sEffectDiscard)) {
                show_debug_message("### EFFECT_DISCARD: sEffectDiscard non trouvé");
                return false;
            }
            return sEffectDiscard(card, effect, context);

        // Effets de ciblage
        
            
        case EFFECT_DESTROY_TARGET:
            if (target == noone && variable_struct_exists(effect, "select_mode") && effect.select_mode == "random") {
                if (script_exists(getTargetsByFilter)) {
                    var candidates = getTargetsByFilter(effect);
                    if (is_array(candidates) && array_length(candidates) > 0) {
                        var rndIdx = irandom(array_length(candidates) - 1);
                        target = candidates[rndIdx];
                    }
                }
            }
            if (target == noone && variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) { target = context.attacker; }
            if (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_ON_ATTACK) {
                if (target == noone || !instance_exists(target) || !(variable_instance_exists(target, "zone") && (target.zone == "Field" || target.zone == "FieldSelected"))) { return false; }
            }
            if (target != noone) {
                var ta = 0;
                var td = 0;
                var target_owner_dt = undefined;
                if (instance_exists(target)) {
                    if (variable_instance_exists(target, "effective_attack")) ta = target.effective_attack; else if (variable_instance_exists(target, "attack")) ta = target.attack;
                    if (variable_instance_exists(target, "effective_defense")) td = target.effective_defense; else if (variable_instance_exists(target, "PV")) td = target.PV;
                    if (variable_instance_exists(target, "isHeroOwner")) target_owner_dt = target.isHeroOwner;
                }
                if (card != noone && instance_exists(card) && variable_instance_exists(card, "isPoisoner") && card.isPoisoner) { spawnPoisonFX(target, card); }
                var okdt = destroyCard(target);
                if (okdt) {
                    var owner_flag_dt = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                    var ctx_dt = { owner_is_hero: owner_flag_dt, from_destroy_target: true, atk_value: ta, def_value: td, target_owner_is_hero: target_owner_dt };
                    if (variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) { ctx_dt.attacker = context.attacker; }
                    if (variable_struct_exists(context, "defender") && instance_exists(context.defender)) { ctx_dt.defender = context.defender; }
                    if (variable_struct_exists(effect, "grant_destroyed_stats") && effect.grant_destroyed_stats && instance_exists(card)) {
                        if (ta != 0) modifyAttack(card, ta, false);
                        if (td != 0) modifyDefense(card, td, false);
                    }
                    if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                        var Ldt = array_length(effect.flow);
                        for (var idt = 0; idt < Ldt; idt++) {
                            var stepDt = effect.flow[idt];
                            if (is_struct(stepDt) && variable_struct_exists(stepDt, "effect_type")) { executeEffect(card, stepDt, ctx_dt); }
                        }
                    } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                        executeEffect(card, effect.flow, ctx_dt);
                    } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                        executeEffect(card, effect.flow_next, ctx_dt);
                    }
                }
                return okdt;
            }
            break;
            
        case EFFECT_DESTROY_SELF:
            return destroyCard(card);

        case EFFECT_SACRIFICE_TARGET:
        {
            if (target == noone || !instance_exists(target)) return false;
            var taSac = 0;
            var tdSac = 0;
            if (instance_exists(target)) {
                if (variable_instance_exists(target, "effective_attack")) taSac = target.effective_attack; else if (variable_instance_exists(target, "attack")) taSac = target.attack;
                if (variable_instance_exists(target, "effective_defense")) tdSac = target.effective_defense; else if (variable_instance_exists(target, "PV")) tdSac = target.PV;
            }
            var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                          : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            if (!(variable_instance_exists(target, "isHeroOwner") && target.isHeroOwner == srcHero)) {
                return false;
            }
            if (!(variable_instance_exists(target, "zone") && (target.zone == "Field" || target.zone == "FieldSelected"))) {
                return false;
            }
            if (variable_instance_exists(target, "isTerrain") && target.isTerrain) {
                return false;
            }
            var okSac = destroyCard(target, card);
            if (okSac) {
                var ctxSac = { owner_is_hero: srcHero, from_sacrifice_target: true, atk_value: taSac, def_value: tdSac };
                if (variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) { ctxSac.attacker = context.attacker; }
                if (variable_struct_exists(context, "defender") && instance_exists(context.defender)) { ctxSac.defender = context.defender; }
                
                if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                    var LSac = array_length(effect.flow);
                    for (var iSac = 0; iSac < LSac; iSac++) {
                        var stepSac = effect.flow[iSac];
                        if (is_struct(stepSac) && variable_struct_exists(stepSac, "effect_type")) { executeEffect(card, stepSac, ctxSac); }
                    }
                } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                    executeEffect(card, effect.flow, ctxSac);
                } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                    executeEffect(card, effect.flow_next, ctxSac);
                }
            }
            return okSac;
        }
            
        case EFFECT_BANISH_TARGET:
            if (target != noone) return banishCard(target);
            break;
            
        case EFFECT_RETURN_TO_HAND:
            if (target != noone) {
                var res = returnToHand(target);
                if (res && variable_struct_exists(effect, "cost_increase")) {
                    if (variable_instance_exists(target, "mana_cost")) {
                        target.mana_cost += effect.cost_increase;
                    } else if (variable_instance_exists(target, "star")) {
                        target.star += effect.cost_increase;
                    }
                }
                return res;
            }
            break;

        case EFFECT_PURGE:
        {
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
            var okAny = false;
            if (!script_exists(asset_get_index("purgeUnit"))) return false;
            
            if (scope == "all") {
                if (!script_exists(getTargetsByFilter)) return false;
                var candidates = getTargetsByFilter(effect);
                if (!is_array(candidates) || array_length(candidates) <= 0) return false;
                
                var posFilter = variable_struct_exists(effect, "field_position_in") ? effect.field_position_in : noone;
                
                for (var i = 0; i < array_length(candidates); i++) {
                    var tgt = candidates[i];
                    if (tgt == noone || !instance_exists(tgt)) continue;
                    if (posFilter != noone) {
                        if (!variable_instance_exists(tgt, "fieldPosition")) continue;
                        var fp = tgt.fieldPosition;
                        var okPos = false;
                        if (is_array(posFilter)) {
                            for (var p = 0; p < array_length(posFilter); p++) { if (fp == posFilter[p]) { okPos = true; break; } }
                        } else {
                            okPos = (fp == posFilter);
                        }
                        if (!okPos) continue;
                    }
                    if (purgeUnit(tgt)) okAny = true;
                }
                return okAny;
            }
            
            if (target == noone && variable_struct_exists(effect, "select_mode") && effect.select_mode == "random") {
                if (script_exists(getTargetsByFilter)) {
                    var candidates2 = getTargetsByFilter(effect);
                    if (is_array(candidates2) && array_length(candidates2) > 0) {
                        var rndIdx = irandom(array_length(candidates2) - 1);
                        target = candidates2[rndIdx];
                    }
                }
            }
            
            if (target != noone && instance_exists(target)) {
                okAny = purgeUnit(target);
            }
            if (okAny) {
                var flowCtxP = { owner_is_hero: (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true) };
                if (target != noone && instance_exists(target)) flowCtxP.target = target;
                if (variable_struct_exists(context, "attacker")) flowCtxP.attacker = context.attacker;
                if (variable_struct_exists(context, "defender")) flowCtxP.defender = context.defender;
                if (variable_struct_exists(context, "source")) flowCtxP.source = context.source;

                if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                    for (var ip = 0; ip < array_length(effect.flow); ip++) {
                        executeEffect(card, effect.flow[ip], flowCtxP);
                    }
                } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                    executeEffect(card, effect.flow, flowCtxP);
                } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                    executeEffect(card, effect.flow_next, flowCtxP);
                }
            }
            return okAny;
        }
        case EFFECT_REVEAL_HAND:
        {
            if (card == noone || !instance_exists(card)) return false;
            var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            var hinst = ownerIsHero ? handEnemy : handHero;
            if (instance_exists(hinst)) {
                hinst.reveal_override = true;
                if (variable_instance_exists(hinst, "updateDisplay")) { hinst.updateDisplay(); }
                return true;
            }
            return false;
        }

        case EFFECT_DECK_REORDER_TOP3:
        {
            if (card == noone || !instance_exists(card)) return false;
            var ownerIsHero_src = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
            var ownerStr = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
            var ownerIsHero_target = (ownerStr == "ally") ? ownerIsHero_src : !ownerIsHero_src;
            var deckInst = ownerIsHero_target ? deckHero : deckEnemy;
            if (!instance_exists(deckInst)) return false;
            var sz = ds_list_size(deckInst.cards);
            if (sz <= 0) return false;
            var count = min(3, sz);
            var topCards = [];
            for (var i = sz - count; i < sz; i++) {
                var c = ds_list_find_value(deckInst.cards, i);
                array_push(topCards, c);
            }
            var ol = instance_create_layer(room_width/2, room_height/2, "Instances", oOverlayDuel);
            if (ol != noone) {
                ol.ownerIsHero = ownerIsHero_target;
                ol.deckInst = deckInst;
                ol.cards = topCards;
                ol.selections = [];
                for (var j = 0; j < array_length(topCards); j++) { array_push(ol.selections, 0); }
                ol.effectCard = card;
                ol.effectStruct = effect;
                ol.scaleView = 0.5;
                ol.pick_one = (variable_struct_exists(effect, "pick_one") && effect.pick_one);
                if (variable_global_exists("isActionMenuOpen")) { global.isActionMenuOpen = true; }
                return true;
            }
            return false;
        }
            
        // Effets personnalisés composites
        case EFFECT_END_DISCARD_DESTROY_ENEMY_SPELL:
        {
            var ownerIsHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                               : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            // Vérifier présence d’au moins une Magie adverse sur le terrain
            if (!hasEnemySpellOnField(ownerIsHero)) {
                show_debug_message("### Aucun sort adverse à détruire; effet ignoré");
                return false;
            }
            // Coût: défausser 1 carte de la main du bon propriétaire
            if (!discardFromHandToGraveyard(ownerIsHero, 1)) {
                show_debug_message("### Coût non payé (main vide); effet annulé");
                return false;
            }
            // Résolution: détruire 1 carte Magie sur le terrain adverse
            return destroyRandomEnemySpell(ownerIsHero);
        }
        
        // Composite générique: valider une cible alliée via critères, puis détruire N cartes adverses
        // (Effet composite Floraison supprimé — utiliser EFFECT_DESTROY via flow)
            
        // Effets de zone
        case EFFECT_DAMAGE_ALL:
        {
            var val_dmg = variable_struct_exists(effect, "value") ? effect.value : 0;
            if (!variable_struct_exists(effect, "source_card")) effect.source_card = card;
            return damageAllMonsters(val_dmg, effect);
        }
        case EFFECT_DAMAGE_ALL_REPEAT_PER_DEATHS_THIS_TURN:
        {
            var base_dmg = variable_struct_exists(effect, "value") ? effect.value : 0;
            var deaths = (variable_global_exists("minions_died_this_turn")) ? global.minions_died_this_turn : 0;
            deaths = max(0, deaths);
            var total_dmg = base_dmg * (1 + deaths);
            if (!variable_struct_exists(effect, "source_card")) effect.source_card = card;
            return damageAllMonsters(total_dmg, effect);
        }
        case EFFECT_HEAL_ALL:
        {
            var val_heal = variable_struct_exists(effect, "value") ? effect.value : 0;
            return healAllMonsters(val_heal, effect);
        }
        case EFFECT_DESTROY_ALL:
            return destroyAllMonsters(effect);
            
        // Effets spéciaux
        case EFFECT_PILLAGE:
        {
            if (is_undefined(sPillage)) { return false; }
            return sPillage(card, effect, context);
        }
        case EFFECT_SEARCH:
        {
            var ok_search = applySearchBySpec(card, effect, context);
            if (ok_search) {
                var owner_flag_s = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner"))
                                   ? card.isHeroOwner
                                   : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                var ctxs = { from_search: true, owner_is_hero: owner_flag_s };
                if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                    var Ls = array_length(effect.flow);
                    var idxs = 0;
                    while (idxs < Ls) {
                        var stepS = effect.flow[idxs];
                        if (is_struct(stepS) && variable_struct_exists(stepS, "effect_type")) {
                            if (stepS.effect_type == EFFECT_TEMPO) {
                                var framesS = 0;
                                if (variable_struct_exists(stepS, "frames")) {
                                    framesS = max(0, stepS.frames);
                                } else if (variable_struct_exists(stepS, "ms")) {
                                    framesS = max(0, round((stepS.ms / 1000.0) * game_get_speed(gamespeed_fps)));
                                }
                                if (framesS > 0 && instance_exists(card)) {
                                    var was_pending_s = (variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending);
                                    if (was_pending_s) { break; }
                                    var remaining_count_s = Ls - (idxs + 1);
                                    var remaining_s = array_create(remaining_count_s);
                                    var rs = 0;
                                    for (var js = idxs + 1; js < Ls; js++) { remaining_s[rs++] = effect.flow[js]; }
                                    card._flow_remaining_steps = remaining_s;
                                    card._flow_owner_is_hero = owner_flag_s;
                                    card._flow_tempo_pending = true;
                                    call_later(framesS, time_source_units_frames, method(card, function() {
                                        if (!instance_exists(self)) { return; }
                                        if (!variable_instance_exists(self, "_flow_tempo_pending") || !self._flow_tempo_pending) { return; }
                                        self._flow_tempo_pending = false;
                                        var rem_local_s = variable_instance_exists(self, "_flow_remaining_steps") ? self._flow_remaining_steps : undefined;
                                        var owner_local_s = variable_instance_exists(self, "_flow_owner_is_hero") ? self._flow_owner_is_hero : undefined;
                                        if (is_array(rem_local_s)) {
                                            for (var r2s = 0; r2s < array_length(rem_local_s); r2s++) {
                                                var step2s = rem_local_s[r2s];
                                                if (is_struct(step2s) && variable_struct_exists(step2s, "effect_type")) {
                                                    executeEffect(self, step2s, { owner_is_hero: owner_local_s });
                                                }
                                            }
                                        }
                                        if (variable_instance_exists(self, "_flow_remaining_steps")) self._flow_remaining_steps = undefined;
                                        if (variable_instance_exists(self, "_flow_owner_is_hero")) self._flow_owner_is_hero = undefined;
                                    }));
                                    break;
                                }
                            } else {
                                executeEffect(card, stepS, { owner_is_hero: owner_flag_s });
                            }
                        }
                        idxs++;
                    }
                } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                    executeEffect(card, effect.flow, ctxs);
                } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                    executeEffect(card, effect.flow_next, ctxs);
                }
            }
            return ok_search;
        }
        case EFFECT_ADD_TO_HAND:
        {
            var ownerIsHero_h = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner
                                 : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
            var handInst_h = ownerIsHero_h ? handHero : handEnemy;
            if (!instance_exists(handInst_h)) return false;
            var objIndex_h = noone;
            if (variable_struct_exists(effect, "object_name")) {
                var idx_on = asset_get_index(effect.object_name);
                if (idx_on != -1) objIndex_h = idx_on;
            }
            if (objIndex_h == noone && variable_struct_exists(effect, "target_name")) {
                var tn = effect.target_name;
                var arr = dbGetCardsByName(tn);
                if (is_array(arr) && array_length(arr) > 0) {
                    var cdata = arr[0];
                    if (variable_struct_exists(cdata, "objectId")) {
                        var idxDb = asset_get_index(cdata.objectId);
                        if (idxDb != -1) objIndex_h = idxDb;
                    }
                }
                if (objIndex_h == noone) {
                    var idx_nm = asset_get_index(tn);
                    if (idx_nm != -1) objIndex_h = idx_nm;
                }
            }
            if (objIndex_h == noone) return false;
            var inst = instance_create_layer(handInst_h.x, handInst_h.y, layer_get_id("Instances"), objIndex_h);
            if (inst == noone) return false;
            inst.isHeroOwner = ownerIsHero_h;
            inst.image_angle = ownerIsHero_h ? 0 : 180;
            if (variable_instance_exists(inst, "zone")) inst.zone = "Hand"; else inst.zone = "Hand";
            handInst_h.addCard(inst);
            var ctx_h = { owner_is_hero: ownerIsHero_h };
            registerTriggerEvent(TRIGGER_ENTER_HAND, inst, ctx_h);
            return true;
        }
        case EFFECT_DESTROY:
        {
            var ok_destroy = applyDestroyBySpec(card, effect, context);
            if (ok_destroy) {
                var owner_flag = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner"))
                                 ? card.isHeroOwner
                                 : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                var ctxd = { from_destroy: true, owner_is_hero: owner_flag };
                if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                    var Ld = array_length(effect.flow);
                    var kd = 0;
                    while (kd < Ld) {
                        var stepD = effect.flow[kd];
                        if (is_struct(stepD) && variable_struct_exists(stepD, "effect_type")) {
                            if (stepD.effect_type == EFFECT_TEMPO) {
                                var framesD = 0;
                                if (variable_struct_exists(stepD, "frames")) {
                                    framesD = max(0, stepD.frames);
                                } else if (variable_struct_exists(stepD, "ms")) {
                                    framesD = max(0, round((stepD.ms / 1000.0) * game_get_speed(gamespeed_fps)));
                                }
                                if (framesD > 0 && instance_exists(card)) {
                                    var was_pending_d = (variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending);
                                    if (was_pending_d) { break; }
                                    var remaining_count_d = Ld - (kd + 1);
                                    var remaining_d = array_create(remaining_count_d);
                                    var rd = 0;
                                    for (var jd = kd + 1; jd < Ld; jd++) { remaining_d[rd++] = effect.flow[jd]; }
                                    card._flow_remaining_steps = remaining_d;
                                    card._flow_owner_is_hero = owner_flag;
                                    card._flow_tempo_pending = true;
                                    call_later(framesD, time_source_units_frames, method(card, function() {
                                        if (!instance_exists(self)) { return; }
                                        if (!variable_instance_exists(self, "_flow_tempo_pending") || !self._flow_tempo_pending) { return; }
                                        self._flow_tempo_pending = false;
                                        var rem_local_d = variable_instance_exists(self, "_flow_remaining_steps") ? self._flow_remaining_steps : undefined;
                                        var owner_local_d = variable_instance_exists(self, "_flow_owner_is_hero") ? self._flow_owner_is_hero : undefined;
                                        if (is_array(rem_local_d)) {
                                            for (var r2d = 0; r2d < array_length(rem_local_d); r2d++) {
                                                var step2d = rem_local_d[r2d];
                                                if (is_struct(step2d) && variable_struct_exists(step2d, "effect_type")) {
                                                    executeEffect(self, step2d, { owner_is_hero: owner_local_d, from_destroy: true });
                                                }
                                            }
                                        }
                                        if (variable_instance_exists(self, "_flow_remaining_steps")) self._flow_remaining_steps = undefined;
                                        if (variable_instance_exists(self, "_flow_owner_is_hero")) self._flow_owner_is_hero = undefined;
                                        if (variable_instance_exists(self, "_consume_after_flow") && self._consume_after_flow) {
                                            self._consume_after_flow = false;
                                            if (!is_undefined(consumeSpellIfNeeded)) { consumeSpellIfNeeded(self, undefined); }
                                        }
                                    }));
                                    break;
                                }
                            } else {
                                executeEffect(card, stepD, ctxd);
                            }
                        }
                        kd++;
                    }
                } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                    executeEffect(card, effect.flow, ctxd);
                } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                    executeEffect(card, effect.flow_next, ctxd);
                }
            }
            return ok_destroy;
        }
        case EFFECT_SUMMON:
        {
            var reps = 1;
            if (variable_struct_exists(effect, "count")) reps = max(1, effect.count);
            else if (variable_struct_exists(effect, "value")) reps = max(1, effect.value);
            var anyOk = false;
            for (var ri = 0; ri < reps; ri++) {
                var okr = applySummonBySpec(card, effect, context);
                anyOk = anyOk || okr;
            }
            return anyOk;
        }

            
        case EFFECT_ATTACK_DIRECT:
        {
            if (card == noone || !instance_exists(card)) return false;
            var isHero = (variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            var force = (variable_instance_exists(card, "effect_force_direct_attack") && card.effect_force_direct_attack);
            if (!variable_instance_exists(card, "effect_force_direct_attack")) card.effect_force_direct_attack = false;
            card.effect_force_direct_attack = true;
            if (variable_global_exists("USE_COMBAT_FX") && global.USE_COMBAT_FX) {
                selectManager.destroyTargetingArrow();
                var fx = instance_create_layer(card.x, card.y, "Instances", FX_Combat);
                if (fx != noone) { fx.attacker = card; fx.defender = noone; fx.mode = "direct"; return true; }
                return false;
            } else {
                if (isHero) {
                    var dm = instance_find(oDamageManager, 0);
                    if (dm != noone) { with (dm) resolveAttackDirect(card); return true; }
                } else {
                    var dmE = instance_find(oDamageManager, 0);
                    if (dmE != noone && variable_instance_exists(dmE.id, "resolveAttackDirectEnemy")) { with (dmE) resolveAttackDirectEnemy(card); return true; }
                }
                return false;
            }
        }
        case EFFECT_NEGATE_EFFECT:
            return negateEffect(target);





        // Effet combiné: défausser cette carte de la main pour chercher par archétype
        // SUPPRIMÉ - Remplacé par le système de flux avec EFFECT_DISCARD + EFFECT_SEARCH
        

         
         // Effet continu: boost d'ATK basé sur l'archétype dans les cimetières
        
        
        // Effet continu: boost d'ATK basé sur le genre dans le cimetière du propriétaire
        
            
        // Effets d’équipement
        case EFFECT_EQUIP_SELECT_TARGET:
        {
            return equipSelectTarget(card, effect, context);
        }
        
        
        
        case EFFECT_EQUIP_CLEANUP:
        {
            return equipCleanup(card, effect, context);
        }
        
        // Aura: buff ATK/PV par archétype sur le terrain
        
        
        case EFFECT_AURA_ALL_MONSTERS_DEBUFF:
        {
            return applyAllMonstersAuraDebuff(card, effect);
        }
        
        case EFFECT_AURA_DAMAGE_REDUCTION:
        {
            return applyAllMonstersDamageReductionAura(card, effect);
        }
        
        case EFFECT_AURA_DAMAGE_TAKEN_BONUS:
        {
            return applyAllMonstersDamageTakenBonusAura(card, effect);
        }
        
        case EFFECT_AURA_CLEANUP_SOURCE:
        {
            return cleanupAuraSource(card, effect);
        }
        
        
        case EFFECT_POINTS:
        case EFFECT_DAMAGE_TARGET:
        {
            var res = sEffectPoints(card, effect, context);
            if (res && variable_struct_exists(effect, "flow")) {
                var flowCtx = { owner_is_hero: (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true) };
                if (variable_struct_exists(context, "target")) flowCtx.target = context.target;
                if (variable_struct_exists(context, "attacker")) flowCtx.attacker = context.attacker;
                if (variable_struct_exists(context, "source")) flowCtx.source = context.source;
                
                if (is_array(effect.flow)) {
                    for (var i = 0; i < array_length(effect.flow); i++) {
                        executeEffect(card, effect.flow[i], flowCtx);
                    }
                } else if (is_struct(effect.flow)) {
                     executeEffect(card, effect.flow, flowCtx);
                }
            }
            return res;
        }
        case EFFECT_PROTECTION:
        {
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
            var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            var crit = variable_struct_exists(effect, "criteria") ? effect.criteria : {};
            var srcKey = "aura:" + string(card.id);
            var redirectDamageToSource = (variable_struct_exists(effect, "redirect_damage_to_source") && effect.redirect_damage_to_source);
            var applyProtect = function(tgt, _key) {
                if (tgt == noone || !instance_exists(tgt)) return false;
                if (!variable_instance_exists(tgt, "protection_sources")) tgt.protection_sources = [];
                var hasKey = false;
                for (var i = 0; i < array_length(tgt.protection_sources); i++) { if (string(tgt.protection_sources[i]) == _key) { hasKey = true; break; } }
                if (!hasKey) { array_push(tgt.protection_sources, _key); }
                if (redirectDamageToSource) {
                    if (!variable_instance_exists(tgt, "damage_redirect_sources") || !is_array(tgt.damage_redirect_sources)) tgt.damage_redirect_sources = [];
                    var hasRedirect = false;
                    for (var ri = 0; ri < array_length(tgt.damage_redirect_sources); ri++) {
                        var r0 = tgt.damage_redirect_sources[ri];
                        if (is_struct(r0) && variable_struct_exists(r0, "key") && string(r0.key) == _key) {
                            r0.source_id = card.id;
                            tgt.damage_redirect_sources[ri] = r0;
                            hasRedirect = true;
                            break;
                        }
                    }
                    if (!hasRedirect) {
                        array_push(tgt.damage_redirect_sources, { key: _key, source_id: card.id });
                    }
                }
                tgt.protection_from_destroy = true;
                return true;
            };
            if (scope == "single") {
                var tgt = (variable_struct_exists(context, "target") && instance_exists(context.target)) ? context.target : card;
                return applyProtect(tgt, srcKey);
            } else if (scope == "aura" || scope == "all") {
                var applied = false;
                var heroArr = fieldMonsterHero.cards;
                for (var hi = 0; hi < array_length(heroArr); hi++) {
                    var ch = heroArr[hi];
                    if (ch != 0 && instance_exists(ch)) {
                        var z1 = variable_instance_exists(ch, "zone") ? string_lower(ch.zone) : "";
                        if (z1 == "field" || z1 == "fieldselected") {
                            var okOwnH = true;
                            if (scope == "all") {
                                if (variable_struct_exists(effect, "owner")) {
                                    var isHeroLocalH = variable_instance_exists(ch, "isHeroOwner") ? ch.isHeroOwner : undefined;
                                    if (ownerSide == "ally" && isHeroLocalH != srcHero) okOwnH = false;
                                    if (ownerSide == "enemy" && isHeroLocalH == srcHero) okOwnH = false;
                                }
                            }
                            if (!okOwnH) { continue; }
                            var okCritH = true;
                            if (script_exists(_cardMatchesCriteria) && is_struct(crit)) { okCritH = _cardMatchesCriteria(ch, crit); }
                            if (okCritH) { if (applyProtect(ch, srcKey)) applied = true; }
                        }
                    }
                }
                var enemyArr = fieldMonsterEnemy.cards;
                for (var ei = 0; ei < array_length(enemyArr); ei++) {
                    var ce = enemyArr[ei];
                    if (ce != 0 && instance_exists(ce)) {
                        var z2 = variable_instance_exists(ce, "zone") ? string_lower(ce.zone) : "";
                        if (z2 == "field" || z2 == "fieldselected") {
                            var okOwnE = true;
                            if (scope == "all") {
                                if (variable_struct_exists(effect, "owner")) {
                                    var isHeroLocalE = variable_instance_exists(ce, "isHeroOwner") ? ce.isHeroOwner : undefined;
                                    if (ownerSide == "ally" && isHeroLocalE != srcHero) okOwnE = false;
                                    if (ownerSide == "enemy" && isHeroLocalE == srcHero) okOwnE = false;
                                }
                            }
                            if (!okOwnE) { continue; }
                            var okCritE = true;
                            if (script_exists(_cardMatchesCriteria) && is_struct(crit)) { okCritE = _cardMatchesCriteria(ce, crit); }
                            if (okCritE) { if (applyProtect(ce, srcKey)) applied = true; }
                        }
                    }
                }
                return applied;
            }
            return false;
        }
        case EFFECT_IMMUNITY:
        {
            if (!instance_exists(game)) return false;
            var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            if (variable_struct_exists(context, "owner_is_hero")) srcHero = context.owner_is_hero;
            var localIndex = variable_instance_exists(game, "local_player_index") ? game.local_player_index : 0;
            var srcOwnerIndex = srcHero ? localIndex : (1 - localIndex);
            
            var expireDelta = -1;
            if (variable_struct_exists(effect, "expire_turn_delta")) {
                expireDelta = max(0, effect.expire_turn_delta);
            } else if (variable_struct_exists(effect, "duration_mode")) {
                var mode = string_lower(string(effect.duration_mode));
                if (mode == "until_next_owner_turn") {
                    expireDelta = (game.player_current == srcOwnerIndex) ? 2 : 1;
                } else if (mode == "until_end_of_next_owner_turn") {
                    expireDelta = (game.player_current == srcOwnerIndex) ? 3 : 2;
                } else if (mode == "until_end_of_turn" || mode == "until_end_of_current_turn") {
                    expireDelta = 1;
                }
            }
            if (expireDelta < 0) {
                expireDelta = (game.player_current == srcOwnerIndex) ? 2 : 1;
            }
            
            var untilTurn = game.nbTurn + expireDelta;
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "ally";
            
            if (ownerSide == "both") {
                _setLpDamageImmunity(true, untilTurn);
                _setLpDamageImmunity(false, untilTurn);
                return true;
            }
            
            var tgtHero = srcHero;
            if (ownerSide == "enemy") tgtHero = !srcHero;
            return _setLpDamageImmunity(tgtHero, untilTurn);
        }
        case EFFECT_CAMOUFLAGE:
        {
            return sCamouflage(card, effect, context);
        }
        
        case EFFECT_ENTRAVE:
        {
            var res = sEntrave(card, effect, context);
            if (res) {
                if (variable_struct_exists(effect, "flow") && is_array(effect.flow)) {
                    var L = array_length(effect.flow);
                    for (var i = 0; i < L; i++) {
                        var step = effect.flow[i];
                        if (is_struct(step) && variable_struct_exists(step, "effect_type")) {
                            executeEffect(card, step, context);
                        }
                    }
                } else if (variable_struct_exists(effect, "flow") && is_struct(effect.flow)) {
                    executeEffect(card, effect.flow, context);
                } else if (variable_struct_exists(effect, "flow_next") && is_struct(effect.flow_next)) {
                    executeEffect(card, effect.flow_next, context);
                }
            }
            return res;
        }
        case EFFECT_ILLUSION:
        {
            return sEffectIllusion(card, effect, context);
        }
        default:
            show_debug_message("Effet non implémenté : " + effectType);
            return false;
    }
    
    return false;
}

// === FONCTIONS D'EFFETS DE BASE ===

// [refactor] Les helpers de pioche/mélange ont été déplacés vers `sEffectDraw.gml`.

/// @function discardCards(amount)
/// @description Fait défausser des cartes au joueur
/// @param {real} amount - Nombre de cartes à défausser
/// @returns {bool} - Succès de l'opération
function discardCards(amount) {
    if (!instance_exists(oHand) || !instance_exists(oGraveyard)) return false;
    
    var handSize = array_length(oHand.cards);
    var actualAmount = min(amount, handSize);
    
    for (var i = 0; i < actualAmount; i++) {
        if (array_length(oHand.cards) > 0) {
            var discardedCard = array_pop(oHand.cards);
            // Trouver le bon cimetière (héros)
            var gyInst = noone; with (oGraveyard) { if (isHeroOwner) { gyInst = id; break; } }
            if (gyInst != noone) {
                gyInst.addToGraveyard(discardedCard);
            } else {
                show_debug_message("### discardCards: cimetière héros introuvable, push direct évité");
            }
            
            // Déclencher l'événement d'entrée au cimetière (conservé pour compat)
            registerTriggerEvent(TRIGGER_ENTER_GRAVEYARD, discardedCard, {});
        }
    }
    
    return true;
}

/// @function gainLP(amount)
/// @description Fait gagner des LP au joueur
/// @param {real} amount - Montant de LP à gagner
/// @returns {bool} - Succès de l'opération
function gainLP(amount) {
    var lpInst = instance_find(oLP_Hero, 0);
    if (lpInst != noone) {
        var oldLP = lpInst.nbLP;
        lpInst.nbLP += amount;
        
        // Déclencher l'événement de changement de LP
        registerTriggerEvent(TRIGGER_ON_LP_CHANGE, noone, {
            old_lp: oldLP,
            new_lp: lpInst.nbLP,
            change: amount,
            owner_is_hero: true
        });
        
        return true;
    }
    return false;
}


/// @function clearTargetingMarkers()
/// @description Nettoie tous les marqueurs de ciblage des cartes
function clearTargetingMarkers() {
    with (oCardParent) {
        if (variable_instance_exists(self, "isTargetableForFloraison")) {
            self.isTargetableForFloraison = false;
        }
    }
}

function _getLpDamageImmunityUntil(ownerIsHero) {
    if (ownerIsHero) {
        return variable_global_exists("lp_damage_immune_hero_until") ? global.lp_damage_immune_hero_until : 0;
    }
    return variable_global_exists("lp_damage_immune_enemy_until") ? global.lp_damage_immune_enemy_until : 0;
}

function _isLpDamageImmune(ownerIsHero) {
    if (!instance_exists(game) || !variable_instance_exists(game, "nbTurn")) return false;
    var untilTurn = _getLpDamageImmunityUntil(ownerIsHero);
    return (untilTurn > game.nbTurn);
}

function _setLpDamageImmunity(ownerIsHero, untilTurn) {
    untilTurn = max(0, untilTurn);
    if (ownerIsHero) {
        if (!variable_global_exists("lp_damage_immune_hero_until")) global.lp_damage_immune_hero_until = 0;
        global.lp_damage_immune_hero_until = max(global.lp_damage_immune_hero_until, untilTurn);
    } else {
        if (!variable_global_exists("lp_damage_immune_enemy_until")) global.lp_damage_immune_enemy_until = 0;
        global.lp_damage_immune_enemy_until = max(global.lp_damage_immune_enemy_until, untilTurn);
    }
    return true;
}

/// @function loseLP(amount)
/// @description Fait perdre des LP au joueur
/// @param {real} amount - Montant de LP à perdre
/// @returns {bool} - Succès de l'opération
function loseLP(amount) {
    if (_isLpDamageImmune(true)) return false;
    var lpInst = instance_find(oLP_Hero, 0);
    if (lpInst != noone) {
        var oldLP = lpInst.nbLP;
        lpInst.nbLP = max(0, oldLP - amount);
        
        // Déclencher l'événement de changement de LP
        registerTriggerEvent(TRIGGER_ON_LP_CHANGE, noone, {
            old_lp: oldLP,
            new_lp: lpInst.nbLP,
            change: -amount,
            owner_is_hero: true
        });
        
        // Vérifier la défaite
        if (lpInst.nbLP <= 0) {
            // Logique de fin de partie
            show_debug_message("Défaite ! LP = 0");
        }
        
        return true;
    }
    return false;
}

/// @function gainLPFor(ownerIsHero, amount)
/// @description Variante owner-aware pour gagner des LP (héros/ennemi)
/// @param {bool} ownerIsHero
/// @param {real} amount
/// @returns {bool}
function gainLPFor(ownerIsHero, amount) {
    if (ownerIsHero) {
        return gainLP(amount);
    } else {
        var lpInst = instance_find(oLP_Enemy, 0);
        if (lpInst != noone) {
            var oldLP = lpInst.nbLP;
            lpInst.nbLP = oldLP + amount;
            var newLP = lpInst.nbLP;
            registerTriggerEvent(TRIGGER_ON_LP_CHANGE, noone, {
                old_lp: oldLP,
                new_lp: newLP,
                change: amount,
                owner_is_hero: false
            });
            return true;
        }
    }
    return false;
}

/// @function loseLPFor(ownerIsHero, amount)
/// @description Variante owner-aware pour perdre des LP (héros/ennemi)
/// @param {bool} ownerIsHero
/// @param {real} amount
/// @returns {bool}
function loseLPFor(ownerIsHero, amount) {
    show_debug_message("### loseLPFor DEBUG ###");
    show_debug_message("- ownerIsHero: " + string(ownerIsHero));
    show_debug_message("- amount: " + string(amount));
    
    if (_isLpDamageImmune(ownerIsHero)) {
        show_debug_message("- LP damage prevented (immunity)");
        return false;
    }
    
    if (ownerIsHero) {
        show_debug_message("- Targeting HERO LP");
        return loseLP(amount);
    } else {
        show_debug_message("- Targeting ENEMY LP");
        var lpInst = instance_find(oLP_Enemy, 0);
        show_debug_message("- oLP_Enemy instance found: " + string(lpInst != noone));
        
        if (lpInst != noone) {
            var oldLP = lpInst.nbLP;
            show_debug_message("- Enemy old LP: " + string(oldLP));
            lpInst.nbLP = max(0, oldLP - amount);
            var newLP = lpInst.nbLP;
            show_debug_message("- Enemy new LP: " + string(newLP));
            
            registerTriggerEvent(TRIGGER_ON_LP_CHANGE, noone, {
                old_lp: oldLP,
                new_lp: newLP,
                change: -amount,
                owner_is_hero: false
            });
            if (newLP <= 0) {
                show_debug_message("Victoire ! LP ennemi = 0");
            }
            return true;
        } else {
            show_debug_message("- ERROR: oLP_Enemy instance not found!");
        }
    }
    return false;
}


// === FONCTIONS D'EFFETS DE COMBAT ===

/// @function modifyAttack(card, amount, temporary)
/// @description Modifie l'attaque d'une carte
/// @param {struct} card - La carte à modifier
/// @param {real} amount - Montant de modification
/// @param {bool} temporary - Si la modification est temporaire
/// @returns {bool} - Succès de l'opération
// [refactor] Helpers de COMBAT déplacés vers `sEffectCombat.gml` et helpers DIVERS vers `sEffectMisc.gml` (modifyAttack/PV, setAttack/PV, damage/heal, destroyCard, spawnPoisonFX, banishCard, returnToHand). 

// === FONCTIONS D'EFFETS DE ZONE ===

/// @function damageAllMonsters(amount, effect)
/// @description Inflige des dégâts à tous les monstres
/// @param {real} amount - Montant de dégâts
/// @param {struct} effect - L'effet source
/// @returns {bool} - Succès de l'opération
// [refactor] Effets de zone et filtre de cibles déplacés\n// damageAllMonsters/ healAllMonsters/ destroyAllMonsters -> `sEffectCombat.gml`\n// getTargetsByFilter -> `sEffectMisc.gml`
// [refactor] Les helpers d’invocation (jetons, activation de magie) sont déplacés vers `sEffectSummon.gml`.

// [refactor] Helpers miscellanés déplacés vers `sEffectMisc.gml` (negateEffect, resetTemporaryEffects, getEffectDescription).
/// getLeftmostFreeMonsterSlot déplacé vers sSummonUtils.gml

/// specialSummonNamed déplacé vers sSummonUtils.gml

// [refactor] `specialSummonSelf` est déplacé vers `sEffectSummon.gml`

// [refactor] Helpers miscellanés déplacés vers `sEffectMisc.gml` (applyGraveyardArchetypeBoost, hasEnemySpellOnField, destroyOneEnemySpell, destroyRandomEnemySpell).

