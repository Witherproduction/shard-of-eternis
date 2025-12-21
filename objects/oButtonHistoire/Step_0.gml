// === oButtonHistoire - Step Event ===
// Détection manuelle des clics sur le bouton Histoire

// DEBUG F1: Vérifier que oButtonHistoire reçoit bien les inputs
if (keyboard_check_pressed(vk_f1)) {
    show_debug_message("### DEBUG F1 from oButtonHistoire: Je suis vivant dans la room " + room_get_name(room));
    if (instance_exists(oGlobalMusicManager)) {
        show_debug_message("### DEBUG F1: oGlobalMusicManager EST PRÉSENT.");
    } else {
        show_debug_message("### DEBUG F1: oGlobalMusicManager EST ABSENT !");
    }
}

// Garde directe pour bloquer les clics quand le panneau d'options est ouvert
if (instance_exists(oPanelOptions)) { exit; }

// Vérifier si on est dans la room d'accueil
if (room != rAcceuil) {
    exit; // Sortir si on n'est pas dans la bonne room
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
        
        show_debug_message("### oButtonHistoire.Step_0 - Clic détecté dans la zone du bouton!");
        show_debug_message("### Position souris: (" + string(mouse_x_pos) + ", " + string(mouse_y_pos) + ")");
        show_debug_message("### Zone bouton: (" + string(button_left) + ", " + string(button_top) + ") à (" + string(button_right) + ", " + string(button_bottom) + ")");
        show_debug_message("### Navigation vers rHistoire depuis rAcceuil");
        
        // Naviguer vers la room Histoire
        room_goto(rHistoire);
    }
}