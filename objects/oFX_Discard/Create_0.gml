// oFX_Discard - Create
// Effet de défausse: paramètres de brûlure et déplacement (spécialisé)
// Paramètres attendus via le spawner:
// - spriteGhost: sprite de la carte
// - imageGhost: frame du sprite
// - target_x, target_y: destination (cimetière ou position voulue)
// - duration_ms (optionnel): durée en millisecondes
// - depth_override (optionnel)

start_x = x;
start_y = y;
var game_fps = game_get_speed(gamespeed_fps);

// Durée par défaut ~2.1s
var default_frames = 2.1 * game_fps;
duration = default_frames;
if (variable_instance_exists(self, "duration_ms")) {
    duration = max(1, (duration_ms / 1000.0) * game_fps);
}

// Courbe fantôme
curve_amplitude = 16; // déviation latérale maximale
curve_phase = irandom_range(0, 360) * pi / 180;
arc_amplitude = 24; // arc vertical (vers le haut)

// Apparence initiale
image_xscale = (variable_instance_exists(self, "image_xscale") ? image_xscale : 1);
image_yscale = (variable_instance_exists(self, "image_yscale") ? image_yscale : 1);
image_angle  = (variable_instance_exists(self, "image_angle")  ? image_angle  : 0);
alpha = 0.9;

// Option profondeur
if (variable_instance_exists(self, "depth_override")) {
    depth = depth_override;
}

// Progression
_t = 0;
_wait = 0;
start_delay_frames = 0;
if (variable_instance_exists(self, "start_delay_ms")) {
    start_delay_frames = max(0, (start_delay_ms / 1000.0) * game_fps);
}

// Params de sprite
spr_w = 0;
spr_h = 0;
spr_xoff = 0;
spr_yoff = 0;
if (!variable_instance_exists(self, "imageGhost")) { imageGhost = 0; }
if (!variable_instance_exists(self, "target_x")) { target_x = x; }
if (!variable_instance_exists(self, "target_y")) { target_y = y; }

// Spécifiques à la défausse (brûlure)
burn_px = 0;
flame_jitter_amp = 4;
flame_thickness = 8;
flame_col1 = make_color_rgb(255, 220, 96);
flame_col2 = make_color_rgb(255, 120, 0);

// Sprite d'effet de flamme personnalisé et son
spr_discard = asset_get_index("sDiscardFire");
spr_discard_frames = (spr_discard != -1) ? sprite_get_number(spr_discard) : 0;
discard_cycle_ms = 1000;
discard_start_time = current_time;
discard_scale_x = 1;
discard_scale_y = 1;

snd_discard = asset_get_index("FireDiscard");
snd_discard_id = -1;
if (snd_discard != -1) {
    var dur_ms = round((duration / game_fps) * 1000);
    var pitchD = clamp(3000.0 / max(1, dur_ms), 0.5, 3.0);
    snd_discard_id = audio_play_sound(snd_discard, 0, false);
    if (snd_discard_id != -1) { audio_sound_pitch(snd_discard_id, pitchD); }
}