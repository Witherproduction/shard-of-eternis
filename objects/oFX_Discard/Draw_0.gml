// oFX_Discard - Draw
// Effet de défausse: brûlure progressive (spécialisé)

if (variable_instance_exists(self, "spriteGhost") && spriteGhost != noone) {
    var old_alpha = draw_get_alpha();

    // Mode Défausse uniquement
    draw_set_alpha(alpha);

    var x_left = x - spr_xoff * image_xscale;
    var y_top  = y - spr_yoff * image_yscale;
    var visible_h = max(spr_h - burn_px, 0);

    if (visible_h > 0) {
        draw_sprite_part_ext(spriteGhost, imageGhost, 0, 0, spr_w, visible_h, x_left, y_top, image_xscale, image_yscale, c_white, 1);
    }

    // Bande d'effet feu: sDiscardFire tilé sur la largeur de la carte
    var y_line = y_top + visible_h * image_yscale;
    var x_right = x_left + spr_w * image_xscale;
    var life = max(0, 1 - (_t / duration));
    var alpha_band = min(1, 0.9 * life);
    if (spr_discard != -1) {
        var sw = sprite_get_width(spr_discard) * discard_scale_x;
        var sh = sprite_get_height(spr_discard) * discard_scale_y;
        var tiles = max(1, ceil((x_right - x_left) / max(1, sw)));
        var per_frame = (spr_discard_frames > 0) ? (discard_cycle_ms / spr_discard_frames) : discard_cycle_ms;
        var pf = (spr_discard_frames > 0) ? floor(((current_time - discard_start_time) mod discard_cycle_ms) / per_frame) : 0;
        draw_set_alpha(alpha_band);
        for (var k = 0; k < tiles; k++) {
            var tx = x_left + k * sw + (sw * 0.5);
            var ty = y_line;
            draw_sprite_ext(spr_discard, pf, tx, ty, discard_scale_x, discard_scale_y, 0, c_white, 1);
        }
        draw_set_alpha(old_alpha);
    } else {
        // Fallback visuel si sprite manquant: garder ancienne bande
        gpu_set_blendmode(bm_add);
        var outer_h = max(3, floor((flame_thickness + 6) / 2));
        draw_set_alpha(min(1, 0.5 * life));
        draw_rectangle_color(x_left, y_line - outer_h, x_right, y_line + outer_h, flame_col2, flame_col2, flame_col2, flame_col2, false);
        var half = max(2, floor(flame_thickness / 2));
        draw_set_alpha(min(1, 1.0 * life));
        draw_rectangle_color(x_left, y_line - half, x_right, y_line + half, flame_col1, flame_col1, flame_col2, flame_col2, false);
        draw_set_alpha(min(1, 0.8 * life));
        draw_rectangle_color(x_left, y_line - 1, x_right, y_line + 1, c_white, c_white, c_white, c_white, false);
        draw_set_alpha(old_alpha);
        gpu_set_blendmode(bm_normal);
    }
}