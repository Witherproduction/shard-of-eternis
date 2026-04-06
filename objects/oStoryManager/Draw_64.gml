if (variable_instance_exists(id, "editor_active") && editor_active) {
    draw_set_color(c_red);
    for (var i = 0; i < array_length(editor_points); i++) {
        var p = editor_points[i];
        draw_circle(p.x, p.y, 4, false);
        
        if (i > 0) {
            var prev = editor_points[i-1];
            draw_line_width(prev.x, prev.y, p.x, p.y, 2);
        }
    }

    // Fermer la boucle visuellement
    if (array_length(editor_points) > 2) {
        var first = editor_points[0];
        var last = editor_points[array_length(editor_points)-1];
        draw_set_alpha(0.5);
        draw_line_width(last.x, last.y, first.x, first.y, 1);
        draw_set_alpha(1);
    }

    // Preview souris
    if (array_length(editor_points) > 0) {
        var last = editor_points[array_length(editor_points)-1];
        draw_set_alpha(0.5);
        draw_line(last.x, last.y, mouse_x, mouse_y);
        draw_set_alpha(1);
    }
    
    // UI Texte
    draw_set_font(fontTitle);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(10, 10, "Mode Éditeur de Zone (E: Toggle)");
    draw_text(10, 30, "Clic: Ajouter Point | Z: Annuler | C: Clear | S: Copier Code");
    draw_text(10, 50, "Points: " + string(array_length(editor_points)));

    if (array_length(editor_points) > 0) {
        var last = editor_points[array_length(editor_points)-1];
        draw_text(10, 70, "Dernier: " + string(last.x) + ", " + string(last.y));
    }
}
