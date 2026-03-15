/// FX_Poison Step: progression de l’animation et destruction différée
if (duration_ms <= 0) duration_ms = 1000;
var elapsed = current_time - start_time;

// Suivre la position de la cible pour garantir l’overlay au bon endroit
if (target != noone && instance_exists(target)) {
    if (variable_instance_exists(target, "x")) x = target.x;
    if (variable_instance_exists(target, "y")) y = target.y;
}

// Ajuster la profondeur une fois la cible disponible ou appliquer un fallback fort
if (!variable_instance_exists(self, "_depth_applied") || !_depth_applied) {
    if (variable_instance_exists(self, "depth_override")) {
        depth = depth_override;
        _depth_applied = true;
    } else if (target != noone && instance_exists(target) && variable_instance_exists(target, "depth")) {
        depth = target.depth - 1;
        _depth_applied = true;
    } else {
        depth = -100000;
        _depth_applied = true;
    }
}

if (elapsed >= duration_ms) {
    if (target != noone && instance_exists(target)) {
        // FIX: Check if poison destruction is still requested (might be cancelled by Illusion)
        if (variable_instance_exists(target, "_delay_instance_destroy_for_poison") && target._delay_instance_destroy_for_poison) {
            var ctx = { destroyed_card: target };
            if (variable_instance_exists(self, "source") && instance_exists(source)) { ctx.attacker = source; }
            var gyInst = noone;
            if (variable_instance_exists(target, "isHeroOwner") && target.isHeroOwner) { gyInst = global.graveyardHero; } else { gyInst = global.graveyardEnemy; }
            if (gyInst != noone && instance_exists(gyInst)) { gyInst.addToGraveyard(target); }
            if (variable_instance_exists(target, "zone") && (target.zone == "Field" || target.zone == "FieldSelected")) {
                registerTriggerEvent(TRIGGER_LEAVE_FIELD, target, ctx);
                var fm = noone;
                if (instance_exists(fieldManagerHero) || instance_exists(fieldManagerEnemy)) {
                    if (variable_instance_exists(target, "isHeroOwner") && target.isHeroOwner && instance_exists(fieldManagerHero)) { fm = fieldManagerHero; }
                    else if (instance_exists(fieldManagerEnemy)) { fm = fieldManagerEnemy; }
                }
                if (fm != noone && variable_instance_exists(target, "fieldPosition")) { fm.remove(target); }
            }
            target.zone = "Graveyard";
            target._delay_instance_destroy_for_poison = false;
            target._skip_destruction_fx = true;
            registerTriggerEvent(TRIGGER_ENTER_GRAVEYARD, target, ctx);
            
            if (!destroy_called) {
                destroy_called = true;
                if (instance_exists(target)) instance_destroy(target);
            }
        }
    }
    instance_destroy();
}