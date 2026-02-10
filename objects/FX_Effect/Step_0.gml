// FX_Effect - Step

// === MODE PROJECTILE ===
if (variable_instance_exists(self, "mode") && mode == "projectile") {
    // Gestion de l'animation en boucle (si plage définie)
    if (variable_instance_exists(self, "projectile_range")) {
        var p_start = projectile_range[0];
        var p_end   = projectile_range[1];
        if (image_index < p_start) image_index = p_start;
        if (image_index > p_end)   image_index = p_start;
    }

    if (target_inst != noone && instance_exists(target_inst)) {
        var tx = target_inst.x;
        var ty = target_inst.y;
        
        // Calcul du centre précis via la bounding box
        if (variable_instance_exists(target_inst, "bbox_left") && variable_instance_exists(target_inst, "bbox_right")) {
            tx = (target_inst.bbox_left + target_inst.bbox_right) / 2;
            ty = (target_inst.bbox_top + target_inst.bbox_bottom) / 2;
        } else {
            // Fallback si pas de bbox (rare)
            // Si c'est une carte avec origine centrée, x/y sont déjà bons.
            // Si origine en haut à gauche, on ajoute la demi-taille.
            if (variable_instance_exists(target_inst, "sprite_width")) {
                 if (target_inst.sprite_xoffset == 0) { // Origine probable à gauche
                     tx += target_inst.sprite_width / 2;
                     ty += target_inst.sprite_height / 2;
                 }
            }
        }
        
        var dist = point_distance(x, y, tx, ty);
        var angle = point_direction(x, y, tx, ty);
        
        image_angle = angle;
        
        var arrived = false;

        // === GESTION DU MOUVEMENT ===
        if (variable_instance_exists(self, "projectile_duration")) {
            // MODE TEMPOREL (Arc supporté)
            if (!variable_instance_exists(self, "start_time")) {
                 start_time = current_time;
            }
            
            var t = (current_time - start_time) / projectile_duration;
            if (t >= 1) {
                arrived = true;
                t = 1;
            }
            
            var lx = lerp(start_x, tx, t);
            var ly = lerp(start_y, ty, t);
            
            // Gestion de l'arc (courbe)
            if (variable_instance_exists(self, "projectile_arc_height") && projectile_arc_height != 0) {
                 var arc = sin(t * pi) * projectile_arc_height;
                 var dir_base = point_direction(start_x, start_y, tx, ty);
                 // Arc vers la gauche (90) ou droite (-90) ? 90 est standard.
                 lx += lengthdir_x(arc, dir_base + 90);
                 ly += lengthdir_y(arc, dir_base + 90);
            }
            
            // Mise à jour de l'angle pour suivre la trajectoire (si pas de rotation forcée plus tard)
            if (!arrived && point_distance(x, y, lx, ly) > 0) {
                image_angle = point_direction(x, y, lx, ly);
            }
            
            x = lx;
            y = ly;
            
        } else {
            // MODE VITESSE LINEAIRE (Legacy)
            if (dist > move_speed) {
                x += lengthdir_x(move_speed, angle);
                y += lengthdir_y(move_speed, angle);
            } else {
                arrived = true;
            }
        }

        // Rotation visuelle supplémentaire (ex: hache/épée qui tourne)
        if (variable_instance_exists(self, "projectile_rotate") && projectile_rotate) {
            var rot_spd = 0.5;
            if (variable_instance_exists(self, "projectile_rotate_speed")) rot_spd = projectile_rotate_speed;
            // On ajoute à l'angle actuel ou on tourne en continu ?
            // L'implémentation précédente faisait += (time * 0.5), ce qui est une rotation absolue basée sur le temps
            // On va garder ça mais permettre de contrôler la vitesse
            image_angle += (current_time * rot_spd) % 360;
        }
        
        if (arrived) {
            // Impact
            x = tx;
            y = ty;
            
            // Son d'impact
            if (variable_instance_exists(self, "snd_impact") && snd_impact != -1) {
                audio_play_sound(snd_impact, 0, false);
            }
            
            // Créer l'explosion si un sprite est défini
            if (variable_instance_exists(self, "spr_explosion") && spr_explosion != -1) {
                // Utiliser instance_create_depth pour éviter le crash si 'layer' est -1 (depth managed)
                var expl = instance_create_depth(x, y, depth - 1, FX_Effect);
                if (expl != noone) {
                    expl.mode = "one_shot";
                    expl.sprite_index = spr_explosion;
                    expl.image_speed = 1;
                    
                    // Appliquer une vitesse d'animation personnalisée si définie
                    if (variable_instance_exists(self, "explosion_image_speed")) {
                        expl.image_speed = explosion_image_speed;
                    }
                    
                    // Passer la durée personnalisée si définie (pour les sprites à 1 frame)
                    if (variable_instance_exists(self, "explosion_duration")) {
                        expl.one_shot_duration = explosion_duration;
                        expl.start_time = current_time;
                    }

                    expl.depth = depth - 1; // Un peu devant
                    expl.depth_override = depth - 1;
                    
                    // Gestion de la plage d'animation pour l'explosion (si définie)
                    if (variable_instance_exists(self, "explosion_range")) {
                        expl.anim_range = explosion_range;
                        expl.image_index = explosion_range[0];
                    }
                    
                    // Passer le callback à l'explosion pour qu'il s'exécute à la fin de l'animation
                    expl.callback = callback;
                }
            } else {
                // Si pas d'explosion, exécuter le callback immédiatement
                if (callback != noone && is_method(callback)) {
                    callback();
                }
            }
            
            // Ne plus exécuter le callback ici car il est délégué à l'explosion (ou déjà fait si pas d'explosion)
            instance_destroy();
        }
    } else {
        // Cible perdue
        instance_destroy();
    }
    return;
}

// === MODE ONE_SHOT (Explosion/Animation simple) ===
if (variable_instance_exists(self, "mode") && mode == "one_shot") {
    
    // Si une durée explicite est définie, on l'utilise PRIORITAIREMENT sur les frames
    if (variable_instance_exists(self, "one_shot_duration")) {
        if (!variable_instance_exists(self, "start_time")) start_time = current_time;
        
        if (current_time >= start_time + one_shot_duration) {
            if (variable_instance_exists(self, "callback") && callback != noone && is_method(callback)) {
                callback();
            }
            instance_destroy();
        }
        return; // On sort pour ne pas exécuter la logique par frame
    }

    var end_frame = image_number - 1;
    if (variable_instance_exists(self, "anim_range")) {
        end_frame = anim_range[1];
    }

    // Détruire à la fin de l'animation
    if (image_index >= end_frame) {
        if (variable_instance_exists(self, "callback") && callback != noone && is_method(callback)) {
            callback();
        }
        instance_destroy();
    }
    return;
}

// === MODE HALO (Legacy) ===
_t++;
var progress = clamp(_t / duration, 0, 1);

// Lissage Smoothstep
var ease = progress * progress * (3 - 2 * progress);

// Centre de l'écran si demandé
if (display_at_center) {
    x = room_width * 0.5;
    y = room_height * 0.5;
}

// Calcul paresseux des dimensions du sprite
if ((spr_w <= 0 || spr_h <= 0) && variable_instance_exists(self, "spriteGhost") && spriteGhost != noone) {
    spr_w   = sprite_get_width(spriteGhost);
    spr_h   = sprite_get_height(spriteGhost);
    spr_xoff = sprite_get_xoffset(spriteGhost);
    spr_yoff = sprite_get_yoffset(spriteGhost);
}

// Expansion douce du halo (respire légèrement)
var expand = sin(progress * pi) * halo_expand_px;

// Alpha du halo: fade-in -> plein -> fade-out
var halo_a = halo_base_alpha;
if (_t <= fade_in_frames) {
    halo_a = halo_base_alpha * (_t / max(1, fade_in_frames));
} else if (_t >= (duration - fade_out_frames)) {
    var rem = duration - _t;
    halo_a = halo_base_alpha * (rem / max(1, fade_out_frames));
}

halo_alpha_current = halo_a;
halo_expand_current = expand;

// Fin
// Lorsque le halo est terminé, enchaîner la file ou libérer le verrou
if (progress >= 1) {
    // Exécuter l'action de fin, si fournie pour CE halo
    if (variable_instance_exists(self, "on_complete_action") && is_callable(on_complete_action)) {
        var __fn = on_complete_action;
        on_complete_action = noone;
        __fn();
    }

    // Vérifier la présence d'une queue valide et non vide
    var __has_queue = variable_global_exists("fx_aura_queue") && (global.fx_aura_queue != undefined) && (ds_queue_size(global.fx_aura_queue) > 0);
    if (__has_queue) {
        var cfg = ds_queue_dequeue(global.fx_aura_queue);
        var px = room_width * 0.5;
        var py = room_height * 0.5;
        var fx = instance_create_depth(px, py, -100000, FX_Effect);
        if (fx != noone) {
            // Aura centrée: ne pas forcer la position carte
            fx.display_at_center = true;
            // Paramètres visuels
            if (variable_struct_exists(cfg, "spriteGhost")) {
                fx.spriteGhost = cfg.spriteGhost;
            }
            fx.imageGhost     = cfg.imageGhost;
            fx.image_xscale   = cfg.image_xscale;
            fx.image_yscale   = cfg.image_yscale;
            fx.image_angle    = cfg.image_angle;
            fx.duration_ms    = cfg.duration_ms;
            fx.halo_pad_px    = cfg.halo_pad_px;
            fx.halo_thickness = cfg.halo_thickness;
            fx.halo_oval_xmul = cfg.halo_oval_xmul;
            fx.halo_oval_ymul = cfg.halo_oval_ymul;
            // Propager une éventuelle action de fin associée à cet item de queue
            if (variable_struct_exists(cfg, "on_complete_action")) {
                fx.on_complete_action = cfg.on_complete_action;
            }
        }
        global.fx_aura_instance = fx;
    } else {
        global.fx_aura_lock = false;
        global.fx_aura_instance = noone;
        instance_destroy();
    }
}