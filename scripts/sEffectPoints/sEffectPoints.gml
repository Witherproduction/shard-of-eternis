function sEffectPoints(card, effect, context) {
    var op = "damage";
    if (variable_struct_exists(effect, "op")) op = string_lower(effect.op); else if (variable_struct_exists(effect, "operation")) op = string_lower(effect.operation);
    var scope = "lp";
    if (variable_struct_exists(effect, "scope")) scope = string_lower(effect.scope);
    var val = 0;
    if (variable_struct_exists(effect, "use_attacker_attack_as_value") && variable_struct_exists(context, "attacker") && instance_exists(context.attacker)) {
        var att = context.attacker;
        var baseAtk = variable_instance_exists(att, "attack") ? att.attack : 0;
        var divisor = variable_struct_exists(effect, "attack_value_divisor") ? max(1, effect.attack_value_divisor) : 1;
        val = floor(baseAtk / divisor);
    } else {
        if (variable_struct_exists(effect, "value")) val = effect.value; else if (variable_struct_exists(effect, "amount")) val = effect.amount; else if (variable_struct_exists(effect, "damage")) val = effect.damage; else if (variable_struct_exists(effect, "heal")) val = effect.heal;
    }
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
            var elem = (card != noone && instance_exists(card) && variable_instance_exists(card, "element")) ? string_lower(card.element) : "neutre";
            if (!is_undefined(animEffectRequestProjectile)) animEffectRequestProjectile(elem, card, val, tgtHero);
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
            if (op == "damage") { return damageCard(targetLocal, val); } else { return healCard(targetLocal, val); }
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
                for (var ipe = 0; ipe < array_length(targetsArr); ipe++) { if (op == "damage") { damageCard(targetsArr[ipe], val); } else { healCard(targetsArr[ipe], val); } }
                return true;
            } else {
                var cnt = 1;
                if (variable_struct_exists(effect, "count")) cnt = effect.count;
                var n = min(cnt, array_length(targetsArr));
                for (var jpe = 0; jpe < n; jpe++) { if (op == "damage") { damageCard(targetsArr[jpe], val); } else { healCard(targetsArr[jpe], val); } }
                return true;
            }
        }
    }
    return false;
}