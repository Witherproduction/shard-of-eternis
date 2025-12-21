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