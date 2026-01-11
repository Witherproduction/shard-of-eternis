/// @description Draw Continent & Mask
draw_self();

if (mask_sprite != -1) {
    // Gestion de la surface de masque
    if (!surface_exists(surf_mask)) {
        // Création de la surface à la taille du masque (en tenant compte de l'échelle du continent)
        var w = sprite_get_width(mask_sprite);
        var h = sprite_get_height(mask_sprite);
        
        // On utilise une surface de la taille du sprite de base pour simplifier les coordonnées locales
        // On l'affichera ensuite avec l'échelle de l'instance
        surf_mask = surface_create(w, h);
    }
    
    surface_set_target(surf_mask);
    draw_clear_alpha(c_black, 0);
    
    // 1. Dessiner le masque complet (Opacité 100%)
    // On dessine aux coordonnées locales de la surface (basées sur l'origine du sprite)
    var ox = sprite_get_xoffset(mask_sprite);
    var oy = sprite_get_yoffset(mask_sprite);
    
    draw_sprite(mask_sprite, 0, ox, oy);
    
    // 2. Appliquer les pochoirs (Soustraction)
    gpu_set_blendmode(bm_subtract);
    
    // Boucle sur les régions définies
    for (var i = 0; i < array_length(regions); i++) {
        var reg = regions[i];
        
        // Vérifier la progression
        var revealed = false;
        
        // OVERRIDE ADMIN : Toujours révéler en mode admin pour pouvoir éditer
        if (variable_global_exists("admin_mode") && global.admin_mode) {
            revealed = true;
        } else {
            try {
                if (variable_global_exists("progression_data")) { // Vérif basique
                     if (is_act_complete(reg.chap, reg.act)) {
                         revealed = true;
                     }
                } else {
                     if (is_act_complete(reg.chap, reg.act)) {
                         revealed = true;
                     }
                }
            } catch(e) {
                revealed = false;
            }
        }
        
        if (revealed && reg.sprite != -1) {
            // Dessiner le pochoir
            // Position : Centre du masque (ox, oy) + Offset de la région
            var draw_x = ox + reg.x;
            var draw_y = oy + reg.y;
            
            draw_sprite_ext(reg.sprite, 0, draw_x, draw_y, reg.scale_x, reg.scale_y, 0, c_white, 1);
        }
    }
    
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    // 3. Dessiner la surface finale sur l'écran
    // On doit aligner la surface avec l'instance
    var surf_x = x - sprite_get_xoffset(mask_sprite) * image_xscale;
    var surf_y = y - sprite_get_yoffset(mask_sprite) * image_yscale;
    
    draw_surface_ext(surf_mask, surf_x, surf_y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
}
