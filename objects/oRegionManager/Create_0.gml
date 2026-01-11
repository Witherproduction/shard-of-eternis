/// @description Init Region Manager
// S'aligne sur le continent
if (instance_exists(oContinentOuest)) {
    var cont = instance_find(oContinentOuest, 0);
    x = cont.x;
    y = cont.y;
    image_xscale = cont.image_xscale;
    image_yscale = cont.image_yscale;
    image_alpha = cont.image_alpha;
}

// Variables Masque
surf_mask = -1;
mask_sprite = -1; // À définir dans l'enfant
mask_points = []; // À définir dans l'enfant
mask_offset_x = 0;
mask_offset_y = 0;
mask_scale_x = 1;
mask_scale_y = 1;

// Condition de révélation
required_chapter = -1;
required_act = -1;
