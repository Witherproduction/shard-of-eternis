// oTalentPanel - Create Event

// Initialisation
hero_id = "";
hero_name = "";
hero_power = {};
talent_tree = [];
selected_talents = [];

// UI Dimensions (Centré)
width = 1000;
height = 800;
x = (display_get_gui_width() - width) / 2;
y = (display_get_gui_height() - height) / 2;
tree_center_x = x + width / 2;

// Layout
header_h = 150; // Zone Pouvoir Héroïque
row_h = 180; // Hauteur d'un tier
col_w = 400; // Largeur colonne choix
choice_w = 300; // Largeur bouton choix
choice_h = 140; // Hauteur bouton choix

// Fermeture
close_btn_rect = { x1: x + width - 50, y1: y + 10, x2: x + width - 10, y2: y + 50 };
hover_close = false;

// Initialisation via méthode (appelée après création)
init = function(_hero_id, _hero_name, _hero_power) {
    hero_id = _hero_id;
    hero_name = _hero_name;
    hero_power = _hero_power;
    
    // Charger l'arbre et les choix
    talent_tree = get_hero_talent_tree(hero_id);
    selected_talents = story_progress_get_talents(hero_id);
};

// Gestion de la souris
hover_choice = { tier: -1, choice: -1 }; // { tier: 0, choice: 0 or 1 }
