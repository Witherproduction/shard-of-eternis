function sMagicSecret() {
    // Initialisation du module des secrets
}

/// Garde commune : secret déclenché uniquement par une attaque adverse, pendant le tour adverse.
function _secretPassesAttackActivationGuards(secretCard, attacker) {
    if (secretCard == noone || !instance_exists(secretCard)) return false;
    if (attacker == noone || !instance_exists(attacker)) return false;

    var secretOwnerIsHero = (variable_instance_exists(secretCard, "isHeroOwner") && secretCard.isHeroOwner);
    var attackerIsHero = (variable_instance_exists(attacker, "isHeroOwner") && attacker.isHeroOwner);

    if (attackerIsHero == secretOwnerIsHero) return false;

    if (instance_exists(game) && variable_instance_exists(game, "player_current")) {
        var currentIsHero = (game.player_current == 0);
        if (secretOwnerIsHero == currentIsHero) return false;
    }

    return true;
}

/// @function secretCardIsSecret(card)
function secretCardIsSecret(_card) {
    if (_card == noone || !instance_exists(_card)) return false;
    if (variable_instance_exists(_card, "genre") && string_lower(_card.genre) == "secret") return true;
    if (variable_instance_exists(_card, "zone") && string_lower(_card.zone) == "secret") return true;
    return false;
}

/// @function secretPrepareActivationPresentation(card)
/// @description Visible pour le halo, mais face cachée (le joueur ne doit pas voir quel secret c'est).
function secretPrepareActivationPresentation(_card) {
    if (_card == noone || !instance_exists(_card)) return;
    with (_card) {
        visible = true;
        depth = -2000;
        isFaceDown = true;
        image_index = 1;
        orientation = "Attack";
        image_angle = 0;
    }
}

/// @function secretCommitActivationReveal(card)
/// @description Révélation après le halo / résolution de l'effet.
function secretCommitActivationReveal(_card) {
    if (_card == noone || !instance_exists(_card)) return;
    if (!secretCardIsSecret(_card)) return;
    with (_card) {
        isFaceDown = false;
        image_index = 0;
        image_angle = 0;
        x = room_width * 0.5;
        y = room_height * 0.5;
    }
}

/// @function secretExecuteEffectWithReveal(card, effect, ctx)
function secretExecuteEffectWithReveal(_card, _effect, _ctx) {
    var ok = executeEffect(_card, _effect, _ctx);
    var deferred = (is_struct(_ctx) && variable_struct_exists(_ctx, "fx_aura_deferred") && _ctx.fx_aura_deferred);
    if (ok && !deferred) {
        secretCommitActivationReveal(_card);
    }
    return ok;
}

function activateSecretsOnDirectAttack(attacker, targetSecretCard = noone) {
    if (!instance_exists(attacker)) return noone;
    
    // Reset global block flag
    global.combat_attack_blocked = false;
    
    var attackerIsHero = variable_instance_exists(attacker, "isHeroOwner") ? attacker.isHeroOwner : true;
    var defendingIsHero = !attackerIsHero;
    var effAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : (variable_instance_exists(attacker, "attack") ? attacker.attack : 0);

    // Ensemble des noms de secrets déjà activés pendant cette attaque
    var activatedNames = [];
    var redirectDefender = noone;
    
    // Use the active secrets list instead of iterating all field cards
    var secretList = defendingIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return noone;
    
    var size = ds_list_size(secretList);
    // Iterate manually
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;
        
        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            
            // Si une carte précise est ciblée (séquence FX_Combat)
            if (targetSecretCard != noone && id != targetSecretCard) continue;
            
            // Note: In HS mode, secrets are in "Secret" zone and might not be "FaceDown" in the old sense, 
            // but they are hidden. We assume all cards in activeSecretsList are valid active secrets.
            
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;
            
            // Cherche un effet de Secret à activer sur attaque directe ou générique
            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                var requireDirect = false;
                var requireOnAttack = false;
                if (variable_struct_exists(e, "secret_activation")) {
                    if (variable_struct_exists(e.secret_activation, "direct_attack")) {
                        requireDirect = e.secret_activation.direct_attack;
                    }
                    if (variable_struct_exists(e.secret_activation, "on_attack")) {
                        requireOnAttack = e.secret_activation.on_attack;
                    }
                }
                if (!(requireDirect || requireOnAttack)) continue;
                chosenEffect = e; break;
            }
            if (chosenEffect == noone) continue;

            if (!_secretPassesAttackActivationGuards(self, attacker)) continue;
            
            // Check if secret blocks the attack
            if (variable_struct_exists(chosenEffect, "block_attack") && chosenEffect.block_attack) {
                global.combat_attack_blocked = true;
                show_debug_message("### Secret: Attack blocked by " + string(variable_instance_exists(self, "name") ? self.name : "Secret"));
            }
            
            // Clé de déduplication: le nom canonique de la carte
            var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            var alreadyActivated = false;
            for (var j = 0; j < array_length(activatedNames); j++) {
                if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
            }
            if (alreadyActivated) {
                continue;
            }
            array_push(activatedNames, cardName);
            
            secretPrepareActivationPresentation(id);
            
            // Calcul des dégâts et préparation du contexte
            var useAtkVal = (variable_struct_exists(chosenEffect, "use_attacker_attack_as_value") && chosenEffect.use_attacker_attack_as_value);
            var dmg = 0;
            if (useAtkVal) {
                dmg = effAtk;
                if (variable_struct_exists(chosenEffect, "attack_value_divisor") && is_real(chosenEffect.attack_value_divisor) && chosenEffect.attack_value_divisor > 1) {
                    dmg = floor(dmg / chosenEffect.attack_value_divisor);
                } else if (variable_struct_exists(chosenEffect, "attack_value_ratio") && is_real(chosenEffect.attack_value_ratio)) {
                    dmg = floor(dmg * chosenEffect.attack_value_ratio);
                }
            }
            
            var ctx = { attacker: attacker, defender: noone };
            if (useAtkVal) { ctx.value = dmg; }

            if (variable_struct_exists(chosenEffect, "target_source")) {
                var ts = chosenEffect.target_source;
                if (ts == "attacker") ctx.target = attacker;
                else if (ts == "defender") ctx.target = noone;
            }
            
            if (variable_struct_exists(chosenEffect, "affect_opponent_lp") && chosenEffect.affect_opponent_lp) {
                ctx.owner_is_hero = !defendingIsHero;
            }
            
            var effIndex = -1;
            if (variable_instance_exists(self, "effects") && is_array(effects)) {
                for (var eff_k = 0; eff_k < array_length(effects); eff_k++) {
                    if (effects[eff_k] == chosenEffect) { effIndex = eff_k; break; }
                }
            }
            
            if (effIndex != -1 && variable_instance_exists(self, "instance_uid")) {
                 var payload = {
                     source_uid: self.instance_uid,
                     effect_index: effIndex
                 };
                 if (variable_struct_exists(ctx, "target") && ctx.target != noone && instance_exists(ctx.target) && variable_instance_exists(ctx.target, "instance_uid")) {
                     payload.target_uid = ctx.target.instance_uid;
                 }
                 RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
            } else {
                secretExecuteEffectWithReveal(id, chosenEffect, ctx);
                if (variable_struct_exists(chosenEffect, "redirect_attack_to_target") && chosenEffect.redirect_attack_to_target) {
                    if (variable_struct_exists(ctx, "target") && ctx.target != noone && instance_exists(ctx.target)) {
                        redirectDefender = ctx.target;
                    }
                }
                if (variable_struct_exists(chosenEffect, "redirect_attack_to_summoned") && chosenEffect.redirect_attack_to_summoned) {
                    if (variable_struct_exists(ctx, "summoned") && ctx.summoned != noone && instance_exists(ctx.summoned)) {
                        redirectDefender = ctx.summoned;
                    }
                }
                
                // Remove from active list to update overlay counter
                var _idx = ds_list_find_index(secretList, id);
                show_debug_message("### SecretDebug: Attempting removal. ID=" + string(id) + " Index=" + string(_idx) + " ListSizeBefore=" + string(ds_list_size(secretList)));
                if (_idx != -1) {
                    ds_list_delete(secretList, _idx);
                    size--;
                    k--;
                    show_debug_message("### SecretDebug: Removed successfully. ListSizeAfter=" + string(ds_list_size(secretList)));
                } else {
                    show_debug_message("### SecretDebug: ID not found in list!");
                }
                
                // Delay destruction if FX are active (e.g. procedural spikes)
                if (variable_global_exists("combat_fx_count") && global.combat_fx_count > 0) {
                     var destroyer = instance_create_depth(x, y, 0, oDelayedSecretDestroyer);
                     destroyer.target_card = id;
                } else {
                     destroyCard(id);
                }
            }
        }
    }
    
    return redirectDefender;
}

// Activation des Secrets sur toute attaque (non-directe ou directe via on_attack)
function activateSecretsOnAttack(attacker, defender) {
    if (!instance_exists(attacker)) return;
    
    // Reset global block flag
    global.combat_attack_blocked = false;
    
    var attackerIsHero = variable_instance_exists(attacker, "isHeroOwner") ? attacker.isHeroOwner : true;
    var defendingIsHero = !attackerIsHero;
    var effAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : (variable_instance_exists(attacker, "attack") ? attacker.attack : 0);

    var activatedNames = [];
    
    var secretList = defendingIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return;
    
    var size = ds_list_size(secretList);
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;
        
        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;

            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                var requireOnAttack = false;
                if (variable_struct_exists(e, "secret_activation") && variable_struct_exists(e.secret_activation, "on_attack")) {
                    requireOnAttack = e.secret_activation.on_attack;
                }
                if (!requireOnAttack) continue;
                chosenEffect = e; break;
            }
            if (chosenEffect == noone) continue;

            if (!_secretPassesAttackActivationGuards(self, attacker)) continue;

            // Check if secret blocks the attack
            if (variable_struct_exists(chosenEffect, "block_attack") && chosenEffect.block_attack) {
                global.combat_attack_blocked = true;
                show_debug_message("### Secret: Attack blocked by " + string(variable_instance_exists(self, "name") ? self.name : "Secret"));
            }

            var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            var alreadyActivated = false;
            for (var j = 0; j < array_length(activatedNames); j++) {
                if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
            }
            if (alreadyActivated) continue;
            array_push(activatedNames, cardName);

            secretPrepareActivationPresentation(id);

            var useAtkVal2 = (variable_struct_exists(chosenEffect, "use_attacker_attack_as_value") && chosenEffect.use_attacker_attack_as_value);
            var dmg = 0;
            if (useAtkVal2) {
                dmg = effAtk;
                if (variable_struct_exists(chosenEffect, "attack_value_divisor") && is_real(chosenEffect.attack_value_divisor) && chosenEffect.attack_value_divisor > 1) {
                    dmg = floor(dmg / chosenEffect.attack_value_divisor);
                } else if (variable_struct_exists(chosenEffect, "attack_value_ratio") && is_real(chosenEffect.attack_value_ratio)) {
                    dmg = floor(dmg * chosenEffect.attack_value_ratio);
                }
            }

            var ctx = { attacker: attacker, defender: defender };
            if (useAtkVal2) { ctx.value = dmg; }
            if (variable_struct_exists(chosenEffect, "target_source")) {
                var ts = chosenEffect.target_source;
                if (ts == "attacker") ctx.target = attacker;
                else if (ts == "defender") ctx.target = defender;
            }
            
            if (variable_struct_exists(chosenEffect, "affect_opponent_lp") && chosenEffect.affect_opponent_lp) {
                ctx.owner_is_hero = !defendingIsHero;
            }
            
            var effIndex = -1;
            if (variable_instance_exists(self, "effects") && is_array(effects)) {
                for (var eff_k = 0; eff_k < array_length(effects); eff_k++) {
                    if (effects[eff_k] == chosenEffect) { effIndex = eff_k; break; }
                }
            }
            
            if (effIndex != -1 && variable_instance_exists(self, "instance_uid")) {
                 var payload = {
                     source_uid: self.instance_uid,
                     effect_index: effIndex
                 };
                 if (variable_struct_exists(ctx, "target") && ctx.target != noone && instance_exists(ctx.target) && variable_instance_exists(ctx.target, "instance_uid")) {
                     payload.target_uid = ctx.target.instance_uid;
                 }
                 RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
            } else {
                secretExecuteEffectWithReveal(id, chosenEffect, ctx);
                
                // Remove from active list to update overlay counter
                 var _idx = ds_list_find_index(secretList, id);
                 show_debug_message("### SecretDebug (Summon): Attempting removal. ID=" + string(id) + " Index=" + string(_idx) + " ListSizeBefore=" + string(ds_list_size(secretList)));
                 if (_idx != -1) {
                     ds_list_delete(secretList, _idx);
                     size--;
                     k--;
                     show_debug_message("### SecretDebug (Summon): Removed successfully. ListSizeAfter=" + string(ds_list_size(secretList)));
                 } else {
                     show_debug_message("### SecretDebug (Summon): ID not found in list!");
                 }
                
                destroyCard(id);
            }
        }
    }
}

function activateSecretsOnMonsterSummon(summoned) {
    if (!instance_exists(summoned)) return;
    var summonedIsHero = variable_instance_exists(summoned, "isHeroOwner") ? summoned.isHeroOwner : true;
    var defendingIsHero = !summonedIsHero;
    var summonedName = (instance_exists(summoned) && variable_instance_exists(summoned, "name")) ? summoned.name : object_get_name(summoned.object_index);
    show_debug_message("### Secrets: ON_MONSTER_SUMMON pour '" + string(summonedName) + "' ownerIsHero=" + string(summonedIsHero));

    var activatedNames = [];
    
    var secretList = defendingIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return;
    
    var size = ds_list_size(secretList);
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;

        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            // No face down check needed for active secrets list
            
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;

            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                var requireOnSummon = false;
                if (variable_struct_exists(e, "secret_activation") && variable_struct_exists(e.secret_activation, "on_summon")) {
                    requireOnSummon = e.secret_activation.on_summon;
                }
                if (!requireOnSummon) continue;
                chosenEffect = e; break;
            }
            if (chosenEffect == noone) continue;

            var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            var alreadyActivated = false;
            for (var j = 0; j < array_length(activatedNames); j++) {
                if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
            }
            if (alreadyActivated) continue;
            array_push(activatedNames, cardName);

            secretPrepareActivationPresentation(id);

            var etype = variable_struct_exists(chosenEffect, "effect_type") ? chosenEffect.effect_type : "unknown";
            show_debug_message("### Secrets: activation '" + string(cardName) + "' sur '" + string(summonedName) + "' (effet=" + string(etype) + ")");

            var ctx = { source: summoned };
            if (variable_struct_exists(chosenEffect, "target_source")) {
                var ts = chosenEffect.target_source;
                if (ts == "summoned") ctx.target = summoned;
            }
            
            var effIndex = -1;
            if (variable_instance_exists(self, "effects") && is_array(effects)) {
                for (var eff_k = 0; eff_k < array_length(effects); eff_k++) {
                    if (effects[eff_k] == chosenEffect) { effIndex = eff_k; break; }
                }
            }
            
            if (effIndex != -1 && variable_instance_exists(self, "instance_uid")) {
                 var payload = {
                     source_uid: self.instance_uid,
                     effect_index: effIndex
                 };
                 if (variable_struct_exists(ctx, "target") && ctx.target != noone && instance_exists(ctx.target) && variable_instance_exists(ctx.target, "instance_uid")) {
                     payload.target_uid = ctx.target.instance_uid;
                 }
                 RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
            } else {
                var ok = secretExecuteEffectWithReveal(id, chosenEffect, ctx);
                show_debug_message("### Secrets: effet exécuté=" + string(ok) + "; destruction");
                
                // Remove from active list to update overlay counter
                 var _idx = ds_list_find_index(secretList, id);
                 show_debug_message("### SecretDebug (Attack): Attempting removal. ID=" + string(id) + " Index=" + string(_idx) + " ListSizeBefore=" + string(ds_list_size(secretList)));
                 if (_idx != -1) {
                     ds_list_delete(secretList, _idx);
                     size--;
                     k--;
                     show_debug_message("### SecretDebug (Attack): Removed successfully. ListSizeAfter=" + string(ds_list_size(secretList)));
                 } else {
                     show_debug_message("### SecretDebug (Attack): ID not found in list!");
                 }
                
                destroyCard(id);
            }
        }
    }
}

function activateSecretsOnSpellCast(spellCard, spellContext = {}) {
    if (!instance_exists(spellCard)) return;
    var casterIsHero = variable_instance_exists(spellCard, "isHeroOwner") ? spellCard.isHeroOwner : true;
    var defendingIsHero = !casterIsHero;
    var spellName = (instance_exists(spellCard) && variable_instance_exists(spellCard, "name")) ? spellCard.name : object_get_name(spellCard.object_index);
    show_debug_message("### Secrets: ON_SPELL_CAST pour '" + string(spellName) + "' casterIsHero=" + string(casterIsHero));
    
    var activatedNames = [];
    
    var secretList = defendingIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return;
    
    var size = ds_list_size(secretList);
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;
        
        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;
            
            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                var requireOnSpell = false;
                if (variable_struct_exists(e, "secret_activation") && variable_struct_exists(e.secret_activation, "on_spell_cast")) {
                    requireOnSpell = e.secret_activation.on_spell_cast;
                }
                if (!requireOnSpell) continue;
                if (variable_struct_exists(e, "secret_activation") && variable_struct_exists(e.secret_activation, "only_if_targeted_ally") && e.secret_activation.only_if_targeted_ally) {
                    if (!variable_struct_exists(spellContext, "target") || spellContext.target == noone || !instance_exists(spellContext.target)) {
                        continue;
                    }
                    var tgtSpell = spellContext.target;
                    var targetIsAlly = (variable_instance_exists(tgtSpell, "isHeroOwner") && tgtSpell.isHeroOwner == defendingIsHero);
                    if (!targetIsAlly) continue;
                    var isMonT = object_is_ancestor(tgtSpell.object_index, oCardMonster) || (variable_instance_exists(tgtSpell, "type") && string_lower(tgtSpell.type) == "monster");
                    if (!isMonT) continue;
                }
                chosenEffect = e; break;
            }
            if (chosenEffect == noone) continue;
            
            var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            var alreadyActivated = false;
            for (var j = 0; j < array_length(activatedNames); j++) {
                if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
            }
            if (alreadyActivated) continue;
            array_push(activatedNames, cardName);
            
            secretPrepareActivationPresentation(id);
            
            var etype = variable_struct_exists(chosenEffect, "effect_type") ? chosenEffect.effect_type : "unknown";
            show_debug_message("### Secrets: activation '" + string(cardName) + "' sur cast '" + string(spellName) + "' (effet=" + string(etype) + ")");
            
            var ctx = { source: spellCard };
            if (variable_struct_exists(spellContext, "target") && spellContext.target != noone && instance_exists(spellContext.target)) {
                ctx.target = spellContext.target;
            }
            
            var effIndex = -1;
            if (variable_instance_exists(self, "effects") && is_array(effects)) {
                for (var kk = 0; kk < array_length(effects); kk++) {
                    if (effects[kk] == chosenEffect) { effIndex = kk; break; }
                }
            }
            
            if (effIndex != -1 && variable_instance_exists(self, "instance_uid")) {
                var payload = {
                    source_uid: self.instance_uid,
                    effect_index: effIndex
                };
                RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
            } else {
                if (variable_struct_exists(chosenEffect, "negate_source_spell") && chosenEffect.negate_source_spell) {
                    if (variable_instance_exists(spellCard, "effects") && is_array(spellCard.effects)) {
                        for (var ni = 0; ni < array_length(spellCard.effects); ni++) {
                            var se = spellCard.effects[ni];
                            if (is_struct(se)) se.negated = true;
                        }
                    }
                }
                var ok = secretExecuteEffectWithReveal(id, chosenEffect, ctx);
                show_debug_message("### Secrets: effet exécuté=" + string(ok) + "; destruction");
                
                var _idx = ds_list_find_index(secretList, id);
                if (_idx != -1) {
                    ds_list_delete(secretList, _idx);
                    size--;
                    k--;
                }
                
                destroyCard(id);
            }
        }
    }
}

/// Activation des Secrets lors d'une tentative de destruction par un effet
function activateSecretsOnDestroyAttempt(target, source) {
    if (target == noone || !instance_exists(target)) return false;
    var ownerIsHero = (variable_instance_exists(target, "isHeroOwner") ? target.isHeroOwner : true);
    var sourceIsEffect = (source != noone && instance_exists(source) && variable_instance_exists(source, "type") && (source.type == "Magic" || source.type == "Monster"));
    var isCombat = false;
    if (instance_exists(game) && variable_instance_exists(game, "phase") && source != noone && instance_exists(source)) {
        var curPh = game.phase[game.phase_current];
        if (curPh == "Attack" && variable_instance_exists(source, "type") && source.type == "Monster") {
            var srcZone = variable_instance_exists(source, "zone") ? source.zone : "";
            if (srcZone == "Field" || srcZone == "FieldSelected") { isCombat = true; }
        }
    }
    var sourceOwnerIsHero = ownerIsHero;
    if (source != noone && instance_exists(source)) {
        if (variable_instance_exists(source, "isHeroOwner")) {
            sourceOwnerIsHero = source.isHeroOwner;
        } else if (variable_instance_exists(source, "is_player_card")) {
            sourceOwnerIsHero = source.is_player_card;
        } else {
            if (instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
                var currentIsHero = (game.player_current == 0);
                if (currentIsHero != ownerIsHero) {
                    sourceOwnerIsHero = !ownerIsHero;
                }
            }
        }
    } else {
        if (instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
            var currentIsHero = (game.player[game.player_current] == "Hero");
            if (currentIsHero != ownerIsHero) {
                sourceOwnerIsHero = !ownerIsHero;
            }
        }
    }

    show_debug_message("### SecretDestroyAttempt: ownerIsHero=" + string(ownerIsHero) + " sourceOwnerIsHero=" + string(sourceOwnerIsHero) + " isCombat=" + string(isCombat));

    var secretList = ownerIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return false;
    
    var size = ds_list_size(secretList);
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;
        
        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            // No FaceDown check
            if (!variable_instance_exists(self, "isHeroOwner") || isHeroOwner != ownerIsHero) continue;
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;

            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                if (variable_struct_exists(e, "secret_activation") && variable_struct_exists(e.secret_activation, "on_destroy_attempt") && e.secret_activation.on_destroy_attempt) {
                    var allowCombat = (variable_struct_exists(e.secret_activation, "allow_combat") && e.secret_activation.allow_combat);
                    var onlyOpponent = (variable_struct_exists(e.secret_activation, "only_if_opponent") && e.secret_activation.only_if_opponent);
                    if (isCombat && !allowCombat) continue;
                    if (onlyOpponent) {
                        if (sourceOwnerIsHero == ownerIsHero) continue;
                        if (instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
                            var currentIsHero = (game.player_current == 0);
                            if (ownerIsHero == currentIsHero) {
                                show_debug_message("### SecretSkip: same turn as owner; ownerIsHero=" + string(ownerIsHero));
                                continue;
                            }
                        }
                    }
                    chosenEffect = e; break;
                }
            }
            if (chosenEffect == noone) continue;

            secretPrepareActivationPresentation(id);
            
            var ctx = { target: target, source: source };
            if (variable_struct_exists(chosenEffect, "effect_type")) {
                secretExecuteEffectWithReveal(id, chosenEffect, ctx);
            }
            show_debug_message("### SecretActivated: consuming secret id=" + string(id));
            
            // Retirer le secret de la liste globale AVANT de le détruire pour éviter la boucle infinie
            var idx = ds_list_find_index(secretList, id);
            if (idx != -1) {
                ds_list_delete(secretList, idx);
                show_debug_message("### SecretActivated: removed secret from active list id=" + string(id));
            }
            
            // Appeler destroyCard avec le flag ignore_secrets=true pour éviter une récursion
            // Note: Comme on l'a déjà retiré de la liste, le risque est faible, mais par sécurité
            // on passe un contexte ou on s'assure que destroyCard ne rappelle pas activateSecretsOnDestroyAttempt
            // pour CETTE carte qui est déjà en cours de destruction.
            
            // Pour éviter la boucle infinie dans destroyCard -> activateSecretsOnDestroyAttempt -> destroyCard...
            // La solution propre est de retirer le secret de la liste (fait ci-dessus)
            // ET d'appeler destroyCard. Comme il n'est plus dans la liste, activateSecretsOnDestroyAttempt retournera false pour lui.
            destroyCard(id);
            
            if (variable_struct_exists(chosenEffect, "secret_let_destruction_proceed") && chosenEffect.secret_let_destruction_proceed) {
                return false;
            }
            return true;
        }
    }
    return false;
}

function activateSecretsOnEnemyDeath(deadCard, source = noone) {
    if (deadCard == noone || !instance_exists(deadCard)) return false;
    var deadIsHero = (variable_instance_exists(deadCard, "isHeroOwner") ? deadCard.isHeroOwner : true);
    var secretOwnerIsHero = !deadIsHero;
    var secretList = secretOwnerIsHero ? global.activeSecretsHero : global.activeSecretsEnemy;
    if (!ds_exists(secretList, ds_type_list)) return false;

    var size = ds_list_size(secretList);
    for (var k = 0; k < size; k++) {
        var secretCard = ds_list_find_value(secretList, k);
        if (!instance_exists(secretCard)) continue;

        with (secretCard) {
            if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
            if (!variable_instance_exists(self, "isHeroOwner") || isHeroOwner != secretOwnerIsHero) continue;
            if (!variable_instance_exists(self, "effects") || array_length(effects) <= 0) continue;

            var chosenEffect = noone;
            for (var i = 0; i < array_length(effects); i++) {
                var e = effects[i];
                if (!is_struct(e)) continue;
                if (variable_struct_exists(e, "secret_activation")
                    && variable_struct_exists(e.secret_activation, "on_enemy_death")
                    && e.secret_activation.on_enemy_death) {
                    var onlyOpponent = (variable_struct_exists(e.secret_activation, "only_if_opponent") && e.secret_activation.only_if_opponent);
                    if (onlyOpponent && instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
                        var currentIsHero = (game.player_current == 0);
                        if (isHeroOwner == currentIsHero) continue;
                    }
                    chosenEffect = e;
                    break;
                }
            }
            if (chosenEffect == noone) continue;

            secretPrepareActivationPresentation(id);

            var ctx = { target: deadCard, source: source };
            if (variable_struct_exists(chosenEffect, "effect_type")) {
                secretExecuteEffectWithReveal(id, chosenEffect, ctx);
            }

            var idx = ds_list_find_index(secretList, id);
            if (idx != -1) ds_list_delete(secretList, idx);
            destroyCard(id);
            return true;
        }
    }

    return false;
}
