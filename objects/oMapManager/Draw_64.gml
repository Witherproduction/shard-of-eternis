/// @description Draw Editor UI

if (!variable_global_exists("admin_mode") || !global.admin_mode) exit;

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var xx = 10;
var yy = 10;
var lh = 20; // Line height

draw_text(xx, yy, "MODE ADMIN (F1 pour quitter)"); yy += lh;
if (poly_mode) {
    draw_set_color(c_red);
    draw_text(xx, yy, "MODE TRACE ACTIF (P pour quitter)"); yy += lh;
    draw_text(xx, yy, "Clic Gauche: Ajouter point"); yy += lh;
    draw_text(xx, yy, "Z: Annuler dernier point"); yy += lh;
    draw_text(xx, yy, "C: Copier points dans presse-papier"); yy += lh;
    draw_text(xx, yy, "Points: " + string(array_length(current_poly_points))); yy += lh;
    draw_set_color(c_white);
} else {
    draw_text(xx, yy, "Activer Mode Tracé (P)"); yy += lh;
    draw_text(xx, yy, "Selection (TAB): " + string(selected_region_name) + " [" + string(selected_region_index) + "]"); yy += lh;
    draw_text(xx, yy, "Deplacer: Fleches"); yy += lh;
    draw_text(xx, yy, "Scale (Uniforme): I/K ou +/-"); yy += lh;
    draw_text(xx, yy, "Vitesse: Shift (rapide), Ctrl (lent)"); yy += lh;
    draw_text(xx, yy, "Copier code GML (Espace ou S)"); yy += lh;
}

if (continent_manager != noone && array_length(continent_manager.regions) > 0) {
    var reg = continent_manager.regions[selected_region_index];
    
    // GROS TITRE POUR LA SÉLECTION ACTUELLE
    var old_color = draw_get_color();
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text_transformed(display_get_gui_width() / 2, 20, "MASQUE SELECTIONNE : " + string(reg.name), 2, 2, 0);
    draw_set_halign(fa_left);
    draw_set_color(old_color);

    yy += lh;
    draw_text(xx, yy, "--- Valeurs Actuelles ---"); yy += lh;
    draw_text(xx, yy, "X: " + string(reg.x)); yy += lh;
    draw_text(xx, yy, "Y: " + string(reg.y)); yy += lh;
    draw_text(xx, yy, "Scale (Uniforme): " + string(reg.scale_x)); yy += lh; // On affiche juste X vu que c'est uniforme
    
    if (clipboard_str != "") {
        yy += lh;
        draw_set_color(c_lime);
        draw_text(xx, yy, "Derniere Copie: " + clipboard_str);
        draw_set_color(c_white);
    }
}
