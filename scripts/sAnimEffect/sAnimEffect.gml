function animEffectQueueInit() {
    if (!variable_global_exists("anim_fx_list") || !is_array(global.anim_fx_list)) {
        global.anim_fx_list = [];
    }
}

function animEffectRequestProjectile(element, srcCard, amount, targetIsHero) {
    animEffectQueueInit();
    if (room != rDuel) return;
    if (srcCard == noone || !instance_exists(srcCard)) return;
    var srcx = srcCard.x; var srcy = srcCard.y;
    var dstx = room_width * 0.85;
    var dsty = room_height * 0.15;
    if (!targetIsHero) {
        var btn = instance_find(oAttackDirectEnemy, 0);
        if (btn != noone) { dstx = btn.x; dsty = btn.y; }
        else {
            var lpE = instance_find(oLP_Enemy, 0); if (lpE != noone) { dstx = lpE.x; dsty = lpE.y; }
        }
    } else {
        var lpH = instance_find(oLP_Hero, 0); if (lpH != noone) { dstx = lpH.x; dsty = lpH.y; }
    }
    var dur = clamp(700 + amount * 80, 700, 1600);
    var size = clamp(6 + amount * 1.5, 6, 18);
    var is_physique = (string_lower(element) == "physique");
    if (is_physique) { dur = clamp(450 + amount * 40, 350, 1000); }
    var sprProj = asset_get_index(is_physique ? "sEpee" : "sBouleDeFeu");
    var sprExpl = asset_get_index(is_physique ? "sBlessure" : "sExplosionFeu");
    var projFrames = (sprProj != -1) ? sprite_get_number(sprProj) : 0;
    var explFrames = (sprExpl != -1) ? sprite_get_number(sprExpl) : 0;
    var expl_fps = 16;
    var expl_per_frame_ms = 1000 / expl_fps;
    var expl_duration_ms = (explFrames > 0) ? expl_per_frame_ms * explFrames : 1000;
    var sndLaunch = is_physique ? asset_get_index("SwordDraw") : asset_get_index("FireBallLaunch");
    var sndImpact = is_physique ? asset_get_index("SwordHit") : asset_get_index("FireBallImpact");
    var sndTravel = is_physique ? -1 : asset_get_index("FireBallTravel");
    var ctrlx = srcx;
    var ctrly = srcy;
    if (is_physique) {
        var mx = (srcx + dstx) * 0.5;
        var my = (srcy + dsty) * 0.5;
        var dx = dstx - srcx;
        var dy = dsty - srcy;
        var dist = point_distance(srcx, srcy, dstx, dsty);
        var nx = -dy;
        var ny = dx;
        var nlen = sqrt(nx * nx + ny * ny);
        if (nlen > 0) { nx /= nlen; ny /= nlen; }
        var dirSign = (variable_instance_exists(srcCard, "isHeroOwner") && srcCard.isHeroOwner) ? -1 : 1;
        var arcAmt = clamp(dist * 0.3, 40, 160) * dirSign;
        ctrlx = mx + nx * arcAmt;
        ctrly = my + ny * arcAmt;
    }
    var fx = {
        kind: "projectile",
        element: string_lower(element),
        start_x: srcx, start_y: srcy,
        end_x: dstx, end_y: dsty,
        start_time: current_time,
        duration: dur,
        size: size,
        spr_proj: sprProj,
        spr_expl: sprExpl,
        spr_proj_frames: projFrames,
        spr_expl_frames: explFrames,
        explosion_time: -1,
        explosion_duration: expl_duration_ms,
        snd_launch: sndLaunch,
        snd_launch_id: -1,
        snd_launch_played: false,
        snd_impact: sndImpact,
        snd_impact_id: -1,
        snd_impact_played: false,
        snd_travel: sndTravel,
        snd_travel_id: -1,
        snd_travel_started: false,
        snd_base_ms: 3000,
        path_mode: is_physique ? "arc" : "linear",
        ctrl_x: ctrlx,
        ctrl_y: ctrly,
        spin_rate: is_physique ? 0.5 : 0,
        lp_damage_amount: max(0, amount),
        lp_target_is_hero: targetIsHero,
        lp_applied: false
    };
    array_push(global.anim_fx_list, fx);
}

function animEffectRequestProjectileTarget(element, srcCard, targetInstance, amount) {
    // Utilisation du nouveau système FX_Effect (Objet) pour une meilleure fiabilité
    if (room != rDuel) return;
    if (srcCard == noone || !instance_exists(srcCard)) return;
    if (targetInstance == noone || !instance_exists(targetInstance)) return;

    var srcx = srcCard.x; var srcy = srcCard.y;
    var dstx = targetInstance.x;
    var dsty = targetInstance.y;

    // Calcul de la durée (pour déterminer la vitesse)
    var dur_ms = clamp(700 + amount * 80, 700, 1600);
    var is_physique = (string_lower(element) == "physique");
    if (is_physique) { dur_ms = clamp(450 + amount * 40, 350, 1000); }
    
    // Calcul de la vitesse (pixels par step)
    // Vitesse = Distance / (Duration_ms / 1000 * 60)
    var dist = point_distance(srcx, srcy, dstx, dsty);
    var frames = (dur_ms / 1000) * 60; // Base 60 FPS
    var spd = (frames > 0) ? (dist / frames) : 25;
    
    // Choix du sprite et sons
    var sprProj = asset_get_index(is_physique ? "sEpee" : "sBouleDeFeu");
    var sndLaunch = is_physique ? asset_get_index("SwordDraw") : asset_get_index("FireBallLaunch");
    var sndImpact = is_physique ? asset_get_index("SwordHit") : asset_get_index("FireBallImpact");
    
    // Création de l'effet visuel
    var fx = instance_create_layer(srcx, srcy, "UI", FX_Effect);
    if (fx != noone) {
        fx.mode = "projectile";
        fx.move_speed = spd;
        fx.target_inst = targetInstance;
        fx.spriteGhost = sprProj;
        
        // Configuration manuelle car le Create Event a déjà tourné avec mode="halo"
        fx.sprite_index = sprProj;
        fx.depth = -20000;
        fx.depth_override = -20000;
        fx.snd_impact = sndImpact;
        
        // Jouer le son de lancement maintenant
        if (sndLaunch != -1) {
            audio_play_sound(sndLaunch, 0, false);
        }
        
        // Configuration spécifique pour le physique (rotation)
        if (is_physique) {
            fx.image_angle = 0; 
        }
    }
}

function animEffectDrawAll() {
    if (!variable_global_exists("anim_fx_list") || !is_array(global.anim_fx_list)) return;
    var remaining = [];
    var now = current_time;
    for (var i = 0; i < array_length(global.anim_fx_list); i++) {
        var fx = global.anim_fx_list[i];
        if (!is_struct(fx)) continue;
        if (fx.kind == "projectile") {
            var t = (now - fx.start_time) / fx.duration;
            if (t < 1) {
                var px = fx.start_x;
                var py = fx.start_y;
                var ang_draw = 90;
                if (variable_struct_exists(fx, "path_mode") && fx.path_mode == "arc") {
                    var omt = 1 - t;
                    px = omt * omt * fx.start_x + 2 * omt * t * fx.ctrl_x + t * t * fx.end_x;
                    py = omt * omt * fx.start_y + 2 * omt * t * fx.ctrl_y + t * t * fx.end_y;
                    var dx1 = 2 * omt * (fx.ctrl_x - fx.start_x) + 2 * t * (fx.end_x - fx.ctrl_x);
                    var dy1 = 2 * omt * (fx.ctrl_y - fx.start_y) + 2 * t * (fx.end_y - fx.ctrl_y);
                    ang_draw = point_direction(0, 0, dx1, dy1);
                } else {
                    px = lerp(fx.start_x, fx.end_x, t);
                    py = lerp(fx.start_y, fx.end_y, t);
                }
                var s  = fx.size;
                var el = fx.element;
                var spin_add = 0;
                if (variable_struct_exists(fx, "spin_rate") && fx.spin_rate != 0) { spin_add = ((now - fx.start_time) * fx.spin_rate) mod 360; }
                if (!fx.snd_launch_played && fx.snd_launch != -1) {
                    var pitchL = clamp(fx.snd_base_ms / fx.duration, 0.5, 3.0);
                    fx.snd_launch_id = audio_play_sound(fx.snd_launch, 0, false);
                    if (fx.snd_launch_id != -1) { audio_sound_pitch(fx.snd_launch_id, pitchL); }
                    fx.snd_launch_played = true;
                }
                if (!fx.snd_travel_started && fx.snd_travel != -1) {
                    var pitchT = clamp(fx.snd_base_ms / fx.duration, 0.5, 3.0);
                    fx.snd_travel_id = audio_play_sound(fx.snd_travel, 0, true);
                    if (fx.snd_travel_id != -1) { audio_sound_pitch(fx.snd_travel_id, pitchT); }
                    fx.snd_travel_started = true;
                }
                if (fx.spr_proj != -1) {
                        var cycle_ms = 1000;
                        var per_frame = (fx.spr_proj_frames > 0) ? (cycle_ms / fx.spr_proj_frames) : cycle_ms;
                        var pf = (fx.spr_proj_frames > 0) ? floor(((now - fx.start_time) mod cycle_ms) / per_frame) : 0;
                        draw_sprite_ext(fx.spr_proj, pf, px, py, 1, 1, ang_draw + spin_add, c_white, 1);
                }
                array_push(remaining, fx);
            } else {
                if (fx.explosion_time < 0) {
                    fx.explosion_time = now;
                    if (fx.snd_travel_started && fx.snd_travel != -1) {
                        audio_stop_sound(fx.snd_travel);
                        fx.snd_travel_started = false;
                    }
                    if (!fx.snd_impact_played && fx.snd_impact != -1) {
                        var pitchI = clamp(fx.snd_base_ms / fx.explosion_duration, 0.5, 3.0);
                        fx.snd_impact_id = audio_play_sound(fx.snd_impact, 0, false);
                        if (fx.snd_impact_id != -1) { audio_sound_pitch(fx.snd_impact_id, pitchI); }
                        fx.snd_impact_played = true;
                    }
                    array_push(remaining, fx);
                } else {
                    var dt = now - fx.explosion_time;
                    if (dt < fx.explosion_duration) {
                        if (fx.spr_expl != -1) {
                            var ef = (fx.spr_expl_frames > 0) ? (floor((dt / (1000 / 16)) mod fx.spr_expl_frames)) : 0;
                            if (string_lower(fx.element) == "physique") {
                                draw_sprite_ext(fx.spr_expl, ef, fx.end_x, fx.end_y, 1, 1, 45, c_white, 1);
                                draw_sprite_ext(fx.spr_expl, ef, fx.end_x, fx.end_y, 1, 1, 135, c_white, 1);
                            } else {
                                draw_sprite_ext(fx.spr_expl, ef, fx.end_x, fx.end_y, 1, 1, 0, c_white, 1);
                            }
                        }
                        array_push(remaining, fx);
                    } else {
                        if (!fx.lp_applied && fx.lp_damage_amount > 0) {
                            if (!is_undefined(loseLPFor)) { loseLPFor(fx.lp_target_is_hero, fx.lp_damage_amount); }
                            fx.lp_applied = true;
                        }
                    }
                }
            }
        }
    }
    global.anim_fx_list = remaining;
    if (array_length(global.anim_fx_list) == 0) {
        if (variable_global_exists("end_turn_processing") && global.end_turn_processing) {
            if (variable_global_exists("end_turn_waiting") && global.end_turn_waiting) {
                if (variable_global_exists("end_turn_ptr")) {
                    global.end_turn_ptr += 1;
                }
                global.end_turn_waiting = false;
                if (variable_global_exists("endTurnSequencerNext") && !is_undefined(global.endTurnSequencerNext)) { global.endTurnSequencerNext(); }
            }
        }
    }
}