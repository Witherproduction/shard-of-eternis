draw_sprite_ext(sLP_Enemy, 0, x, y+5, 1, 1, 0, c_white, 1);
draw_set_font(fontLP);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var text_x_enemy = x - 40;
var text_y_enemy = y + 5;
var t_enemy = clamp(nbLP / 50, 0, 1);
var col_enemy = make_color_rgb(round(255 * (1 - t_enemy)), round(255 * t_enemy), 0);
draw_text_color(text_x_enemy, text_y_enemy, nbLP, col_enemy, col_enemy, col_enemy, col_enemy, 1);

// --- SECRET OVERLAY ---
if (variable_global_exists("activeSecretsEnemy") && ds_exists(global.activeSecretsEnemy, ds_type_list)) {
    var cnt = ds_list_size(global.activeSecretsEnemy);
    if (cnt > 0) {
        var secret_x = x;
        var secret_y = y + 70; // Juste en dessous des LP
        
        // Scaling 50%
        draw_sprite_ext(sSecret, 0, secret_x, secret_y, 0.5, 0.5, 0, c_white, 1);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        // Texte dans la partie basse
        draw_text(secret_x, secret_y + 12, string(cnt));
    }
}
