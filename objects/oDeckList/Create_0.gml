// === oDeckList - Create Event ===
// Initialisation des variables

show_debug_message("=== oDeckList Create Event démarré ===");

// Variable pour contrôler l'affichage du cadre oDeckBuilder
show_deck_builder = false;

// Instance de l'objet oDeckBuilder (sera créée quand nécessaire)
deck_builder_instance = noone;

// Redimensionner l'objet pour couvrir la zone du bouton
// Calculer la position du bouton (même calcul que dans Draw_0)
var sprW = sprite_get_width(sDeckBuilder);
var scale_x = (sprW - 100) / sprW;
var scaled_w = sprW * scale_x;
var sprite_x = room_width - scaled_w + 55 - 55;
var button_x = sprite_x + 50;
var button_y = room_height / 3 - 170;
var baseW_btn = sprite_get_width(sButton);
var baseH_btn = sprite_get_height(sButton);
var button_width = round(baseW_btn * (320.0 / 300.0));
var button_height = round(baseH_btn * (80.0 / 100.0));

// Positionner l'objet sur le bouton et ajuster sa taille
x = button_x;
y = button_y;
image_xscale = button_width / sprite_get_width(sprInvisible);
image_yscale = button_height / sprite_get_height(sprInvisible);

show_debug_message("oDeckList positionné à: (" + string(x) + ", " + string(y) + ") avec échelle: (" + string(image_xscale) + ", " + string(image_yscale) + ")");