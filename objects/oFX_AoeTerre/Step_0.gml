// oFX_ProceduralSpike - Step Event

// Suivi de cible si phase < 2
if (target != noone && instance_exists(target) && phase < 2) {
    x = target.x;
    y = target.y;
    // Ajuster profondeur
    if (variable_instance_exists(target, "depth")) depth = target.depth - 100;
}

timer++;

// Machine à états
switch (phase) {
    case 0: // Anticipation (Ombre)
        var progress = timer / phase0_duration;
        shadow_alpha = lerp(0, 0.6, progress);
        shadow_radius = lerp(0, shadow_max_radius, progress);
        
        if (timer >= phase0_duration) {
            phase = 1;
            timer = 0;
            // Son (optionnel)
            // audio_play_sound(sndEarthRumble, 10, false);
        }
        break;

    case 1: // Frappe (Pic)
        var progress = timer / phase1_duration;
        // Easing cubic out pour impact violent
        var p = 1 - power(1 - progress, 3); 
        spike_height = lerp(0, spike_max_height, p);
        
        // Déclencher dégâts à mi-course ou fin
        if (progress >= 0.8 && !damage_applied) {
            damage_applied = true;
            if (!is_undefined(callback)) {
                callback();
            } else if (target != noone && instance_exists(target)) {
                 // Fallback si pas de callback
                 if (variable_instance_exists(target, "takeDamage")) {
                     target.takeDamage(damage_amount);
                 } else {
                     // Utiliser damageCard si dispo (global script)
                     if (script_exists(asset_get_index("damageCard"))) {
                         damageCard(target, damage_amount);
                     } else {
                         if (variable_instance_exists(target, "current_hp")) target.current_hp -= damage_amount;
                         else if (variable_instance_exists(target, "PV")) target.PV -= damage_amount;
                     }
                 }
                 // FX visuel de dégât sur la cible
                 if (variable_instance_exists(target, "visual_damage")) target.visual_damage(damage_amount);
            }
            // Screen shake léger ?
        }
        
        if (timer >= phase1_duration) {
            phase = 2;
            timer = 0;
            
            // Générer débris
            repeat(5) {
                array_push(debris_list, {
                    dx: random_range(-15, 15), // Offset X relatif au centre
                    dy: -spike_max_height + random_range(0, 20), // Sommet du pic
                    vx: random_range(-4, 4),
                    vy: random_range(-2, -5), // Vers le haut initialement
                    grav: 0.5,
                    rot: random(360),
                    rot_spd: random_range(-10, 10),
                    size: random_range(4, 8)
                });
            }
        }
        break;

    case 2: // Effritement
        // Mise à jour débris
        for (var i = 0; i < array_length(debris_list); i++) {
            var d = debris_list[i];
            d.x = x + d.dx; // dx devient position absolue X temporairement pour calcul, non, restons en relatif
            d.dx += d.vx;
            d.dy += d.vy;
            d.vy += d.grav;
            d.rot += d.rot_spd;
        }
        
        if (timer >= phase2_duration) {
            instance_destroy();
        }
        break;
}