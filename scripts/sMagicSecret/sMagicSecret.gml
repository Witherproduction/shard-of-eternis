function sMagicSecret() {
    // Initialisation du module des secrets (placeholder)
}

function activateSecretsOnDirectAttack(attacker, targetSecretCard = noone) {
    if (!instance_exists(attacker)) return noone;
    var attackerIsHero = variable_instance_exists(attacker, "isHeroOwner") ? attacker.isHeroOwner : true;
    var defendingIsHero = !attackerIsHero;
    var effAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : (variable_instance_exists(attacker, "attack") ? attacker.attack : 0);

    // Ensemble des noms de secrets déjà activés pendant cette attaque
    var activatedNames = [];
    var redirectDefender = noone;
    
    // Parcourir toutes les cartes Magie (incluant les objets enfants de oCardMagic)
    with (all) {
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "type") || type != "Magic") continue;
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "zone") || zone != "Field") continue;
        if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
        // Si une carte précise est ciblée (séquence FX_Combat), ne pas exiger face cachée
        if (targetSecretCard == noone) {
            if (!variable_instance_exists(self, "isFaceDown") || !isFaceDown) continue;
        } else {
            // Restreindre au seul secret ciblé
            if (id != targetSecretCard) continue;
        }
        if (!variable_instance_exists(self, "isHeroOwner") || isHeroOwner != defendingIsHero) continue;
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
        
        // Clé de déduplication: le nom canonique de la carte
        var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
        var alreadyActivated = false;
        for (var j = 0; j < array_length(activatedNames); j++) {
            if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
        }
        if (alreadyActivated) {
            // Un exemplaire identique a déjà été activé; ignorer cette copie
            continue;
        }
        array_push(activatedNames, cardName);
        
        // Révéler la carte (si pas déjà retournée par l'animation)
        isFaceDown = false;
        image_index = 0;
        
        // Calcul des dégâts et préparation du contexte (n'ajouter 'value' que si demandé)
        var useAtkVal = (variable_struct_exists(chosenEffect, "use_attacker_attack_as_value") && chosenEffect.use_attacker_attack_as_value);
        var dmg = 0;
        if (useAtkVal) {
            dmg = effAtk;
            // Support fraction/multiplicateur éventuel
            if (variable_struct_exists(chosenEffect, "attack_value_divisor") && is_real(chosenEffect.attack_value_divisor) && chosenEffect.attack_value_divisor > 1) {
                dmg = floor(dmg / chosenEffect.attack_value_divisor);
            } else if (variable_struct_exists(chosenEffect, "attack_value_ratio") && is_real(chosenEffect.attack_value_ratio)) {
                dmg = floor(dmg * chosenEffect.attack_value_ratio);
            }
        }
        
        // Préparer le contexte sans 'value' par défaut pour ne pas écraser effect.value
        var ctx = { attacker: attacker, defender: noone };
        if (useAtkVal) { ctx.value = dmg; }

        // Résoudre la cible à partir de target_source si présent
        if (variable_struct_exists(chosenEffect, "target_source")) {
            var ts = chosenEffect.target_source;
            if (ts == "attacker") ctx.target = attacker;
            else if (ts == "defender") ctx.target = noone;
        }
        
        // Si l'effet affecte les LP de l'adversaire, configurer owner_is_hero
        if (variable_struct_exists(chosenEffect, "affect_opponent_lp") && chosenEffect.affect_opponent_lp) {
            ctx.owner_is_hero = !defendingIsHero; // Cibler l'adversaire
        }
        
        // Phase 1.5: Migration Command Pattern
        // Recherche de l'index de l'effet
        var effIndex = -1;
        if (variable_instance_exists(self, "effects") && is_array(effects)) {
            for(var k=0; k<array_length(effects); k++) {
                if (effects[k] == chosenEffect) { effIndex = k; break; }
            }
        }
        
        if (effIndex != -1 && variable_instance_exists(self, "instance_uid")) {
             var payload = {
                 source_uid: self.instance_uid,
                 effect_index: effIndex
             };
             // Ajouter cibles contextuelles si besoin (mais ctx est complexe ici)
             // Note: RequestGameAction ne prend pas un 'ctx' arbitraire, mais le reconstruira.
             // ATTENTION: Le 'ctx' calculé ici (useAtkVal, target_source) doit être reproduit par executeEffect.
             // executeEffect le fait déjà (il recalcule value si non fournie, target si target_source).
             // Mais si on a passé une 'value' explicite (dmg), on doit la passer dans payload?
             // Le contrôleur ne supporte pas encore 'custom_context_value' dans payload.
             // Pour l'instant, on passe 'target_uid' si 'ctx.target' est défini.
             if (variable_struct_exists(ctx, "target") && ctx.target != noone && instance_exists(ctx.target) && variable_instance_exists(ctx.target, "instance_uid")) {
                 payload.target_uid = ctx.target.instance_uid;
             }
             
             RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
             
             // NOTE: La redirection (redirectDefender) est maintenant gérée par global.combat_redirect_defender
             // rempli par le contrôleur.
             
        } else {
            // Fallback Legacy
            executeEffect(self, chosenEffect, ctx);
            
            // Si l'effet demande une redirection vers l'instance invoquée, l'utiliser comme nouveau défenseur
            if (variable_struct_exists(chosenEffect, "redirect_attack_to_summoned") && chosenEffect.redirect_attack_to_summoned) {
                if (variable_struct_exists(ctx, "summoned") && ctx.summoned != noone && instance_exists(ctx.summoned)) {
                    redirectDefender = ctx.summoned;
                }
            }
            
            // Consommer la carte Secret après activation (uniquement en fallback, sinon géré par sSpellUtils/Controller)
            destroyCard(id);
        }
    }
    
    return redirectDefender;
}

// Activation des Secrets sur toute attaque (non-directe ou directe via on_attack)
function activateSecretsOnAttack(attacker, defender) {
    if (!instance_exists(attacker)) return;
    var attackerIsHero = variable_instance_exists(attacker, "isHeroOwner") ? attacker.isHeroOwner : true;
    var defendingIsHero = !attackerIsHero;
    var effAtk = variable_instance_exists(attacker, "effective_attack") ? attacker.effective_attack : (variable_instance_exists(attacker, "attack") ? attacker.attack : 0);

    var activatedNames = [];
    // Parcourir toutes les cartes Magie (incluant les objets enfants de oCardMagic)
    with (all) {
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "type") || type != "Magic") continue;
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "zone") || zone != "Field") continue;
        if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
        if (!variable_instance_exists(self, "isFaceDown") || !isFaceDown) continue;
        if (!variable_instance_exists(self, "isHeroOwner") || isHeroOwner != defendingIsHero) continue;
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

        var cardName = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
        var alreadyActivated = false;
        for (var j = 0; j < array_length(activatedNames); j++) {
            if (activatedNames[j] == cardName) { alreadyActivated = true; break; }
        }
        if (alreadyActivated) continue;
        array_push(activatedNames, cardName);

        // Révéler la carte
        isFaceDown = false;
        image_index = 0;

        // Calcul des dégâts (n'ajouter 'value' que si demandé)
        var useAtkVal2 = (variable_struct_exists(chosenEffect, "use_attacker_attack_as_value") && chosenEffect.use_attacker_attack_as_value);
        var dmg = 0;
        if (useAtkVal2) {
            dmg = effAtk;
            // Support fraction/multiplicateur: moitié d’ATK via attack_value_divisor=2 ou ratio
            if (variable_struct_exists(chosenEffect, "attack_value_divisor") && is_real(chosenEffect.attack_value_divisor) && chosenEffect.attack_value_divisor > 1) {
                dmg = floor(dmg / chosenEffect.attack_value_divisor);
            } else if (variable_struct_exists(chosenEffect, "attack_value_ratio") && is_real(chosenEffect.attack_value_ratio)) {
                dmg = floor(dmg * chosenEffect.attack_value_ratio);
            }
        }

        // Préparer le contexte; ne pas inclure 'value' si non utilisé pour ne pas écraser effect.value
        var ctx = { attacker: attacker, defender: defender };
        if (useAtkVal2) { ctx.value = dmg; }
        if (variable_struct_exists(chosenEffect, "target_source")) {
            var ts = chosenEffect.target_source;
            if (ts == "attacker") ctx.target = attacker;
            else if (ts == "defender") ctx.target = defender;
        }
        
        // Si l'effet affecte les LP de l'adversaire, configurer owner_is_hero
        if (variable_struct_exists(chosenEffect, "affect_opponent_lp") && chosenEffect.affect_opponent_lp) {
            ctx.owner_is_hero = !defendingIsHero; // Cibler l'adversaire
        }
        
        // Phase 1.5: Migration Command Pattern
        var effIndex = -1;
        if (variable_instance_exists(self, "effects") && is_array(effects)) {
            for(var k=0; k<array_length(effects); k++) {
                if (effects[k] == chosenEffect) { effIndex = k; break; }
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
            executeEffect(self, chosenEffect, ctx);
            // Consommer la carte Secret après activation
            destroyCard(id);
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
    // Parcourir toutes les cartes Magie (incluant les objets enfants de oCardMagic)
    with (all) {
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "type") || type != "Magic") continue;
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "zone") || zone != "Field") continue;
        if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
        if (!variable_instance_exists(self, "isFaceDown") || !isFaceDown) {
            var nm_fd = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            show_debug_message("### Secrets: skip '" + string(nm_fd) + "' (pas face cachée)");
            continue;
        }
        if (!variable_instance_exists(self, "isHeroOwner") || isHeroOwner != defendingIsHero) {
            var nm_own = variable_instance_exists(self, "name") ? self.name : object_get_name(object_index);
            show_debug_message("### Secrets: skip '" + string(nm_own) + "' (mauvais propriétaire)");
            continue;
        }
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

        // Révéler la carte
        isFaceDown = false;
        image_index = 0;

        var etype = variable_struct_exists(chosenEffect, "effect_type") ? chosenEffect.effect_type : "unknown";
        show_debug_message("### Secrets: activation '" + string(cardName) + "' sur '" + string(summonedName) + "' (effet=" + string(etype) + ")");

        var ctx = { source: summoned };
        if (variable_struct_exists(chosenEffect, "target_source")) {
            var ts = chosenEffect.target_source;
            if (ts == "summoned") ctx.target = summoned;
        }
        
        // Phase 1.5: Migration Command Pattern
        var effIndex = -1;
        if (variable_instance_exists(self, "effects") && is_array(effects)) {
            for(var k=0; k<array_length(effects); k++) {
                if (effects[k] == chosenEffect) { effIndex = k; break; }
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
            var ok = executeEffect(self, chosenEffect, ctx);
            show_debug_message("### Secrets: effet exécuté=" + string(ok) + "; destruction");
            // Consommer la carte Secret après activation
            destroyCard(id);
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
    // Amélioration de la détection du propriétaire de la source
    var sourceOwnerIsHero = ownerIsHero;
    if (source != noone && instance_exists(source)) {
        if (variable_instance_exists(source, "isHeroOwner")) {
            sourceOwnerIsHero = source.isHeroOwner;
        } else if (variable_instance_exists(source, "is_player_card")) {
            sourceOwnerIsHero = source.is_player_card;
        } else {
            // Fallback : si la source existe mais n'a pas d'allégeance, déduire via tour courant
            if (instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
                var currentIsHero = (game.player[game.player_current] == "Hero");
                if (currentIsHero != ownerIsHero) {
                    sourceOwnerIsHero = !ownerIsHero;
                }
            }
        }
    } else {
        // Fallback : si la source n'existe plus (ex. détruite avant), déduire via tour courant
        if (instance_exists(game) && variable_instance_exists(game, "player") && variable_instance_exists(game, "player_current")) {
            var currentIsHero = (game.player[game.player_current] == "Hero");
            if (currentIsHero != ownerIsHero) {
                sourceOwnerIsHero = !ownerIsHero;
            }
        }
    }

    show_debug_message("### SecretDestroyAttempt: ownerIsHero=" + string(ownerIsHero) + " sourceOwnerIsHero=" + string(sourceOwnerIsHero) + " isCombat=" + string(isCombat));

    with (all) {
        if (!instance_exists(id)) continue;
        if (!variable_instance_exists(self, "type") || type != "Magic") continue;
        if (!variable_instance_exists(self, "zone") || (zone != "Field" && zone != "FieldSelected")) continue;
        if (!variable_instance_exists(self, "genre") || string_lower(genre) != string_lower("Secret")) continue;
        if (!variable_instance_exists(self, "isFaceDown") || !isFaceDown) continue;
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
                        var currentIsHero = (game.player[game.player_current] == "Hero");
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

        isFaceDown = false;
        image_index = 0;
        var ctx = { target: target, source: source };
        if (variable_struct_exists(chosenEffect, "effect_type")) {
            executeEffect(self, chosenEffect, ctx);
        }
        show_debug_message("### SecretActivated: consuming secret id=" + string(id));
        destroyCard(id);
        return true;
    }
    return false;
}
