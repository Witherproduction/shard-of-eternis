/// @description Logique du panneau d’options
// Se caler au centre de l’écran (détection de la vue visible)
var cam = noone;
// Activer le bouton Abandonner uniquement dans la room de duel
abandon_enabled = (room == rDuel);
quit_enabled = (room == rScenario);
if (view_enabled) {
    for (var i = 0; i < 8; i++) {
        if (view_visible[i]) { cam = view_camera[i]; break; }
    }
}

if (cam == noone) {
    // Fallback: centrer dans la room si les vues ne sont pas activées
    x = room_width * 0.5;
    y = room_height * 0.5;
} else {
    var cx = camera_get_view_x(cam) + camera_get_view_width(cam) * 0.5;
    var cy = camera_get_view_y(cam) + camera_get_view_height(cam) * 0.5;
    x = cx;
    y = cy;
}

// Bouton "Retour" interne (centré en bas du panneau) pour fermer le panel
var spr = asset_get_index("sFond");
if (spr != -1) {
    var sx = image_xscale;
    var sy = image_yscale;
    var w = sprite_get_width(spr);
    var h = sprite_get_height(spr);
    var ox = sprite_get_xoffset(spr);
    var oy = sprite_get_yoffset(spr);

    // Zone intérieure (contenu) basée sur le bbox du sprite centré
    var bboxL = sprite_get_bbox_left(spr);
    var bboxR = sprite_get_bbox_right(spr);
    var bboxT = sprite_get_bbox_top(spr);
    var bboxB = sprite_get_bbox_bottom(spr);
    var content_x1 = x - ox * sx + bboxL * sx;
    var content_y1 = y - oy * sy + bboxT * sy;
    var content_x2 = x - ox * sx + bboxR * sx;
    var content_y2 = y - oy * sy + bboxB * sy;
    var content_w = content_x2 - content_x1;
    var content_h = content_y2 - content_y1;

    // Dimensions et placement symétriques des boutons Retour et Abandonner
    var margin = 20;
    var raise_y = 210; // remonter pour rester bien dans le cadre
    var btn_w = 120;
    var btn_h = 40;
    var gap = 20; // "trou" au centre du cadre
    var content_center_x = (content_x1 + content_x2) * 0.5;
    var base_y1 = content_y2 - margin - btn_h - raise_y;
    var base_y2 = base_y1 + btn_h;
    if (base_y2 > content_y2 - margin) {
        var _dy = base_y2 - (content_y2 - margin);
        base_y1 -= _dy;
        base_y2 -= _dy;
    }

    // Bouton Retour (à gauche du centre)
    retour_btn_x2 = content_center_x - gap * 0.5;
    retour_btn_x1 = retour_btn_x2 - btn_w;
    retour_btn_y1 = base_y1;
    retour_btn_y2 = base_y2;

    // Bouton secondaire (à droite du centre): Abandonner (Duel) ou Quitter (Scénario)
    abandon_btn_x1 = content_center_x + gap * 0.5;
    abandon_btn_x2 = abandon_btn_x1 + btn_w;
    abandon_btn_y1 = base_y1;
    abandon_btn_y2 = base_y2;

    // Clic pour fermer le panneau (bouton Retour)
    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mouse_x, mouse_y, retour_btn_x1, retour_btn_y1, retour_btn_x2, retour_btn_y2)) {
            instance_destroy();
            exit;
        }
    }

    // ==========================
    // Bouton Quitter (room Scénario uniquement)
    // ==========================
    if (quit_enabled && !abandon_enabled) {
        if (mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(mouse_x, mouse_y, abandon_btn_x1, abandon_btn_y1, abandon_btn_x2, abandon_btn_y2)) {
                var runner = instance_find(oScenarioRunner, 0);
                if (runner != noone) {
                    if (variable_instance_exists(runner, "chapter_id") && variable_instance_exists(runner, "scene_index") && variable_instance_exists(runner, "act_num")) {
                        story_progress_write_last_scene(runner.chapter_id, runner.scene_index, runner.act_num);
                    }
                    if (variable_instance_exists(runner, "bg_sound_asset_current") && runner.bg_sound_asset_current != -1) {
                        audio_stop_sound(runner.bg_sound_asset_current);
                        runner.bg_sound_asset_current = -1;
                    }
                    if (variable_instance_exists(runner, "bg2_sound_asset_current") && runner.bg2_sound_asset_current != -1) {
                        audio_stop_sound(runner.bg2_sound_asset_current);
                        runner.bg2_sound_asset_current = -1;
                    }
                }
                instance_destroy();
                room_goto(rHistoire);
                exit;
            }
        }
    }

    // ==========================
    // Slider Volume (0..100)
    // ==========================
    // Placement: en haut du cadre, longueur réduite de moitié
    var slider_margin_h = 40;     // marge latérale intérieure
    var slider_top = content_y1 + 170; // descendre encore plus (140 + 30)
    var offset_x = 20;            // petit décalage horizontal entre le label et la barre
    var label_w = 80;             // largeur réservée pour le libellé
    var slider_shift_x = 120;     // décalage vers la droite pour rester dans le cadre
    var track_w = (content_w - slider_margin_h*2 - label_w - offset_x) * 0.6 * 0.95; // 60% dispo (indépendant du shift)
    var track_h = 6;
    var track_x1 = content_x1 + slider_margin_h + label_w + offset_x + slider_shift_x;
    var track_x2 = track_x1 + track_w;
    track_w *= 0.95;
    track_x2 = track_x1 + track_w;
    var track_y  = slider_top;
    var vol_label_x_loc = content_x1 + slider_margin_h + slider_shift_x;
    var right_limit = content_x2 - 20;
    var vol_right = track_x2 + 60;
    if (vol_right > right_limit) {
        var _dx = vol_right - right_limit;
        track_x1 -= _dx;
        track_x2 -= _dx;
        vol_label_x_loc -= _dx;
    }

    // Conserver pour Draw
    vol_track_x1 = track_x1;
    vol_track_x2 = track_x2;
    vol_track_y  = track_y;
    vol_label_x  = vol_label_x_loc;
    vol_label_y  = track_y; // aligner au centre de la barre

    // Interaction: clic/drag sur la barre ou le curseur
    var knob_radius = 10;
    var knob_x = lerp(track_x1, track_x2, vol_value / 100);
    var knob_y = track_y;
    var over_track = point_in_rectangle(mouse_x, mouse_y, track_x1, track_y - 10, track_x2, track_y + 10);
    var over_knob  = point_distance(mouse_x, mouse_y, knob_x, knob_y) <= knob_radius + 3;

    // Démarrer le drag si clic sur la barre ou le knob
    if (mouse_check_button_pressed(mb_left)) {
        if (over_track || over_knob) {
            vol_dragging = true;
        }
    }
    // Mettre à jour pendant le drag
    if (vol_dragging && mouse_check_button(mb_left)) {
        var t = clamp((mouse_x - track_x1) / (track_x2 - track_x1), 0, 1);
        var new_val = round(t * 100);
        if (new_val != vol_value) {
            vol_value = new_val;
            global.volume_percent = vol_value;
            var _gain2 = vol_value / 100;
            audio_master_gain(_gain2);
        }
    }
    // Relâcher et persister la valeur
    if (vol_dragging && mouse_check_button_released(mb_left)) {
        vol_dragging = false;
        ini_open("options.ini");
        ini_write_real("audio", "volume_percent", vol_value);
        ini_close();
    }

    // ==========================
    // Bloc Mode d'affichage (Dropdown)
    // ==========================
    var dm_pad = 8;
    var dm_top = track_y + 50; // sous le slider volume
    
    // Mise à jour positions (au cas où x/y changent)
    var dm_label_x_loc = content_x1 + slider_margin_h + slider_shift_x;
    var dm_label_y_loc = dm_top;
    
    var dm_dropdown_w = 160 * 0.95;
    var dm_dropdown_h = 25;
    
    var dm_dropdown_x1_loc = dm_label_x_loc + 120;
    var dm_dropdown_y1_loc = dm_top - dm_dropdown_h * 0.5;
    dm_dropdown_w *= 1.05;
    var dm_dropdown_x2_loc = dm_dropdown_x1_loc + dm_dropdown_w;
    var dm_dropdown_y2_loc = dm_dropdown_y1_loc + dm_dropdown_h;
    var dm_right = dm_dropdown_x2_loc + dm_pad;
    if (dm_right > right_limit) {
        var _dxm = dm_right - right_limit;
        dm_label_x_loc -= _dxm;
        dm_dropdown_x1_loc -= _dxm;
        dm_dropdown_x2_loc -= _dxm;
    }

    // Conserver pour Draw
    display_mode_label_x = dm_label_x_loc;
    display_mode_label_y = dm_label_y_loc;
    display_mode_dropdown_x1 = dm_dropdown_x1_loc;
    display_mode_dropdown_y1 = dm_dropdown_y1_loc;
    display_mode_dropdown_x2 = dm_dropdown_x2_loc;
    display_mode_dropdown_y2 = dm_dropdown_y2_loc;
    
    display_mode_box_x1 = dm_label_x_loc - dm_pad;
    display_mode_box_y1 = dm_dropdown_y1_loc - dm_pad;
    display_mode_box_x2 = dm_dropdown_x2_loc + dm_pad;
    display_mode_box_y2 = dm_dropdown_y2_loc + dm_pad;

    // Géométrie de la liste déroulante Mode
    var dm_item_h = 22;
    var dm_list_h = array_length(display_mode_list) * dm_item_h;
    var dm_list_x1 = dm_dropdown_x1_loc;
    var dm_list_y1 = dm_dropdown_y2_loc;
    var dm_list_x2 = dm_dropdown_x2_loc;
    var dm_list_y2 = dm_list_y1 + dm_list_h;

    // Gestion différée du redimensionnement
    if (resize_delay_frames > 0) {
        resize_delay_frames--;
        if (resize_delay_frames == 0) {
            // Appliquer la taille cible (calculée au moment du changement)
            window_set_size(resize_target_w, resize_target_h);
            
            if (surface_exists(application_surface)) {
                surface_resize(application_surface, resize_target_w, resize_target_h);
            }
            
            // Centrage manuel + Sécurité barre des tâches (Uniquement pertinent si fenêtré)
            if (display_mode == 0) { // Fenêtré
                var disp_w = display_get_width();
                var disp_h = display_get_height();
                var target_x = (disp_w - resize_target_w) / 2;
                var target_y = (disp_h - resize_target_h) / 2;
                var safety_margin = 60;
                
                if (target_y + resize_target_h > disp_h - safety_margin) {
                    target_y = max(0, disp_h - resize_target_h - safety_margin);
                }
                window_set_position(target_x, target_y);
            } else if (display_mode == 2) { // Sans bordure
                // Positionner en 0,0
                window_set_position(0, 0);
            }
        }
    }

    // Interaction Dropdown Mode
    if (mouse_check_button_pressed(mb_left)) {
        // Clic sur le dropdown principal
        var over_dm_dropdown = point_in_rectangle(mouse_x, mouse_y, dm_dropdown_x1_loc, dm_dropdown_y1_loc, dm_dropdown_x2_loc, dm_dropdown_y2_loc);
        
        if (over_dm_dropdown) {
            display_mode_dropdown_open = !display_mode_dropdown_open;
            // Fermer l'autre dropdown si ouvert
            resolution_dropdown_open = false; 
        } else if (display_mode_dropdown_open) {
            // Clic dans la liste ?
            var over_dm_list = point_in_rectangle(mouse_x, mouse_y, dm_list_x1, dm_list_y1, dm_list_x2, dm_list_y2);
            if (over_dm_list) {
                var clicked_index = floor((mouse_y - dm_list_y1) / dm_item_h);
                if (clicked_index >= 0 && clicked_index < array_length(display_mode_list)) {
                    display_mode = clicked_index;
                    display_mode_dropdown_open = false;
                    
                    // === APPLICATION DU MODE ===
                    if (display_mode == 1) { 
                        // Plein écran
                        window_set_fullscreen(true);
                        window_set_showborder(true); // reset default
                        ini_open("options.ini");
                        ini_write_real("display", "fullscreen", 1);
                        ini_close();
                    } 
                    else if (display_mode == 2) { 
                        // Sans bordure
                        window_set_fullscreen(false);
                        window_set_showborder(false);
                        
                        // Redimensionner à la taille de l'écran avec délai pour sûreté
                        resize_target_w = display_get_width();
                        resize_target_h = display_get_height();
                        resize_delay_frames = 2;
                        
                        ini_open("options.ini");
                        ini_write_real("display", "fullscreen", 2);
                        ini_close();
                    } 
                    else { 
                        // Fenêtré (Mode 0)
                        window_set_fullscreen(false);
                        window_set_showborder(true);
                        
                        // Appliquer la résolution sélectionnée
                        if (resolution_selected >= 0 && resolution_selected < array_length(resolution_list)) {
                            var res_str = resolution_list[resolution_selected];
                            var x_pos = string_pos("x", res_str);
                            if (x_pos > 0) {
                                resize_target_w = real(string_copy(res_str, 1, x_pos - 1));
                                resize_target_h = real(string_copy(res_str, x_pos + 1, string_length(res_str) - x_pos));
                                resize_delay_frames = 2;
                            }
                        }
                        
                        ini_open("options.ini");
                        ini_write_real("display", "fullscreen", 0);
                        ini_close();
                    }
                }
            } else {
                // Clic ailleurs -> fermer
                display_mode_dropdown_open = false;
            }
        }
    }

    // Survol liste Mode
    display_mode_hover_index = -1;
    if (display_mode_dropdown_open) {
        var over_dm_list = point_in_rectangle(mouse_x, mouse_y, dm_list_x1, dm_list_y1, dm_list_x2, dm_list_y2);
        if (over_dm_list) {
            display_mode_hover_index = floor((mouse_y - dm_list_y1) / dm_item_h);
        }
    }

    // ==========================
    // Menu déroulant Résolution
    // ==========================
    var res_pad = 8;
    var res_top = display_mode_box_y2 + 30; // placer sous le bloc Mode
    var res_label_x_loc = content_x1 + slider_margin_h + slider_shift_x;
    var res_label_y_loc = res_top;
    var res_dropdown_w = 200 * 0.95;
    var res_dropdown_h = 25;
    var res_dropdown_x1_loc = res_label_x_loc + 120;
    var res_dropdown_y1_loc = res_top - res_dropdown_h * 0.5;
    var res_dropdown_x2_loc = res_dropdown_x1_loc + res_dropdown_w;
    var res_dropdown_y2_loc = res_dropdown_y1_loc + res_dropdown_h;
    res_dropdown_w *= 0.95;
    res_dropdown_x1_loc = res_dropdown_x2_loc - res_dropdown_w;
    var res_right = res_dropdown_x2_loc + res_pad;
    if (res_right > right_limit) {
        var _dxr = res_right - right_limit;
        res_label_x_loc -= _dxr;
        res_dropdown_x1_loc -= _dxr;
        res_dropdown_x2_loc -= _dxr;
    }

    // Conserver pour Draw
    res_label_x = res_label_x_loc;
    res_label_y = res_label_y_loc;
    res_dropdown_x1 = res_dropdown_x1_loc;
    res_dropdown_y1 = res_dropdown_y1_loc;
    res_dropdown_x2 = res_dropdown_x2_loc;
    res_dropdown_y2 = res_dropdown_y2_loc;
    res_box_x1 = res_label_x - res_pad;
    res_box_y1 = res_dropdown_y1 - res_pad;
    res_box_x2 = res_dropdown_x2 + res_pad;
    res_box_y2 = res_dropdown_y2 + res_pad;

    // Géométrie de la liste déroulante (quand ouverte)
    var res_item_h = 22;
    var res_list_h = array_length(resolution_list) * res_item_h;
    var res_list_x1 = res_dropdown_x1;
    var res_list_y1 = res_dropdown_y2;
    var res_list_x2 = res_dropdown_x2;
    var res_list_y2 = res_list_y1 + res_list_h;

    // Interaction: clic sur le menu déroulant principal
    if (mouse_check_button_pressed(mb_left)) {
        var over_dropdown = point_in_rectangle(mouse_x, mouse_y, res_dropdown_x1, res_dropdown_y1, res_dropdown_x2, res_dropdown_y2);
        
        if (over_dropdown) {
            // Basculer l'état ouvert/fermé
            resolution_dropdown_open = !resolution_dropdown_open;
        } else if (resolution_dropdown_open) {
            // Vérifier si on clique sur un élément de la liste
            var over_list = point_in_rectangle(mouse_x, mouse_y, res_list_x1, res_list_y1, res_list_x2, res_list_y2);
            if (over_list) {
                // Calculer quel élément est cliqué
                var clicked_index = floor((mouse_y - res_list_y1) / res_item_h);
                if (clicked_index >= 0 && clicked_index < array_length(resolution_list)) {
                    // Sélectionner cette résolution
                    resolution_selected = clicked_index;
                    resolution_dropdown_open = false;
                    
                    // Appliquer la nouvelle résolution
                    var res_str = resolution_list[resolution_selected];
                    var x_pos = string_pos("x", res_str);
                    if (x_pos > 0) {
                        var new_w = real(string_copy(res_str, 1, x_pos - 1));
                        var new_h = real(string_copy(res_str, x_pos + 1, string_length(res_str) - x_pos));
                        
                        // Appliquer la résolution seulement si on n'est pas en plein écran
                        if (display_mode == 0) { // Fenêtré
                            // Utiliser le système différé pour bénéficier de la sécurité barre des tâches
                            resize_target_w = new_w;
                            resize_target_h = new_h;
                            resize_delay_frames = 2;
                        }
                        
                        // Persister dans options.ini
                        ini_open("options.ini");
                        ini_write_string("display", "resolution", res_str);
                        ini_close();
                    }
                }
            } else {
                // Clic en dehors de la liste, fermer le menu
                resolution_dropdown_open = false;
            }
        }
    }

    // Gestion du survol pour la liste déroulante
    resolution_hover_index = -1;
    if (resolution_dropdown_open) {
        var over_list = point_in_rectangle(mouse_x, mouse_y, res_list_x1, res_list_y1, res_list_x2, res_list_y2);
        if (over_list) {
            resolution_hover_index = floor((mouse_y - res_list_y1) / res_item_h);
            if (resolution_hover_index < 0 || resolution_hover_index >= array_length(resolution_list)) {
                resolution_hover_index = -1;
            }
        }
    }

    // ==========================
    // Bouton Abandonner (à côté du bouton Retour, seulement en duel)
    // ==========================
    if (abandon_enabled) {
        // Géométrie déjà calculée ci-dessus pour la symétrie autour du centre

        // Ouvrir la confirmation si clic sur le bouton
        if (!abandon_confirm_open && mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(mouse_x, mouse_y, abandon_btn_x1, abandon_btn_y1, abandon_btn_x2, abandon_btn_y2)) {
                abandon_confirm_open = true;
                abandon_confirm_block = true; // empêche le clic courant de fermer immédiatement

                // Définir la géométrie de la pop-up de confirmation
                var box_w = 360;
                var box_h = 120;
                var box_x1 = x - box_w * 0.5;
                var box_y1 = y - box_h * 0.5;
                var box_x2 = box_x1 + box_w;
                var box_y2 = box_y1 + box_h;

                // Conserver pour Draw
                confirm_box_x1 = box_x1;
                confirm_box_y1 = box_y1;
                confirm_box_x2 = box_x2;
                confirm_box_y2 = box_y2;

                // Boutons Oui / Non
                var cbtn_w = 120;
                var cbtn_h = 32;
                var pad = 30;
                var yes_x1 = box_x1 + pad;
                var yes_y1 = box_y2 - pad - cbtn_h;
                var yes_x2 = yes_x1 + cbtn_w;
                var yes_y2 = yes_y1 + cbtn_h;
                var no_x2 = box_x2 - pad;
                var no_x1 = no_x2 - cbtn_w;
                var no_y1 = yes_y1;
                var no_y2 = yes_y2;

                confirm_yes_x1 = yes_x1;
                confirm_yes_y1 = yes_y1;
                confirm_yes_x2 = yes_x2;
                confirm_yes_y2 = yes_y2;
                confirm_no_x1 = no_x1;
                confirm_no_y1 = no_y1;
                confirm_no_x2 = no_x2;
                confirm_no_y2 = no_y2;
            }
        }

        // Pop-up de confirmation
        if (abandon_confirm_open) {
            // Lever le blocage après relâchement du clic d'ouverture
            if (abandon_confirm_block) {
                if (mouse_check_button_released(mb_left)) {
                    abandon_confirm_block = false;
                }
            }
            // Gestion des clics dans la pop-up (uniquement quand non bloqué)
            if (!abandon_confirm_block && mouse_check_button_pressed(mb_left)) {
                var clickYes = point_in_rectangle(mouse_x, mouse_y, confirm_yes_x1, confirm_yes_y1, confirm_yes_x2, confirm_yes_y2);
                var clickNo  = point_in_rectangle(mouse_x, mouse_y, confirm_no_x1, confirm_no_y1, confirm_no_x2, confirm_no_y2);
                if (clickYes) {
                    // Envoyer l'action d'abandon (Surrender)
                    if (instance_exists(oGame)) {
                        var payload = { quitter_index: oGame.local_player_index };
                        RequestGameAction(ACTION_SURRENDER, payload);
                    }
                    instance_destroy();
                } else if (clickNo) {
                    abandon_confirm_open = false;
                } else {
                    // Clic hors de la boîte = fermer
                    var outside = !point_in_rectangle(mouse_x, mouse_y, confirm_box_x1, confirm_box_y1, confirm_box_x2, confirm_box_y2);
                    if (outside) abandon_confirm_open = false;
                }
            }
        }
    }
}
