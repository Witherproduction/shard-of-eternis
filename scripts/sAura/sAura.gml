/// Aura: fonctions utilitaires pour appliquer et nettoyer les contributions de buff


function cleanupAuraSource(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    var srcKey = "aura:" + string(card.id);
    var buffPrefix = "effect:" + string(EFFECT_BUFF) + ":" + string(card.id) + ":";
    var cname = variable_instance_exists(card, "name") ? card.name : string(card.id);
    show_debug_message("### cleanupAuraSource: removing contributions from source " + cname + " (" + srcKey + ")");
    with (oCardParent) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var isMonster2 = false;
            if (variable_instance_exists(self, "type")) {
                isMonster2 = (type == "Monster");
            } else {
                isMonster2 = object_is_ancestor(object_index, oCardMonster);
            }
            if (isMonster2) {
                buffRemoveContribution(id, srcKey);
                if (variable_instance_exists(self, "protection_sources") && is_array(self.protection_sources)) {
                    var filteredProt = [];
                    var lenPS = array_length(self.protection_sources);
                    var i2 = 0;
                    for (i2 = 0; i2 < lenPS; i2++) {
                        var pk = string(self.protection_sources[i2]);
                        if (pk != srcKey) { array_push(filteredProt, pk); }
                    }
                    self.protection_sources = filteredProt;
                    if (array_length(self.protection_sources) <= 0) { if (variable_instance_exists(self, "protection_from_destroy")) self.protection_from_destroy = false; }
                }
                if (variable_instance_exists(self, "buff_contribs")) {
                    var filtered = [];
                    for (var i = 0; i < array_length(self.buff_contribs); i++) {
                        var c = self.buff_contribs[i];
                        if (is_struct(c) && variable_struct_exists(c, "key")) {
                            var k = string(c.key);
                            if (string_pos(buffPrefix, k) == 1) {
                                continue;
                            }
                        }
                        array_push(filtered, c);
                    }
                    self.buff_contribs = filtered;
                }
                if (variable_instance_exists(self, "damage_reduction_sources") && is_array(self.damage_reduction_sources)) {
                    var filteredDR = [];
                    for (var di = 0; di < array_length(self.damage_reduction_sources); di++) {
                        var d0 = self.damage_reduction_sources[di];
                        if (is_struct(d0) && variable_struct_exists(d0, "key") && string(d0.key) == srcKey) {
                            continue;
                        }
                        array_push(filteredDR, d0);
                    }
                    self.damage_reduction_sources = filteredDR;
                    var sumDR = 0;
                    for (var dj = 0; dj < array_length(self.damage_reduction_sources); dj++) {
                        var d1 = self.damage_reduction_sources[dj];
                        if (is_struct(d1) && variable_struct_exists(d1, "amount")) { sumDR += d1.amount; }
                    }
                    self.damage_reduction = sumDR;
                }
                if (variable_instance_exists(self, "damage_taken_bonus_sources") && is_array(self.damage_taken_bonus_sources)) {
                    var filteredDT = [];
                    for (var ti = 0; ti < array_length(self.damage_taken_bonus_sources); ti++) {
                        var t0 = self.damage_taken_bonus_sources[ti];
                        if (is_struct(t0) && variable_struct_exists(t0, "key") && string(t0.key) == srcKey) {
                            continue;
                        }
                        array_push(filteredDT, t0);
                    }
                    self.damage_taken_bonus_sources = filteredDT;
                    var sumDT = 0;
                    for (var tj = 0; tj < array_length(self.damage_taken_bonus_sources); tj++) {
                        var t1 = self.damage_taken_bonus_sources[tj];
                        if (is_struct(t1) && variable_struct_exists(t1, "amount")) { sumDT += t1.amount; }
                    }
                    self.damage_taken_bonus = sumDT;
                }
                if (variable_instance_exists(self, "damage_redirect_sources") && is_array(self.damage_redirect_sources)) {
                    var filteredRD = [];
                    for (var rdi = 0; rdi < array_length(self.damage_redirect_sources); rdi++) {
                        var r0 = self.damage_redirect_sources[rdi];
                        if (is_struct(r0) && variable_struct_exists(r0, "key") && string(r0.key) == srcKey) {
                            continue;
                        }
                        array_push(filteredRD, r0);
                    }
                    self.damage_redirect_sources = filteredRD;
                }
                buffRecompute(id);
            }
        }
    }
    return true;
}

function damageReductionSetContribution(target, key, amount) {
    if (target == noone || !instance_exists(target)) return false;
    if (!variable_instance_exists(target, "damage_reduction_sources") || !is_array(target.damage_reduction_sources)) target.damage_reduction_sources = [];
    var found = false;
    for (var i = 0; i < array_length(target.damage_reduction_sources); i++) {
        var c = target.damage_reduction_sources[i];
        if (is_struct(c) && variable_struct_exists(c, "key") && string(c.key) == key) {
            c.amount = amount;
            target.damage_reduction_sources[i] = c;
            found = true;
            break;
        }
    }
    if (!found) array_push(target.damage_reduction_sources, { key: key, amount: amount });
    var sum = 0;
    for (var j = 0; j < array_length(target.damage_reduction_sources); j++) {
        var c2 = target.damage_reduction_sources[j];
        if (is_struct(c2) && variable_struct_exists(c2, "amount")) { sum += c2.amount; }
    }
    target.damage_reduction = sum;
    return true;
}

function damageTakenBonusSetContribution(target, key, amount) {
    if (target == noone || !instance_exists(target)) return false;
    if (!variable_instance_exists(target, "damage_taken_bonus_sources") || !is_array(target.damage_taken_bonus_sources)) target.damage_taken_bonus_sources = [];
    var found = false;
    for (var i = 0; i < array_length(target.damage_taken_bonus_sources); i++) {
        var c = target.damage_taken_bonus_sources[i];
        if (is_struct(c) && variable_struct_exists(c, "key") && string(c.key) == key) {
            c.amount = amount;
            target.damage_taken_bonus_sources[i] = c;
            found = true;
            break;
        }
    }
    if (!found) array_push(target.damage_taken_bonus_sources, { key: key, amount: amount });
    var sum = 0;
    for (var j = 0; j < array_length(target.damage_taken_bonus_sources); j++) {
        var c2 = target.damage_taken_bonus_sources[j];
        if (is_struct(c2) && variable_struct_exists(c2, "amount")) { sum += c2.amount; }
    }
    target.damage_taken_bonus = sum;
    return true;
}


function applyAllMonstersAuraDebuff(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    if (!variable_instance_exists(card, "zone")) return false;
    if (!(card.zone == "Field" || card.zone == "FieldSelected")) return false;
    if (variable_instance_exists(card, "isFaceDown") && card.isFaceDown) return false;

    var atk = variable_struct_exists(effect, "atk") ? effect.atk : -500;
    var PV = variable_struct_exists(effect, "PV") ? effect.PV : -500;
    var srcKey = "aura:" + string(card.id);
    var ownerFilter = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "both";
    var frontLineOnly = (variable_struct_exists(effect, "front_line_only") && effect.front_line_only);
    var srcIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    var excludeGenres = [];
    if (variable_struct_exists(effect, "exclude_genres")) {
        if (is_array(effect.exclude_genres)) excludeGenres = effect.exclude_genres; else excludeGenres = [effect.exclude_genres];
    }

    with (oCardParent) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var isMonster = false;
            if (variable_instance_exists(self, "type")) {
                isMonster = (type == "Monster");
            } else {
                isMonster = object_is_ancestor(object_index, oCardMonster);
            }
            if (isMonster) {
                if (frontLineOnly) {
                    if (!variable_instance_exists(self, "fieldPosition")) continue;
                    if (self.fieldPosition < 0 || self.fieldPosition > 3) continue;
                }
                if (ownerFilter != "both") {
                    var tgtIsHero = (variable_instance_exists(self, "isHeroOwner") && self.isHeroOwner);
                    if (ownerFilter == "ally" && tgtIsHero != srcIsHero) continue;
                    if (ownerFilter == "enemy" && tgtIsHero == srcIsHero) continue;
                }
                var excluded = false;
                if (array_length(excludeGenres) > 0 && variable_instance_exists(self, "genre")) {
                    var g = string_lower(self.genre);
                    for (var i = 0; i < array_length(excludeGenres); i++) {
                        if (g == string_lower(string(excludeGenres[i]))) { excluded = true; break; }
                    }
                }
                if (excluded) continue;
                var auraSrcName = "";
                if (card != noone && instance_exists(card) && variable_instance_exists(card, "name")) {
                    auraSrcName = string(card.name);
                }
                buffSetContribution(id, srcKey, atk, PV, auraSrcName);
                buffRecompute(id);
            }
        }
    }
    return true;
}

function applyAllMonstersDamageReductionAura(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    if (!variable_instance_exists(card, "zone")) return false;
    if (!(card.zone == "Field" || card.zone == "FieldSelected")) return false;
    if (variable_instance_exists(card, "isFaceDown") && card.isFaceDown) return false;

    var amount = 0;
    if (variable_struct_exists(effect, "amount")) amount = effect.amount;
    else if (variable_struct_exists(effect, "value")) amount = effect.value;
    else if (variable_struct_exists(effect, "damage_reduction")) amount = effect.damage_reduction;
    amount = max(0, amount);
    var srcKey = "aura:" + string(card.id);
    var ownerFilter = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "ally";
    var srcIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);

    with (oCardParent) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var isMonster = false;
            if (variable_instance_exists(self, "type")) {
                isMonster = (type == "Monster");
            } else {
                isMonster = object_is_ancestor(object_index, oCardMonster);
            }
            if (isMonster) {
                if (ownerFilter != "both") {
                    var tgtIsHero = (variable_instance_exists(self, "isHeroOwner") && self.isHeroOwner);
                    if (ownerFilter == "ally" && tgtIsHero != srcIsHero) continue;
                    if (ownerFilter == "enemy" && tgtIsHero == srcIsHero) continue;
                }
                damageReductionSetContribution(id, srcKey, amount);
            }
        }
    }
    return true;
}

function applyAllMonstersDamageTakenBonusAura(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    if (!variable_instance_exists(card, "zone")) return false;
    if (!(card.zone == "Field" || card.zone == "FieldSelected")) return false;
    if (variable_instance_exists(card, "isFaceDown") && card.isFaceDown) return false;

    var amount = 0;
    if (variable_struct_exists(effect, "amount")) amount = effect.amount;
    else if (variable_struct_exists(effect, "value")) amount = effect.value;
    else if (variable_struct_exists(effect, "damage_taken_bonus")) amount = effect.damage_taken_bonus;
    amount = max(0, amount);
    var srcKey = "aura:" + string(card.id);
    var ownerFilter = variable_struct_exists(effect, "owner") ? string_lower(string(effect.owner)) : "enemy";
    var srcIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);

    with (oCardParent) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var isMonster = false;
            if (variable_instance_exists(self, "type")) {
                isMonster = (type == "Monster");
            } else {
                isMonster = object_is_ancestor(object_index, oCardMonster);
            }
            if (isMonster) {
                if (ownerFilter != "both") {
                    var tgtIsHero = (variable_instance_exists(self, "isHeroOwner") && self.isHeroOwner);
                    if (ownerFilter == "ally" && tgtIsHero != srcIsHero) continue;
                    if (ownerFilter == "enemy" && tgtIsHero == srcIsHero) continue;
                }
                damageTakenBonusSetContribution(id, srcKey, amount);
            }
        }
    }
    return true;
}

