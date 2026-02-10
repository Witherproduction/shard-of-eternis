// === oButtonQuitter - Draw Event ===
// Dessine un cadre neutre avec le texte "Quitter"

// Position centrée sur l'objet
var draw_x = x - button_width / 2;
var draw_y = y - button_height / 2;

// Dessiner le sprite du bouton
draw_sprite_stretched(sButton, 0, draw_x, draw_y, button_width, button_height);

// Ombre portée légère sous le texte
draw_set_color(make_color_rgb(80, 50, 20));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fontStep);
var text_scale = 0.5;
draw_text_transformed(x + 2, y + 2, "Quitter", text_scale, text_scale, 0);

// Dessiner le texte "Quitter" centré en crème dorée
draw_set_color(make_color_rgb(230, 200, 120));
draw_text_transformed(x, y, "Quitter", text_scale, text_scale, 0);

// Remettre les alignements par défaut
draw_set_halign(fa_left);
draw_set_valign(fa_top);