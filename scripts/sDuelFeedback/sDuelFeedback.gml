/// @description Journal de duel, résumé de résolution et nombres flottants (dégâts/soins)

#macro DUEL_LOG_MAX_LINES 100
#macro DUEL_LOG_VISIBLE_LINES 5
#macro DUEL_LOG_SIDE_HERO "hero"
#macro DUEL_LOG_SIDE_ENEMY "enemy"
#macro DUEL_LOG_SIDE_NEUTRAL "neutral"

/// @function duelFeedbackInit()
function duelFeedbackInit() {
    global.duel_log = [];
    global.duel_log_scroll = 0;
    global.duel_last_summary = "";
    global.duel_feedback_ready = true;
    if (script_exists(asset_get_index("fxAuraInitQueues"))) {
        fxAuraInitQueues();
    }
}

/// @function duelFeedbackReset()
function duelFeedbackReset() {
    duelFeedbackInit();
}

/// @function duelFeedbackEnsureUI()
function duelFeedbackEnsureUI() {
    if (room != rDuel) return;
    if (!instance_exists(oDuelLogPanel)) {
        instance_create_layer(0, 0, "Instances", oDuelLogPanel);
    }
}

function _duelFeedbackTurn() {
    if (instance_exists(oGame) && variable_instance_exists(oGame, "nbTurn")) {
        return oGame.nbTurn;
    }
    return 0;
}

function _duelFeedbackPhase() {
    if (instance_exists(oGame) && variable_instance_exists(oGame, "phase")) {
        return game.phase[game.phase_current];
    }
    return "";
}

/// @function _duelCardDisplayName(card)
function _duelCardDisplayName(_card) {
    if (_card == noone) return "???";
    if (!instance_exists(_card) && !is_struct(_card)) return "???";

    if (variable_instance_exists(_card, "nbLP") || (is_struct(_card) && variable_struct_exists(_card, "nbLP"))) {
        if (instance_exists(_card)) {
            if (_card.object_index == oLP_Hero) return "Héros";
            if (_card.object_index == oLP_Enemy) return "Adversaire";
            if (variable_instance_exists(_card, "isHeroOwner")) {
                return _card.isHeroOwner ? "Héros" : "Adversaire";
            }
        }
        return "Héros";
    }

    var isHidden = false;
    if (instance_exists(_card)) {
        var isEnemy = !(variable_instance_exists(_card, "isHeroOwner") && _card.isHeroOwner);
        if (isEnemy) {
            if (variable_instance_exists(_card, "isFaceDown") && _card.isFaceDown) isHidden = true;
            var zz = variable_instance_exists(_card, "zone") ? string_lower(string(_card.zone)) : "";
            if (zz == "hand" || zz == "handselected") {
                var revealed = (instance_exists(handEnemy) && variable_instance_exists(handEnemy, "reveal_override") && handEnemy.reveal_override);
                if (!revealed) isHidden = true;
            }
        }
    }
    if (isHidden) return "carte cachée";

    if (variable_instance_exists(_card, "name") && string(_card.name) != "") return string(_card.name);
    if (instance_exists(_card)) return object_get_name(_card.object_index);
    return "???";
}

/// @function _duelIsHeroOwner(card)
function _duelIsHeroOwner(_card) {
    if (_card == noone) return true;
    if (variable_instance_exists(_card, "nbLP") || (is_struct(_card) && variable_struct_exists(_card, "nbLP"))) {
        if (instance_exists(_card)) {
            if (_card.object_index == oLP_Hero) return true;
            if (_card.object_index == oLP_Enemy) return false;
        }
        if (variable_instance_exists(_card, "isHeroOwner")) return _card.isHeroOwner;
        return true;
    }
    if (variable_instance_exists(_card, "isHeroOwner")) return _card.isHeroOwner;
    return true;
}

/// @function _duelActorLabel(card) — sujet français (Vous / L'adversaire / Héros)
function _duelActorLabel(_card) {
    if (_card == noone) return "";
    if (variable_instance_exists(_card, "nbLP") || (is_struct(_card) && variable_struct_exists(_card, "nbLP"))) {
        if (instance_exists(_card)) {
            if (_card.object_index == oLP_Hero) return "Votre héros";
            if (_card.object_index == oLP_Enemy) return "Héros adverse";
        }
        return _duelIsHeroOwner(_card) ? "Votre héros" : "Héros adverse";
    }
    return _duelIsHeroOwner(_card) ? "Vous" : "L'adversaire";
}

/// @function _duelCardNameOnly(card) — nom de carte seul (sans préfixe joueur)
function _duelCardNameOnly(_card) {
    return _duelCardDisplayName(_card);
}

/// @function _duelPlayVerb(card)
function _duelPlayVerb(_card) {
    var isMagic = false;
    if (variable_instance_exists(_card, "type")) {
        isMagic = (string_lower(string(_card.type)) == "magic");
    }
    if (_duelIsHeroOwner(_card)) {
        return isMagic ? "lancez" : "jouez";
    }
    return isMagic ? "lance" : "joue";
}

/// @function _duelPossessiveCard(card) — « Votre Tunnelin », « Le Loup adverse »
function _duelPossessiveCard(_card) {
    if (_card == noone) return "???";
    if (variable_instance_exists(_card, "nbLP") || (is_struct(_card) && variable_struct_exists(_card, "nbLP"))) {
        if (instance_exists(_card)) {
            if (_card.object_index == oLP_Hero) return "Votre héros";
            if (_card.object_index == oLP_Enemy) return "Le héros adverse";
        }
        return _duelIsHeroOwner(_card) ? "Votre héros" : "Le héros adverse";
    }
    var name = _duelCardNameOnly(_card);
    if (_duelIsHeroOwner(_card)) return "Votre " + name;
    return "Le " + name + " adverse";
}

/// @function _duelDamageLabel(amount)
function _duelDamageLabel(_amount) {
    if (_amount == 1) return "1 dégât";
    return string(_amount) + " dégâts";
}

/// @function _duelHealLabel(amount)
function _duelHealLabel(_amount) {
    if (_amount == 1) return "1 PV";
    return string(_amount) + " PV";
}

/// @function _duelSourceClause(source, target)
function _duelSourceClause(_source, _target) {
    if (_source == noone || !instance_exists(_source) || _source == _target) return "";
    return ", infligés par " + _duelPossessiveCard(_source);
}

/// @function _duelLogSubjectCard(card) — alias possessif (compatibilité)
function _duelLogSubjectCard(_card) {
    return _duelPossessiveCard(_card);
}

/// @function _duelLogSideFromCard(card)
function _duelLogSideFromCard(_card) {
    if (_card == noone || !instance_exists(_card)) return DUEL_LOG_SIDE_NEUTRAL;
    if (variable_instance_exists(_card, "nbLP") || (is_struct(_card) && variable_struct_exists(_card, "nbLP"))) {
        if (instance_exists(_card)) {
            if (_card.object_index == oLP_Hero) return DUEL_LOG_SIDE_HERO;
            if (_card.object_index == oLP_Enemy) return DUEL_LOG_SIDE_ENEMY;
        }
        return _duelIsHeroOwner(_card) ? DUEL_LOG_SIDE_HERO : DUEL_LOG_SIDE_ENEMY;
    }
    return _duelIsHeroOwner(_card) ? DUEL_LOG_SIDE_HERO : DUEL_LOG_SIDE_ENEMY;
}

/// @function _duelLogInferSide(line, kind)
function _duelLogInferSide(_line, _kind) {
    var t = string(_line);
    if (_kind == "script") {
        if (string_pos("Vous recevez", t) > 0) return DUEL_LOG_SIDE_HERO;
        return DUEL_LOG_SIDE_ENEMY;
    }
    if (_kind == "effect") return DUEL_LOG_SIDE_NEUTRAL;
    if (_kind == "phase") return DUEL_LOG_SIDE_NEUTRAL;
    if (string_copy(t, 1, 7) == "Votre " || string_copy(t, 1, 5) == "Vous ") return DUEL_LOG_SIDE_HERO;
    if (string_copy(t, 1, 12) == "L'adversaire" || string_copy(t, 1, 3) == "Le ") return DUEL_LOG_SIDE_ENEMY;
    if (string_pos("adversaire", string_lower(t)) > 0) return DUEL_LOG_SIDE_ENEMY;
    return DUEL_LOG_SIDE_NEUTRAL;
}

/// @function duelLogEntryPassesFilter(entry, filterId)
function duelLogEntryPassesFilter(_entry, _filterId) {
    if (_filterId == "all" || _filterId == "") return true;
    if (!is_struct(_entry)) return false;
    var kind = variable_struct_exists(_entry, "kind") ? _entry.kind : "";
    var side = variable_struct_exists(_entry, "side")
        ? _entry.side
        : _duelLogInferSide(variable_struct_exists(_entry, "text") ? _entry.text : "", kind);
    switch (_filterId) {
        case "hero": return (side == DUEL_LOG_SIDE_HERO);
        case "enemy": return (side == DUEL_LOG_SIDE_ENEMY);
        case "effect": return (kind == "effect");
        case "damage": return (kind == "damage");
    }
    return true;
}

/// @function duelLogPush(line, kind, side)
function duelLogPush(_line, _kind, _side = DUEL_LOG_SIDE_NEUTRAL) {
    if (room != rDuel) return;
    if (!variable_global_exists("duel_feedback_ready")) duelFeedbackInit();
    duelFeedbackEnsureUI();

    if (_side == DUEL_LOG_SIDE_NEUTRAL) {
        _side = _duelLogInferSide(_line, _kind);
    }

    var entry = {
        text: _line,
        kind: _kind,
        side: _side,
        turn: _duelFeedbackTurn(),
        t: current_time
    };
    array_push(global.duel_log, entry);

    while (array_length(global.duel_log) > DUEL_LOG_MAX_LINES) {
        array_delete(global.duel_log, 0, 1);
    }

}

/// @function duelLogSetSummary(line) — conservé pour compatibilité (plus affiché dans le panneau)
function duelLogSetSummary(_line) {
    if (room != rDuel) return;
}

/// @function duelFeedbackShowNumber(target, amount, isHeal)
function duelFeedbackShowNumber(_target, _amount, _isHeal) {
    if (room != rDuel) return;
    if (_amount <= 0) return;
    if (_target == noone) return;

    var wx = mouse_x;
    var wy = mouse_y;
    if (instance_exists(_target)) {
        wx = _target.x;
        wy = _target.y - 36;
    }

    var fx = instance_create_layer(wx, wy, "Instances", oFloatingNumber);
    if (fx != noone) {
        fx.value = _amount;
        fx.is_heal = _isHeal;
        fx.depth = -12000;
    }
}

/// @function duelLogDamage(target, amount, source)
function duelLogDamage(_target, _amount, _source) {
    if (room != rDuel || _amount <= 0) return;

    var line = _duelPossessiveCard(_target) + " subit " + _duelDamageLabel(_amount) + _duelSourceClause(_source, _target);
    duelLogPush(line, "damage", _duelLogSideFromCard(_target));
    duelFeedbackShowNumber(_target, _amount, false);
}

/// @function duelLogHeal(target, amount)
function duelLogHeal(_target, _amount) {
    if (room != rDuel || _amount <= 0) return;
    var line = _duelPossessiveCard(_target) + " récupère " + _duelHealLabel(_amount);
    duelLogPush(line, "heal", _duelLogSideFromCard(_target));
    duelFeedbackShowNumber(_target, _amount, true);
}

/// @function duelLogDestroy(card, source)
function duelLogDestroy(_card, _source) {
    if (room != rDuel) return;
    var line = _duelPossessiveCard(_card) + " est envoyé au cimetière";
    if (_source != noone && instance_exists(_source) && _source != _card) {
        line += ", par " + _duelPossessiveCard(_source);
    }
    duelLogPush(line, "destroy", _duelLogSideFromCard(_card));
}

/// @function duelLogPlayCard(card)
function duelLogPlayCard(_card) {
    if (room != rDuel || _card == noone || !instance_exists(_card)) return;
    var line = _duelActorLabel(_card) + " " + _duelPlayVerb(_card) + " " + _duelCardNameOnly(_card);
    duelLogPush(line, "play", _duelLogSideFromCard(_card));
}

/// @function duelLogAttackStart(attacker, target, isDirect)
function duelLogAttackStart(_attacker, _target, _isDirect) {
    if (room != rDuel || _attacker == noone || !instance_exists(_attacker)) return;
    var line = _duelPossessiveCard(_attacker) + " attaque";
    if (_isDirect) {
        line += " le héros adverse";
    } else if (_target != noone && instance_exists(_target)) {
        line += " " + _duelPossessiveCard(_target);
    }
    duelLogPush(line, "attack", _duelLogSideFromCard(_attacker));
}

/// @function duelLogPhaseChange(phaseName)
function duelLogPhaseChange(_phaseName) {
    if (room != rDuel) return;
    duelLogPush("— Phase " + string(_phaseName) + " (tour " + string(_duelFeedbackTurn()) + ") —", "phase", DUEL_LOG_SIDE_NEUTRAL);
}

/// @function duelLogDraw(ownerIsHero, count)
function duelLogDraw(_ownerIsHero, _count) {
    if (room != rDuel) return;
    var line = _ownerIsHero
        ? ("Vous piochez " + string(max(1, _count)) + " carte(s)")
        : ("L'adversaire pioche " + string(max(1, _count)) + " carte(s)");
    duelLogPush(line, "draw", _ownerIsHero ? DUEL_LOG_SIDE_HERO : DUEL_LOG_SIDE_ENEMY);
}

/// @function duelLogGeneric(text, kind)
function duelLogGeneric(_text, _kind) {
    duelLogPush(_text, _kind);
}

/// @function _duelAssetDisplayName(assetName)
function _duelAssetDisplayName(_assetName) {
    var s = string(_assetName);
    if (string_length(s) > 1 && string_char_at(s, 1) == "o") {
        s = string_delete(s, 1, 1);
    }
    var out = "";
    for (var ci = 1; ci <= string_length(s); ci++) {
        var ch = string_char_at(s, ci);
        var code = ord(ch);
        if (ci > 1 && code >= 65 && code <= 90) out += " ";
        out += ch;
    }
    return out;
}

/// @function _duelEffectShouldLog(effectType, trigger)
function _duelEffectShouldLog(_effectType, _trigger) {
    if (_trigger == TRIGGER_CONTINUOUS || _trigger == TRIGGER_PASSIVE) return false;
    switch (_effectType) {
        case EFFECT_DAMAGE_TARGET:
        case EFFECT_DAMAGE_ALL:
        case EFFECT_HEAL_TARGET:
        case EFFECT_HEAL_ALL:
        case EFFECT_DESTROY_TARGET:
        case EFFECT_DESTROY:
        case EFFECT_DESTROY_SELF:
        case EFFECT_DESTROY_ALL:
            return false;
        case EFFECT_TEMPO:
        case EFFECT_CONDITIONAL_FLOW:
        case EFFECT_TRACK_GRAVEYARD_PRESENCE:
        case EFFECT_TRACK_FIELD_PRESENCE:
        case EFFECT_TRACK_SELF_PROPERTY_BOOL:
        case EFFECT_DOT_TICK:
        case EFFECT_TERRAIN_TICK:
        case EFFECT_REMOVE_SELF_BUFF_CONTRIBS:
        case EFFECT_SET_SELF_BUFF_CONTRIB:
        case EFFECT_COUNT_APPLY:
            return false;
    }
    return true;
}

/// @function _duelEffectTypeLabel(effectType)
function _duelEffectTypeLabel(_effectType) {
    switch (_effectType) {
        case EFFECT_DRAW_CARDS: return "pioche";
        case EFFECT_DISCARD: return "défausse";
        case EFFECT_DAMAGE_TARGET: return "dégâts";
        case EFFECT_DAMAGE_ALL: return "dégâts (zone)";
        case EFFECT_HEAL_TARGET: return "soin";
        case EFFECT_HEAL_ALL: return "soin (zone)";
        case EFFECT_DESTROY_TARGET: return "destruction";
        case EFFECT_DESTROY: return "destruction";
        case EFFECT_DESTROY_SELF: return "auto-destruction";
        case EFFECT_DESTROY_ALL: return "destruction (zone)";
        case EFFECT_SUMMON: return "invocation";
        case EFFECT_BUFF: return "buff";
        case EFFECT_POISON: return "poison";
        case EFFECT_STEALTH: return "furtivité";
        case EFFECT_RETURN_TO_HAND: return "retour en main";
        case EFFECT_ADD_TO_HAND: return "ajout en main";
        case EFFECT_REVIVE: return "ressuscite";
        case EFFECT_SEARCH: return "recherche";
        case EFFECT_ENTRAVE: return "entrave";
        case EFFECT_POINTS: return "modifie les stats";
        case EFFECT_LOSE_ATTACK: return "perd de l'ATK";
        case EFFECT_LOSE_DEFENSE: return "perd de la PV";
        case EFFECT_SET_ATTACK: return "fixe l'ATK";
        case EFFECT_SET_DEFENSE: return "fixe la PV";
        case EFFECT_APPLY_DOT: return "applique un effet";
        case EFFECT_RANDOM_PROJECTILES: return "projectiles";
        case EFFECT_CLEAVE_ADJACENT: return "entaille adjacente";
        case EFFECT_REVEAL_HAND: return "révèle la main";
        case EFFECT_BANISH_TARGET: return "bannit";
        default: return string(_effectType);
    }
}

/// @function duelLogEffect(card, effect, context)
function duelLogEffect(_card, _effect, _context) {
    if (room != rDuel) return;
    if (_card == noone || !instance_exists(_card)) return;
    if (!is_struct(_effect) || !variable_struct_exists(_effect, "effect_type")) return;

    var trig = variable_struct_exists(_effect, "trigger") ? _effect.trigger : "";
    if (!_duelEffectShouldLog(_effect.effect_type, trig)) return;
    if (is_struct(_context) && variable_struct_exists(_context, "silent_log") && _context.silent_log) return;

    var label = _duelEffectTypeLabel(_effect.effect_type);
    var line = _duelPossessiveCard(_card) + " : " + label;

    var tgt = (is_struct(_context) && variable_struct_exists(_context, "target")) ? _context.target : noone;
    if (tgt != noone && instance_exists(tgt)) {
        line += " sur " + _duelPossessiveCard(tgt);
    }

    var val = variable_struct_exists(_effect, "value") ? _effect.value : 0;
    if (val != 0) line += " (" + string(val) + ")";

    duelLogPush(line, "effect", _duelLogSideFromCard(_card));
}

/// @function _duelLogBotScriptPendingSummon(gameInst, assetField, countField)
function _duelLogBotScriptPendingSummon(_gi, _assetField, _countField) {
    if (!variable_instance_exists(_gi, _assetField)) return false;
    var asset = variable_instance_get(_gi, _assetField);
    if (asset == "" || asset == undefined) return false;
    var cnt = 1;
    if (_countField != "" && variable_instance_exists(_gi, _countField)) {
        cnt = max(1, variable_instance_get(_gi, _countField));
    }
    var name = _duelAssetDisplayName(asset);
    var line = "  • Invoque ";
    if (cnt > 1) line += string(cnt) + " " + name;
    else line += name;
    duelLogPush(line, "script", DUEL_LOG_SIDE_ENEMY);
    return true;
}

/// @function _duelLogBotScriptPendingHand(gameInst, assetField, isHero)
function _duelLogBotScriptPendingHand(_gi, _assetField, _isHero) {
    if (!variable_instance_exists(_gi, _assetField)) return false;
    var asset = variable_instance_get(_gi, _assetField);
    if (asset == "" || asset == undefined) return false;
    var name = _duelAssetDisplayName(asset);
    var who = _isHero ? "Vous recevez" : "L'adversaire reçoit";
    var side = _isHero ? DUEL_LOG_SIDE_HERO : DUEL_LOG_SIDE_ENEMY;
    duelLogPush("  • " + who + " " + name + " en main", "script", side);
    return true;
}

/// @function duelLogBotScriptDescribePending(gameInst)
/// @description Liste les actions prévues (story_pending_*) au déclenchement du script
function duelLogBotScriptDescribePending(_gameInst) {
    if (room != rDuel || _gameInst == noone || !instance_exists(_gameInst)) return;

    var any = false;
    any = _duelLogBotScriptPendingSummon(_gameInst, "story_pending_summon_asset", "story_pending_summon_count") || any;
    any = _duelLogBotScriptPendingSummon(_gameInst, "story_pending_summon_asset2", "story_pending_summon_count2") || any;
    any = _duelLogBotScriptPendingSummon(_gameInst, "story_pending_summon_asset3", "story_pending_summon_count3") || any;
    any = _duelLogBotScriptPendingHand(_gameInst, "story_pending_add_to_hand_asset", false) || any;
    any = _duelLogBotScriptPendingHand(_gameInst, "story_pending_add_to_hand_asset2", false) || any;
    any = _duelLogBotScriptPendingHand(_gameInst, "story_pending_add_to_hero_hand_asset", true) || any;

    if (variable_instance_exists(_gameInst, "story_pending_cast_spell_asset")
        && _gameInst.story_pending_cast_spell_asset != "") {
        duelLogPush("  • Lance " + _duelAssetDisplayName(_gameInst.story_pending_cast_spell_asset), "script", DUEL_LOG_SIDE_ENEMY);
        any = true;
    }

    if (!any) {
        duelLogPush("  • (réplique uniquement, pas d'action immédiate)", "script", DUEL_LOG_SIDE_ENEMY);
    }
}

/// @function duelLogBotScriptHeader(gameInst, quoteText)
/// @description Script scénario : déclencheur, réplique, puis actions prévues
function duelLogBotScriptHeader(_gameInst, _quoteText) {
    if (room != rDuel) return;
    if (_gameInst == noone || !instance_exists(_gameInst)) return;

    var lpEnemy = instance_find(oLP_Enemy, 0);
    var lpv = (lpEnemy != noone && variable_instance_exists(lpEnemy, "nbLP")) ? lpEnemy.nbLP : -1;
    var turnN = variable_instance_exists(_gameInst, "nbTurn") ? _gameInst.nbTurn : _duelFeedbackTurn();

    var byTurn = false;
    if (variable_instance_exists(_gameInst, "duel_log_script_by_turn")) {
        byTurn = _gameInst.duel_log_script_by_turn;
        _gameInst.duel_log_script_by_turn = false;
    } else if (lpv > 0) {
        byTurn = (lpv > 45);
    }

    if (byTurn) {
        duelLogPush("Script déclenché (tour " + string(turnN) + ")", "script", DUEL_LOG_SIDE_ENEMY);
    } else if (lpv >= 0) {
        var th = -1;
        if (variable_instance_exists(_gameInst, "duel_log_script_lp_threshold")) {
            th = _gameInst.duel_log_script_lp_threshold;
        }
        if (th > 0) {
            duelLogPush("PV adverses : " + string(lpv) + " (seuil " + string(th) + ")", "script", DUEL_LOG_SIDE_ENEMY);
        } else {
            duelLogPush("PV adverses : " + string(lpv), "script", DUEL_LOG_SIDE_ENEMY);
        }
    }

    var q = string(_quoteText);
    if (q != "") {
        duelLogPush("Adversaire : " + q, "script", DUEL_LOG_SIDE_ENEMY);
    }

    duelLogPush("Effets du script :", "script", DUEL_LOG_SIDE_ENEMY);
    duelLogBotScriptDescribePending(_gameInst);
}

/// @function duelLogBotScriptMarkTurnTrigger(gameInst)
function duelLogBotScriptMarkTurnTrigger(_gameInst) {
    if (_gameInst == noone || !instance_exists(_gameInst)) return;
    _gameInst.duel_log_script_by_turn = true;
}

/// @function duelLogBotScriptSummon(assetName, count)
function duelLogBotScriptSummon(_assetName, _count) {
    if (room != rDuel || _assetName == "" || _count < 1) return;
    var name = _duelAssetDisplayName(_assetName);
    var line = "L'adversaire invoque ";
    if (_count > 1) line += string(_count) + " " + name;
    else line += name;
    duelLogPush(line, "script");
}

/// @function duelLogBotScriptAddToHand(assetName)
function duelLogBotScriptAddToHand(_assetName) {
    if (room != rDuel || _assetName == "") return;
    duelLogPush("L'adversaire reçoit " + _duelAssetDisplayName(_assetName) + " en main", "script");
}

/// @function duelLogBotScriptCastSpell(assetName)
function duelLogBotScriptCastSpell(_assetName) {
    if (room != rDuel || _assetName == "") return;
    duelLogPush("L'adversaire lance " + _duelAssetDisplayName(_assetName), "script");
}
