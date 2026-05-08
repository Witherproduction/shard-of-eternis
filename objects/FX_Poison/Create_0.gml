/// FX_Poison Create: initialise l’animation de flaque et la teinte fantomatique
if (!variable_instance_exists(self, "target")) target = noone;
if (!variable_instance_exists(self, "source")) source = noone;

// Appliquer la profondeur par défaut: juste sous la cible si possible
if (variable_instance_exists(self, "depth_override")) {
    depth = depth_override;
} else if (target != noone && instance_exists(target) && variable_instance_exists(target, "depth")) {
    depth = target.depth - 1;
}

start_time = current_time;
duration_ms = 1000;
progress = 0;
var game_fps = game_get_speed(gamespeed_fps);
if (!variable_instance_exists(self, "duration_steps")) duration_steps = max(1, round(game_fps * 1.0));
if (!variable_instance_exists(self, "color")) color = make_color_rgb(60, 200, 80);

alpha_start = 1;
alpha_end   = 1;
radius_start = 6;

var baseScaleX = 1;
var baseScaleY = 1;
if (target != noone && instance_exists(target)) {
    if (variable_instance_exists(target, "image_xscale")) baseScaleX = target.image_xscale;
    if (variable_instance_exists(target, "image_yscale")) baseScaleY = target.image_yscale;
}

var spr = (target != noone && instance_exists(target)) ? target.sprite_index : -1;
var w = (spr != -1) ? sprite_get_width(spr) : 64;
var h = (spr != -1) ? sprite_get_height(spr) : 96;
var base = max(w * baseScaleX, h * baseScaleY);
radius_max = max(radius_start + 1, floor(base * 0.6));

// Sauvegarder l’apparence d’origine pour restaurer ensuite
orig_blend = c_white;
orig_alpha = 1;
if (target != noone && instance_exists(target)) {
    if (variable_instance_exists(target, "image_blend")) orig_blend = target.image_blend; else orig_blend = c_white;
    if (variable_instance_exists(target, "image_alpha")) orig_alpha = target.image_alpha; else orig_alpha = 1;
}

// Drapeau pour éviter double destruction
destroy_called = false;

var spr_poison = asset_get_index("sPoison");
if (spr_poison != -1) {
    sprite_index = spr_poison;
    image_speed = 0;
    image_xscale = 1;
    image_yscale = 1;
}
show_debug_message("### FX_Poison.Create: target=" + string(target) + " spr_set=" + string(spr_poison != -1) + " depth=" + string(depth));

var snd_poison = asset_get_index("Poison");
if (snd_poison != -1) {
    var total_ms = duration_ms;
    var snd_len_ms = 3000;
    snd_id = audio_play_sound(snd_poison, 0, false);
    if (snd_id != -1) {
        audio_sound_pitch(snd_id, clamp(snd_len_ms / total_ms, 0.5, 3.0));
    }
}