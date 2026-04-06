var portrait_spr = -1;
if (variable_global_exists("selected_bot_deck_id")) {
    var bot_id = global.selected_bot_deck_id;
    if (script_exists(asset_get_index("get_bot_deck_by_id_new"))) {
        var deck = get_bot_deck_by_id_new(bot_id);
        if (is_struct(deck) && variable_struct_exists(deck, "portrait")) {
            portrait_spr = asset_get_index(string(deck.portrait));
        }
    }
}
if (portrait_spr == -1) portrait_spr = asset_get_index("sPortraitKaelen");

var base_x = x;
var base_y = y + 5;

draw_sprite_ext(sLP_Enemy, 0, base_x, base_y, 1, 1, 0, c_white, 1);

if (portrait_spr != -1) {
    var slot_cx = base_x + 84;
    var slot_cy = base_y - 3;
    var inner = 123;

    var spr_w = max(1, sprite_get_width(portrait_spr));
    var spr_h = max(1, sprite_get_height(portrait_spr));
    var crop = min(spr_w, spr_h);
    var src_x = floor((spr_w - crop) * 0.5);
    var src_y = floor((spr_h - crop) * 0.5);
    var pscale = inner / crop;
    var dst_x = round(slot_cx - inner * 0.5);
    var dst_y = round(slot_cy - inner * 0.5);
    draw_sprite_part_ext(portrait_spr, 0, src_x, src_y, crop, crop, dst_x, dst_y, pscale, pscale, c_white, 1);
}

draw_set_font(fontLife);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var text_x_enemy = base_x - 40;
var text_y_enemy = base_y;
var t_enemy = clamp(nbLP / 50, 0, 1);
var col_enemy = make_color_rgb(round(255 * (1 - t_enemy)), round(255 * t_enemy), 0);
draw_text_color(text_x_enemy, text_y_enemy, nbLP, col_enemy, col_enemy, col_enemy, col_enemy, 1);

// --- SECRET OVERLAY ---
if (variable_global_exists("activeSecretsEnemy") && ds_exists(global.activeSecretsEnemy, ds_type_list)) {
    var cnt = ds_list_size(global.activeSecretsEnemy);
    if (cnt > 0) {
        var secret_x = base_x;
        var secret_y = base_y + 70; // Juste en dessous des LP
        
        // Scaling 50%
        draw_sprite_ext(sSecret, 0, secret_x, secret_y, 0.5, 0.5, 0, c_white, 1);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        // Texte dans la partie basse
        draw_text_transformed(secret_x, secret_y + 12, string(cnt), 0.6, 0.6, 0);
    }
}
