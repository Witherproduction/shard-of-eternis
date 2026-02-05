// oTalentPanel - Step Event

// Gestion Fermeture
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

// Bouton Fermer
hover_close = (mx >= close_btn_rect.x1 && mx <= close_btn_rect.x2 && my >= close_btn_rect.y1 && my <= close_btn_rect.y2);
if (hover_close && click) {
    instance_destroy();
    exit;
}

// Gestion Choix Talents
hover_choice = { tier: -1, choice: -1 };

var start_y = y + header_h + 20;

for (var i = 0; i < array_length(talent_tree); i++) {
    var tier = talent_tree[i];
    var tier_y = start_y + i * row_h;
    
    // Vérifier si débloqué
    // Note: req_chapter signifie "Chapitre X complété" ou "Début Chapitre X"?
    // Supposons: req_chapter 1 = Faut avoir fini Chapitre 1.
    // Utilisons is_chapter_complete(req_chapter) ou similaire.
    // Pour simplifier, on check si story_progress_is_reward_unlocked ou autre.
    // Ici on va utiliser une logique simple: Chapitre ID < Current Chapter ID ?
    // Ou mieux: On suppose que req_chapter est l'ID du chapitre qu'il faut avoir FINI.
    // Donc si req_chapter = 1, il faut que le chapitre 1 soit marqué comme complet (tous les actes).
    // Ou simplement check si le chapitre suivant est débloqué.
    
    // On va utiliser une fonction helper locale ou globale
    var unlocked = true;
    if (variable_struct_exists(tier, "req_chapter")) {
        // Logique temporaire: Si on a accès au chapitre (req_chapter + 1), c'est bon ?
        // Non, "Les point se debloque au fur et a mesure qu'on avabnce".
        // Disons: req_chapter 1 => Chapitre 1 terminé.
        // On check si le chapitre (req_chapter + 1) est débloqué (car on débloque le suivant quand on finit).
        // is_chapter_unlocked(tier.req_chapter + 1) ?
        // Mais attention au dernier chapitre.
        
        // Alternative: Vérifier si le chapitre req_chapter est terminé.
        // is_chapter_complete n'existe pas directement en global, mais on peut vérifier l'acte 4 du chapitre.
        unlocked = is_act_complete(tier.req_chapter, 4); // Suppose 4 actes
    }
    
    if (unlocked) {
        // Positions des boutons choix
        // var choice_w = 300; // Utilise variable instance
        // var choice_h = 140; // Utilise variable instance
        
        var ax = tree_center_x - choice_w - 20;
        var bx = tree_center_x + 20;
        var cy = tier_y + 20;
        
        // Choix A (Gauche)
        if (mx >= ax && mx <= ax + choice_w && my >= cy && my <= cy + choice_h) {
            hover_choice = { tier: i, choice: 0 };
            if (click) {
                // Si déjà sélectionné, on désélectionne ? Non, switch.
                if (selected_talents[i] == 0) {
                     // Rien ou désélection ? Gardons sélectionné.
                } else {
                    selected_talents[i] = 0;
                    story_progress_save_talent(hero_id, i, 0);
                }
            }
        }
        
        // Choix B (Droite)
        if (mx >= bx && mx <= bx + choice_w && my >= cy && my <= cy + choice_h) {
            hover_choice = { tier: i, choice: 1 };
            if (click) {
                if (selected_talents[i] == 1) {
                     // Rien
                } else {
                    selected_talents[i] = 1;
                    story_progress_save_talent(hero_id, i, 1);
                }
            }
        }
    }
}
