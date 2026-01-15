// === oChoixMultijoueur - Create Event ===

show_debug_message("### oChoixMultijoueur.Create_0 - Objet créé à la position (" + string(x) + ", " + string(y) + ")");

button_width = 160;
button_height = 40;

collision_left = x - button_width / 2;
collision_top = y - button_height / 2;
collision_right = x + button_width / 2;
collision_bottom = y + button_height / 2;

