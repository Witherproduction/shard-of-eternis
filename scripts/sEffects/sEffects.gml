// === Script des Effets Possibles ===
// Ce script contient tous les effets possibles pour les cartes

// === CONSTANTES DES TYPES D'EFFETS ===

// Effets de base
#macro EFFECT_DRAW_CARDS "draw_cards"                   // Piocher des cartes

#macro EFFECT_DISCARD "discard"                          // Effet unifié de défausse paramétrable
#macro EFFECT_TEMPO "tempo"                              // Étape de délai/tempo pour les flows


// Effets de combat
#macro EFFECT_LOSE_ATTACK "lose_attack"                 // Perdre de l'ATK
#macro EFFECT_LOSE_ATTACK_PERMANENT "lose_attack_permanent" // Perdre de l'ATK de façon permanente
#macro EFFECT_LOSE_DEFENSE "lose_defense"               // Perdre de la DEF
#macro EFFECT_SET_ATTACK "set_attack"                   // Définir l'ATK
#macro EFFECT_SET_DEFENSE "set_defense"                 // Définir la DEF
#macro EFFECT_BUFF "buff"

// Effets de ciblage
#macro EFFECT_DESTROY_TARGET "destroy_target"           // Détruire une cible
#macro EFFECT_DESTROY_SELF "destroy_self"               // Se détruire
#macro EFFECT_DESTROY "destroy"                         // Effet générique de destruction par critères
#macro EFFECT_BANISH_TARGET "banish_target"             // Bannir une cible
#macro EFFECT_RETURN_TO_HAND "return_to_hand"           // Renvoyer en main
#macro EFFECT_REVEAL_HAND "reveal_hand"

// Effets de zone
#macro EFFECT_DESTROY_ALL "destroy_all"                 // Détruire tous les monstres

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

// Effet combiné: défausser cette carte de la main pour chercher par archétype



// Effets d’équipement (nouveaux)
#macro EFFECT_EQUIP_SELECT_TARGET "equip_select_target"   // Sélectionner une cible et équiper
#macro EFFECT_EQUIP_CLEANUP "equip_cleanup"               // Nettoyer à la destruction (réinitialiser la cible)

// Effets d’aura de champ (nouveaux)
#macro EFFECT_AURA_ALL_MONSTERS_DEBUFF "aura_all_monsters_debuff"   // Aura: debuff ATK/DEF pour tous les monstres sur le terrain
#macro EFFECT_AURA_CLEANUP_SOURCE "aura_cleanup_source"   // Nettoyage d’aura: retirer les contributions d’une source
#macro EFFECT_POINTS "points_effect"
#macro EFFECT_ATTACK_DIRECT "attack_direct"
#macro EFFECT_DECK_REORDER_TOP3 "deck_top3_reorder"
#macro EFFECT_PILLAGE "pillage"

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
        etype == EFFECT_EQUIP_SELECT_TARGET ||
        etype == EFFECT_ENTRAVE ||
        etype == EFFECT_RETURN_TO_HAND ||
        etype == EFFECT_BANISH_TARGET ||
        etype == EFFECT_DAMAGE_TARGET ||
        etype == EFFECT_HEAL_TARGET) {
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
    
    return false;
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
                       || effectType == EFFECT_BANISH_TARGET
                       || effectType == EFFECT_RETURN_TO_HAND
                       || effectType == EFFECT_EQUIP_SELECT_TARGET
                       || (effectType == EFFECT_BUFF && scope_for_target == "single")
                       || (effectType == EFFECT_ENTRAVE && scope_for_target == "single")
                       || (effectType == EFFECT_POINTS && string_lower(variable_struct_exists(effect, "scope") ? effect.scope : "lp") == "card" && string_lower(variable_struct_exists(effect, "select_mode") ? effect.select_mode : "filter") == "target")
                      );
    if (!((effectType == EFFECT_BUFF) && (scope_for_target == "single") && !variable_struct_exists(effect, "owner") && !variable_struct_exists(effect, "criteria")) && needsTarget && target == noone) {
        // Activation manuelle uniquement (phase principale ou effet rapide) et uniquement côté Héros (jamais IA)
        var isManualActivation = (!variable_struct_exists(effect, "trigger")
                                  || effect.trigger == TRIGGER_MAIN_PHASE
                                  || effect.trigger == TRIGGER_QUICK_EFFECT
                                  || effect.trigger == TRIGGER_ON_SUMMON);
        var ownerIsHero_ctx = (variable_struct_exists(context, "owner_is_hero")) ? context.owner_is_hero
                              : ((card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true);
        if (isManualActivation && ownerIsHero_ctx && instance_exists(selectManager)) {
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
            } else if (effectType == EFFECT_DESTROY_TARGET || effectType == EFFECT_BANISH_TARGET || effectType == EFFECT_RETURN_TO_HAND) {
                hasValidTarget = false;
                if (script_exists(getTargetsByFilter)) {
                    var arrT = getTargetsByFilter(effect);
                    hasValidTarget = (is_array(arrT) && array_length(arrT) > 0);
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
            
            // (Effet Floraison obsolète supprimé)
            
            // Définir le callback de sélection de cible (utilise self = struct de l'effet)
            effect.onTargetSelected = function(cardTarget) {
                var eff = (instance_exists(selectManager)) ? selectManager.targetingEffectId : noone;
                var src = (is_struct(eff) && variable_struct_exists(eff, "source_card")) ? eff.source_card : noone;
                if (cardTarget != noone && instance_exists(cardTarget) && (cardTarget.zone == "Field" || cardTarget.zone == "FieldSelected")) {
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
                        RequestGameAction(ACTION_ACTIVATE_EFFECT, {
                            source_uid: src.instance_uid,
                            effect_index: effIdx,
                            target_uid: cardTarget.instance_uid
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
                selectManager.createTargetingArrow(card);
            }
            // Le processus est lancé; l'application se fera après la sélection
            // Important: ne pas signaler une réussite immédiate pour éviter la consommation prématurée des sorts Direct
            return false;
        }
    }
    
    switch(effectType) {
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
                                frames = max(0, round((stepEff.ms / 1000.0) * room_speed));
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
                            executeEffect(card, stepEff, { owner_is_hero: ownerIsHero });
                        }
                    }
                    idx++;
                }
            }
            return ok;
        }
        
        
        
        
            

            
        
            
        // Effets de combat
        
            
        case EFFECT_LOSE_ATTACK:
            return modifyAttack(card, -value, true);
            
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
            var agg = (effect.trigger == TRIGGER_CONTINUOUS) || (variable_struct_exists(effect, "aggregate") && effect.aggregate);
            var atkVal = 0;
            var defVal = 0;
            if (variable_struct_exists(context, "atk_value")) atkVal = context.atk_value; else if (variable_struct_exists(effect, "atk")) atkVal = effect.atk; else atkVal = value;
            if (variable_struct_exists(context, "def_value")) defVal = context.def_value; else if (variable_struct_exists(effect, "def")) defVal = effect.def; else defVal = value;

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
            if (variable_struct_exists(eff, "exclude_face_down_targets") && eff.exclude_face_down_targets) {
                if (variable_instance_exists(tgt2, "isFaceDown") && tgt2.isFaceDown) return false;
            }
            var okc = true;
            
            // DEBUG: Trace filtering for specific card
            var debug_trace = false;
            if (variable_struct_exists(eff, "criteria") && variable_struct_exists(eff.criteria, "genre") && eff.criteria.genre == "Bête") {
                if (variable_instance_exists(tgt2, "name") && tgt2.name == "Araignée forestière") {
                    debug_trace = true;
                    show_debug_message("--- DEBUG EFFECT FILTER: " + string(tgt2.name) + " ---");
                }
            }

            if (variable_struct_exists(eff, "criteria")) {
                var critB = eff.criteria;
                if (variable_struct_exists(critB, "type")) {
                    var wt = string_lower(critB.type);
                    var isMon = object_is_ancestor(tgt2.object_index, oCardMonster) || (variable_instance_exists(tgt2, "type") && string_lower(tgt2.type) == "monster");
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
                    if (wa != "" && ta != wa) okc = false;
                }
                if (variable_struct_exists(critB, "name_contains")) {
                    var wn = string_lower(string(critB.name_contains));
                    var tn = variable_instance_exists(tgt2, "name") ? string_lower(string(tgt2.name)) : "";
                    if (wn != "" && string_pos(wn, tn) == 0) okc = false;
                }
            }
            // Filtre supplémentaire: n'appliquer qu'aux cibles camouflées
            if (okc && variable_struct_exists(eff, "only_camouflaged") && eff.only_camouflaged) {
                var isCamo = (variable_instance_exists(tgt2, "isCamouflage") && tgt2.isCamouflage);
                if (!isCamo) okc = false;
            }
            if (variable_struct_exists(eff, "owner")) {
                var tgtHero = (instance_exists(tgt2) && variable_instance_exists(tgt2, "isHeroOwner")) ? tgt2.isHeroOwner : srcHeroP;
                if (ownerSideP == "ally" && (tgtHero != srcHeroP)) okc = false;
                if (ownerSideP == "enemy" && (tgtHero == srcHeroP)) okc = false;
            }
            if (variable_struct_exists(eff, "target_zone")) {
                var tz = string_lower(eff.target_zone);
                var z = variable_instance_exists(tgt2, "zone") ? string_lower(tgt2.zone) : "";
                if (tz == "field" && z != "field" && z != "fieldselected") okc = false;
                if (tz == "hand" && z != "hand") okc = false;
            }
            if (!okc) return false;
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
                var srcId = (srcCard != noone && instance_exists(srcCard) && variable_instance_exists(srcCard, "id")) ? srcCard.id : -1;
                var srcKeyB = "effect:" + string(eff.effect_type) + ":" + string(srcId) + ":" + string(variable_struct_exists(eff, "id") ? eff.id : -1);
                if (scopeP == "equip") { srcKeyB = "equip:" + string(srcId); }
                else if (scopeP == "aura") { srcKeyB = "aura:" + string(srcId); }
                buffSetContribution(tgt2, srcKeyB, laAtk, laDef);
                buffRecompute(tgt2);
                if (variable_struct_exists(eff, "grant_ambidextrous") && eff.grant_ambidextrous) {
                    tgt2.isAmbidextrous = true;
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
                if (variable_struct_exists(eff, "keep_camouflage_this_turn") && eff.keep_camouflage_this_turn) {
                    if (instance_exists(tgt2)) {
                        var curT2 = (instance_exists(game) && variable_instance_exists(game, "nbTurn")) ? game.nbTurn : 0;
                        tgt2.keepCamouflageTurn = curT2;
                    }
                }
                return true;
            }
        };


            if (scope == "single") {
                var tgt;
                if (target != noone) {
                    tgt = target;
                } else {
                    var excludeSelfC = (variable_struct_exists(effect, "criteria") && variable_struct_exists(effect.criteria, "exclude_self")) ? effect.criteria.exclude_self : false;
                    tgt = excludeSelfC ? noone : card;
                }
                if (tgt == noone) { return false; }
                return applyTo(tgt, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card);
            } else if (scope == "equip") {
                var tEquip = (variable_instance_exists(card, "equipped_target")) ? card.equipped_target : noone;
                return applyTo(tEquip, effect, ownerSideB, srcHeroB, agg, scope, mode, atkVal, defVal, card);
            } else if (scope == "all" || scope == "aura") {
                var applied = false;
                var heroArr = fieldMonsterHero.cards;
                for (var hi = 0; hi < array_length(heroArr); hi++) {
                    var ch = heroArr[hi];
                    if (ch != 0 && instance_exists(ch)) {
                        var z1 = variable_instance_exists(ch, "zone") ? string_lower(ch.zone) : "";
                        if (z1 == "field" || z1 == "fieldselected") {
                            if (scope == "all") {
                                var okOwnH = true;
                                if (variable_struct_exists(effect, "owner")) {
                                    var isHeroLocalH = variable_instance_exists(ch, "isHeroOwner") ? ch.isHeroOwner : undefined;
                                    if (ownerSideB == "ally" && isHeroLocalH != srcHeroB) okOwnH = false;
                                    if (ownerSideB == "enemy" && isHeroLocalH == srcHeroB) okOwnH = false;
                                }
                                if (!okOwnH) { continue; }
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
                            if (scope == "all") {
                                var okOwnE = true;
                                if (variable_struct_exists(effect, "owner")) {
                                    var isHeroLocalE = variable_instance_exists(ce, "isHeroOwner") ? ce.isHeroOwner : undefined;
                                    if (ownerSideB == "ally" && isHeroLocalE != srcHeroB) okOwnE = false;
                                    if (ownerSideB == "enemy" && isHeroLocalE == srcHeroB) okOwnE = false;
                                }
                                if (!okOwnE) { continue; }
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
            if (target == noone && variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) { target = context.attacker; }
            if (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_ON_ATTACK) {
                if (target == noone || !instance_exists(target) || !(variable_instance_exists(target, "zone") && (target.zone == "Field" || target.zone == "FieldSelected"))) { return false; }
            }
            if (target != noone) {
                var ta = 0;
                var td = 0;
                if (instance_exists(target)) {
                    if (variable_instance_exists(target, "effective_attack")) ta = target.effective_attack; else if (variable_instance_exists(target, "attack")) ta = target.attack;
                    if (variable_instance_exists(target, "effective_defense")) td = target.effective_defense; else if (variable_instance_exists(target, "defense")) td = target.defense;
                }
                if (card != noone && instance_exists(card) && variable_instance_exists(card, "isPoisoner") && card.isPoisoner) { spawnPoisonFX(target, card); return true; }
                var okdt = destroyCard(target);
                if (okdt) {
                    var owner_flag_dt = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : (variable_struct_exists(context, "owner_is_hero") ? context.owner_is_hero : true);
                    var ctx_dt = { owner_is_hero: owner_flag_dt, from_destroy_target: true, atk_value: ta, def_value: td };
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
            
        case EFFECT_BANISH_TARGET:
            if (target != noone) return banishCard(target);
            break;
            
        case EFFECT_RETURN_TO_HAND:
            if (target != noone) return returnToHand(target);
            break;
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
                                    framesS = max(0, round((stepS.ms / 1000.0) * room_speed));
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
                                    framesD = max(0, round((stepD.ms / 1000.0) * room_speed));
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
        
        // Aura: buff ATK/DEF par archétype sur le terrain
        
        
        case EFFECT_AURA_ALL_MONSTERS_DEBUFF:
        {
            return applyAllMonstersAuraDebuff(card, effect);
        }
        
        case EFFECT_AURA_CLEANUP_SOURCE:
        {
            return cleanupAuraSource(card, effect);
        }
        
        
        case EFFECT_POINTS:
        {
            return sEffectPoints(card, effect, context);
        }
        case EFFECT_PROTECTION:
        {
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "single";
            var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
            var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            var crit = variable_struct_exists(effect, "criteria") ? effect.criteria : {};
            var srcKey = "aura:" + string(card.id);
            var applyProtect = function(tgt) {
                if (tgt == noone || !instance_exists(tgt)) return false;
                if (!variable_instance_exists(tgt, "protection_sources")) tgt.protection_sources = [];
                var hasKey = false;
                for (var i = 0; i < array_length(tgt.protection_sources); i++) { if (string(tgt.protection_sources[i]) == srcKey) { hasKey = true; break; } }
                if (!hasKey) { array_push(tgt.protection_sources, srcKey); }
                tgt.protection_from_destroy = true;
                return true;
            };
            if (scope == "single") {
                var tgt = (variable_struct_exists(context, "target") && instance_exists(context.target)) ? context.target : card;
                return applyProtect(tgt);
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
                            if (okCritH) { if (applyProtect(ch)) applied = true; }
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
                            if (okCritE) { if (applyProtect(ce)) applied = true; }
                        }
                    }
                }
                return applied;
            }
            return false;
        }
        case EFFECT_CAMOUFLAGE:
        {
            return sCamouflage(card, effect, context);
        }
        
        case EFFECT_ENTRAVE:
        {
            return sEntrave(card, effect, context);
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

/// @function loseLP(amount)
/// @description Fait perdre des LP au joueur
/// @param {real} amount - Montant de LP à perdre
/// @returns {bool} - Succès de l'opération
function loseLP(amount) {
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
// [refactor] Helpers de COMBAT déplacés vers `sEffectCombat.gml` et helpers DIVERS vers `sEffectMisc.gml` (modifyAttack/Defense, setAttack/Defense, damage/heal, destroyCard, spawnPoisonFX, banishCard, returnToHand). 

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
