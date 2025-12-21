// === oRetour1 - Create Event ===
// Définir les dimensions du bouton pour la détection des clics

show_debug_message("### oRetour1.Create_0 - Objet créé à la position (" + string(x) + ", " + string(y) + ")");

// Dimensions du bouton basées sur le sprite `sButton`
var baseW = sprite_get_width(sButton);
var baseH = sprite_get_height(sButton);
var scaleX = 0.6; // 400 * 0.6 = 240
var scaleY = 0.8; // 100 * 0.8 = 80
button_width = round(baseW * scaleX);
button_height = round(baseH * scaleY);

show_debug_message("### Dimensions du bouton: " + string(button_width) + "x" + string(button_height));

// Créer un masque de collision invisible
// On utilise sprite_create_from_surface pour créer un sprite temporaire
// ou on définit simplement les dimensions pour la détection manuelle

// Variables pour la détection de collision
collision_left = x - button_width / 2;
collision_top = y - button_height / 2;
collision_right = x + button_width / 2;
collision_bottom = y + button_height / 2;

show_debug_message("### Zone de collision: (" + string(collision_left) + ", " + string(collision_top) + ") à (" + string(collision_right) + ", " + string(collision_bottom) + ")");