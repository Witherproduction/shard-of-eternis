// Affiche uniquement la dernière carte du cimetière, si elle existe
if (array_length(cards) > 0) {
    var lastCardData = cards[array_length(cards) - 1];
    
    if (is_struct(lastCardData)) {
        var ang = isHeroOwner ? 0 : 180;
        draw_sprite_ext(lastCardData.sprite_index, lastCardData.image_index, x, y, 0.25, 0.25, ang, c_white, 1);
        gpu_set_texfilter(false);
        var s = 0.25;
        var spr = lastCardData.sprite_index;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
        var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
        var is_magic = (variable_struct_exists(lastCardData, "cardType") && string_lower(string(lastCardData.cardType)) == "magic");
        if (font_exists(fontText)) draw_set_font(fontText);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_black);
        var fit_line = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var w0 = string_width(text);
            var h0 = base_line_h;
            var s_max = (h0 > 0) ? max_px / h0 : 1;
            var s_w = (w0 > 0) ? rw / w0 : s_max;
            var s_h = (h0 > 0) ? rh / h0 : s_max;
            return min(s_max, s_w, s_h);
        };
        var pad = 0;
        var rel = s / 0.6;
        var mar = 7;
        var base_title_size = 16;
        if (font_exists(fontTitle)) base_title_size = font_get_size(fontTitle);
        var base_text_size = 14;
        if (font_exists(fontText)) base_text_size = font_get_size(fontText);
        var get_font = function(kind, size) {
            if (variable_global_exists("get_runtime_font")) return global.get_runtime_font(kind, size);
            if (kind == "title") {
                if (font_exists(fontTitle)) return fontTitle;
                if (font_exists(fontText)) return fontText;
                if (font_exists(fontUI)) return fontUI;
            } else {
                if (font_exists(fontText)) return fontText;
                if (font_exists(fontTitle)) return fontTitle;
                if (font_exists(fontUI)) return fontUI;
            }
            return -1;
        };
        var prev_world = matrix_get(matrix_world);
        var mat = matrix_build(x, y, 0, 0, 0, ang, 1, 1, 1);
        matrix_set(matrix_world, mat);
        var tlx = -cw * 0.5;
        var tly = -ch * 0.5;
        if (variable_struct_exists(lastCardData, "name")) {
            var tx = string_trim(string(lastCardData.name));
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var sc = fit_line(tx, 20 * rel, rw, rh);
            var want_px = base_title_size * sc;
            var want_size = max(6, floor(want_px));
            var f = get_font("title", want_size);
            while (want_size > 6 && f != -1) {
                draw_set_font(f);
                if (string_width(tx) <= rw && string_height("Ag") <= rh) break;
                want_size -= 1;
                f = get_font("title", want_size);
            }
            if (f != -1) draw_set_font(f);
            if (string_width(tx) > rw) {
                var suffix = "...";
                while (string_length(tx) > 1 && string_width(tx + suffix) > rw) {
                    tx = string_delete(tx, string_length(tx), 1);
                }
                tx += suffix;
            }
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            draw_text_transformed(round(left), round(top + 2), tx, 1, 1, 0);
        }
        if (variable_struct_exists(lastCardData, "mana_cost")) {
            var tx = string(lastCardData.mana_cost);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var rw = (star_x2 - star_x1) * s;
            var rh = (star_y2 - star_y1) * s;
            var center_x = tlx + (star_x1 + (star_x2-star_x1)/2) * s;
            var center_y = tly + (star_y1 + (star_y2-star_y1)/2) * s;
            center_x -= 1;
            center_x = round(center_x);
            center_y = round(center_y);
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            var sc = fit_line(tx, 22 * rel, rw, rh);
            var want_px = base_title_size * sc;
            var want_size = max(6, floor(want_px));
            var f = get_font("title", want_size);
            while (want_size > 6 && f != -1) {
                draw_set_font(f);
                if (string_width(tx) <= rw && string_height("Ag") <= rh) break;
                want_size -= 1;
                f = get_font("title", want_size);
            }
            if (f != -1) draw_set_font(f);
            draw_text_transformed(center_x, center_y, tx, 1, 1, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        if (variable_struct_exists(lastCardData, "genre")) {
            var tx = string(lastCardData.genre);
            if (variable_struct_exists(lastCardData, "race") && string_length(string(lastCardData.race)) > 0) {
                var split = string_split(tx, " - ");
                if (array_length(split) > 0) {
                    tx = split[0];
                }
            }
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            var sc = fit_line(tx, 9 * rel, rw, rh);
            var want_px = base_text_size * sc;
            var want_size = max(8, floor(want_px));
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            var left_g = tlx + genre_x1 * s + pad + mar;
            var top_g  = tly + genre_y1 * s + pad;
            draw_text_transformed(round(left_g), round(top_g), tx, sc2, sc2, 0);
        }
        var race_text = "";
        if (variable_struct_exists(lastCardData, "race") && string_length(string(lastCardData.race)) > 0) {
            race_text = string(lastCardData.race);
        } else if (variable_struct_exists(lastCardData, "archetype") && string_length(string(lastCardData.archetype)) > 0) {
            race_text = string(lastCardData.archetype);
        }
        if (race_text != "") {
            var tx = race_text;
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            var sc = fit_line(tx, 12 * rel, rw, rh);
            var want_px = base_text_size * sc;
            var want_size = max(8, floor(want_px));
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            var left_a = tlx + arch_x1 * s + pad + mar;
            var top_a  = tly + arch_y1 * s + pad;
            draw_text_transformed(round(left_a), round(top_a), tx, sc2 * 0.9, sc2 * 0.9, 0);
        }
        // Terrain style: pas de description sur la carte.
        if (!is_magic && variable_struct_exists(lastCardData, "attack")) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var txA = string(lastCardData.attack);
            var circleA_x = round(tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s) - 1;
            var circleA_y = round(tly + (atk_y1 + (atk_y2-atk_y1)/2) * s);
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            var rwA = (atk_x2 - atk_x1) * s;
            var rhA = (atk_y2 - atk_y1) * s;
            var want_px = base_title_size * (1.3 * rel);
            var want_size = max(6, floor(want_px));
            var f = get_font("title", want_size);
            while (want_size > 6 && f != -1) {
                draw_set_font(f);
                if (string_width(txA) <= rwA && string_height("Ag") <= rhA) break;
                want_size -= 1;
                f = get_font("title", want_size);
            }
            if (f != -1) draw_set_font(f);
            var o_dist = max(1, round(2 * rel));
            draw_set_color(c_black);
            draw_text_transformed(circleA_x - o_dist, circleA_y, txA, 1, 1, 0);
            draw_text_transformed(circleA_x + o_dist, circleA_y, txA, 1, 1, 0);
            draw_text_transformed(circleA_x, circleA_y - o_dist, txA, 1, 1, 0);
            draw_text_transformed(circleA_x, circleA_y + o_dist, txA, 1, 1, 0);
            draw_set_color(c_lime);
            draw_text_transformed(circleA_x, circleA_y, txA, 1, 1, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        if (!is_magic && variable_struct_exists(lastCardData, "PV")) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var txD = string(lastCardData.PV);
            var circleD_x = round(tlx + (def_x1 + (def_x2-def_x1)/2) * s);
            var circleD_y = round(tly + (def_y1 + (def_y2-def_y1)/2) * s);
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            var rwD = (def_x2 - def_x1) * s;
            var rhD = (def_y2 - def_y1) * s;
            var want_px = base_title_size * (1.2 * rel);
            var want_size = max(6, floor(want_px));
            var f = get_font("title", want_size);
            while (want_size > 6 && f != -1) {
                draw_set_font(f);
                if (string_width(txD) <= rwD && string_height("Ag") <= rhD) break;
                want_size -= 1;
                f = get_font("title", want_size);
            }
            if (f != -1) draw_set_font(f);
            var o_dist = max(1, round(2 * rel));
            draw_set_color(c_black);
            draw_text_transformed(circleD_x - o_dist, circleD_y, txD, 1, 1, 0);
            draw_text_transformed(circleD_x + o_dist, circleD_y, txD, 1, 1, 0);
            draw_text_transformed(circleD_x, circleD_y - o_dist, txD, 1, 1, 0);
            draw_text_transformed(circleD_x, circleD_y + o_dist, txD, 1, 1, 0);
            draw_set_color(c_lime);
            draw_text_transformed(circleD_x, circleD_y, txD, 1, 1, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        matrix_set(matrix_world, prev_world);
        gpu_set_texfilter(true);
    } else if (instance_exists(lastCardData)) {
        // Compatibilité avec anciennes entrées poussées comme instance
        var ang2 = isHeroOwner ? 0 : 180;
        draw_sprite_ext(lastCardData.sprite_index, lastCardData.image_index, x, y, 0.25, 0.25, ang2, c_white, 1);
    } else {
        // Instance invalide: ne rien dessiner pour éviter les erreurs
    }
}
