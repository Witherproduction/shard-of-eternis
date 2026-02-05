/// Utilitaires d’agrégation de buffs pour éviter les écrasements

function buffEnsure(target) {
    if (target == noone || !instance_exists(target)) return false;
    if (!variable_instance_exists(target, "buff_contribs")) {
        target.buff_contribs = [];
    }
    if (!variable_instance_exists(target, "effective_attack")) {
        target.effective_attack = target.attack;
    }
    if (!variable_instance_exists(target, "effective_defense")) {
        target.effective_defense = target.PV;
    }
    return true;
}

function buffSetContribution(target, source_key, atk_delta, def_delta) {
    if (target == noone || !instance_exists(target)) return false;
    buffEnsure(target);
    var idxFound = -1;
    for (var i = 0; i < array_length(target.buff_contribs); i++) {
        var c = target.buff_contribs[i];
        if (is_struct(c) && variable_struct_exists(c, "key") && c.key == source_key) {
            idxFound = i; break;
        }
    }
    var entry = { key: source_key, atk: atk_delta, PV: def_delta };
    if (idxFound >= 0) {
        target.buff_contribs[idxFound] = entry;
    } else {
        array_push(target.buff_contribs, entry);
    }
    return true;
}

function buffRemoveContribution(target, source_key) {
    if (target == noone || !instance_exists(target)) return false;
    if (!variable_instance_exists(target, "buff_contribs")) return true;
    var filtered = [];
    for (var i = 0; i < array_length(target.buff_contribs); i++) {
        var c = target.buff_contribs[i];
        if (!(is_struct(c) && variable_struct_exists(c, "key") && c.key == source_key)) {
            array_push(filtered, c);
        }
    }
    target.buff_contribs = filtered;
    return true;
}

function buffRecompute(target) {
    if (target == noone || !instance_exists(target)) return false;
    buffEnsure(target);
    var totalAtk = 0;
    var totalDef = 0;
    for (var i = 0; i < array_length(target.buff_contribs); i++) {
        var c = target.buff_contribs[i];
        if (is_struct(c)) {
            var a = variable_struct_exists(c, "atk") ? c.atk : 0;
            var d = variable_struct_exists(c, "PV") ? c.PV : 0;
            totalAtk += a;
            totalDef += d;
        }
    }
    // Clamp: les stats effectives ne doivent jamais descendre sous 0
    var tempAtk = variable_instance_exists(target, "temp_attack") ? target.temp_attack : 0;
    var tempDef = variable_instance_exists(target, "temp_defense") ? target.temp_defense : 0;
    
    target.effective_attack = max(0, target.attack + totalAtk + tempAtk);
    target.effective_defense = max(0, target.PV + totalDef + tempDef);
    return true;
}
