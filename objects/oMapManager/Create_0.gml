/// @description Init Editor & Map Logic
// Gestion du mode Admin / Édition
editor_active = false;
selected_region_index = 0;
selected_region_name = "";

// Délais pour les inputs (éviter que ça file trop vite)
input_delay = 0;

// Référence au manager de continent
continent_manager = noone;

// Variables pour copier-coller facile
clipboard_str = "";

// Mode Tracé de Polygone (Pochoir)
poly_mode = false;
current_poly_points = []; // Array of structs {x, y} relative to location center


// --- GESTION DE LA CARTE ET TRANSITIONS ---
// États possibles : "IDLE", "ZOOMING_IN", "SHOW_LOCATION", "ZOOMING_OUT"
map_zoom_state = "IDLE";

location_sprite = -1; // Le sprite de la région à afficher (ex: sForetDesVoleur)
location_mask = -1;   // Le masque à appliquer par-dessus (ex: sMasqueForetDesVoleur)
location_alpha = 0;   // Transparence du lieu (0 à 1)

// Zones de révélation (Pochoirs dynamiques)
location_reveal_zones = []; // Array of structs { points: [], condition_check: func }
mask_surface = -1;


zoom_level_initial = 1.0;
zoom_level_target = 2.0;  // Zoom cible lors de la sélection
zoom_speed = 0.05;        // Vitesse du zoom

fade_speed = 0.05;        // Vitesse du fondu

// On s'assure d'être au-dessus du continent pour dessiner la région par-dessus (si besoin)
// Mais comme le continent fade out, l'ordre importe peu si c'est un fondu enchaîné
depth = -100;
