/// @description Halo de présentation carte + file de résolution (effets après l'animation)

#macro DUEL_FX_AURA_DURATION_MS 1500
#macro DUEL_FX_AURA_CARD_SCALE 0.2475
#macro DUEL_FX_AURA_PAD 18
#macro DUEL_FX_AURA_THICKNESS 10
#macro DUEL_FX_AURA_OVAL_X 1.50
#macro DUEL_FX_AURA_OVAL_Y 0.80

/// @function fxAuraInitQueues()
function fxAuraInitQueues() {
    if (!variable_global_exists("fx_aura_lock")) global.fx_aura_lock = false;
    if (!variable_global_exists("fx_aura_effect_queue") || !is_array(global.fx_aura_effect_queue)) {
        global.fx_aura_effect_queue = [];
    }
    if (!variable_global_exists("fx_aura_queue") || global.fx_aura_queue == undefined) {
        global.fx_aura_queue = ds_queue_create();
    }
}

/// @function fxAuraHasHaloInstance()
function fxAuraHasHaloInstance() {
    var n = instance_number(FX_Effect);
    for (var i = 0; i < n; i++) {
        var inst = instance_find(FX_Effect, i);
        if (inst == noone || !instance_exists(inst)) continue;
        if (!variable_instance_exists(inst, "mode") || inst.mode == "halo") return true;
    }
    return false;
}

/// @function fxAuraAdvanceQueueWithoutLock()
/// @description Débloque la file si le halo n'a pas démarré (carte détruite, etc.)
function fxAuraAdvanceQueueWithoutLock() {
    fxAuraInitQueues();
    if (global.fx_aura_lock) return;

    var guard = 0;
    while (array_length(global.fx_aura_effect_queue) > 0 && !global.fx_aura_lock && guard < 48) {
        guard++;
        var card = fxAuraCardForQueueItem(global.fx_aura_effect_queue[0]);
        if (card != noone && instance_exists(card)) {
            fxAuraPresentCard(card);
            if (global.fx_aura_lock) return;
        }
        var item = global.fx_aura_effect_queue[0];
        array_delete(global.fx_aura_effect_queue, 0, 1);
        fxAuraApplyQueuedItem(item);
    }
}

/// @function fxAuraIsBusy()
function fxAuraIsBusy() {
    fxAuraInitQueues();

    if (global.fx_aura_lock && !fxAuraHasHaloInstance()
        && !(variable_global_exists("fx_aura_instance") && instance_exists(global.fx_aura_instance))) {
        global.fx_aura_lock = false;
        global.fx_aura_instance = noone;
    }

    if (global.fx_aura_lock) return true;
    if (variable_global_exists("fx_aura_instance") && instance_exists(global.fx_aura_instance)) return true;
    if (fxAuraHasHaloInstance()) return true;

    if (array_length(global.fx_aura_effect_queue) > 0) {
        fxAuraAdvanceQueueWithoutLock();
    }

    return (global.fx_aura_lock || fxAuraHasHaloInstance());
}

/// @function fxAuraShouldPresentTrigger(triggerType, context, effect)
function fxAuraShouldPresentTrigger(_triggerType, _context, _effect) {
    if (is_struct(_context) && variable_struct_exists(_context, "suppress_fx_aura") && _context.suppress_fx_aura) {
        return false;
    }
    if (is_struct(_effect) && variable_struct_exists(_effect, "show_aura")) {
        return _effect.show_aura;
    }
    return (_triggerType == TRIGGER_MAIN_PHASE
        || _triggerType == TRIGGER_START_TURN
        || _triggerType == TRIGGER_END_TURN
        || _triggerType == TRIGGER_QUICK_EFFECT);
}

/// @function fxAuraContextWithSkip(ctx)
function fxAuraContextWithSkip(_ctx) {
    var out = { fx_aura_skip: true };
    if (is_struct(_ctx)) {
        var keys = variable_struct_get_names(_ctx);
        for (var i = 0; i < array_length(keys); i++) {
            var k = keys[i];
            out[$ k] = _ctx[$ k];
        }
    }
    return out;
}

/// @function fxAuraShouldPresentEffect(card, effect, context)
/// @description Halo avant la résolution d'un effet (tous chemins passant par executeEffect)
function fxAuraShouldPresentEffect(_card, _effect, _context) {
    if (room != rDuel) return false;
    if (_card == noone || !instance_exists(_card)) return false;
    if (!is_struct(_effect) || !variable_struct_exists(_effect, "effect_type")) return false;

    if (is_struct(_context)) {
        if (variable_struct_exists(_context, "fx_aura_skip") && _context.fx_aura_skip) return false;
        if (variable_struct_exists(_context, "suppress_fx_aura") && _context.suppress_fx_aura) return false;
        if (variable_struct_exists(_context, "silent_log") && _context.silent_log) return false;
    }

    if (variable_struct_exists(_effect, "show_aura") && !_effect.show_aura) return false;

    if (script_exists(asset_get_index("effectWillRequestManualTargeting"))
        && effectWillRequestManualTargeting(_card, _effect, _context)) {
        return false;
    }

    var trig = variable_struct_exists(_effect, "trigger") ? _effect.trigger : "";
    if (trig == TRIGGER_CONTINUOUS || trig == TRIGGER_PASSIVE) return false;

    var et = _effect.effect_type;
    switch (et) {
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
        case EFFECT_BUFF:
            return false;
    }

    return true;
}

/// @function requestFXAura(...)
function requestFXAura(spriteGhost, imageGhost, xscale, yscale, angle, duration_ms, halo_pad_px, halo_thickness, halo_oval_xmul, halo_oval_ymul, pos_x, pos_y) {
    fxAuraInitQueues();

    var cfg = {
        spriteGhost: spriteGhost,
        imageGhost: imageGhost,
        image_xscale: xscale,
        image_yscale: yscale,
        image_angle: angle,
        duration_ms: duration_ms,
        halo_pad_px: halo_pad_px,
        halo_thickness: halo_thickness,
        halo_oval_xmul: halo_oval_xmul,
        halo_oval_ymul: halo_oval_ymul,
        pos_x: pos_x,
        pos_y: pos_y
    };

    var oncomp = (variable_global_exists("fx_aura_next_on_complete") ? global.fx_aura_next_on_complete : noone);

    if (!global.fx_aura_lock) {
        var px = room_width * 0.5;
        var py = room_height * 0.5;
        var fx = instance_create_depth(px, py, -100000, FX_Effect);
        if (fx != noone) {
            fx.display_at_center = true;
            fx.spriteGhost = cfg.spriteGhost;
            fx.imageGhost = cfg.imageGhost;
            fx.image_xscale = cfg.image_xscale;
            fx.image_yscale = cfg.image_yscale;
            fx.image_angle = cfg.image_angle;
            fx.duration_ms = cfg.duration_ms;
            fx.halo_pad_px = cfg.halo_pad_px;
            fx.halo_thickness = cfg.halo_thickness;
            fx.halo_oval_xmul = cfg.halo_oval_xmul;
            fx.halo_oval_ymul = cfg.halo_oval_ymul;
            if (oncomp != noone) fx.on_complete_action = oncomp;
            global.fx_aura_lock = true;
            global.fx_aura_instance = fx;
        } else if (script_exists(asset_get_index("fxAuraOnPresentationFinished"))) {
            fxAuraOnPresentationFinished();
        }
        global.fx_aura_next_on_complete = noone;
    } else {
        if (oncomp != noone) cfg.on_complete_action = oncomp;
        ds_queue_enqueue(global.fx_aura_queue, cfg);
        global.fx_aura_next_on_complete = noone;
    }
}

/// @function fxAuraGetPresentationGhost(card)
/// @description Face visible + échelle centre (évite dos main ennemie / mini-carte)
function fxAuraGetPresentationGhost(_card) {
    var ghost = {
        sprite: -1,
        image: 0,
        xscale: 1,
        yscale: 1,
        angle: 0
    };
    if (_card == noone || !instance_exists(_card)) return ghost;

    ghost.sprite = _card.sprite_index;
    ghost.image = _card.image_index;
    ghost.angle = _card.image_angle;
    if (ghost.angle == 180) ghost.angle = 0;
    ghost.xscale = DUEL_FX_AURA_CARD_SCALE;
    ghost.yscale = DUEL_FX_AURA_CARD_SCALE;

    if (variable_instance_exists(_card, "isFaceDown") && _card.isFaceDown) {
        ghost.image = 1;
    }

    // Sorts / magies : face visible (bot / main)
    if (variable_instance_exists(_card, "type") && _card.type == "Magic") {
        ghost.image = 0;
        ghost.angle = 0;
    } else if (variable_instance_exists(_card, "genre")) {
        var g = string_lower(_card.genre);
        if (g == "sort" || g == "direct") {
            ghost.image = 0;
            ghost.angle = 0;
        }
    }

    return ghost;
}

/// @function fxAuraPresentCard(card)
function fxAuraPresentCard(_card) {
    if (_card == noone || !instance_exists(_card)) return;
    var g = fxAuraGetPresentationGhost(_card);
    requestFXAura(
        g.sprite,
        g.image,
        g.xscale,
        g.yscale,
        g.angle,
        DUEL_FX_AURA_DURATION_MS,
        DUEL_FX_AURA_PAD,
        DUEL_FX_AURA_THICKNESS,
        DUEL_FX_AURA_OVAL_X,
        DUEL_FX_AURA_OVAL_Y,
        _card.x,
        _card.y
    );
}

/// @function fxAuraStartPresentationIfIdle(card)
function fxAuraStartPresentationIfIdle(_card) {
    fxAuraInitQueues();
    if (global.fx_aura_lock) return;
    fxAuraPresentCard(_card);
}

/// @function fxAuraEnqueueExecuteEffect(card, effect, context)
function fxAuraEnqueueExecuteEffect(_card, _effect, _context) {
    fxAuraInitQueues();
    array_push(global.fx_aura_effect_queue, {
        kind: "execute_effect",
        card: _card,
        effect: _effect,
        context: is_struct(_context) ? _context : {}
    });
}

/// @function fxAuraEnqueueActivateEffectAction(payload)
function fxAuraEnqueueActivateEffectAction(_payload) {
    fxAuraInitQueues();
    array_push(global.fx_aura_effect_queue, {
        kind: "activate_effect_action",
        payload: _payload
    });
}

/// @function fxAuraEnqueueSpellHandPlay(handInst, card, effectTarget, isHeroOwner, removedIndex, modeResolved)
function fxAuraEnqueueSpellHandPlay(_handInst, _card, _effectTarget, _isHeroOwner, _removedIndex, _modeResolved) {
    fxAuraInitQueues();
    array_push(global.fx_aura_effect_queue, {
        kind: "spell_hand_play",
        hand_inst: _handInst,
        card: _card,
        effect_target: _effectTarget,
        is_hero_owner: _isHeroOwner,
        removed_index: _removedIndex,
        mode_resolved: _modeResolved
    });
}

/// @function fxAuraApplyQueuedItem(item)
function fxAuraApplyQueuedItem(_item) {
    if (!is_struct(_item) || !variable_struct_exists(_item, "kind")) return;

    switch (_item.kind) {
        case "execute_effect":
            var card = _item.card;
            var effect = _item.effect;
            var ctx = variable_struct_exists(_item, "context") ? _item.context : {};
            if (card == noone || !instance_exists(card)) return;
            if (!is_struct(effect)) return;

            ctx = fxAuraContextWithSkip(ctx);
            var effectSucceeded = executeEffect(card, effect, ctx);
            if (effectSucceeded) {
                if (script_exists(asset_get_index("markEffectAsUsed"))) {
                    markEffectAsUsed(card, effect);
                }
                if (script_exists(asset_get_index("consumeSpellIfNeeded"))) {
                    consumeSpellIfNeeded(card, effect);
                }
            }
            break;

        case "activate_effect_action":
            if (variable_struct_exists(_item, "payload") && script_exists(asset_get_index("RequestGameAction"))) {
                var payload = _item.payload;
                if (!is_struct(payload)) payload = {};
                payload.fx_aura_skip = true;
                RequestGameAction(ACTION_ACTIVATE_EFFECT, payload);
            }
            break;

        case "spell_hand_play":
            var handInst = _item.hand_inst;
            if (handInst != noone && instance_exists(handInst) && variable_instance_exists(handInst, "finishSpellPlayAfterAura")) {
                handInst.finishSpellPlayAfterAura(
                    _item.card,
                    _item.effect_target,
                    _item.is_hero_owner,
                    _item.removed_index,
                    _item.mode_resolved
                );
            }
            break;
    }
}

/// @function fxAuraCardForQueueItem(item)
function fxAuraCardForQueueItem(_item) {
    if (!is_struct(_item)) return noone;
    if (variable_struct_exists(_item, "card")) return _item.card;
    return noone;
}

/// @function fxAuraResolveNextPendingEffect()
/// @description Résout un seul effet en file, puis enchaîne un halo si d'autres attendent
function fxAuraResolveNextPendingEffect() {
    fxAuraInitQueues();
    if (array_length(global.fx_aura_effect_queue) == 0) return;

    var item = global.fx_aura_effect_queue[0];
    array_delete(global.fx_aura_effect_queue, 0, 1);
    fxAuraApplyQueuedItem(item);

    if (array_length(global.fx_aura_effect_queue) > 0) {
        fxAuraAdvanceQueueWithoutLock();
    }
}

/// @function fxAuraOnPresentationFinished()
/// @description Appelé à la fin d'un halo — résout un effet puis enchaîne halo ou libère le verrou
function fxAuraOnPresentationFinished() {
    fxAuraResolveNextPendingEffect();

    fxAuraInitQueues();
    if (array_length(global.fx_aura_effect_queue) > 0) {
        if (!global.fx_aura_lock) {
            fxAuraAdvanceQueueWithoutLock();
        }
        if (array_length(global.fx_aura_effect_queue) > 0 && global.fx_aura_lock) {
            return;
        }
        if (array_length(global.fx_aura_effect_queue) > 0) {
            while (array_length(global.fx_aura_effect_queue) > 0) {
                var stuck = global.fx_aura_effect_queue[0];
                array_delete(global.fx_aura_effect_queue, 0, 1);
                fxAuraApplyQueuedItem(stuck);
            }
        }
    }

    var __has_queue = (global.fx_aura_queue != undefined) && (ds_queue_size(global.fx_aura_queue) > 0);
    if (__has_queue) {
        var cfg = ds_queue_dequeue(global.fx_aura_queue);
        var px = room_width * 0.5;
        var py = room_height * 0.5;
        var fx = instance_create_depth(px, py, -100000, FX_Effect);
        if (fx != noone) {
            fx.display_at_center = true;
            if (variable_struct_exists(cfg, "spriteGhost")) fx.spriteGhost = cfg.spriteGhost;
            fx.imageGhost = cfg.imageGhost;
            fx.image_xscale = cfg.image_xscale;
            fx.image_yscale = cfg.image_yscale;
            fx.image_angle = cfg.image_angle;
            fx.duration_ms = cfg.duration_ms;
            fx.halo_pad_px = cfg.halo_pad_px;
            fx.halo_thickness = cfg.halo_thickness;
            fx.halo_oval_xmul = cfg.halo_oval_xmul;
            fx.halo_oval_ymul = cfg.halo_oval_ymul;
            if (variable_struct_exists(cfg, "on_complete_action")) {
                fx.on_complete_action = cfg.on_complete_action;
            }
            global.fx_aura_lock = true;
            global.fx_aura_instance = fx;
        } else {
            fxAuraOnPresentationFinished();
        }
        return;
    }

    global.fx_aura_lock = false;
    global.fx_aura_instance = noone;
}

/// @function fxAuraPresentThenExecuteEffect(card, effect, context)
function fxAuraPresentThenExecuteEffect(_card, _effect, _context) {
    if (_card == noone || !instance_exists(_card)) return;
    fxAuraEnqueueExecuteEffect(_card, _effect, _context);
    fxAuraStartPresentationIfIdle(_card);
}

/// @function fxAuraPresentThenActivateEffect(card, payload)
function fxAuraPresentThenActivateEffect(_card, _payload) {
    if (_card == noone || !instance_exists(_card)) return;
    fxAuraEnqueueActivateEffectAction(_payload);
    fxAuraStartPresentationIfIdle(_card);
}
