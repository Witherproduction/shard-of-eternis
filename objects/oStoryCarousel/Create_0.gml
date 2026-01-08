sprite_panel = asset_get_index("sCarousel");
index = 0;
count = 5;
k = min(room_width / 1920, room_height / 1080);
target_w_center = 560 * k;
target_w_side = 440 * k;
spr_w = (sprite_panel != -1) ? sprite_get_width(sprite_panel) : target_w_center;
scale_center = (target_w_center / spr_w) * 0.9;
scale_side = (target_w_side / spr_w) * 0.9;
panel_y = room_height * 0.55;
gap = 80 * k;
angle_side = 0;
alpha_side = 0.8;
inner_margin_left = 0.12;
inner_margin_right = 0.12;
inner_margin_top = 0.20;
inner_margin_bottom = 0.12;
line_gap = 44 * k;
title_offset = 40 * k;
btn_start_height = 56 * k;
btn_start_width_ratio = 0.6;
btn_start_margin_bottom = 24 * k;
btn_start_hover = false;

// Définition des données de chapitres (Titres et Actes)
chapters_data = [
    {
        title: "Initiation",
        acts: ["Les bases du duel"]
    },
    {
        title: "La foret des voleurs",
        acts: ["L'arrivée du héros", "En route vers l'aventure", "Le récolteur", "La fin de la Terreur"]
    },
    {
        title: "Les plaines gelées",
        acts: ["Le froid mordant", "Traces dans la neige", "Le gardien de glace", "Coeur gelé"]
    },
    {
        title: "Le volcan endormi",
        acts: ["Chaleur montante", "Chemin de lave", "L'esprit du feu", "Eruption"]
    },
    {
        title: "La cité des nuages",
        acts: ["Ascension", "Parmi les cieux", "Le palais céleste", "Chute libre"]
    },
    {
        title: "Le néant",
        acts: ["Obscurité", "Murmures", "Confrontation", "Eternité"]
    }
];

btn_rect_x1 = 0;
btn_rect_y1 = 0;
btn_rect_x2 = 0;
btn_rect_y2 = 0;

// Compter le nombre de chapitres dynamiquement
count = array_length(chapters_data);

// Initialiser la sélection sur le chapitre actuel (ou 0 par défaut pour le tuto)
if (!variable_global_exists("current_chapter")) global.current_chapter = 0;

// Mapping : Index du tableau = ID du chapitre (0 = Tuto, 1 = Chap1, etc.)
index = global.current_chapter; 

// S'assurer que index est valide
if (index < 0) index = 0;
if (index >= count) index = 0;
global.current_chapter = index;

// Initialiser l'acte sélectionné (le plus avancé par défaut)
if (!variable_global_exists("current_act")) global.current_act = 1;
// Mettre à jour l'acte par défaut si nécessaire (au chargement du carousel)
var _resume_act = story_progress_get_resume_act(global.current_chapter);
global.current_act = _resume_act;

