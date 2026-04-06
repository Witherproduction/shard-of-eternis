// === oFiltre - Draw GUI Event ===

// Affiche uniquement dans la room rCollection
if (room == rCollection) {
    // Couleur de fond selon l'état du champ
    // Actif: utiliser le même brun que les boutons de tri cliqués
    var tri_active_fill = make_color_rgb(120, 90, 45);
    var currentBoxColor = isTyping ? tri_active_fill : boxColor;

    // Dessiner le fond de la barre de filtre avec le sprite sButton
    // Réduction de la HAUTEUR du sprite (85%), centré verticalement, largeur inchangée
    var spriteWidth = filterBarWidth * 0.97; // réduction très légère de la longueur
    var spriteHeight = filterBarHeight * 0.85;
    var spriteX = filterBarX + (filterBarWidth - spriteWidth) / 2; // centré horizontalement
    var spriteY = filterBarY + (filterBarHeight - spriteHeight) / 2;
    draw_sprite_stretched(sButton, 0, spriteX, spriteY, spriteWidth, spriteHeight);

    // Champ de texte sans cadre ni fond

    // Style du texte (ombre + crème dorée)
    var text_shadow_color = c_black;
    // Texte en crème dans tous les états (plus lisible sur fond brun actif)
    var text_main_color = textColor;

    // Préparer le rendu du texte dans le champ (placeholder si vide)
    var f = filterFont;
    if (variable_global_exists("get_runtime_font")) {
        var rf = global.get_runtime_font("text", 18);
        if (rf != -1) f = rf;
    }
    if (f != -1) draw_set_font(f);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var textX = filterBoxX + 10;
    var textY = filterBoxY + filterBoxHeight/2;

    // Placeholder "Filtre" quand vide; sinon, afficher le texte saisi
    if (string_length(filterText) == 0) {
        if (isTyping) {
            // Champ sélectionné: sans ombre
            draw_set_color(text_main_color);
            draw_text(textX, textY, "Filtre");
        } else {
            // Au repos: avec ombre
            draw_set_color(text_shadow_color);
            draw_text(textX + 2, textY + 2, "Filtre");
            draw_set_color(text_main_color);
            draw_text(textX, textY, "Filtre");
        }
    } else {
        var displayText = filterText;
        if (isTyping && (current_time % 1000 < 500)) {
            displayText += "|"; // Curseur clignotant
        }
        if (isTyping) {
            // Champ sélectionné: sans ombre
            draw_set_color(text_main_color);
            draw_text(textX, textY, displayText);
        } else {
            // Au repos: avec ombre
            draw_set_color(text_shadow_color);
            draw_text(textX + 2, textY + 2, displayText);
            draw_set_color(text_main_color);
            draw_text(textX, textY, displayText);
        }
    }

    // Reset des paramètres de dessin
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
