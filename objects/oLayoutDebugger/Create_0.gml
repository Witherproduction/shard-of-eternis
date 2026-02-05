// === oLayoutDebugger - Create Event ===

// Champs éditables
fields = ["name", "mana", "genre", "archetype", "description", "atk", "hp"];
current_field_index = 0;
active = false; // Activé par F3

// Mode édition: 0=x1, 1=y1, 2=x2, 3=y2
edit_mode = 0; 
edit_labels = ["x1", "y1", "x2", "y2"];

// Pour l'affichage
move_speed = 1; // Vitesse de déplacement (pixel par pixel, shift pour 10)
