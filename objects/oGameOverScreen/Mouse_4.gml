show_debug_message("### oGameOverScreen.Mouse_4 - Clic pour quitter")

// Attendre que l'animation soit terminée avant de permettre le clic
if (alpha >= targetAlpha) {
    // Retourner à la room précédente sauvegardée
    var target_room = global.previous_room_before_duel;
    
    // === RECOMPENSES GENERALES (Victoire) ===
    if (isVictory) {
        // 1. Débloquer les cartes du deck joueur utilisé
        if (variable_global_exists("selected_player_deck") && is_struct(global.selected_player_deck)) {
             if (variable_struct_exists(global.selected_player_deck, "cards")) {
                 var deck_cards = global.selected_player_deck.cards;
                 if (is_array(deck_cards)) {
                     var cards_unlocked_count = 0;
                     var all_db_cards = dbGetAllCards();
                     
                     for (var i = 0; i < array_length(deck_cards); i++) {
                          var c_entry = deck_cards[i];
                          var c_obj_name = "";

                          if (is_string(c_entry)) {
                              c_obj_name = c_entry;
                          } else if (is_struct(c_entry) && variable_struct_exists(c_entry, "objectId")) {
                              c_obj_name = c_entry.objectId;
                          }
                          
                          if (c_obj_name != "") {
                              // Trouver l'ID de la carte correspondant au nom de l'objet
                              var found_card_id = "";
                              
                              // Chercher dans la DB par objectId
                              for (var k = 0; k < array_length(all_db_cards); k++) {
                                  var db_card = all_db_cards[k];
                                  if (variable_struct_exists(db_card, "objectId") && db_card.objectId == c_obj_name) {
                                      if (variable_struct_exists(db_card, "id")) {
                                          found_card_id = db_card.id;
                                      }
                                      break;
                                  }
                              }
                              
                              // Si trouvé, débloquer
                              if (found_card_id != "") {
                                  if (unlock_card(found_card_id)) {
                                      cards_unlocked_count++;
                                  }
                              } else {
                                  show_debug_message("### Warning: Impossible de trouver l'ID carte pour l'objet " + string(c_obj_name));
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

    // Gestion du résultat du duel pour le scénario
    if (target_room == rScenario) {
        if (isVictory) {
             // Débloquer le bot vaincu pour le mode Contre IA
             if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) {
                 unlock_bot(global.selected_bot_deck_id);
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
                       // line index sera 0 par défaut
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
    
    show_debug_message("### oGameOverScreen.Mouse_4 - Navigation vers " + string(room_get_name(target_room)));
    room_goto(target_room);
    
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
    
    show_debug_message("### Retour à la room précédente: " + string(room_get_name(target_room)));
}