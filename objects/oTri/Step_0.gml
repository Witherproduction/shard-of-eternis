// === Gestion des clics dans l'evenement Step ===

// Hériter de la garde de oButtonBlock
event_inherited();

// Garde directe pour s'assurer du blocage
if (instance_exists(oPanelOptions)) {
    exit;
}

// Verifier si le clic gauche vient d'etre presse
if (mouse_check_button_pressed(mb_left)) {
    show_debug_message("### Clic gauche detecte a (" + string(mouse_x) + ", " + string(mouse_y) + ")");
    
    // Parametres identiques a ceux du Draw
    var baseW = sprite_get_width(sButton);
    var baseH = sprite_get_height(sButton);
    var barWidth = round(baseW * (570.0 / 300.0)) * 0.8;
    var barHeight = round(baseH * (90.0 / 100.0)) * 0.8;
    var spacing = 50;
    var barY = 40;
    var barX = 40;
    if (instance_exists(oCardViewer)) {
        with (oCardViewer) {
            barY = dropdown_y;
            barX = dropdown_x + dropdown_w + spacing;
        }
    }
    var buttonRadius = 15;
    var buttonSpacing = 60; // Espacement légèrement réduit pour resserrer les boutons
    // Centrer les boutons dans la barre
    var totalButtonsWidth = (7 * buttonSpacing) + (2 * buttonRadius);
    var startX = barX + (barWidth - totalButtonsWidth) / 2 + buttonRadius;
    var buttonY = barY + barHeight / 2;
    
    show_debug_message("### Verification dans la zone de la barre: (" + string(barX) + ", " + string(barY) + ") taille: " + string(barWidth) + "x" + string(barHeight));
    
    // Verifier si le clic est dans la zone de la barre
    if (mouse_x >= barX && mouse_x <= barX + barWidth && mouse_y >= barY && mouse_y <= barY + barHeight) {
        show_debug_message("### Clic dans la zone de la barre de tri!");
        
        // Fonction pour verifier si un clic est dans un cercle
        function pointInCircle(px, py, cx, cy, radius) {
            var distance = point_distance(px, py, cx, cy);
            return distance <= radius;
        }
        
        // Boutons avec boucle pour simplifier (ajout du tri alphabétique)
        var buttons = ["attack", "PV", "level", "type", "favorites", "rarity", "alpha"];
        var buttonLabels = ["Attaque", "PV", "Niveau", "Type", "Favoris", "Rarete", "Alphabetique"];
        
        for (var i = 0; i < 7; i++) {
            var buttonX = startX + (i * buttonSpacing);
            
            show_debug_message("### Verification bouton " + string(i) + " (" + buttonLabels[i] + ") a (" + string(buttonX) + ", " + string(buttonY) + ") rayon: " + string(buttonRadius));
            
            if (pointInCircle(mouse_x, mouse_y, buttonX, buttonY, buttonRadius)) {
                show_debug_message("### ✓ CLIC DETECTE sur bouton " + buttonLabels[i] + "!");
                global.sort_mode = buttons[i];
                sort_active_button = i;
                show_debug_message("### Mode de tri change vers: " + global.sort_mode);
                show_debug_message("### Tri par " + buttonLabels[i] + " active - oCardViewer va detecter le changement");
                
                // Forcer le redessinage immédiat de l'interface
                event_perform(ev_draw, 0);
                event_perform(ev_gui, 0);
                
                break; // Sortir de la boucle apres le premier clic detecte
            }
        }
        
        // Vérifier le clic sur le bouton d'inversion
        var invertButtonX = startX + (7 * buttonSpacing);
        if (pointInCircle(mouse_x, mouse_y, invertButtonX, buttonY, buttonRadius)) {
            show_debug_message("### ✓ CLIC DETECTE sur bouton d'inversion!");
            global.sort_descending = !global.sort_descending;
            show_debug_message("### Ordre de tri inversé: " + (global.sort_descending ? "décroissant" : "croissant"));
            
            // Réappliquer le tri actuel avec le nouvel ordre
            if (global.sort_mode != "none") {
                // Forcer le rafraîchissement du tri
                var current_mode = global.sort_mode;
                global.sort_mode = "none";
                global.sort_mode = current_mode;
            }
            
            // Forcer le redessinage immédiat de l'interface
            event_perform(ev_draw, 0);
            event_perform(ev_gui, 0);
            
            // Forcer le rafraîchissement des cartes
            with (oCardViewer) {
                clearCardDisplay();
                applyFilter(currentFilter);
                sortCards(global.sort_mode);
                displayFilteredCards();
            }
        }
    } else {
        show_debug_message("### Clic en dehors de la zone de la barre");
    }
}
