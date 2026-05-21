// === oCardParent - Step Event ===

// Update Ambidextrous Timer
if (variable_instance_exists(id, "isAmbidextrous") && isAmbidextrous) {
    ambidextrousAnimTimer++;
}

// --- STATS INITIALIZATION SYNC ---
// Ensure max_hp/current_hp are correctly set if PV was assigned after Create event (e.g. in child Create)
if (!variable_instance_exists(id, "stats_initialized")) {
    // 1. HP/PV Sync (Monsters only)
    if (variable_instance_exists(id, "PV") && PV > 0) {
        if (!variable_instance_exists(id, "max_hp") || max_hp <= 0) {
            max_hp = PV;
            if (!variable_instance_exists(id, "current_hp") || current_hp <= 0) {
                current_hp = max_hp;
            }
        }
    }

    // Stats imprimées : beaucoup de cartes définissent attack/PV après event_inherited()
    if (variable_instance_exists(id, "original_attack") && original_attack == 0 && variable_instance_exists(id, "attack") && attack > 0) {
        original_attack = attack;
    }
    if (variable_instance_exists(id, "original_PV") && original_PV == 0 && variable_instance_exists(id, "PV") && PV > 0) {
        original_PV = PV;
    }

    // 2. Effective Stats Sync (Attack/Defense)
    // Ensures stats are correct even if assigned after Create event (e.g. in Child object)
    var has_buffs = (variable_instance_exists(id, "buff_contribs") && is_array(buff_contribs) && array_length(buff_contribs) > 0);
    
    if (has_buffs) {
        if (script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(id);
        }
    } else {
        if (variable_instance_exists(id, "effective_defense") && variable_instance_exists(id, "PV")) {
            effective_defense = PV;
        }
        if (variable_instance_exists(id, "effective_attack") && variable_instance_exists(id, "attack")) {
            effective_attack = attack;
        }
    }
    stats_initialized = true;
}

if (variable_instance_exists(id, "position_anim_active") && position_anim_active) {
    // Lire vitesses/délai depuis globals si non définis
    if (!variable_instance_exists(id, "anim_rotate_speed")) {
        anim_rotate_speed = (variable_global_exists("ANIM_ROTATE_SPEED") ? global.ANIM_ROTATE_SPEED : 6);
    }
    if (!variable_instance_exists(id, "anim_flip_speed")) {
        anim_flip_speed = (variable_global_exists("ANIM_FLIP_SPEED") ? global.ANIM_FLIP_SPEED : 0.03);
    }
    if (!variable_instance_exists(id, "anim_pre_delay_frames")) {
        anim_pre_delay_frames = (variable_global_exists("ANIM_ROTATE_PRE_DELAY_FRAMES") ? global.ANIM_ROTATE_PRE_DELAY_FRAMES : 6);
    }
    if (!variable_instance_exists(id, "anim_phase")) anim_phase = "rotate";
    if (!variable_instance_exists(id, "anim_flip_orig_scale")) anim_flip_orig_scale = image_xscale;
    if (!variable_instance_exists(id, "target_angle")) target_angle = image_angle;

    var pi_c = 3.141592653589793;

    // Phase 1: flip-in (rétrécit X)
    if (anim_phase == "flip_in") {
        if (!variable_instance_exists(id, "anim_init_flip_in") || !anim_init_flip_in) {
            anim_init_flip_in = true;
            anim_timer = 0;
            flip_start = image_xscale;
            flip_end = 0;
            anim_duration = max(1, round(abs(flip_start - flip_end) / max(0.001, anim_flip_speed)));
        }
        anim_timer = min(anim_timer + 1 / anim_duration, 1);
        var t = -(cos(pi_c * anim_timer) - 1) / 2; // easeInOutSine
        image_xscale = lerp(flip_start, flip_end, t);
        if (anim_timer >= 1) {
            image_xscale = 0;
            image_index = 0;
            if (variable_instance_exists(id, "isFaceDown")) isFaceDown = false;
            anim_init_flip_in = false;
            anim_phase = "flip_out";
        }
    }
    // Phase 2: flip-out (ré-élargit X)
    else if (anim_phase == "flip_out") {
        if (!variable_instance_exists(id, "anim_init_flip_out") || !anim_init_flip_out) {
            anim_init_flip_out = true;
            anim_timer = 0;
            flip_start = image_xscale;
            flip_end = anim_flip_orig_scale;
            anim_duration = max(1, round(abs(flip_end - flip_start) / max(0.001, anim_flip_speed)));
        }
        anim_timer = min(anim_timer + 1 / anim_duration, 1);
        var t2 = -(cos(pi_c * anim_timer) - 1) / 2;
        image_xscale = lerp(flip_start, flip_end, t2);
        if (anim_timer >= 1) {
            image_xscale = anim_flip_orig_scale;
            anim_init_flip_out = false;
            anim_phase = "rotate";
        }
    }
    // Phase 3: rotation (avec pré-délai léger)
    else if (anim_phase == "rotate") {
        if (!variable_instance_exists(id, "anim_init_rotate") || !anim_init_rotate) {
            anim_init_rotate = true;
            anim_timer = 0;
            anim_start_angle = image_angle;
            anim_end_angle = target_angle;
            anim_delta_angle = anim_end_angle - anim_start_angle;
            anim_duration = max(1, round(abs(anim_delta_angle) / max(0.001, anim_rotate_speed)));
            anim_delay_counter = 0; // pré-délai avant rotation
        }
        // Appliquer le pré-délai
        if (anim_delay_counter < anim_pre_delay_frames) {
            anim_delay_counter++;
        } else {
            // Interpolation ease-in-out
            anim_timer = min(anim_timer + 1 / anim_duration, 1);
            var t3 = -(cos(pi_c * anim_timer) - 1) / 2;
            image_angle = anim_start_angle + anim_delta_angle * t3;
            if (anim_timer >= 1) {
                image_angle = target_angle;
                if (variable_instance_exists(id, "target_orientation")) orientation = target_orientation;
                // Renforcer la synchro finale
                if (variable_instance_exists(id, "isFaceDown") && isFaceDown) {
                    image_index = 1;
                } else {
                    image_index = 0;
                }
                orientationChangedThisTurn = true;
                position_anim_active = false;
                anim_init_rotate = false;
            }
        }
    }
}

// --- Stat mod / icônes capacités (terrain + main joueur) ---
if (variable_instance_exists(id, "type") && type == "Monster") {
    var _statVisZone = (zone == "Field" || zone == "FieldSelected"
        || ((zone == "Hand" || zone == "HandSelected") && variable_instance_exists(id, "isHeroOwner") && isHeroOwner));
    if (_statVisZone) statModAnimTimer += 1;
    else if (variable_instance_exists(id, "statModAnimTimer")) statModAnimTimer = 0;
}

// --- COMBO CHECK (Spell Alert Logic) ---
if (variable_instance_exists(id, "zone") && zone == "Hand") {
    comboAnimTimer += 1;
    if (comboCheckTimer > 0) {
        comboCheckTimer--;
    } else {
        comboCheckTimer = 15; // Check every 15 frames (4 times per sec)
        var newComboState = false;
        
        if (variable_instance_exists(id, "effects") && is_array(effects)) {
            for (var i = 0; i < array_length(effects); i++) {
                var eff = effects[i];
                var conditionsList = [];
                
                if (variable_struct_exists(eff, "condition")) array_push(conditionsList, eff.condition);
                if (variable_struct_exists(eff, "bonus_condition")) array_push(conditionsList, eff.bonus_condition);
                
                // Check in flow
                if (variable_struct_exists(eff, "flow")) {
                    if (is_array(eff.flow)) {
                        for (var k = 0; k < array_length(eff.flow); k++) {
                            var step = eff.flow[k];
                            if (is_struct(step) && variable_struct_exists(step, "condition")) {
                                array_push(conditionsList, step.condition);
                            }
                        }
                    } else if (is_struct(eff.flow)) {
                        if (variable_struct_exists(eff.flow, "condition")) {
                            array_push(conditionsList, eff.flow.condition);
                        }
                    }
                }

                if (array_length(conditionsList) > 0) {
                    // Utilise checkCondition depuis sEffects (doit être accessible)
                    if (script_exists(asset_get_index("checkCondition"))) {
                        // Contexte minimal pour le check
                        var ctx = { owner_is_hero: (variable_instance_exists(id, "isHeroOwner") ? isHeroOwner : true) };
                        for (var c = 0; c < array_length(conditionsList); c++) {
                            if (checkCondition(conditionsList[c], id, ctx)) {
                                newComboState = true;
                                break;
                            }
                        }
                    }
                }
                if (newComboState) break;
            }
        }
        isComboActive = newComboState;
    }
} else {
    isComboActive = false;
}

// --- Détection de survol (sans interférer avec la sélection) ---
// Désactiver le survol pendant une animation de position/flip
if (variable_instance_exists(id, "position_anim_active") && position_anim_active) {
    isHovered = false;
} else {
    // Restreindre le survol aux cartes de la main et du terrain uniquement
    var zone_exists = variable_instance_exists(id, "zone");
    var hover_zone_allowed = zone_exists && (zone == "Hand" || zone == "Field" || zone == "HandSelected" || zone == "FieldSelected");
    if (!hover_zone_allowed) {
        isHovered = false;
    } else {
        // Calculer un rectangle englobant la carte en tenant compte de l'échelle et de la rotation
        var w = sprite_get_width(sprite_index) * image_xscale;
        var h = sprite_get_height(sprite_index) * image_yscale;
        var cx = x;
        var cy = y;
        var ca = cos(image_angle * pi / 180);
        var sa = sin(image_angle * pi / 180);
        var lx1 = -w * 0.5; var ly1 = -h * 0.5;
        var lx2 =  w * 0.5; var ly2 = -h * 0.5;
        var lx3 =  w * 0.5; var ly3 =  h * 0.5;
        var lx4 = -w * 0.5; var ly4 =  h * 0.5;
        var x1 = cx + lx1*ca - ly1*sa; var y1 = cy + lx1*sa + ly1*ca;
        var x2 = cx + lx2*ca - ly2*sa; var y2 = cy + lx2*sa + ly2*ca;
        var x3 = cx + lx3*ca - ly3*sa; var y3 = cy + lx3*sa + ly3*ca;
        var x4 = cx + lx4*ca - ly4*sa; var y4 = cy + lx4*sa + ly4*ca;
        var left_b   = min(min(x1,x2), min(x3,x4));
        var right_b  = max(max(x1,x2), max(x3,x4));
        var top_b    = min(min(y1,y2), min(y3,y4));
        var bottom_b = max(max(y1,y2), max(y3,y4));
        isHovered = (mouse_x >= left_b && mouse_x <= right_b && mouse_y >= top_b && mouse_y <= bottom_b);
    }
}

// --- POISON BUBBLE VISUALS ---
if (variable_instance_exists(id, "isPoisoner") && isPoisoner && variable_instance_exists(id, "zone") && (zone == "Field" || zone == "FieldSelected")) {
    // Spawn new bubbles
    poison_spawn_timer++;
    if (poison_spawn_timer > 10) { // Spawn every ~10 frames
        poison_spawn_timer = 0;
        var bubble_count = irandom_range(1, 2);
        
        var card_w = 0;
        var card_h = 0;
        if (sprite_exists(sprite_index)) {
             card_w = sprite_get_width(sprite_index) * image_xscale;
             card_h = sprite_get_height(sprite_index) * image_yscale;
        } else {
             // Fallback dimensions
             card_w = 100 * image_xscale;
             card_h = 140 * image_yscale;
        }

        repeat(bubble_count) {
            var _r = random_range(2, 6);
            var _life = irandom_range(40, 80);
            var _off_x = random_range(-card_w * 0.4, card_w * 0.4);
            var _off_y = random_range(-card_h * 0.4, card_h * 0.4);
            
            array_push(poison_bubbles, {
                off_x: _off_x,
                off_y: _off_y,
                r: 0, // Start small
                target_r: _r,
                alpha: 0,
                life: _life,
                max_life: _life,
                speed_y: random_range(0.2, 0.5)
            });
        }
    }
    
    // Update existing bubbles
    for (var i = array_length(poison_bubbles) - 1; i >= 0; i--) {
        var b = poison_bubbles[i];
        b.life--;
        b.off_y -= b.speed_y; // Float up
        
        // Growth and Fade logic
        var progress = 1 - (b.life / b.max_life);
        if (progress < 0.2) {
            b.alpha = progress / 0.2; // Fade in
            b.r = lerp(0, b.target_r, progress / 0.2);
        } else if (progress > 0.8) {
            b.alpha = (1 - progress) / 0.2; // Fade out
        } else {
            b.alpha = 1;
        }
        
        if (b.life <= 0) {
            array_delete(poison_bubbles, i, 1);
        }
    }
} else {
    // Clear bubbles if no longer poisoner or not on field
    if (array_length(poison_bubbles) > 0) poison_bubbles = [];
}
