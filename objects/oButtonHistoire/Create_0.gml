// === oButtonHistoire - Create Event ===
// Définir les dimensions du bouton pour la détection des clics

show_debug_message("### oButtonHistoire.Create_0 - Objet créé à la position (" + string(x) + ", " + string(y) + ")");

// FAIL-SAFE: Créer le manager de musique s'il n'existe pas
if (!instance_exists(oGlobalMusicManager)) {
    show_debug_message("### oButtonHistoire: oGlobalMusicManager MANQUANT ! Création immédiate par code.");
    instance_create_depth(0, 0, 0, oGlobalMusicManager);
} else {
    show_debug_message("### oButtonHistoire: oGlobalMusicManager existe déjà.");
}

// Dimensions du bouton (identiques à celles dans Draw_0)
button_width = 400;
button_height = 100;

show_debug_message("### Dimensions du bouton: " + string(button_width) + "x" + string(button_height));

// Variables pour la détection de collision
collision_left = x - button_width / 2;
collision_top = y - button_height / 2;
collision_right = x + button_width / 2;
collision_bottom = y + button_height / 2;

show_debug_message("### Zone de collision: (" + string(collision_left) + ", " + string(collision_top) + ") à (" + string(collision_right) + ", " + string(collision_bottom) + ")");