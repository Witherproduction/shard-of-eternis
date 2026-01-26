if (!is_undefined(animEffectDrawAll)) animEffectDrawAll();

// Note: L'affichage du mode ADMIN est désormais géré par oGlobalManager
// Ce code est commenté pour éviter les doublons
/*
if (variable_global_exists("admin_mode") && global.admin_mode) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_red);
    draw_set_font(fontCardDisplay); // Utiliser une police existante
    draw_text(display_get_gui_width() - 10, display_get_gui_height() - 10, "ADMIN MODE ACTIVE");
    draw_set_color(c_white);
}
*/

// --- DESSIN DU PILE OU FACE (Overlay plein écran GUI) ---
if (variable_instance_exists(id, "coin_toss_active") && coin_toss_active) {
    // Fond semi-transparent sombre sur TOUT l'écran GUI
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
    
    // Position centrale
    var cx = gui_w / 2;
    var cy = gui_h / 2;
    var radius = 100;
    
    // Calcul de l'échelle X pour l'effet 3D de rotation
    var scale_x = dcos(coin_toss_angle);
    var is_front = (scale_x > 0);
    
    // Dessin de la pièce
    // Couleur : Or (Front/Pile) ou Argent (Back/Face)
    var coin_color = is_front ? make_color_rgb(255, 215, 0) : make_color_rgb(192, 192, 192);
    var text_color = is_front ? c_black : c_black;
    var label = is_front ? "PILE" : "FACE";
    
    // Ombre (ellipse décalée)
    draw_set_color(c_dkgray);
    draw_ellipse(cx - radius * abs(scale_x), cy - radius + 10, cx + radius * abs(scale_x), cy + radius + 10, false);
    
    // Corps de la pièce
    draw_set_color(coin_color);
    draw_ellipse(cx - radius * abs(scale_x), cy - radius, cx + radius * abs(scale_x), cy + radius, false);
    
    // Contour
    draw_set_color(make_color_rgb(100, 80, 0));
    draw_ellipse(cx - radius * abs(scale_x), cy - radius, cx + radius * abs(scale_x), cy + radius, true);
    draw_ellipse(cx - radius * abs(scale_x) * 0.8, cy - radius * 0.8, cx + radius * abs(scale_x) * 0.8, cy + radius * 0.8, true);
    
    // Texte sur la pièce (si visible)
    if (abs(scale_x) > 0.3) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(text_color);
        // On étire le texte avec la pièce
        draw_text_transformed(cx, cy, label, abs(scale_x), 1, 0);
    }
    
    // Texte de résultat (Phase 2)
    if (coin_toss_phase == 2) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        
        // Utilisation d'une police existante sûre (fontStep est déjà utilisée plus haut)
        if (variable_global_exists("fontTitle") && font_exists(asset_get_index("fontTitle"))) {
             draw_set_font(asset_get_index("fontTitle"));
        } else {
             // Fallback : on garde la police actuelle ou on en met une plus grande si possible
             draw_set_font(fontStep); 
        }
        
        var res_text = coin_toss_is_heads ? "VOUS COMMENCEZ !" : "L'ADVERSAIRE COMMENCE";
        var res_col = coin_toss_is_heads ? c_lime : c_red;
        
        // Effet de texte plus gros si pas de fontTitle
        var text_scale = (draw_get_font() == fontStep) ? 2.0 : 1.0;
        
        draw_text_transformed_color(cx, cy + 150, res_text, text_scale, text_scale, 0, res_col, res_col, res_col, res_col, 1);
        
        draw_set_font(fontStep); // Rétablir police
    } else {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(cx, cy - 150, "QUI COMMENCE ?");
    }
    
    // Reset
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}