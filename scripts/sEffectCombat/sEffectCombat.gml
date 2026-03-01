/// sEffectCombat.gml — Helpers d’effets de combat (ATK/PV, dégâts/soins, destruction)

function modifyAttack(card, amount, temporary = false) {
    if (card == noone) return false;
    if (temporary) {
        if (!variable_struct_exists(card, "temp_attack")) {
            card.temp_attack = 0;
        }
        card.temp_attack += amount;
        // Mettre à jour les stats effectives pour inclure le temporaire
        if (script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(card);
        } else if (variable_instance_exists(card, "effective_attack")) {
             card.effective_attack = card.attack + card.temp_attack;
        }
    } else {
        card.attack += amount;
        card.attack = max(0, card.attack);
        // Si le système de buffs/effectifs est utilisé, recalculer l'ATK effective
        if (script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(card);
        } else if (variable_instance_exists(card, "effective_attack")) {
            card.effective_attack = card.attack;
        }
    }
    return true;
}

/// @function modifyDefense(card, amount, temporary)
function modifyDefense(card, amount, temporary = false) {
    if (card == noone) return false;
    if (temporary) {
        if (!variable_struct_exists(card, "temp_defense")) {
            card.temp_defense = 0;
        }
        card.temp_defense += amount;
        // Mettre à jour les stats effectives pour inclure le temporaire
        if (variable_instance_exists(card, "effective_defense") || variable_instance_exists(card, "buff_contribs")) {
            if (!is_undefined(buffRecompute)) buffRecompute(card);
        }
    } else {
        card.PV += amount;
        card.PV = max(0, card.PV);
        
        // Mettre à jour max_hp et current_hp pour refléter le buff
        if (variable_instance_exists(card, "max_hp")) {
            card.max_hp += amount;
            card.max_hp = max(0, card.max_hp);
        }
        if (variable_instance_exists(card, "current_hp")) {
            card.current_hp += amount;
            // Optionnel: ne pas descendre en dessous de 1 si c'est un buff positif? Non, standard logic.
            // Si c'est un debuff qui tue, current_hp <= 0 sera géré ailleurs ou nécessite destroyCheck.
        }

        // Recalculer la PV effective si le système est en place
        if (variable_instance_exists(card, "effective_defense") || variable_instance_exists(card, "buff_contribs")) {
            if (is_undefined(buffRecompute)) {
                if (variable_instance_exists(card, "effective_defense")) {
                    card.effective_defense = card.PV;
                }
            } else {
                buffRecompute(card);
            }
        }
    }
    return true;
}

/// @function setAttack(card, value)
function setAttack(card, value) {
    if (card == noone) return false;
    card.attack = max(0, value);
    // Synchroniser l'ATK effective si présente
    if (variable_instance_exists(card, "effective_attack") || variable_instance_exists(card, "buff_contribs")) {
        if (is_undefined(buffRecompute)) {
            if (variable_instance_exists(card, "effective_attack")) {
                card.effective_attack = card.attack;
            }
        } else {
            buffRecompute(card);
        }
    }
    return true;
}

/// @function setDefense(card, value)
function setDefense(card, value) {
    if (card == noone) return false;
    card.PV = max(0, value);
    // Synchroniser la PV effective si présente
    if (variable_instance_exists(card, "effective_defense") || variable_instance_exists(card, "buff_contribs")) {
        if (is_undefined(buffRecompute)) {
            if (variable_instance_exists(card, "effective_defense")) {
                card.effective_defense = card.PV;
            }
        } else {
            buffRecompute(card);
        }
    }
    return true;
}

// === Dégâts et soins ===
/// @function damageCard(card, amount, source)
function damageCard(card, amount, source = noone) {
    if (card == noone) return false;
    registerTriggerEvent(TRIGGER_ON_DAMAGE, card, { damage: amount, source: card });
    
    // Quest System Notification
    if (instance_exists(oQuestManager)) {
        oQuestManager.notify_event("deal_damage", amount, { source: source, target: card });
    }
    
    // Support for LP Objects (Hero/Enemy)
    if (variable_instance_exists(card, "nbLP")) {
        var oldLP = card.nbLP;
        card.nbLP = max(0, card.nbLP - amount);
        var newLP = card.nbLP;
        
        var ownerIsHero = (card.object_index == oLP_Hero); // Determine owner based on object type
        if (variable_instance_exists(card, "isHeroOwner")) ownerIsHero = card.isHeroOwner;

        // Notify Quest Manager for "Deal damage to enemy hero"
        if (instance_exists(oQuestManager) && !ownerIsHero) {
            oQuestManager.notify_event("damage_hero", amount);
        }
        
        registerTriggerEvent(TRIGGER_ON_LP_CHANGE, noone, {
            old_lp: oldLP,
            new_lp: newLP,
            change: -amount,
            owner_is_hero: ownerIsHero
        });
        
        if (newLP <= 0) {
             // Handle Victory/Defeat if needed, usually handled by Game Manager check
             show_debug_message("### Victory/Defeat via damageCard on LP Object");
        }
        return true;
    }
    
    // Support for both Structs and Instances
    var has_current_hp = variable_struct_exists(card, "current_hp");
    if (!has_current_hp && instance_exists(card)) has_current_hp = variable_instance_exists(card, "current_hp");
    
    if (has_current_hp) {
        card.current_hp -= amount;
        if (card.current_hp <= 0) { destroyCard(card); }
    } else {
        var has_pv = variable_struct_exists(card, "PV");
        if (!has_pv && instance_exists(card)) has_pv = variable_instance_exists(card, "PV");
        
        if (has_pv) {
            card.PV -= amount;
            if (card.PV <= 0) { destroyCard(card); }
        }
    }
    return true;
}

/// @function healCard(card, amount)
function healCard(card, amount) {
    if (card == noone) return false;
    registerTriggerEvent(TRIGGER_ON_HEAL, card, { heal: amount, target: card });
    
    // Support for both Structs and Instances
    var has_current_hp = variable_struct_exists(card, "current_hp");
    if (!has_current_hp && instance_exists(card)) has_current_hp = variable_instance_exists(card, "current_hp");
    
    var has_max_hp = variable_struct_exists(card, "max_hp");
    if (!has_max_hp && instance_exists(card)) has_max_hp = variable_instance_exists(card, "max_hp");

    if (has_current_hp && has_max_hp) {
        card.current_hp = min(card.max_hp, card.current_hp + amount);
    } else {
        var has_pv = variable_struct_exists(card, "PV");
        if (!has_pv && instance_exists(card)) has_pv = variable_instance_exists(card, "PV");
        
        var has_def = variable_struct_exists(card, "original_defense");
        if (!has_def && instance_exists(card)) has_def = variable_instance_exists(card, "original_defense");
        
        if (has_pv && has_def) {
            card.PV = min(card.original_defense, card.PV + amount);
        }
    }
    return true;
}

// === Destruction, bannissement, retour en main ===
/// @function destroyCard(card, source)
/// @description Détruit une carte et enregistre le contexte (incluant l'attaquant si fourni)
function destroyCard(card, source = noone) {
    if (card == noone) return false;
    if (instance_exists(card)) {
        
        // --- ILLUSION CHECK ---
        // Si la carte a l'état Illusion, elle survit à la première destruction
        if (variable_instance_exists(card, "HasIllusion") && card.HasIllusion) {
            card.HasIllusion = false;
            show_debug_message("### destroyCard: Prevented by Illusion! (HasIllusion consumed)");
            
            // Quest System Notification
            if (instance_exists(oQuestManager)) {
                // "Activer l'effet illusion"
                oQuestManager.notify_event("trigger_keyword", 1, { keyword: "Illusion", card: card });
            }
            return false;
        }

        var cancelled_by_secret = false;
        if (!is_undefined(activateSecretsOnDestroyAttempt)) {
            cancelled_by_secret = activateSecretsOnDestroyAttempt(card, source);
        }
        if (cancelled_by_secret) {
            return false;
        }
    }
    if (instance_exists(card) && variable_instance_exists(card, "protection_sources") && is_array(card.protection_sources) && array_length(card.protection_sources) > 0) {
        // FIX: If protected from destruction but HP reached 0, clamp to 1 to avoid "0 HP zombie" state
        if (variable_instance_exists(card, "PV") && card.PV <= 0) { card.PV = 1; }
        if (variable_instance_exists(card, "current_hp") && card.current_hp <= 0) { card.current_hp = 1; }
        return false;
    }
    var ctx = { destroyed_card: card };
    if (source != noone && instance_exists(source)) { ctx.attacker = source; }
    
    // Safety check redundant with the one above, but kept for legacy structure consistency
    if (instance_exists(card) && variable_instance_exists(card, "HasIllusion") && card.HasIllusion) {
        card.HasIllusion = false;
        if (variable_instance_exists(card, "PV") && card.PV <= 0) { card.PV = 1; }
        if (variable_instance_exists(card, "current_hp") && card.current_hp <= 0) { card.current_hp = 1; }
        return true; // Return true here means "handled/prevented" in this context? Wait, destroyCard usually returns false if prevented.
                     // The block above returns false.
                     // If we are here, it means we passed the first check.
                     // If HasIllusion is somehow true here, we should probably return false (prevent destruction).
                     // But let's just use the same logic: consume and prevent.
        return false; 
    }
    registerTriggerEvent(TRIGGER_ON_DESTROY, card, ctx);

    // QUEST SYSTEM NOTIFICATION (Destruction)
    if (instance_exists(oQuestManager) && instance_exists(card)) {
        var cType = variable_instance_exists(card, "type") ? string_lower(card.type) : "";
        var isMinion = (cType == "monster" || cType == "minion" || cType == "creature" || cType == "bête" || cType == "soldat");
        var isEnemy = (variable_instance_exists(card, "isHeroOwner") && !card.isHeroOwner);
        
        // Count destroyed enemy minions for quest "destroy_10_minions"
        if (isMinion && isEnemy) {
            oQuestManager.notify_event("destroy_minion", 1);
        }
        
        // Count ally minion deaths for quest "ally_death_10"
        var isAlly = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
        if (isMinion && isAlly) {
            oQuestManager.notify_event("ally_minion_death", 1);
        }
    }

    var delay_destroy = (instance_exists(card) && variable_instance_exists(card, "_delay_instance_destroy_for_poison") && card._delay_instance_destroy_for_poison);
    
    // Utiliser les variables globales des cimetières
    var gyInst = noone;
    if (card.isHeroOwner) {
        gyInst = global.graveyardHero;
    } else {
        gyInst = global.graveyardEnemy;
    }
    
    if (!delay_destroy) {
        if (gyInst != noone && instance_exists(gyInst)) {
            gyInst.addToGraveyard(card);
        } else {
            show_debug_message("### destroyCard: cimetière introuvable pour owner=" + string(card.isHeroOwner) + " (global.graveyardHero=" + string(global.graveyardHero) + ", global.graveyardEnemy=" + string(global.graveyardEnemy) + ")");
        }
    }
    if (instance_exists(card) && variable_instance_exists(card, "zone")) {
        if (!delay_destroy) {
            if (card.zone == "Field" || card.zone == "FieldSelected") {
                registerTriggerEvent(TRIGGER_LEAVE_FIELD, card, ctx);
                var fm = noone;
                if (instance_exists(fieldManagerHero) || instance_exists(fieldManagerEnemy)) {
                    if (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner && instance_exists(fieldManagerHero)) { fm = fieldManagerHero; }
                    else if (instance_exists(fieldManagerEnemy)) { fm = fieldManagerEnemy; }
                }
                if (fm != noone && variable_instance_exists(card, "fieldPosition")) { fm.remove(card); }
            } else if (card.zone == "Secret") {
                var sList = card.isHeroOwner ? global.activeSecretsHero : global.activeSecretsEnemy;
                if (ds_exists(sList, ds_type_list)) {
                    var idx = ds_list_find_index(sList, card);
                    if (idx != -1) ds_list_delete(sList, idx);
                }
            }
            card.zone = "Graveyard";
        }
        var dCard = card;
        with (oCardMagic) {
            // Check both Field and FieldSelected (in case the artifact is selected)
            var z = variable_instance_exists(self, "zone") ? zone : "";
            if (z == "Field" || z == "FieldSelected") {
                // Correction: On ne vérifie plus le genre "Artéfact" strictement.
                // Si une carte magique a une "equipped_target" qui correspond à la carte détruite,
                // elle doit être détruite aussi (règle générale d'équipement).
                var eqt = (variable_instance_exists(self, "equipped_target")) ? equipped_target : noone;
                if (eqt != noone && eqt == dCard) {
                    show_debug_message("### destroyCard: Linked equipment found (" + string(variable_instance_exists(self, "name") ? name : "???") + "). Destroying.");
                    destroyCard(id);
                }
            }
        }
        
        // --- FALLBACK SECURITY CHECK ---
        // Verify explicitly in field managers to ensure no artifact is left behind (especially for AI)
        var managersToCheck = [];
        if (instance_exists(oFieldManagerHero)) array_push(managersToCheck, oFieldManagerHero);
        if (instance_exists(oFieldManagerEnemy)) array_push(managersToCheck, oFieldManagerEnemy);
        
        for (var m = 0; m < array_length(managersToCheck); m++) {
            var mgr = managersToCheck[m];
            // Use safe getter that handles internal variable names (Hero/Enemy)
            if (variable_instance_exists(mgr, "getField")) {
                 var f = mgr.getField("MagicTrap");
                 if (f != noone && instance_exists(f)) {
                     for (var i = 0; i < array_length(f.cards); i++) {
                         var c = f.cards[i];
                         if (c != 0 && instance_exists(c) && c != dCard) { // Avoid self-check
                             var eqt = (variable_instance_exists(c, "equipped_target")) ? c.equipped_target : noone;
                             if (eqt == dCard) {
                                 show_debug_message("### destroyCard: Linked equipment found via Fallback (" + string(variable_instance_exists(c, "name") ? c.name : "???") + "). Destroying.");
                                 destroyCard(c);
                             }
                         }
                     }
                 }
            }
        }
        var skip_fx = (variable_instance_exists(card, "_skip_destruction_fx") && card._skip_destruction_fx);
        if (!skip_fx) {
            var fx = instance_create_layer(card.x, card.y, "Instances", FX_Destruction);
            if (fx != noone) {
                fx.spriteGhost   = card.sprite_index;
                fx.imageGhost    = card.image_index;
                fx.image_xscale  = card.image_xscale;
                fx.image_yscale  = card.image_yscale;
                fx.image_angle   = card.image_angle;
                fx.duration_ms   = 700;
                fx.sep_px        = 48;
                fx.strip_h       = 3;
                fx.ragged_amp_px = 6;
                if (variable_instance_exists(self, "target") && instance_exists(target) && variable_instance_exists(target, "depth")) { fx.depth_override = target.depth + 1; }
                else { fx.depth_override = 100000; }
            }
        }
        // Détruire immédiatement l'instance sauf si une tempo est en attente sur cette carte
        if (instance_exists(card)) {
            
            // Quest System Notification (Unit Die)
            if (instance_exists(oQuestManager)) {
                var cType = variable_instance_exists(card, "type") ? string_lower(card.type) : "";
                if (cType == "monster" || cType == "minion" || cType == "creature") {
                    oQuestManager.notify_event("unit_die", 1, { card: card, source: source });
                }
            }

            var has_tempo_pending = variable_instance_exists(card, "_flow_tempo_pending") && card._flow_tempo_pending;
            if (has_tempo_pending) {
                // Masquer brièvement et demander destruction après reprise du flow
                card.visible = false;
                card.image_alpha = 0;
                card.sprite_index = sprInvisible;
                card._wait_destroy_on_tempo = true;
            } else {
                var delay_destroy = (variable_instance_exists(card, "_delay_instance_destroy_for_poison") && card._delay_instance_destroy_for_poison);
                if (!delay_destroy) {
                    instance_destroy(card);
                }
            }
        }
    }
    return true;
}

/// @function spawnPoisonFX(target, source)
function spawnPoisonFX(target, source) {
    if (target == noone) return;
    var lx = (instance_exists(target) && variable_instance_exists(target, "x")) ? target.x : 0;
    var ly = (instance_exists(target) && variable_instance_exists(target, "y")) ? target.y : 0;
    var fx = instance_create_layer(lx, ly, "Instances", FX_Poison);
    if (fx != noone) {
        if (instance_exists(source)) fx.source = source;
        fx.target = target;
        fx.depth_override = -100000;
        fx.visible = true;
        fx.image_xscale = 1;
        fx.image_yscale = 1;
        if (!variable_instance_exists(fx, "duration_steps")) fx.duration_steps = max(1, round(room_speed * 1.0));
        if (!variable_instance_exists(fx, "color")) fx.color = make_color_rgb(60, 200, 80);
        var spr_poison = asset_get_index("sPoison");
        if (spr_poison != -1) {
            fx.sprite_index = spr_poison;
            fx.image_speed = sprite_get_number(spr_poison) / max(1, fx.duration_steps);
        }
        show_debug_message("### spawnPoisonFX: target=" + string(target) + " source=" + string(source) + " pos=(" + string(lx) + "," + string(ly) + ") spr_set=" + string(spr_poison != -1));
        if (instance_exists(target)) {
            target._skip_destruction_fx = true;
            target._delay_instance_destroy_for_poison = true;
        }
    }
}

// === Effets de zone ===
function damageAllMonsters(amount, effect) {
    var targets = getTargetsByFilter(effect);
    
    // Check for Visual FX request
    var fx_type = variable_struct_exists(effect, "visual_fx") ? effect.visual_fx : "";
    var elem = variable_struct_exists(effect, "element") ? string_lower(effect.element) : "";
    
    if (fx_type == "multicible" || elem == "multicible") {
        for (var i = 0; i < array_length(targets); i++) {
            var tgt = targets[i];
            if (tgt == noone || !instance_exists(tgt)) continue;
            
            var dmgCallback = method({t: tgt, a: amount}, function() {
                if (instance_exists(t)) {
                    damageCard(t, a);
                }
            });
            
            if (!is_undefined(animEffectRequestProjectileTarget)) {
                animEffectRequestProjectileTarget("feu", effect.source_card, tgt, amount, dmgCallback);
            } else {
                dmgCallback();
            }
        }
    } else {
        // Default instant behavior
        for (var i = 0; i < array_length(targets); i++) { damageCard(targets[i], amount); }
    }
    return true;
}

function healAllMonsters(amount, effect) {
    var targets = getTargetsByFilter(effect);
    for (var i = 0; i < array_length(targets); i++) { healCard(targets[i], amount); }
    return true;
}

function destroyAllMonsters(effect) {
    var targets = getTargetsByFilter(effect);
    for (var i = 0; i < array_length(targets); i++) { destroyCard(targets[i]); }
    return true;
}
