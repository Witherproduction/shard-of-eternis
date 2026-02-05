// === oGameOverScreen - Step Event ===
// Gestion du survol du bouton et blocage des clics

// Vérifier si l'animation est terminée
if (alpha >= targetAlpha) {
    // Calculer les limites du bouton
    var button_left = buttonX - buttonWidth / 2;
    var button_top = buttonY - buttonHeight / 2;
    var button_right = buttonX + buttonWidth / 2;
    var button_bottom = buttonY + buttonHeight / 2;
    
    // Vérifier si la souris survole le bouton
    if (mouse_x >= button_left && mouse_x <= button_right && 
        mouse_y >= button_top && mouse_y <= button_bottom) {
        buttonHover = true;
    } else {
        buttonHover = false;
    }
    
    // Bloquer tous les clics en consommant l'événement de clic
    // Ceci empêche les autres objets de recevoir les clics
    if (mouse_check_button_pressed(mb_left)) {
        // Si le clic est sur le bouton, gérer la navigation
        if (buttonHover) {
            show_debug_message("### oGameOverScreen - Bouton Continuer cliqué");
            
            // Retourner à la room précédente sauvegardée
            var target_room = global.previous_room_before_duel;
            
            // === RECOMPENSES GENERALES (Victoire) ===
            // Note: Pas de déblocage de cartes pour le Chapitre 0 (Tutoriel)
            if (isVictory && (!variable_global_exists("current_chapter") || global.current_chapter != 0)) {
                // 1. Débloquer les cartes du deck joueur utilisé
                if (variable_global_exists("selected_player_deck") && is_struct(global.selected_player_deck)) {
                     if (variable_struct_exists(global.selected_player_deck, "cards")) {
                         var deck_cards = global.selected_player_deck.cards;
                         if (is_array(deck_cards)) {
                             var cards_unlocked_count = 0;
                             var all_db_cards = dbGetAllCards();
                             
                             for (var i = 0; i < array_length(deck_cards); i++) {
                                 var c_id = deck_cards[i];
                                 if (is_string(c_id)) {
                                     var final_id = c_id;
                                     // Tentative de mapping Object Name -> Card ID si c'est un nom d'objet (ex: oTortue)
                                     // On parcourt la DB pour trouver l'ID correspondant
                                     for (var k = 0; k < array_length(all_db_cards); k++) {
                                          var db_card = all_db_cards[k];
                                          if (variable_struct_exists(db_card, "objectId") && db_card.objectId == c_id) {
                                              if (variable_struct_exists(db_card, "id")) {
                                                  final_id = db_card.id;
                                              }
                                              break;
                                          }
                                     }
                                     
                                     if (unlock_card(final_id)) {
                                         cards_unlocked_count++;
                                     }
                                 }
                             }
                             if (cards_unlocked_count > 0) {
                                 show_debug_message("### Victoire : " + string(cards_unlocked_count) + " nouvelles cartes débloquées !");
                             }
                         }
                     }
                }
            }
            
            // Gestion du résultat du duel pour le scénario (Logic copied from Mouse_4)
            if (target_room == rScenario) {
                if (isVictory) {
                     // Débloquer le bot vaincu pour le mode Contre IA
                     if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) {
                         unlock_bot(global.selected_bot_deck_id);
                     }

                     if (variable_global_exists("current_chapter") && variable_global_exists("current_act")) {
                         if (global.current_chapter == 1 && global.current_act == 2) {
                             if (variable_global_exists("selected_bot_deck_id") && (global.selected_bot_deck_id == 2 || global.selected_bot_deck_id == "Essaim_Abyssien")) {
                                 story_progress_unlock_reward("chap1_act2_duel1_win");
                             }
                         }
                     }

                     if (variable_global_exists("duel_next_scene") && variable_global_exists("duel_is_last_scene")) {
                          if (global.duel_is_last_scene) {
                               // Fin du scénario (Dernière scène)
                               target_room = rHistoire; 
                               
                               // Sauvegarder la progression
                               var ch = variable_global_exists("current_chapter") ? global.current_chapter : 1;
                               var ac = variable_global_exists("current_act") ? global.current_act : 1;
                               var sc = variable_global_exists("duel_resume_scene") ? global.duel_resume_scene : 0;
                               
                               // Integrer la progression
                               unlock_act_complete(ch, ac);
                               if (ac >= 4) {
                                   unlock_chapter_access(ch + 1);
                               }
                               
                               // Essayer d'appeler la fonction de sauvegarde si elle existe
                               try {
                                   story_progress_write_last_scene(ch, sc, ac);
                               } catch(e) {
                                   show_debug_message("### Erreur sauvegarde progression: " + string(e));
                               }
                          } else {
                               // Scène suivante
                               global.current_scene_index = global.duel_next_scene;
                          }
                     }
                } else {
                     // Défaite : Recommencer la dernière action
                     if (variable_global_exists("duel_resume_scene") && variable_global_exists("duel_resume_line")) {
                          global.current_scene_index = global.duel_resume_scene;
                          global.sc_load_line_index = global.duel_resume_line;
                     }
                }
            } 
            // Gestion Spéciale : Chapitre 0 (Tutoriel)
            // Si on n'est pas passé par le Scénario (target_room != rScenario) mais qu'on a fait le Tuto
            else if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
                if (isVictory) {
                     show_debug_message("### Victoire Tuto : Chapitre 0 complété !");
                     
                     // Valider l'Acte 1 du Chapitre 0
                     unlock_act_complete(0, 1);
                     
                     // Débloquer l'accès au Chapitre 1
                     unlock_chapter_access(1);
                }
            }

            show_debug_message("### Navigation vers " + string(room_get_name(target_room)));
            
            // Nettoyer les variables globales si nécessaire
            if (variable_global_exists("selected_player_deck")) {
                global.selected_player_deck = noone;
            }
            if (variable_global_exists("selected_bot_deck_id")) {
                global.selected_bot_deck_id = noone;
            }
            if (variable_global_exists("isGraveyardViewerOpen")) {
                global.isGraveyardViewerOpen = false;
            }
            if (variable_global_exists("story_hero_id")) {
                global.story_hero_id = noone;
            }
            
            room_goto(target_room);
        } else {
            // Clic en dehors du bouton - ne rien faire mais bloquer le clic
            show_debug_message("### oGameOverScreen - Clic bloqué (en dehors du bouton)");
        }
    }
}
