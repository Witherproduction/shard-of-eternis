// === oStoryManager - Create Event ===
// Gestion de l'interface de sélection Héros / Chapitre

// 1. Récupération des données
heroes = get_story_heroes();

// 2. Initialisation de la sélection
selected_hero_index = -1; // Par défaut : aucun héros sélectionné
selected_chapter_id = -1; // Par défaut : aucun chapitre sélectionné

/*
// Essayer de retrouver le héros correspondant au chapitre actuel (global.current_chapter)
if (variable_global_exists("current_chapter")) {
    var curr = global.current_chapter;
    for (var i = 0; i < array_length(heroes); i++) {
        var h = heroes[i];
        for (var j = 0; j < array_length(h.chapters); j++) {
            if (h.chapters[j] == curr) {
                selected_hero_index = i;
                selected_chapter_id = curr;
                break;
            }
        }
    }
}
*/

// Initialiser l'acte sélectionné
if (!variable_global_exists("current_act")) global.current_act = 1;

// 3. Configuration UI
// Panel Gauche : Liste des Héros
panel_hero_x = 80;
panel_hero_y = 120;
panel_hero_w = 350;
panel_hero_h = 800;
item_hero_h = 120;
item_hero_margin = 10;

// Panel Droit : Liste des Chapitres (s'ouvre quand un héros est sélectionné)
panel_chap_w = 350;
panel_chap_x = 1490; // 1920 - 80 - 350 (Aligné à droite)
panel_chap_y = 120;
panel_chap_h = 800;

chapter_btn_h = 70;
chapter_gap = 10;
acts_top_gap = 10;
act_btn_h = 38;
act_btn_h = 46;
act_row_step = 56;
start_btn_w = 200;
start_btn_h = 60;
start_btn_top_gap = 20;
start_btn_bottom_gap = 10;

// Couleurs et Fonts
col_bg_panel = make_color_rgb(30, 30, 40);
col_border = make_color_rgb(100, 100, 120);
col_selected = make_color_rgb(60, 60, 80);
col_text_main = c_white;
col_text_dim = c_gray;

// Variables d'interaction
hover_hero_index = -1;
hover_chapter_id = -1;
hover_act_index = -1; // Format: {chapter: id, act: num}

// Bouton Start
btn_start_rect = { x1: 0, y1: 0, x2: 0, y2: 0 };
hover_start_btn = false;


// Fonction pour rafraîchir l'acte par défaut lors du changement de chapitre
function update_resume_act() {
    var resume = story_progress_get_resume_act(selected_chapter_id);
    global.current_act = resume;
}

// Appel initial
update_resume_act();

// Instanciation du MapManager
if (!instance_exists(oMapManager)) {
    instance_create_depth(0, 0, depth, oMapManager);
}
