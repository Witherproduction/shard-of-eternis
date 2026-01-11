draw_self(); // Dessine le continent

// Gestion de la surface pour le masque (Fog of War)
if (!surface_exists(surf_mask)) {
    surf_mask = surface_create(room_width, room_height);
}

surface_set_target(surf_mask);
draw_clear_alpha(c_black, 0); // Nettoie la surface avec de la transparence

// 1. Dessine le masque complet (le brouillard)
draw_sprite_ext(sMasqueContinentOuest, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);

// 2. Applique le pochoir pour révéler la zone (soustraction)
// Seulement si le Chapitre 0 (Acte 1) est terminé
if (is_act_complete(0, 1)) {
    gpu_set_blendmode(bm_subtract);
    
    // Calcul dynamique de la position et de l'échelle du reveal pour suivre le zoom du continent
    var off_x = 105 * image_xscale;
    var off_y = 130 * image_yscale;
    var cur_reveal_scale = reveal_scale * image_xscale;
    
    draw_sprite_ext(sMasqueForetDesVoleur, 0, x + off_x, y + off_y, cur_reveal_scale, cur_reveal_scale, 0, c_white, 1);
    gpu_set_blendmode(bm_normal);
}

surface_reset_target();

// 3. Affiche la surface par-dessus le continent avec son alpha
draw_surface_ext(surf_mask, 0, 0, 1, 1, 0, c_white, image_alpha);
