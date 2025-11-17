// oFX_Draw - Step
// Effet de pioche: glissade verticale vers la main avec glow

_t++;
var progress = clamp(_t / duration, 0, 1);

// Lissage Smoothstep
var ease = progress * progress * (3 - 2 * progress);

// Calcul paresseux des dimensions du sprite si non initialisées
if ((spr_w <= 0 || spr_h <= 0) && variable_instance_exists(self, "spriteGhost") && spriteGhost != noone) {
    spr_w = sprite_get_width(spriteGhost);
    spr_h = sprite_get_height(spriteGhost);
    spr_xoff = sprite_get_xoffset(spriteGhost);
    spr_yoff = sprite_get_yoffset(spriteGhost);
}

// Initialisation paresseuse de l’échelle au premier Step (après assignation par le spawner)
if (!scale_initialized) {
    base_scale_x = image_xscale;
    base_scale_y = image_yscale;
    scale_initialized = true;
}

// Gestion des phases: 0 = flip (retournement), 1 = move (glissade)
if (variable_instance_exists(self, "phase") && phase == 0) {
    // Flip
    flip_t++;
    var r = clamp(flip_t / flip_frames, 0, 1);
    // Scale X vers 0 puis retour
    var sx = base_scale_x * (1 - abs(1 - 2 * r));
    image_xscale = max(0.001, sx);
    image_yscale = base_scale_y;
    x = start_x;
    y = start_y;
    alpha = 1;
    // Bascule de la face à mi-parcours
    if (r >= 0.5 && variable_instance_exists(self, "flip_to_back") && flip_to_back) {
        imageGhost = 1;
    }
    // Passage à la phase move
    if (r >= 1) { phase = 1; _t = 0; }
} else {
    // Move
    // Lissage Smoothstep
    var ease_move = progress * progress * (3 - 2 * progress);
    alpha = min(1, 0.15 + 0.85 * ease_move);
    var base_x = lerp(start_x, target_x, ease_move);
    var base_y = lerp(start_y, target_y, ease_move);
    x = base_x;
    y = base_y;
    image_xscale = base_scale_x;
    image_yscale = base_scale_y;
}

// Fin d’animation
if ((phase == 1) && progress >= 1) {
    // Rafraîchir la main seulement une fois l’animation terminée
    if (variable_instance_exists(self, "hand_to_update") && instance_exists(hand_to_update)) {
        if (variable_instance_exists(hand_to_update, "updateDisplay")) {
            hand_to_update.updateDisplay();
        }
    }
    // Révéler la carte réelle si fournie
    if (variable_instance_exists(self, "card_to_reveal") && instance_exists(card_to_reveal)) {
        card_to_reveal.visible = true;
    }
    // Mélanger le deck si demandé
    if (variable_instance_exists(self, "shuffle_after") && shuffle_after && variable_instance_exists(self, "deck_to_shuffle") && instance_exists(deck_to_shuffle)) {
        if (variable_instance_exists(deck_to_shuffle, "cards")) {
            ds_list_shuffle(deck_to_shuffle.cards);
        }
    }
    instance_destroy();
}