/// @description Init
is_revealed = false; // Par défaut, le continent est caché sous le brouillard
surf_mask = -1;

// Coordonnées relatives pour que le reveal suive l'objet
// Basé sur les valeurs originales : x=384, y=544 -> reveal_x=489, reveal_y=674
// Différence : x+105, y+130
reveal_x = x + 105;
reveal_y = y + 130;

reveal_scale = 0.17; // Échelle du pochoir
