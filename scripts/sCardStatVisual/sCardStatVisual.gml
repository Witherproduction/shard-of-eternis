/// @description Particules / orbes stats + icônes capacités (purge, combat, brisé)

#macro CARD_STAT_COL_BUFF make_color_rgb(70, 255, 110)
#macro CARD_STAT_COL_DEBUFF make_color_rgb(255, 55, 55)

/// @function cardStatModGetDeltas(card)
/// Compare les stats effectives aux valeurs imprimées (original_*), pas aux champs attack/PV
/// qui peuvent déjà inclure des buffs permanents (ex. Cri de la meute via modifyAttack).
function cardStatModGetDeltas(_card) {
    var out = { atk: 0, def: 0, has_atk: false, has_def: false };
    if (_card == noone || !instance_exists(_card)) return out;

    if (variable_instance_exists(_card, "effective_attack")) {
        var baseA = _card.attack;
        if (variable_instance_exists(_card, "original_attack")) baseA = _card.original_attack;
        var effA = _card.effective_attack;
        if (effA == 0 && baseA > 0) effA = baseA;
        out.atk = effA - baseA;
        out.has_atk = (out.atk != 0);
    }

    if (variable_instance_exists(_card, "effective_defense")) {
        var baseD = _card.PV;
        if (variable_instance_exists(_card, "original_PV")) baseD = _card.original_PV;
        var effD = _card.effective_defense;
        if (effD == 0 && baseD > 0) effD = baseD;
        out.def = effD - baseD;
        out.has_def = (out.def != 0);
    }

    return out;
}

/// @function cardStatModLocalToWorld(card, lx, ly, tlx, tly, s)
function cardStatModLocalToWorld(_card, _lx, _ly, _tlx, _tly, _s) {
    var ox = _tlx + _lx * _s;
    var oy = _tly + _ly * _s;
    if (!variable_instance_exists(_card, "image_angle") || _card.image_angle == 0) {
        return [ox, oy];
    }
    var ang = _card.image_angle;
    var rad = degtorad(ang);
    var dx = ox - _card.x;
    var dy = oy - _card.y;
    var ca = cos(rad);
    var sa = sin(rad);
    return [_card.x + dx * ca - dy * sa, _card.y + dx * sa + dy * ca];
}

/// @function cardStatModDrawEdgeParticles(cx, cy, cardW, cardH, direction, col, timer)
/// @param {real} direction 1 = monte (buff), -1 = descend (malus)
function cardStatModDrawEdgeParticles(_cx, _cy, _cardW, _cardH, _direction, _col, _timer) {
    gpu_set_blendmode(bm_add);
    var slots = 3;
    for (var i = 0; i < slots; i++) {
        var phase = ((_timer + i * 20) % 60) / 60;
        var pY;
        if (_direction > 0) {
            pY = _cy + _cardH * 0.5 - (_cardH * phase);
        } else {
            pY = _cy - _cardH * 0.5 + (_cardH * phase);
        }
        var wobble = sin(pY * 0.1 + i) * 5;
        var pX_L = _cx - _cardW * 0.5 + wobble;
        var pX_R = _cx + _cardW * 0.5 - wobble;
        var r = max(2, _cardW * 0.02);
        draw_circle_color(pX_L, pY, r, _col, c_black, false);
        draw_circle_color(pX_R, pY, r, _col, c_black, false);
    }
    gpu_set_blendmode(bm_normal);
}

/// @function cardStatModDrawOrb(wx, wy, col, timer, scale)
function cardStatModDrawOrb(_wx, _wy, _col, _timer, _scale) {
    var pulse = 0.65 + 0.35 * sin(_timer * 0.12);
    var r = max(4, 7 * _scale) * (0.9 + 0.15 * sin(_timer * 0.08));
    gpu_set_blendmode(bm_add);
    draw_set_alpha(pulse * 0.85);
    draw_circle_color(_wx, _wy, r, _col, c_black, false);
    draw_set_alpha(pulse * 0.35);
    draw_circle_color(_wx, _wy, r * 1.45, _col, c_black, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

/// @function drawCardStatModifierVisual(card)
function drawCardStatModifierVisual(_card) {
    if (_card == noone || !instance_exists(_card)) return;
    if (!variable_instance_exists(_card, "zone")) return;
    if (!(_card.zone == "Field" || _card.zone == "FieldSelected")) return;
    if (!variable_instance_exists(_card, "type") || _card.type != "Monster") return;
    if (variable_instance_exists(_card, "isFaceDown") && _card.isFaceDown) return;
    if (variable_instance_exists(_card, "isTerrain") && _card.isTerrain) return;

    var d = cardStatModGetDeltas(_card);
    if (!d.has_atk && !d.has_def) return;

    var atkPos = (d.atk > 0);
    var atkNeg = (d.atk < 0);
    var defPos = (d.def > 0);
    var defNeg = (d.def < 0);

    var spr = _card.sprite_index;
    if (!sprite_exists(spr)) return;
    var sc = _card.image_xscale;
    var cw = sprite_get_width(spr) * sc;
    var ch = sprite_get_height(spr) * sc;
    if (cw <= 0 || ch <= 0) return;

    var tlx = _card.x - cw * 0.5;
    var tly = _card.y - ch * 0.5;
    var timer = (variable_instance_exists(_card, "statModAnimTimer") ? _card.statModAnimTimer : 0);

    if (!variable_global_exists("card_layout")) return;
    var layout = global.card_layout;
    var atk_lx = (layout.atk.x1 + layout.atk.x2) * 0.5;
    var atk_ly = (layout.atk.y1 + layout.atk.y2) * 0.5;
    var hp_lx = (layout.hp.x1 + layout.hp.x2) * 0.5;
    var hp_ly = (layout.hp.y1 + layout.hp.y2) * 0.5;

    var atkW = cardStatModLocalToWorld(_card, atk_lx, atk_ly, tlx, tly, sc);
    var hpW = cardStatModLocalToWorld(_card, hp_lx, hp_ly, tlx, tly, sc);

    // ATK = côté booster (gauche), PV = côté affaibli (droite)
    if (d.has_atk && d.has_def) {
        if (atkPos && defPos) {
            cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, 1, CARD_STAT_COL_BUFF, timer);
        } else if (atkNeg && defNeg) {
            cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, -1, CARD_STAT_COL_DEBUFF, timer);
        } else {
            if (atkPos) cardStatModDrawOrb(atkW[0], atkW[1], CARD_STAT_COL_BUFF, timer, sc);
            else if (atkNeg) cardStatModDrawOrb(atkW[0], atkW[1], CARD_STAT_COL_DEBUFF, timer, sc);
            if (defPos) cardStatModDrawOrb(hpW[0], hpW[1], CARD_STAT_COL_BUFF, timer, sc);
            else if (defNeg) cardStatModDrawOrb(hpW[0], hpW[1], CARD_STAT_COL_DEBUFF, timer, sc);
        }
        return;
    }

    if (d.has_atk) {
        if (atkPos) cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, 1, CARD_STAT_COL_BUFF, timer);
        else if (atkNeg) cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, -1, CARD_STAT_COL_DEBUFF, timer);
        return;
    }

    if (d.has_def) {
        if (defPos) cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, 1, CARD_STAT_COL_BUFF, timer);
        else if (defNeg) cardStatModDrawEdgeParticles(_card.x, _card.y, cw, ch, -1, CARD_STAT_COL_DEBUFF, timer);
    }
}

// --- Icônes capacités (centre ATK–PV) ---

/// @function cardAbilityTagMatch(card, keywords)
function cardAbilityTagMatch(_card, _keywords) {
    if (!is_array(_keywords)) return false;
    if (variable_instance_exists(_card, "tags") && is_array(_card.tags)) {
        for (var i = 0; i < array_length(_card.tags); i++) {
            var t = string_lower(string(_card.tags[i]));
            for (var k = 0; k < array_length(_keywords); k++) {
                if (t == string_lower(string(_keywords[k]))) return true;
            }
        }
    }
    if (variable_instance_exists(_card, "tags") && is_string(_card.tags)) {
        var ts = string_lower(_card.tags);
        for (var j = 0; j < array_length(_keywords); j++) {
            if (string_pos(string_lower(string(_keywords[j])), ts) > 0) return true;
        }
    }
    return false;
}

/// @function cardIsPurged(card)
function cardIsPurged(_card) {
    if (_card == noone || !instance_exists(_card)) return false;
    return (variable_instance_exists(_card, "is_purged") && _card.is_purged);
}

/// @function cardHasCombatAbilityIcon(card)
/// @description Charge, Percée, Repoussement (pas Éveil — joué depuis la main)
function cardHasCombatAbilityIcon(_card) {
    if (_card == noone || !instance_exists(_card)) return false;
    if (cardIsPurged(_card)) return false;

    if (variable_instance_exists(_card, "has_charge") && _card.has_charge) return true;
    if (variable_instance_exists(_card, "isPercee") && _card.isPercee) return true;
    if (variable_instance_exists(_card, "hasRepoussement") && _card.hasRepoussement) return true;
    if (variable_instance_exists(_card, "isRepoussement") && _card.isRepoussement) return true;

    if (cardAbilityTagMatch(_card, ["charge", "percee", "percée", "repoussement"])) return true;

    if (variable_instance_exists(_card, "description")) {
        var desc = string_lower(string(_card.description));
        if (string_pos("percée", desc) > 0 || string_pos("percee", desc) > 0) return true;
        if (string_pos("repoussement", desc) > 0) return true;
    }

    return false;
}

/// @function cardHasBriseAbilityIcon(card)
function cardHasBriseAbilityIcon(_card) {
    if (_card == noone || !instance_exists(_card)) return false;
    if (cardIsPurged(_card)) return false;
    if (cardHasCombatAbilityIcon(_card)) return false;

    if (cardAbilityTagMatch(_card, ["brisé", "brise", "tombe"])) return true;

    if (variable_instance_exists(_card, "effects") && is_array(_card.effects)) {
        for (var i = 0; i < array_length(_card.effects); i++) {
            var eff = _card.effects[i];
            if (!is_struct(eff)) continue;
            if (variable_struct_exists(eff, "negated") && eff.negated) continue;
            var trig = variable_struct_exists(eff, "trigger") ? string_lower(string(eff.trigger)) : "";
            if (trig == TRIGGER_ON_DESTROY || trig == "on_destroy" || trig == "on_graveyard" || trig == TRIGGER_ENTER_GRAVEYARD) {
                return true;
            }
        }
    }

    if (variable_instance_exists(_card, "description")) {
        var d = string_lower(string(_card.description));
        if (string_pos("brisé", d) > 0 || string_pos("brise", d) > 0) return true;
    }

    return false;
}

/// @function cardAbilityIconGetCenter(card)
function cardAbilityIconGetCenter(_card) {
    if (!variable_global_exists("card_layout")) return undefined;
    var spr = _card.sprite_index;
    if (!sprite_exists(spr)) return undefined;
    var sc = _card.image_xscale;
    var cw = sprite_get_width(spr) * sc;
    var ch = sprite_get_height(spr) * sc;
    var tlx = _card.x - cw * 0.5;
    var tly = _card.y - ch * 0.5;
    var layout = global.card_layout;
    var atk_lx = (layout.atk.x1 + layout.atk.x2) * 0.5;
    var atk_ly = (layout.atk.y1 + layout.atk.y2) * 0.5;
    var hp_lx = (layout.hp.x1 + layout.hp.x2) * 0.5;
    var hp_ly = (layout.hp.y1 + layout.hp.y2) * 0.5;
    var mid_lx = (atk_lx + hp_lx) * 0.5;
    var mid_ly = (atk_ly + hp_ly) * 0.5;
    var w = cardStatModLocalToWorld(_card, mid_lx, mid_ly, tlx, tly, sc);
    return { x: w[0], y: w[1], scale: sc };
}

/// @function cardAbilityDrawPurgedIcon(wx, wy, scale)
function cardAbilityDrawPurgedIcon(_wx, _wy, _scale) {
    var r = max(8, 11 * _scale);
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(220, 220, 230));
    draw_circle(_wx, _wy, r, true);
    draw_set_color(make_color_rgb(40, 40, 50));
    draw_circle(_wx, _wy, r, false);

    draw_set_color(make_color_rgb(60, 60, 70));
    var dot_r = max(1.5, 2.2 * _scale);
    var dot_sp = max(3, 4.5 * _scale);
    draw_circle(_wx - dot_sp, _wy, dot_r, false);
    draw_circle(_wx, _wy, dot_r, false);
    draw_circle(_wx + dot_sp, _wy, dot_r, false);

    draw_set_color(make_color_rgb(220, 50, 50));
    var lw = max(2, 2.5 * _scale);
    draw_line_width(_wx - r * 0.75, _wy + r * 0.75, _wx + r * 0.75, _wy - r * 0.75, lw);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// @function cardAbilityDrawLightningIcon(wx, wy, scale, timer)
function cardAbilityDrawLightningIcon(_wx, _wy, _scale, _timer) {
    var pulse = 0.85 + 0.15 * sin(_timer * 0.14);
    var h = max(10, 14 * _scale);
    var col = make_color_rgb(255, 240, 120);
    var col2 = make_color_rgb(255, 180, 40);
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.9 * pulse);
    draw_set_color(col2);
    var x0 = _wx;
    var y0 = _wy - h * 0.45;
    draw_triangle(x0 - h * 0.22, y0, x0 + h * 0.08, y0 + h * 0.35, x0 - h * 0.05, y0 + h * 0.35, false);
    draw_triangle(x0 + h * 0.05, y0 + h * 0.3, x0 - h * 0.2, y0 + h * 0.95, x0 + h * 0.12, y0 + h * 0.55, false);
    draw_set_color(col);
    draw_triangle(x0 - h * 0.16, y0 + h * 0.05, x0 + h * 0.02, y0 + h * 0.32, x0 - h * 0.02, y0 + h * 0.32, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// @function cardAbilityDrawTombIcon(wx, wy, scale)
function cardAbilityDrawTombIcon(_wx, _wy, _scale) {
    var w = max(9, 12 * _scale);
    var h = max(11, 14 * _scale);
    var col = make_color_rgb(180, 180, 200);
    var col_d = make_color_rgb(90, 90, 110);
    draw_set_alpha(0.95);
    draw_set_color(col_d);
    draw_rectangle(_wx - w * 0.5, _wy - h * 0.15, _wx + w * 0.5, _wy + h * 0.45, false);
    draw_set_color(col);
    draw_rectangle(_wx - w * 0.42, _wy - h * 0.55, _wx + w * 0.42, _wy - h * 0.1, false);
    draw_set_color(col_d);
    draw_line(_wx - w * 0.35, _wy - h * 0.52, _wx + w * 0.35, _wy - h * 0.52);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// @function drawCardAbilityIcon(card)
function drawCardAbilityIcon(_card) {
    if (_card == noone || !instance_exists(_card)) return;
    if (!variable_instance_exists(_card, "zone")) return;
    var z = _card.zone;
    var onBoard = (z == "Field" || z == "FieldSelected");
    var inHand = (z == "Hand" || z == "HandSelected");
    if (!onBoard && !inHand) return;
    if (!variable_instance_exists(_card, "type") || _card.type != "Monster") return;
    if (variable_instance_exists(_card, "isFaceDown") && _card.isFaceDown) return;
    if (inHand && !(variable_instance_exists(_card, "isHeroOwner") && _card.isHeroOwner)) return;
    if (variable_instance_exists(_card, "isTerrain") && _card.isTerrain) return;

    var center = cardAbilityIconGetCenter(_card);
    if (center == undefined) return;

    var timer = (variable_instance_exists(_card, "statModAnimTimer") ? _card.statModAnimTimer : current_time * 0.1);

    if (cardIsPurged(_card)) {
        cardAbilityDrawPurgedIcon(center.x, center.y, center.scale);
        return;
    }
    if (cardHasCombatAbilityIcon(_card)) {
        cardAbilityDrawLightningIcon(center.x, center.y, center.scale, timer);
        return;
    }
    if (cardHasBriseAbilityIcon(_card)) {
        cardAbilityDrawTombIcon(center.x, center.y, center.scale);
    }
}

// --- Infobulle survol (bonus / malus / états) ---

/// @function cardStatusTooltipCanShow(card)
function cardStatusTooltipCanShow(_card) {
    if (_card == noone || !instance_exists(_card)) return false;
    if (!variable_instance_exists(_card, "zone")) return false;
    var z = _card.zone;
    if (!(z == "Hand" || z == "HandSelected" || z == "Field" || z == "FieldSelected")) return false;
    if (z == "Hand" || z == "HandSelected") {
        if (!(variable_instance_exists(_card, "isHeroOwner") && _card.isHeroOwner)) return false;
    }
    if ((z == "Field" || z == "FieldSelected") && variable_instance_exists(_card, "isFaceDown") && _card.isFaceDown) {
        if (!(variable_instance_exists(_card, "isHeroOwner") && _card.isHeroOwner)) return false;
    }
    return true;
}

/// @function cardStatusTooltipFormatSigned(value, statLabel)
function cardStatusTooltipFormatSigned(_value, _statLabel) {
    if (_value == 0) {
        return "";
    }
    var prefix = "+";
    if (_value < 0) {
        prefix = "";
    }
    return prefix + string(_value) + " " + _statLabel;
}

/// @function cardStatusTooltipFindInstanceById(instId)
function cardStatusTooltipFindInstanceById(_instId) {
    var iid = real(_instId);
    if (iid <= 0) return noone;

    var objList = [];
    if (asset_get_index("oCardParent") != -1) array_push(objList, oCardParent);
    if (asset_get_index("oCardMonster") != -1) array_push(objList, oCardMonster);
    if (asset_get_index("oCardMagic") != -1) array_push(objList, oCardMagic);

    for (var oi = 0; oi < array_length(objList); oi++) {
        var obj = objList[oi];
        var n = instance_number(obj);
        for (var i = 0; i < n; i++) {
            var inst = instance_find(obj, i);
            if (inst != noone && instance_exists(inst) && inst.id == iid) {
                return inst;
            }
        }
    }
    return noone;
}

/// @function cardStatusTooltipParseKeyParts(key)
function cardStatusTooltipParseKeyParts(_key) {
    var parts = [];
    var chunk = string(_key);
    var sep = string_pos(":", chunk);
    while (sep > 0) {
        array_push(parts, string_copy(chunk, 1, sep - 1));
        chunk = string_delete(chunk, 1, sep);
        sep = string_pos(":", chunk);
    }
    if (chunk != "") array_push(parts, chunk);
    return parts;
}

/// @function cardStatusTooltipInstanceIdFromKey(key)
function cardStatusTooltipInstanceIdFromKey(_key) {
    var parts = cardStatusTooltipParseKeyParts(_key);
    if (array_length(parts) < 2) return -1;

    if (parts[0] == "aura" || parts[0] == "equip") {
        return real(parts[1]);
    }
    if (parts[0] == "effect" && array_length(parts) >= 3) {
        return real(parts[2]);
    }
    if (array_length(parts) == 2) {
        return real(parts[1]);
    }
    return -1;
}

/// @function cardStatusTooltipResolveBuffSourceName(contribStruct)
function cardStatusTooltipResolveBuffSourceName(_contrib) {
    if (!is_struct(_contrib)) return "Bonus";

    if (variable_struct_exists(_contrib, "source_name") && is_string(_contrib.source_name) && _contrib.source_name != "") {
        return _contrib.source_name;
    }

    if (!variable_struct_exists(_contrib, "key")) return "Bonus";
    var k = string(_contrib.key);
    if (k == "") return "Bonus";

    var instId = cardStatusTooltipInstanceIdFromKey(k);
    if (instId > 0) {
        var srcInst = cardStatusTooltipFindInstanceById(instId);
        if (srcInst != noone && instance_exists(srcInst) && variable_instance_exists(srcInst, "name")) {
            return string(srcInst.name);
        }
    }

    return "Bonus";
}

/// @function cardStatusTooltipGetLines(card)
function cardStatusTooltipGetLines(_card) {
    var lines = [];
    if (!cardStatusTooltipCanShow(_card)) return lines;

    if (cardIsPurged(_card)) {
        array_push(lines, "Purgé (effets neutralisés)");
    }

    var d = cardStatModGetDeltas(_card);
    var buffAtkSum = 0;
    var buffDefSum = 0;
    var hasBuffContribs = (variable_instance_exists(_card, "buff_contribs")
        && is_array(_card.buff_contribs) && array_length(_card.buff_contribs) > 0);

    if (hasBuffContribs) {
        for (var bi = 0; bi < array_length(_card.buff_contribs); bi++) {
            var c = _card.buff_contribs[bi];
            if (!is_struct(c)) continue;
            var ca = variable_struct_exists(c, "atk") ? c.atk : 0;
            var cd = variable_struct_exists(c, "PV") ? c.PV : 0;
            if (ca == 0 && cd == 0) continue;

            buffAtkSum += ca;
            buffDefSum += cd;

            var parts = "";
            if (ca != 0) parts = cardStatusTooltipFormatSigned(ca, "ATK");
            if (cd != 0) {
                var p2 = cardStatusTooltipFormatSigned(cd, "PV max");
                parts = (parts == "") ? p2 : (parts + ", " + p2);
            }
            var src = cardStatusTooltipResolveBuffSourceName(c);
            array_push(lines, src + " : " + parts);
        }
    }

    var remainAtk = d.has_atk ? (d.atk - buffAtkSum) : 0;
    var remainDef = d.has_def ? (d.def - buffDefSum) : 0;
    if (remainAtk != 0) {
        array_push(lines, cardStatusTooltipFormatSigned(remainAtk, "ATK"));
    }
    if (remainDef != 0) {
        array_push(lines, cardStatusTooltipFormatSigned(remainDef, "PV max"));
    }

    if (variable_instance_exists(_card, "temp_attack") && _card.temp_attack != 0) {
        var tLine = cardStatusTooltipFormatSigned(_card.temp_attack, "ATK (tempo)");
        var dup = false;
        if (d.has_atk && d.atk == _card.temp_attack) dup = true;
        if (!dup) array_push(lines, tLine);
    }
    if (variable_instance_exists(_card, "temp_defense") && _card.temp_defense != 0) {
        var tLineD = cardStatusTooltipFormatSigned(_card.temp_defense, "PV max (tempo)");
        var dupD = false;
        if (d.has_def && d.def == _card.temp_defense) dupD = true;
        if (!dupD) array_push(lines, tLineD);
    }

    if (variable_instance_exists(_card, "current_hp") && variable_instance_exists(_card, "max_hp")) {
        if (_card.max_hp > 0 && _card.current_hp < _card.max_hp) {
            array_push(lines, "Blessé : " + string(_card.current_hp) + " / " + string(_card.max_hp) + " PV");
        }
    }

    if (!cardIsPurged(_card)) {
        if (variable_instance_exists(_card, "isCamouflage") && _card.isCamouflage) {
            array_push(lines, "Camouflage");
        }
        if (variable_instance_exists(_card, "entrave_turns_remaining") && _card.entrave_turns_remaining > 0) {
            var et = _card.entrave_turns_remaining;
            var entraveTxt = "Entravé (" + string(et) + " tour" + (et > 1 ? "s" : "") + ")";
            array_push(lines, entraveTxt);
        }
        if (variable_instance_exists(_card, "isPoisoner") && _card.isPoisoner) {
            array_push(lines, "Poison");
        }
        if (variable_instance_exists(_card, "dot_states") && is_array(_card.dot_states)) {
            for (var di = 0; di < array_length(_card.dot_states); di++) {
                var st = _card.dot_states[di];
                if (!is_struct(st)) continue;
                var dmg = variable_struct_exists(st, "damage") ? st.damage : 0;
                var rem = variable_struct_exists(st, "remaining") ? st.remaining : 0;
                var k = variable_struct_exists(st, "key") ? string(st.key) : "DOT";
                if (string_lower(k) == "poison" || dmg > 0) {
                    array_push(lines, "Poison : " + string(dmg) + "/tour, " + string(rem) + " tour(s)");
                }
            }
        }
        if (variable_instance_exists(_card, "has_charge") && _card.has_charge) {
            array_push(lines, "Charge");
        }
        if (variable_instance_exists(_card, "isPercee") && _card.isPercee) {
            array_push(lines, "Percée");
        }
        if ((variable_instance_exists(_card, "hasRepoussement") && _card.hasRepoussement)
            || (variable_instance_exists(_card, "isRepoussement") && _card.isRepoussement)) {
            array_push(lines, "Repoussement");
        }
        if (variable_instance_exists(_card, "has_taunt") && _card.has_taunt) {
            array_push(lines, "Provocation");
        }
        if ((variable_instance_exists(_card, "hasEgide") && _card.hasEgide)
            || (variable_instance_exists(_card, "isEgide") && _card.isEgide)) {
            array_push(lines, "Égide");
        }
        if (variable_instance_exists(_card, "isAmbidextrous") && _card.isAmbidextrous) {
            array_push(lines, "Ambidextrie");
        }
        if (variable_instance_exists(_card, "hasPonction") && _card.hasPonction) {
            array_push(lines, "Ponction");
        }
    }

    return lines;
}

/// @function cardStatusTooltipFindHoveredCard()
function cardStatusTooltipFindHoveredCard() {
    var best = noone;
    var bestDepth = 1000000000;

    var objList = [];
    if (asset_get_index("oCardMonster") != -1) array_push(objList, oCardMonster);
    if (asset_get_index("oCardMagic") != -1) array_push(objList, oCardMagic);

    for (var oi = 0; oi < array_length(objList); oi++) {
        var obj = objList[oi];
        var n = instance_number(obj);
        for (var i = 0; i < n; i++) {
            var inst = instance_find(obj, i);
            if (inst == noone || !instance_exists(inst)) continue;
            if (!variable_instance_exists(inst, "isHovered") || !inst.isHovered) continue;
            if (!cardStatusTooltipCanShow(inst)) continue;
            if (array_length(cardStatusTooltipGetLines(inst)) == 0) continue;
            if (inst.depth < bestDepth) {
                bestDepth = inst.depth;
                best = inst;
            }
        }
    }

    return best;
}

/// @function drawCardStatusTooltipGUI(card, mx, my)
function drawCardStatusTooltipGUI(_card, _mx, _my) {
    if (_card == noone || !instance_exists(_card)) return;

    var linesArr = cardStatusTooltipGetLines(_card);
    if (array_length(linesArr) == 0) return;

    var title = variable_instance_exists(_card, "name") ? string(_card.name) : "Carte";

    var pad = 12;
    var w = 240;
    var textScale = 0.85;

    if (font_exists(fontTitle)) draw_set_font(fontTitle);
    var th = string_height(title) * textScale + 8;
    if (font_exists(fontText)) draw_set_font(fontText);
    var lineH = string_height("Ag") * textScale + 4;
    var bodyH = array_length(linesArr) * lineH;
    var h = pad * 2 + th + bodyH + 4;

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var x1 = _mx + 18;
    var y1 = _my - h - 12;
    x1 = max(10, min(x1, gui_w - w - 10));
    y1 = max(10, min(y1, gui_h - h - 10));
    var x2 = x1 + w;
    var y2 = y1 + h;

    draw_set_alpha(0.94);
    draw_set_color(make_color_rgb(18, 22, 28));
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(120, 200, 255));
    draw_rectangle(x1, y1, x2, y2, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    if (font_exists(fontTitle)) draw_set_font(fontTitle);
    draw_set_color(make_color_rgb(230, 210, 140));
    draw_text_transformed(x1 + pad, y1 + pad, title, textScale, textScale, 0);

    if (font_exists(fontText)) draw_set_font(fontText);
    draw_set_color(c_white);
    var by = y1 + pad + th;
    for (var li = 0; li < array_length(linesArr); li++) {
        draw_text_transformed(x1 + pad, by, linesArr[li], textScale, textScale, 0);
        by += lineH;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
