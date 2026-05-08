function sEffectPoints(card, effect, context) {
    var op = "damage";
    if (variable_struct_exists(effect, "op")) op = string_lower(effect.op); else if (variable_struct_exists(effect, "operation")) op = string_lower(effect.operation);
    var scope = "lp";
    if (variable_struct_exists(effect, "scope")) scope = string_lower(effect.scope);
    var val = 0;
    if (variable_struct_exists(effect, "use_attacker_attack_as_value") && variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) {
        var att = context.attacker;
        var baseAtk = variable_instance_exists(att, "attack") ? att.attack : 0;
        if (variable_instance_exists(att, "effective_attack")) baseAtk = att.effective_attack;
        var divisor = variable_struct_exists(effect, "attack_value_divisor") ? max(1, effect.attack_value_divisor) : 1;
        val = floor(baseAtk / divisor);
    } else if (variable_struct_exists(effect, "use_defender_attack_as_value") && variable_struct_exists(context, "defender") && instance_exists(context.defender)) {
        var def = context.defender;
        var baseDefAtk = variable_instance_exists(def, "attack") ? def.attack : 0;
        if (variable_instance_exists(def, "effective_attack")) baseDefAtk = def.effective_attack;
        var divisorDef = variable_struct_exists(effect, "attack_value_divisor") ? max(1, effect.attack_value_divisor) : 1;
        val = floor(baseDefAtk / divisorDef);
    } else if (variable_struct_exists(effect, "use_target_defense_as_value") && variable_struct_exists(context, "target") && instance_exists(context.target)) {
        var tgt = context.target;
        var baseDef = variable_instance_exists(tgt, "PV") ? tgt.PV : 0;
        if (variable_instance_exists(tgt, "effective_defense")) baseDef = tgt.effective_defense;
        val = max(0, floor(baseDef));
    } else {
        if (variable_struct_exists(effect, "value")) val = effect.value; else if (variable_struct_exists(effect, "amount")) val = effect.amount; else if (variable_struct_exists(effect, "damage")) val = effect.damage; else if (variable_struct_exists(effect, "heal")) val = effect.heal;
    }
    
    // [Start] Logic for use_highest_attack_of_genre (Alpha Strike)
    if (variable_struct_exists(effect, "use_highest_attack_of_genre")) {
        var genreT = effect.use_highest_attack_of_genre;
        
        // Normalize target genre
        var genreTargetNorm = string_lower(string(genreT));
        genreTargetNorm = string_replace_all(genreTargetNorm, "ê", "e");
        genreTargetNorm = string_replace_all(genreTargetNorm, "é", "e");
        genreTargetNorm = string_replace_all(genreTargetNorm, "è", "e");
        
        var checkHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
        
        // Prioritize explicit source owner, otherwise fallback to target owner (legacy behavior)
        var ownerS = variable_struct_exists(effect, "highest_attack_source_owner") ? string_lower(effect.highest_attack_source_owner) : (variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally");
        
        var lookAtHero = (ownerS == "ally") ? checkHero : !checkHero;
        var mgr = lookAtHero ? (instance_exists(oFieldManagerHero) ? oFieldManagerHero : noone) : (instance_exists(oFieldManagerEnemy) ? oFieldManagerEnemy : noone);
        
        var highest = 0;
        if (mgr != noone) {
            var fM = mgr.getField("Monster");
            if (fM != noone) {
                for (var im = 0; im < array_length(fM.cards); im++) {
                    var cm = fM.cards[im];
                    if (cm != 0 && instance_exists(cm)) {
                         var g = variable_instance_exists(cm, "genre") ? string_lower(string(cm.genre)) : "";
                         g = string_replace_all(g, "ê", "e");
                         g = string_replace_all(g, "é", "e");
                         g = string_replace_all(g, "è", "e");

                         if (g == genreTargetNorm) {
                             var at = variable_instance_exists(cm, "attack") ? cm.attack : 0;
                             if (variable_instance_exists(cm, "effective_attack")) at = cm.effective_attack;
                             if (at > highest) highest = at;
                         }
                    }
                }
            }
        }
        val = highest;
    }
    // [End] Logic
    
    // [Start] Logic for conditional bonus value (e.g. Combo: Camouflage)
    if (variable_struct_exists(effect, "bonus_condition") && variable_struct_exists(effect, "bonus_value")) {
        var bCond = effect.bonus_condition;
        var bVal = effect.bonus_value;
        var bMet = false;
        
        if (bCond == "control_camouflaged") {
            var checkHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            var mgr = checkHero ? (instance_exists(oFieldManagerHero) ? oFieldManagerHero : noone) : (instance_exists(oFieldManagerEnemy) ? oFieldManagerEnemy : noone);
            if (mgr != noone) {
                var fM = mgr.getField("Monster");
                if (fM != noone) {
                    for (var im = 0; im < array_length(fM.cards); im++) {
                        var cm = fM.cards[im];
                        if (cm != 0 && instance_exists(cm) && variable_instance_exists(cm, "isCamouflage") && cm.isCamouflage) {
                            bMet = true;
                            break;
                        }
                    }
                }
            }
        }
        
        if (bMet) {
            if (variable_struct_exists(effect, "replace_base_value") && effect.replace_base_value) {
                val = bVal;
            } else {
                val += bVal;
            }
        }
    }
    // [End] Logic

    var ownerSide = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "ally";
    if (variable_struct_exists(effect, "affect_opponent_lp") && effect.affect_opponent_lp) ownerSide = "enemy";
    var srcHero = (card != noone && instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
    var cond = variable_struct_exists(effect, "conditions") ? effect.conditions : noone;
    if (cond != noone) {
        if (variable_struct_exists(cond, "phase")) {
            var curPhase = instance_exists(game) ? game.phase[game.phase_current] : "";
            if (curPhase != cond.phase) { return false; }
        }
        if (variable_struct_exists(cond, "min_lp")) {
            var lpInstMin = noone;
            if (ownerSide == "ally") { lpInstMin = srcHero ? instance_find(oLP_Hero, 0) : instance_find(oLP_Enemy, 0); }
            else if (ownerSide == "enemy") { lpInstMin = srcHero ? instance_find(oLP_Enemy, 0) : instance_find(oLP_Hero, 0); }
            if (lpInstMin == noone || lpInstMin.nbLP < cond.min_lp) { return false; }
        }
        if (variable_struct_exists(cond, "max_lp")) {
            var lpInstMax = noone;
            if (ownerSide == "ally") { lpInstMax = srcHero ? instance_find(oLP_Hero, 0) : instance_find(oLP_Enemy, 0); }
            else if (ownerSide == "enemy") { lpInstMax = srcHero ? instance_find(oLP_Enemy, 0) : instance_find(oLP_Hero, 0); }
            if (lpInstMax == noone || lpInstMax.nbLP > cond.max_lp) { return false; }
        }
    }
    if (scope == "lp") {
        var perVal = 0;
        if (variable_struct_exists(effect, "value_per_card")) perVal = effect.value_per_card;
        else if (variable_struct_exists(effect, "damage_per_card")) perVal = effect.damage_per_card;
        else if (variable_struct_exists(effect, "heal_per_card")) perVal = effect.heal_per_card;
        if (perVal > 0) {
            var effCount = {};
            effCount.target_zone = variable_struct_exists(effect, "target_zone") ? effect.target_zone : "field";
            effCount.criteria = variable_struct_exists(effect, "criteria") ? effect.criteria : {};
            var countOwner = ownerSide;
            if (variable_struct_exists(effect, "count_owner")) countOwner = string_lower(effect.count_owner);
            if (countOwner == "ally") { effCount.owner = srcHero ? "hero" : "enemy"; }
            else if (countOwner == "enemy") { effCount.owner = srcHero ? "enemy" : "hero"; }
            else { effCount.owner = "both"; }
            var arrC = getTargetsByFilter(effCount);
            val = perVal * array_length(arrC);
        }
        var tgtHero = srcHero;
        if (ownerSide == "ally") { tgtHero = srcHero; }
        else if (ownerSide == "enemy") { tgtHero = !srcHero; }
        if (op == "damage") {
            var elem = "neutre";
            if (variable_struct_exists(effect, "element")) elem = string_lower(effect.element);
            else if (card != noone && instance_exists(card) && variable_instance_exists(card, "element")) elem = string_lower(card.element);
            
            // Resolve target instance for FX
            var targetInstance = noone;
            if (tgtHero) { // Hero or Ally
                 targetInstance = instance_find(oLP_Hero, 0);
            } else { // Enemy
                 targetInstance = instance_find(oLP_Enemy, 0);
            }
            
            // Define callback to apply damage at impact
            var damageCallback = method({targetIsHero: tgtHero, value: val, card: card, srcHero: srcHero}, function() {
                if (!is_undefined(loseLPFor)) { loseLPFor(targetIsHero, value); }
                if (!is_undefined(cardHasPonction) && !is_undefined(gainLPFor) && value > 0 && cardHasPonction(card)) {
                    gainLPFor(srcHero, value);
                }
            });

            if (!is_undefined(animEffectRequestProjectileTarget) && targetInstance != noone) {
                animEffectRequestProjectileTarget(elem, card, targetInstance, val, damageCallback);
            } else {
                // Fallback: apply damage immediately
                damageCallback();
            }
            return true;
        }
        else { return gainLPFor(tgtHero, val); }
    } else {
        var selectMode = variable_struct_exists(effect, "select_mode") ? string_lower(effect.select_mode) : "filter";
        var selectAll = variable_struct_exists(effect, "select_all") ? effect.select_all : false;
        var targetLocal = noone;
        if (selectMode == "self") { targetLocal = card; }
        else if (selectMode == "target") {
            if (variable_struct_exists(context, "target") && instance_exists(context.target)) { targetLocal = context.target; }
            else if (variable_struct_exists(effect, "target") && instance_exists(effect.target)) { targetLocal = effect.target; }
        }
        if (targetLocal != noone) {
            if (op == "damage") { 
                var elem = "neutre";
                if (variable_struct_exists(effect, "element")) elem = string_lower(effect.element);
                else if (card != noone && instance_exists(card) && variable_instance_exists(card, "element")) elem = string_lower(card.element);
                
                // Définition du callback pour appliquer les dégâts à l'impact
                var damageCallback = method({target: targetLocal, value: val, card: card}, function() {
                    if (target != noone && instance_exists(target)) {
                         damageCard(target, value, card);
                    }
                });

                if (!is_undefined(animEffectRequestProjectileTarget)) { 
                    animEffectRequestProjectileTarget(elem, card, targetLocal, val, damageCallback); 
                } else {
                    damageCard(targetLocal, val, card);
                }
                return true; // Retourne true car l'effet est initié (visuellement ou immédiatement)
            } else { return healCard(targetLocal, val); }
        } else {
            var effOwner = ownerSide;
            if (effOwner == "ally") {
                if (srcHero) effect.owner = "hero"; else effect.owner = "enemy";
            } else if (effOwner == "enemy") {
                if (srcHero) effect.owner = "enemy"; else effect.owner = "hero";
            }
            var targetsArr = getTargetsByFilter(effect);
            if (array_length(targetsArr) <= 0) { return false; }
            if (selectAll) {
                for (var ipe = 0; ipe < array_length(targetsArr); ipe++) { if (op == "damage") { damageCard(targetsArr[ipe], val, card); } else { healCard(targetsArr[ipe], val); } }
                return true;
            } else {
                var cnt = 1;
                if (variable_struct_exists(effect, "count")) cnt = effect.count;
                var n = min(cnt, array_length(targetsArr));
                for (var jpe = 0; jpe < n; jpe++) { if (op == "damage") { damageCard(targetsArr[jpe], val, card); } else { healCard(targetsArr[jpe], val); } }
                return true;
            }
        }
    }
}
