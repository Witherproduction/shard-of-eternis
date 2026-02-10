// oFX_ReturnToHand - Create
// Animation de retour en main
// Paramètres attendus (injectés après création):
// - card_instance : l'instance de la carte (qui est déjà en main mais invisible)
// - spriteGhost : sprite de la carte
// - imageGhost : frame de la carte
// - start_x, start_y : position de départ

card_instance = noone;
spriteGhost = noone;
imageGhost = 0;

start_x = x;
start_y = y;

// Durée de l'animation
duration = 1.5 * room_speed; // 1500ms
_t = 0;

// Echelle
start_scale = 1.0;
end_scale = 0.6; // Taille typique en main (sera ajusté si card_instance existe)

// Arc
arc_height = -100; // Monte un peu
