// FX_Invocation - Create
// Effet d'invocation: glissade vers le terrain depuis la main + post-effet circuit

// Paramètres attendus via le spawner:
// - card_real: instance de la carte réelle à placer
// - spriteGhost: sprite du fantôme
// - imageGhost: frame du sprite
// - target_x, target_y: destination (emplacement sur le terrain)
// - field_position: index logique de position sur le terrain
// - owner_is_hero: booléen (true si héros)
// - summon_mode: "Summon", "Set", "SpecialSummon"...
// - card_type: "Monster" ou "Magic"
// - desired_orientation (ennemi): "Defense" ou "Attack" (par défaut)
// - duration_ms (optionnel): durée du mouvement (ms)
// - post_fx_duration_ms (optionnel): durée du circuit (ms)
// - depth_override (optionnel)

start_x = x;
start_y = y;

// Durée par défaut ~0.45s
var default_frames = 0.45 * room_speed;
duration = default_frames;
if (variable_instance_exists(self, "duration_ms")) {
    duration = max(1, (duration_ms / 1000.0) * room_speed);
}

// Phase post-effet circuit (~0.6s)
var post_default = 0.6 * room_speed;
post_fx_duration = post_default;
if (variable_instance_exists(self, "phase_duration_ms")) {
    post_fx_duration = max(1, ((phase_duration_ms * 4) / 1000.0) * room_speed);
} else if (variable_instance_exists(self, "post_fx_duration_ms")) {
    post_fx_duration = max(1, (post_fx_duration_ms / 1000.0) * room_speed);
}
// Durée du flash final (par défaut ~0.15s), surcharge via flash_duration_ms
var flash_default = 0.15 * room_speed;
flash_duration = (variable_instance_exists(self, "flash_duration_ms") ? max(1, (flash_duration_ms / 1000.0) * room_speed) : flash_default);
post_fx_t = 0;
finished_move = false;

// Circuit params (set lors de la fin du mouvement)
circ_w = 0;
circ_h = 0;
circ_angle = 0;
col_main = (variable_instance_exists(self, "col_main") ? col_main : make_color_rgb(255, 215, 0));
thickness_start = (variable_instance_exists(self, "thickness_start") ? thickness_start : 6);
thickness_end   = (variable_instance_exists(self, "thickness_end")   ? thickness_end   : 2);
grid_count = 3;

// Paramètres avancés du circuit imprimé (autour de la carte)
circuit_margin   = (variable_instance_exists(self, "circuit_margin")   ? circuit_margin   : 14); // marge hors carte
node_radius      = (variable_instance_exists(self, "node_radius")      ? node_radius      : 6);  // taille des "boules"
trace_thickness  = (variable_instance_exists(self, "trace_thickness")  ? trace_thickness  : 3);  // épaisseur des pistes
trace_out        = (variable_instance_exists(self, "trace_out")        ? trace_out        : 18); // extension vers l'extérieur


// Option profondeur
if (variable_instance_exists(self, "depth_override")) {
    depth = depth_override;
}

// Progression
_t = 0;

// Cibles par défaut
if (!variable_instance_exists(self, "imageGhost")) { imageGhost = 0; }
if (!variable_instance_exists(self, "target_x")) { target_x = x; }
if (!variable_instance_exists(self, "target_y")) { target_y = y; }

// Apparence du fantôme
image_angle  = (variable_instance_exists(self, "image_angle")  ? image_angle  : 0);
alpha = 1.0;

// Échelle : peut être définie par le spawner; sinon 1
image_xscale = (variable_instance_exists(self, "image_xscale") ? image_xscale : 1);
image_yscale = (variable_instance_exists(self, "image_yscale") ? image_yscale : 1);

// Vars spécial summon overlay
ss_sprite_idx = -1;
ss_x = x;
ss_y = y;
ss_alpha = 0.9;
_ss_init_done = false;
ss_intro_frames = round(0.15 * room_speed);
ss_anim_total_frames = round(2.0 * room_speed);
ss_anim_t = 0;
ss_hold_total_frames = round(1.0 * room_speed);
ss_hold_t = 0;
ss_zoom_frames = round(0.5 * room_speed);
ss_anim_frames = round(1.0 * room_speed);
ss_move_total_frames = round(1.0 * room_speed);
ss_pre_total_frames = ss_zoom_frames + ss_anim_frames;
ss_portal_total_frames = ss_pre_total_frames + ss_move_total_frames;
ss_portal_t = 0;

electric_sprite_idx = -1;
var _s1 = asset_get_index("sSummons");
if (_s1 != -1) electric_sprite_idx = _s1;
if (electric_sprite_idx == -1) {
    var _s2 = asset_get_index("sElectricSummon");
    if (_s2 != -1) electric_sprite_idx = _s2;
}
if (electric_sprite_idx == -1) {
    var _s3 = asset_get_index("sSummonLightning");
    if (_s3 != -1) electric_sprite_idx = _s3;
}
if (electric_sprite_idx == -1) {
    var _s4 = asset_get_index("sSpecialSummonElectric");
    if (_s4 != -1) electric_sprite_idx = _s4;
}

snd_invocation = -1;
snd_invocation_id = -1;
snd_invocation_played = false;
if (variable_instance_exists(self, "summon_mode") && summon_mode == "SpecialSummon") {
    var si = asset_get_index("invocationspecial");
    if (si == -1) si = asset_get_index("InvocationSpecial");
    snd_invocation = si;
} else if (variable_instance_exists(self, "summon_mode") && summon_mode == "Summon") {
    var sn = asset_get_index("invocation");
    if (sn == -1) sn = asset_get_index("Invocation");
    snd_invocation = sn;
}
if (snd_invocation != -1) {
    var total_frames = duration + post_fx_duration + flash_duration;
    if (variable_instance_exists(self, "summon_mode") && summon_mode == "SpecialSummon") {
        var pre_total_local = (variable_instance_exists(self, "ss_pre_total_frames") ? ss_pre_total_frames : round(2.0 * room_speed));
        var move_total_local = (variable_instance_exists(self, "ss_move_total_frames") ? ss_move_total_frames : round(1.0 * room_speed));
        total_frames = pre_total_local + move_total_local + post_fx_duration + flash_duration;
    }
    var total_ms = max(1, round((total_frames / room_speed) * 1000));
    var snd_len_ms = 3000;
    var pitchS = clamp(snd_len_ms / total_ms, 0.5, 3.0);
    snd_invocation_id = audio_play_sound(snd_invocation, 0, false);
    if (snd_invocation_id != -1) { audio_sound_pitch(snd_invocation_id, pitchS); }
    snd_invocation_played = true;
}