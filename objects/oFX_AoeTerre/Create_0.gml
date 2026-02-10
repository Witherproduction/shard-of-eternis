// oFX_ProceduralSpike - Create Event
// Animation procédurale de pic de pierre sortant du sol

// Paramètres configurables (via `with` après création)
target = noone;
damage_amount = 0;
callback = undefined;
source = noone;

// États de l'animation
phase = 0; // 0: Anticipation (Ombre), 1: Frappe (Pic), 2: Effritement (Débris)
timer = 0;

// Phase 0: Ombre
shadow_alpha = 0;
shadow_radius = 0;
shadow_max_radius = 40;
phase0_duration = 30; // frames

// Phase 1: Pic
spike_height = 0;
spike_max_height = 100; // Hauteur en pixels
spike_width_base = 30;
phase1_duration = 16; // frames (rapide)
damage_applied = false;

// Phase 2: Débris
phase2_duration = 60;
debris_list = []; // Array de structs {x, y, speed_x, speed_y, rot, rot_speed, size}

// Initialisation position (sera écrasée si target existe)
x = 0;
y = 0;

// Couleur
color_spike = make_color_rgb(101, 67, 33); // Marron foncé
color_highlight = make_color_rgb(139, 100, 60); // Marron plus clair
color_shadow = c_black;

depth = -9000; // Devant la plupart des choses

// Gestion du verrouillage d'animation de combat
if (!variable_global_exists("combat_fx_count")) global.combat_fx_count = 0;
global.combat_fx_count++;
