// === oStoryManager - Step Event ===
// Gestion des interactions souris

var mx = mouse_x;
var my = mouse_y;
var click = mouse_check_button_pressed(mb_left);

// --- 1. Gestion du Panel Héros (Gauche) ---
hover_hero_index = -1;

for (var i = 0; i < array_length(heroes); i++) {
    var item_y = panel_hero_y + i * (item_hero_h + item_hero_margin);
    
    // Zone de clic pour le héros
    if (mx >= panel_hero_x && mx <= panel_hero_x + panel_hero_w &&
        my >= item_y && my <= item_y + item_hero_h) {
        
        hover_hero_index = i;
        
        if (click) {
            selected_hero_index = i;
            // Ne pas sélectionner de chapitre par défaut, l'utilisateur doit choisir
            selected_chapter_id = -1;
            
            // Reset Zoom si on change de héros via oMapManager
            if (instance_exists(oMapManager)) {
                oMapManager.map_zoom_state = "ZOOMING_OUT";
            }
        }
    }
}

// --- 2. Gestion du Panel Chapitres (Droit) ---
// Seulement si un héros est sélectionné
hover_chapter_id = -1;
hover_act_index = -1;
hover_start_btn = false;

if (selected_hero_index != -1) {
    var hero = heroes[selected_hero_index];
    var cx = panel_chap_x;
    var cy = panel_chap_y;
    
    // Entête du héros (pas d'interaction spéciale pour l'instant)
    cy += 20; // Espace pour le titre du héros (réduit car titre supprimé)
    
    // Liste des chapitres
    for (var i = 0; i < array_length(hero.chapters); i++) {
        var ch_id = hero.chapters[i];
        var ch_data = get_chapter_data(ch_id);
        var ch_unlocked = is_chapter_unlocked(ch_id);
        
        var ch_h = 60; // Hauteur barre titre chapitre
        var acts_h = 0;
        
        // Si c'est le chapitre sélectionné, on affiche les actes
        if (selected_chapter_id == ch_id) {
            acts_h = array_length(ch_data.acts) * 40 + 20; // 40px par acte + marge
            if (ch_unlocked) acts_h += 80; // Espace pour le bouton Start
        }
        
        // Zone de clic pour le titre du chapitre
        if (mx >= cx && mx <= cx + panel_chap_w &&
            my >= cy && my <= cy + ch_h) {
            
            hover_chapter_id = ch_id;
            
            if (click) {
                selected_chapter_id = ch_id;
                global.current_chapter = selected_chapter_id;
                update_resume_act();
                
                // Déclencher le zoom et afficher le lieu via oMapManager
                if (instance_exists(oMapManager)) {
                    oMapManager.map_zoom_state = "ZOOMING_IN";
                    
                    // Choix du sprite et du masque selon le chapitre
                    oMapManager.location_sprite = -1;
                    oMapManager.location_mask = -1;
                    
                    // Chapitre 1 de Kaelen
                    if (selected_chapter_id == 1) {
                        oMapManager.location_sprite = sForetDesVoleur;
                        oMapManager.location_mask = sMasqueForetDesVoleur;
                        
                        // Définir les zones de révélation (Pochoirs) via le script dédié
                        oMapManager.location_reveal_zones = region_get_zones_ForetDesVoleur();
                    }
                }
            }
        }
        
        // Gestion des Actes (si chapitre sélectionné et débloqué)
        if (selected_chapter_id == ch_id) {
            var ay = cy + ch_h + 10;
            
            if (ch_unlocked) {
                // Liste des actes
                for (var j = 0; j < array_length(ch_data.acts); j++) {
                    var act_num = j + 1;
                    var act_unlocked = false;
                    
                    if (act_num == 1) act_unlocked = true;
                    else if (act_num == 2) act_unlocked = is_act_complete(ch_id, 1);
                    else if (act_num == 3) act_unlocked = is_act_complete(ch_id, 2);
                    else if (act_num == 4) act_unlocked = is_act_complete(ch_id, 3);
                    
                    if (act_unlocked) {
                        // Zone de clic acte
                        if (mx >= cx + 20 && mx <= cx + panel_chap_w - 20 &&
                            my >= ay && my <= ay + 30) {
                            
                            hover_act_index = act_num;
                            
                            if (click) {
                                global.current_act = act_num;
                            }
                        }
                    }
                    ay += 40;
                }
                
                // Bouton Commencer
                var btn_w = 200;
                var btn_h = 50;
                var btn_x = cx + panel_chap_w / 2 - btn_w / 2;
                var btn_y = ay + 20;
                
                btn_start_rect = { x1: btn_x, y1: btn_y, x2: btn_x + btn_w, y2: btn_y + btn_h };
                
                if (mx >= btn_start_rect.x1 && mx <= btn_start_rect.x2 &&
                    my >= btn_start_rect.y1 && my <= btn_start_rect.y2) {
                    
                    hover_start_btn = true;
                    
                    if (click) {
                        // --- Logique de lancement de chapitre ---
                        var ch_id = global.current_chapter;
                        
                        // 1. Cas Spécial : Chapitre 0 (Tutoriel)
                        if (ch_id == 0) {
                             if (!room_exists(rDuel)) {
                                 show_debug_message("### ERROR: rDuel does not exist!");
                                 exit;
                             }
                             
                             global.current_act = 1;
                             global.selected_bot_deck_id = "tuto_deck_bot";
                             
                             // Deck Joueur
                             var decks = get_hero_decks_tuto();
                             if (array_length(decks) > 0) {
                                 global.selected_player_deck = decks[0];
                             } else {
                                 global.selected_player_deck = { name: "Deck Tuto", cards: [] };
                             }
                             
                             global.previous_room_before_duel = room;
                             global.duel_resume_scene = -1; 
                             
                             audio_stop_all();
                             room_goto(rDuel);
                             exit;
                        }
                        
                        // 2. Cas Normal : Scénario
                        if (variable_global_exists("current_chapter") && variable_global_exists("current_act")) {
                             // Préparer les infos de reprise
                             var resume_act = story_progress_get_resume_act(ch_id);
                             var start_scene = 0;
                             
                             // Si on joue l'acte "en cours", on reprend la scène sauvegardée
                             if (global.current_act == resume_act) {
                                 var last = story_progress_read_last_scene(ch_id);
                                 if (last.act == global.current_act) {
                                     start_scene = last.scene_index;
                                 }
                             }
                             
                             global.story_resume_info = { chapter_id: ch_id, act: global.current_act, scene_index: start_scene };
                             room_goto(rScenario);
                        }
                    }
                }
            }
        }
        
        cy += ch_h + acts_h + 10; // Passer au chapitre suivant
    }
}
