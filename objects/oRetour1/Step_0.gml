// === oRetour1 - Step Event ===
// Détection manuelle des clics sur le bouton retour

// Hériter de la garde de oButtonBlock
event_inherited();

// Garde directe pour s'assurer du blocage
if (instance_exists(oPanelOptions)) {
    exit;
}

// Vérifier si on est dans une room qui a un bouton retour
if (room != rCollection && room != rHistoire && room != rMode && room != rContreIa && 
    room != rDuel && room != rLobby && room != rBoutique) {
    exit; // Sortir si on n'est pas dans une room appropriée
}

// Vérifier si le bouton gauche de la souris vient d'être pressé
if (mouse_check_button_pressed(mb_left)) {
    
    // Obtenir la position de la souris
    var mouse_x_pos = mouse_x;
    var mouse_y_pos = mouse_y;
    
    // Calculer les limites du bouton
    var button_left = x - button_width / 2;
    var button_top = y - button_height / 2;
    var button_right = x + button_width / 2;
    var button_bottom = y + button_height / 2;
    
    // Vérifier si le clic est dans la zone du bouton
    if (mouse_x_pos >= button_left && mouse_x_pos <= button_right && 
        mouse_y_pos >= button_top && mouse_y_pos <= button_bottom) {
        
        show_debug_message("### oRetour1.Step_0 - Clic détecté dans la zone du bouton!");
        show_debug_message("### Position souris: (" + string(mouse_x_pos) + ", " + string(mouse_y_pos) + ")");
        show_debug_message("### Zone bouton: (" + string(button_left) + ", " + string(button_top) + ") à (" + string(button_right) + ", " + string(button_bottom) + ")");
        
        // Déterminer la destination selon la room actuelle
        if (room == rDuel) {
            clear_selected_decks();
            show_debug_message("### Navigation vers rMode depuis rDuel avec nettoyage des decks");
            room_goto(rMode);
        } else if (room == rContreIa) {
            show_debug_message("### Navigation vers rMode depuis " + string(room_get_name(room)));
            room_goto(rMode);
        } else {
            show_debug_message("### Navigation vers rAcceuil depuis " + string(room_get_name(room)));
            room_goto(rAcceuil);
        }
    }
}
