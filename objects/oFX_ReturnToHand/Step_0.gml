// oFX_ReturnToHand - Step
_t++;
var progress = clamp(_t / duration, 0, 1);
var ease = 1 - power(1 - progress, 3); // Ease Out Cubic

// Cible dynamique (la carte bouge peut-être dans la main)
var tx = x;
var ty = y;
var target_scale_x = end_scale;
var target_scale_y = end_scale;

if (instance_exists(card_instance)) {
    tx = card_instance.x;
    ty = card_instance.y;
    target_scale_x = card_instance.image_xscale;
    target_scale_y = card_instance.image_yscale;
    
    // Garder la carte invisible pendant le trajet
    card_instance.visible = false;
}

// Interpolation position
var lx = lerp(start_x, tx, ease);
var ly = lerp(start_y, ty, ease);

// Arc
var arc = sin(progress * pi) * arc_height * (1 - ease); // S'atténue vers la fin
y = ly + arc;
x = lx;

// Interpolation échelle
image_xscale = lerp(start_scale, target_scale_x, ease);
image_yscale = lerp(start_scale, target_scale_y, ease);

// Rotation (petit effet sympa)
image_angle = lerp(0, 360, ease); // Un tour complet ou ajuster selon besoin
if (instance_exists(card_instance)) {
    // S'aligner sur la rotation finale de la carte en main
    image_angle = lerp(0, card_instance.image_angle, ease);
}

// Fin
if (progress >= 1) {
    if (instance_exists(card_instance)) {
        card_instance.visible = true;
        // Petit flash ou effet d'arrivée ?
    }
    instance_destroy();
}