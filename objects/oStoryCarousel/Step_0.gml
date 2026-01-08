if (instance_exists(oPanelOptions)) exit;

var left_trigger = keyboard_check_pressed(vk_left) || mouse_wheel_up();
var right_trigger = keyboard_check_pressed(vk_right) || mouse_wheel_down();

if (left_trigger) {
    index = (index - 1 + count) mod count;
    global.current_chapter = index;
    global.current_act = story_progress_get_resume_act(global.current_chapter);
}
if (right_trigger) {
    index = (index + 1) mod count;
    global.current_chapter = index;
    global.current_act = story_progress_get_resume_act(global.current_chapter);
}

var spr = sprite_panel;
var sw = (spr != -1) ? sprite_get_width(spr) : target_w_center;
var sh = (spr != -1) ? sprite_get_height(spr) : target_w_center * (3/2);
var cx = room_width * 0.5;
var off = (sw * scale_center) * 0.5 + gap + (sw * scale_side) * 0.5;
var lx = cx - off;
var rx = cx + off;

// Navigation clic sur les panneaux latéraux
if (mouse_check_button_pressed(mb_left)) {
    var lw = sw * scale_side;
    var lh = sh * scale_side;
    var rw = lw;
    var rh = lh;
    var lleft = lx - lw * 0.5;
    var lright = lx + lw * 0.5;
    var ltop = panel_y - lh * 0.5;
    var lbottom = panel_y + lh * 0.5;
    var rleft = rx - rw * 0.5;
    var rright = rx + rw * 0.5;
    var rtop = panel_y - rh * 0.5;
    var rbottom = panel_y + rh * 0.5;
    if (point_in_rectangle(mouse_x, mouse_y, lleft, ltop, lright, lbottom)) {
        index = (index - 1 + count) mod count;
        global.current_chapter = index;
        global.current_act = story_progress_get_resume_act(global.current_chapter);
    } else if (point_in_rectangle(mouse_x, mouse_y, rleft, rtop, rright, rbottom)) {
        index = (index + 1) mod count;
        global.current_chapter = index;
        global.current_act = story_progress_get_resume_act(global.current_chapter);
    }
}

// Navigation flèches
if (mouse_check_button_pressed(mb_left)) {
    var arr_w = 40 * k;
    var arr_h = 64 * k;
    var axl = lx - (sw * scale_side) * 0.5 - arr_w * 1.5;
    var axr = rx + (sw * scale_side) * 0.5 + arr_w * 1.5;
    var ay = panel_y;
    var lrect_left = axl;
    var lrect_top = ay - arr_h * 0.5;
    var lrect_right = axl + arr_w;
    var lrect_bottom = ay + arr_h * 0.5;
    var rrect_left = axr - arr_w;
    var rrect_top = ay - arr_h * 0.5;
    var rrect_right = axr;
    var rrect_bottom = ay + arr_h * 0.5;
    if (point_in_rectangle(mouse_x, mouse_y, lrect_left, lrect_top, lrect_right, lrect_bottom)) {
        index = (index - 1 + count) mod count;
        global.current_chapter = index;
        global.current_act = story_progress_get_resume_act(global.current_chapter);
    } else if (point_in_rectangle(mouse_x, mouse_y, rrect_left, rrect_top, rrect_right, rrect_bottom)) {
        index = (index + 1) mod count;
        global.current_chapter = index;
        global.current_act = story_progress_get_resume_act(global.current_chapter);
    }
}

// Clics Panneau Central
if (mouse_check_button_pressed(mb_left)) {
    var cen_w2 = sw * scale_center;
    var cen_h2 = sh * scale_center;
    var ixl = cx - cen_w2 * 0.5 + inner_margin_left * cen_w2;
    var ixr = cx + cen_w2 * 0.5 - inner_margin_right * cen_w2;
    var iyt = panel_y - cen_h2 * 0.5 + inner_margin_top * cen_h2;
    var iyb = panel_y + cen_h2 * 0.5 - inner_margin_bottom * cen_h2;
    var center_x = (ixl + ixr) * 0.5;
    var inner_w = ixr - ixl;
    var btn_w = inner_w * btn_start_width_ratio;
    var btn_h = btn_start_height;
    var btn_x1 = center_x - btn_w * 0.5;
    var btn_x2 = center_x + btn_w * 0.5;
    var btn_y2 = iyb - btn_start_margin_bottom;
    var btn_y1 = btn_y2 - btn_h;
    
    // Mise à jour des coordonnées du bouton (juste pour être sûr)
    // ON NE LE FAIT PAS ICI : On laisse le Draw event gérer btn_rect pour être sûr que ça correspond à l'affichage
    // btn_rect_x1 = btn_x1; btn_rect_y1 = btn_y1; btn_rect_x2 = btn_x2; btn_rect_y2 = btn_y2;

    // Utilisation des coordonnées du rectangle de dessin (btn_rect_*) pour la détection du clic
    // Cela garantit que la zone cliquable correspond exactement à ce que le joueur voit
    var click_start = point_in_rectangle(mouse_x, mouse_y, btn_rect_x1, btn_rect_y1, btn_rect_x2, btn_rect_y2);
    
    if (mouse_check_button_pressed(mb_left)) {
         // Debug clic global
         /*
         show_debug_message("### oStoryCarousel Click: " + string(mouse_x) + "," + string(mouse_y));
         show_debug_message("### Button Rect: " + string(btn_rect_x1) + "," + string(btn_rect_y1) + " - " + string(btn_rect_x2) + "," + string(btn_rect_y2));
         show_debug_message("### Click Start Detected: " + string(click_start));
         show_debug_message("### Current Index/ChapID: " + string(index));
         */
         
         // Force check
         if (mouse_x >= btn_rect_x1 && mouse_x <= btn_rect_x2 && mouse_y >= btn_rect_y1 && mouse_y <= btn_rect_y2) {
             // show_debug_message("### MANUAL CHECK: Inside Rect!");
             click_start = true;
         }
    }
    
    // Logique de clic sur les Actes individuels
     var chap_id = floor(index);
     if (is_chapter_unlocked(chap_id)) {
        var top_y = iyt;
        var y0 = top_y + 180 * k;
        var act_click_w = inner_w * 0.9;
        var act_click_h = line_gap; // Utiliser l'écartement des lignes comme hauteur de zone
        
        for (var i = 1; i <= 4; i++) {
            var ay = y0 + (i - 1) * line_gap;
            var a_x1 = center_x - act_click_w * 0.5;
            var a_y1 = ay - act_click_h * 0.5;
            var a_x2 = center_x + act_click_w * 0.5;
            var a_y2 = ay + act_click_h * 0.5;
            
            if (point_in_rectangle(mouse_x, mouse_y, a_x1, a_y1, a_x2, a_y2)) {
                // Vérifier si l'acte est débloqué
                var unlocked = false;
                if (i == 1) unlocked = true;
                else if (i == 2) unlocked = is_act_complete(chap_id, 1);
                else if (i == 3) unlocked = is_act_complete(chap_id, 2);
                else if (i == 4) unlocked = is_act_complete(chap_id, 3);
                
                if (unlocked) {
                    // Sélectionner l'acte
                    global.current_chapter = chap_id;
                    global.current_act = i;
                    // Jouer un son de sélection ?
                    // audio_play_sound(sndSelect, 10, false);
                    exit; // Clic traité
                }
            }
        }
    }

    if (click_start) {
        
        // Vérification du verrouillage
        if (!is_chapter_unlocked(chap_id)) {
            show_debug_message("### oStoryCarousel: Chapitre " + string(chap_id) + " verrouillé.");
            exit;
        }

        show_debug_message("### oStoryCarousel: clic sur Commencer");
        show_debug_message("### Processing Chapter: " + string(chap_id));
        
        // --- MODIFICATION POUR CHAPITRE 0 (TUTO) ---
        if (chap_id == 0) {
             // show_debug_message("### Starting Tutorial Duel Logic");
             
             if (!room_exists(rDuel)) {
                 show_debug_message("### ERROR: rDuel does not exist!");
                 exit;
             }
             
             // Configuration directe du duel de tutoriel
             global.current_chapter = 0;
             global.current_act = 1;
             
             // Deck Bot
             global.selected_bot_deck_id = "tuto_deck_bot";
             
             // Deck Joueur
             var decks = get_hero_decks_tuto();
             if (array_length(decks) > 0) {
                 global.selected_player_deck = decks[0];
             } else {
                 // Fallback
                 global.selected_player_deck = { name: "Deck Tuto", cards: [] };
             }
             
             // Pas de retour scénario spécifique pour le moment, ou retour au menu
             global.previous_room_before_duel = room; // Retour au carousel
             global.duel_resume_scene = -1; 
             
             audio_stop_all();
             room_goto(rDuel);
             show_debug_message("### room_goto(rDuel) called");
             exit;
        }
        // -------------------------------------------
        
        // Lancer l'acte sélectionné
        var selected_act = global.current_act;
        var start_scene = 0;
        
        // Vérifier si on reprend la progression (acte le plus avancé)
        var resume_act = story_progress_get_resume_act(chap_id);
        
        if (selected_act == resume_act) {
            var last = story_progress_read_last_scene(chap_id);
            // Si l'acte enregistré correspond, on reprend la scène
            if (last.act == selected_act) {
                start_scene = last.scene_index;
            }
        }
        
        global.story_resume_info = { chapter_id: chap_id, act: selected_act, scene_index: start_scene };
        room_goto(rScenario);
    }
}
