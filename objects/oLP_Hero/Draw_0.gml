draw_sprite_ext(sLP_Hero, 0, x, y, 1, 1, 0, c_white, 1);
draw_set_font(fontLP);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var text_x_hero = x + 40;
var text_y_hero = y;
var t_hero = clamp(nbLP / 50, 0, 1);
var col_hero = make_color_rgb(round(255 * (1 - t_hero)), round(255 * t_hero), 0);
draw_text_color(text_x_hero, text_y_hero, nbLP, col_hero, col_hero, col_hero, col_hero, 1);

// --- SECRET OVERLAY ---
if (variable_global_exists("activeSecretsHero") && ds_exists(global.activeSecretsHero, ds_type_list)) {
    var cnt = ds_list_size(global.activeSecretsHero);
    if (cnt > 0) {
        var secret_x = x;
        var secret_y = y - 70; // Juste au dessus des LP
        
        // Scaling 50%
        draw_sprite_ext(sSecret, 0, secret_x, secret_y, 0.5, 0.5, 0, c_white, 1);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        // Texte dans la partie basse
        draw_text_transformed(secret_x, secret_y + 12, string(cnt), 0.6, 0.6, 0);
    }
}
