var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cw = floor(gw * 2 / 3);
var ch = floor(gh * 2 / 3);
var cx = floor((gw - cw) / 2);
var cy = floor((gh - ch) / 2);
var pad = 24;
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(cx, cy, cx + cw, cy + ch, false);
draw_set_color(make_color_rgb(230, 200, 120));
draw_rectangle(cx, cy, cx + cw, cy + ch, true);
var ix = cx + pad;
var iy = cy + pad;
var iw = cw - pad * 2;
var ih = ch - pad * 2;
var gap = 24;
var bw = floor((iw - gap * 2) / 3);
var bh = floor(ih * 0.65);
for (var i = 0; i < 3; i++) {
    var bx = ix + i * (bw + gap);
    var by = iy;
    draw_set_color(make_color_rgb(30, 30, 30));
    draw_rectangle(bx, by, bx + bw, by + bh, false);
    draw_set_color(make_color_rgb(200, 180, 100));
    draw_rectangle(bx, by, bx + bw, by + bh, true);
    var cx1 = bx + 12;
    var cy1 = by + 12;
    var cx2 = bx + bw - 12;
    var cy2 = by + bh - 12;
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_line(cx1, cy1, cx2, cy2);
    draw_line(cx1, cy2, cx2, cy1);
    var px = bx + bw / 2;
    var py = by + bh / 2;
    draw_set_font(fontStep);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(px, py, "placeholder", 0.7, 0.7, 0);
    var ly = by + bh + 32;
    var lx = bx + bw / 2;
    var label;
    if (i == 0) {
        label = "Retour des Archontes";
    } else {
        label = "Saison " + string(i + 1) + " (Bientôt)";
    }
    draw_set_font(fontStep);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(lx, ly, label, 0.7, 0.7, 0);
    var buy_y = ly + 36;
    var buy_h = 40;
    var buy_left = bx + bw * 0.15;
    var buy_right = bx + bw * 0.85;
    var buy_top = buy_y - buy_h * 0.5;
    var buy_bottom = buy_y + buy_h * 0.5;
    var available = (i == 0);
    var can_buy = available && can_afford(cost * buy_quantity);
    var col_bg = make_color_rgb(40, 40, 40);
    var col_border = make_color_rgb(120, 120, 120);
    if (can_buy) {
        col_bg = make_color_rgb(70, 60, 30);
        col_border = make_color_rgb(230, 200, 120);
    }
    draw_set_color(col_bg);
    draw_rectangle(buy_left, buy_top, buy_right, buy_bottom, false);
    draw_set_color(col_border);
    draw_rectangle(buy_left, buy_top, buy_right, buy_bottom, true);
    var buy_label = "Acheter x" + string(buy_quantity) + " : " + string(cost * buy_quantity) + " PO";
    draw_set_font(fontStep);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed((buy_left + buy_right) * 0.5, buy_y, buy_label, 0.6, 0.6, 0);
    if (i == 0) {
        var qty_w = 180;
        var qty_h = 36;
        var qty_y = buy_y + 46;
        var qty_left = bx + bw * 0.22;
        var qty_right = qty_left + qty_w;
        var qty_top = qty_y - qty_h * 0.5;
        var qty_bottom = qty_y + qty_h * 0.5;
        draw_set_color(make_color_rgb(buy_qty_edit_mode ? 60 : 40, 40, 40));
        draw_rectangle(qty_left, qty_top, qty_right, qty_bottom, false);
        draw_set_color(make_color_rgb(120, 120, 120));
        draw_rectangle(qty_left, qty_top, qty_right, qty_bottom, true);
        var minus_w = 36;
        var plus_w = 36;
        var minus_x1 = qty_left;
        var minus_x2 = minus_x1 + minus_w;
        var plus_x2 = qty_right;
        var plus_x1 = plus_x2 - plus_w;
        var center_x = (qty_left + qty_right) * 0.5;
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(minus_x1, qty_top, minus_x2, qty_bottom, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(minus_x1, qty_top, minus_x2, qty_bottom, true);
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(plus_x1, qty_top, plus_x2, qty_bottom, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(plus_x1, qty_top, plus_x2, qty_bottom, true);
        draw_set_font(fontStep);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed(minus_x1 + (minus_w * 0.5), qty_y, "-", 0.8, 0.8, 0);
        draw_text_transformed(plus_x1 + (plus_w * 0.5), qty_y, "+", 0.8, 0.8, 0);
        var qty_text = (buy_qty_edit_mode && string_length(buy_qty_input) > 0) ? buy_qty_input : string(buy_quantity);
        draw_text_transformed(center_x, qty_y, qty_text, 0.7, 0.7, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (confirm_open) {
    var dlg_w = floor(iw * 0.5);
    var dlg_h = 180;
    var dlg_x1 = ix + (iw - dlg_w) * 0.5;
    var dlg_y1 = iy + (ih - dlg_h) * 0.5;
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(dlg_x1, dlg_y1, dlg_x1 + dlg_w, dlg_y1 + dlg_h, false);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_rectangle(dlg_x1, dlg_y1, dlg_x1 + dlg_w, dlg_y1 + dlg_h, true);
    var t = "Confirmer l'achat de " + string(buy_quantity) + " booster(s) ?";
    draw_set_font(fontStep);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(dlg_x1 + dlg_w * 0.5, dlg_y1 + 50, t, 0.7, 0.7, 0);
    var btn_w = 140;
    var btn_h = 40;
    var ok_x1 = dlg_x1 + 40;
    var ok_y1 = dlg_y1 + dlg_h - btn_h - 20;
    var ok_x2 = ok_x1 + btn_w;
    var ok_y2 = ok_y1 + btn_h;
    var cancel_x2 = dlg_x1 + dlg_w - 40;
    var cancel_x1 = cancel_x2 - btn_w;
    var cancel_y1 = ok_y1;
    var cancel_y2 = ok_y2;
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_rectangle(ok_x1, ok_y1, ok_x2, ok_y2, false);
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_rectangle(ok_x1, ok_y1, ok_x2, ok_y2, true);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(ok_x1 + btn_w * 0.5, ok_y1 + btn_h * 0.5, "Valider", 0.6, 0.6, 0);
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_rectangle(cancel_x1, cancel_y1, cancel_x2, cancel_y2, false);
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_rectangle(cancel_x1, cancel_y1, cancel_x2, cancel_y2, true);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(cancel_x1 + btn_w * 0.5, cancel_y1 + btn_h * 0.5, "Annuler", 0.6, 0.6, 0);
}
if (loading_active) {
    var ld_w = 260;
    var ld_h = 140;
    var ldx = ix + iw * 0.5 - ld_w * 0.5;
    var ldy = iy + ih * 0.5 - ld_h * 0.5;
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(ldx, ldy, ldx + ld_w, ldy + ld_h, false);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_rectangle(ldx, ldy, ldx + ld_w, ldy + ld_h, true);
    draw_set_font(fontStep);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(ldx + ld_w * 0.5, ldy + 32, "Veuillez patienter", 0.7, 0.7, 0);
    var cx_ld = ldx + ld_w * 0.5;
    var cy_ld = ldy + ld_h * 0.5 + 10;
    var r_outer = 26;
    var r_inner = 14;
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_circle(cx_ld, cy_ld, r_outer, false);
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_circle(cx_ld, cy_ld, r_inner, true);
    var base_ang = loading_angle;
    var seg_count = 18;
    var arc_len = 80;
    for (var s = 0; s < seg_count; s++) {
        var a0 = degtorad(base_ang + s * (arc_len / seg_count));
        var a1 = degtorad(base_ang + (s + 1) * (arc_len / seg_count));
        var x0 = cx_ld + cos(a0) * r_outer;
        var y0 = cy_ld + sin(a0) * r_outer;
        var x1 = cx_ld + cos(a1) * r_outer;
        var y1 = cy_ld + sin(a1) * r_outer;
        var tcol = make_color_rgb(80 + s * 3, 140 + s * 3, 220);
        draw_set_color(tcol);
        draw_line_width(x0, y0, x1, y1, 3);
    }
    var per_frame = 3;
    for (var q = 0; q < per_frame; q++) {
        if (loading_idx < array_length(reveal_cards)) {
            var cc = reveal_cards[loading_idx];
            if (is_struct(cc) && variable_struct_exists(cc, "sprite")) {
                cc.cache_spr = asset_get_index(cc.sprite);
                var _sw = sprite_get_width(cc.cache_spr);
                var _sh = sprite_get_height(cc.cache_spr);
                var _sn = sprite_get_number(cc.cache_spr);
            }
            loading_idx++;
        } else {
            break;
        }
    }
    if (loading_idx >= array_length(reveal_cards)) {
        loading_timer = 0;
    }
    exit;
}
if (reveal_active && array_length(reveal_cards) > 0) {
    var panel_w = iw;
    var panel_h = ih;
    var left_w = floor(panel_w * 0.35);
    var right_w = panel_w - left_w;
    var left_x1 = ix;
    var left_x2 = ix + left_w;
    var right_x1 = left_x2;
    var right_x2 = ix + panel_w;
    var spr_idx = asset_get_index("sSpecialSummon");
    var sx = ix + panel_w * 0.10;
    var sy = iy + panel_h * 0.5;
    var sc = max(0, portal_scale);
    if (spr_idx != -1 && sc > 0) {
        var frame = (reveal_anim_t div 3) mod max(1, sprite_get_number(spr_idx));
        draw_sprite_ext(spr_idx, frame, sx, sy, sc, sc, 0, c_white, 1);
    }
    var card = reveal_cards[reveal_index];
    var card_spr = -1;
    if (is_struct(card) && variable_struct_exists(card, "cache_spr")) {
        card_spr = card.cache_spr;
    } else if (is_struct(card) && variable_struct_exists(card, "sprite")) {
        card_spr = asset_get_index(card.sprite);
    }
    var cx = ix + iw * 0.5;
    var cy = iy + panel_h * 0.5;
    var start_x = sx + 60;
    var end_x = cx;
    var cscale_y = 0.9;
    var cscale_x = 0.9;
    var slide_frames = 24;
    var flip_frames = 20;
    var back_spr = asset_get_index("sCarteBack");
    if (reveal_stage == 0) {
        var p = clamp(reveal_t / slide_frames, 0, 1);
        var cur_x = lerp(start_x, end_x, p);
        var cur_s = lerp(0.6, cscale_x, p);
        var cur_face_index = 1;
        if (card_spr != -1) {
            var use_face = cur_face_index;
            if (sprite_get_number(card_spr) <= 1 && back_spr != -1) {
                draw_sprite_ext(back_spr, 0, cur_x, cy, cur_s, cur_s, 0, c_white, 1);
            } else {
                draw_sprite_ext(card_spr, use_face, cur_x, cy, cur_s, cur_s, 0, c_white, 1);
            }
        }
        if (reveal_t >= slide_frames) { reveal_stage = 1; reveal_t = 0; }
    } else if (reveal_stage == 1) {
        var p2 = clamp(reveal_t / flip_frames, 0, 1);
        var xs = (p2 < 0.5) ? (1 - p2 * 2) : ((p2 - 0.5) * 2);
        var face_now = (p2 < 0.5) ? 1 : 0;
        if (card_spr != -1) {
            if (face_now == 1) {
                if (sprite_get_number(card_spr) <= 1 && back_spr != -1) {
                    draw_sprite_ext(back_spr, 0, end_x, cy, xs * cscale_x, cscale_y, 0, c_white, 1);
                } else {
                    draw_sprite_ext(card_spr, 1, end_x, cy, xs * cscale_x, cscale_y, 0, c_white, 1);
                }
            } else {
                draw_sprite_ext(card_spr, 0, end_x, cy, xs * cscale_x, cscale_y, 0, c_white, 1);
            }
        }
        if (reveal_t >= flip_frames) { reveal_stage = 2; reveal_t = 0; }
    } else if (reveal_stage == 2) {
        if (card_spr != -1) {
            draw_sprite_ext(card_spr, 0, end_x, cy, cscale_x, cscale_y, 0, c_white, 1);
        }
        var rar = "commun";
        if (is_struct(card) && variable_struct_exists(card, "rarity")) {
            rar = string_lower(string(card.rarity));
        }
        if (rar != "commun") {
            var col1 = make_color_rgb(200, 200, 200);
            var col2 = make_color_rgb(220, 220, 220);
            if (rar == "rare") {
                col1 = make_color_rgb(80, 160, 255);
                col2 = make_color_rgb(120, 190, 255);
            } else if (rar == "epique") {
                col1 = make_color_rgb(170, 80, 255);
                col2 = make_color_rgb(210, 120, 255);
            } else if (rar == "legendaire") {
                col1 = make_color_rgb(255, 200, 80);
                col2 = make_color_rgb(255, 230, 140);
            }
            var spr = card_spr;
            var s = cscale_x;
            var cw = sprite_get_width(spr) * s;
            var ch = sprite_get_height(spr) * s;
            var tlx2 = end_x - cw * 0.5;
            var tly2 = cy - ch * 0.5;
            var pulse = 0.5 + 0.5 * sin(reveal_anim_t * 0.06);
            var m = 14 + 6 * pulse;
            var rw = cw + m * 2;
            var rh = ch + m * 2;
            var per = 2 * (rw + rh);
            var segs = 36;
            var seg_len = per / segs * 0.6;
            var base = (reveal_anim_t * 6) mod per;
            draw_set_alpha(0.6 * pulse);
            for (var si = 0; si < segs; si++) {
                var d = (si * (per / segs) + base) mod per;
                var d0 = d - seg_len * 0.5;
                var d1 = d + seg_len * 0.5;
                if (d0 < 0) d0 += per;
                if (d1 >= per) d1 -= per;
                var x0, y0, x1, y1;
                var dd0 = d0;
                if (dd0 < rw) { x0 = tlx2 - m + dd0; y0 = tly2 - m; }
                else if (dd0 < rw + rh) { x0 = tlx2 + cw + m; y0 = tly2 - m + (dd0 - rw); }
                else if (dd0 < rw + rh + rw) { x0 = tlx2 + cw + m - (dd0 - (rw + rh)); y0 = tly2 + ch + m; }
                else { x0 = tlx2 - m; y0 = tly2 + ch + m - (dd0 - (rw + rh + rw)); }
                var dd1 = d1;
                if (dd1 < rw) { x1 = tlx2 - m + dd1; y1 = tly2 - m; }
                else if (dd1 < rw + rh) { x1 = tlx2 + cw + m; y1 = tly2 - m + (dd1 - rw); }
                else if (dd1 < rw + rh + rw) { x1 = tlx2 + cw + m - (dd1 - (rw + rh)); y1 = tly2 + ch + m; }
                else { x1 = tlx2 - m; y1 = tly2 + ch + m - (dd1 - (rw + rh + rw)); }
                var use_col = (si mod 2 == 0) ? col1 : col2;
                draw_set_color(use_col);
                draw_line_width(x0, y0, x1, y1, 4);
            }
            draw_set_alpha(1);
        }
        if (reveal_sequence && reveal_t >= reveal_wait_frames) {
            if (reveal_index < array_length(reveal_cards) - 1) {
                reveal_index++;
                reveal_stage = 0;
                reveal_t = 0;
            } else {
                if (!portal_done) {
                    portal_state = 6;
                    reveal_t = 0;
                    portal_done = true;
                }
                reveal_ready = true;
                reveal_sequence = false;
            }
        }
    }
    if (!reveal_ready) {
        var arrow_h = 60;
        var arrow_w = 60;
        var mid_y = cy;
        var left_center = end_x - 260;
        var right_center = end_x + 260;
        var left_ax1 = left_center - arrow_w * 0.5;
        var left_ax2 = left_center + arrow_w * 0.5;
        var left_ay1 = mid_y - arrow_h * 0.5;
        var left_ay2 = mid_y + arrow_h * 0.5;
        var right_ax1 = right_center - arrow_w * 0.5;
        var right_ax2 = right_center + arrow_w * 0.5;
        var right_ay1 = left_ay1;
        var right_ay2 = left_ay2;
        var skip_w = 160;
        var skip_h = 40;
        var skip_x1 = ix + iw - skip_w - 20;
        var skip_y1 = iy + ih - skip_h - 20;
        var skip_x2 = skip_x1 + skip_w;
        var skip_y2 = skip_y1 + skip_h;
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(skip_x1, skip_y1, skip_x2, skip_y2, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(skip_x1, skip_y1, skip_x2, skip_y2, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed((skip_x1 + skip_x2) * 0.5, (skip_y1 + skip_y2) * 0.5, "Passer", 0.7, 0.7, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        var arrow_h = 60;
        var arrow_w = 60;
        var mid_y = cy;
        var left_center = end_x - 260;
        var right_center = end_x + 260;
        var left_ax1 = left_center - arrow_w * 0.5;
        var left_ax2 = left_center + arrow_w * 0.5;
        var left_ay1 = mid_y - arrow_h * 0.5;
        var left_ay2 = mid_y + arrow_h * 0.5;
        var right_ax1 = right_center - arrow_w * 0.5;
        var right_ax2 = right_center + arrow_w * 0.5;
        var right_ay1 = left_ay1;
        var right_ay2 = left_ay2;
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(left_ax1, left_ay1, left_ax2, left_ay2, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(left_ax1, left_ay1, left_ax2, left_ay2, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed((left_ax1 + left_ax2) * 0.5, (left_ay1 + left_ay2) * 0.5, "<", 0.8, 0.8, 0);
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(right_ax1, right_ay1, right_ax2, right_ay2, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(right_ax1, right_ay1, right_ax2, right_ay2, true);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed((right_ax1 + right_ax2) * 0.5, (right_ay1 + right_ay2) * 0.5, ">", 0.8, 0.8, 0);
        var prev_idx = max(0, reveal_index - 1);
        if (prev_idx < reveal_index) {
            var next_card = reveal_cards[prev_idx];
            var next_spr = -1;
            if (is_struct(next_card) && variable_struct_exists(next_card, "cache_spr")) {
                next_spr = next_card.cache_spr;
            } else if (is_struct(next_card) && variable_struct_exists(next_card, "sprite")) {
                next_spr = asset_get_index(next_card.sprite);
            }
            if (next_spr != -1) {
                var pv_scale = 0.66;
                var pv_w = sprite_get_width(next_spr) * pv_scale;
                var pv_x = right_ax2 + 40 + pv_w * 0.5;
                draw_sprite_ext(next_spr, 0, pv_x, cy, pv_scale, pv_scale, 0, c_white, 1);
            }
        }
        var skip_w = 160;
        var skip_h = 40;
        var skip_x1 = ix + iw - skip_w - 20;
        var skip_y1 = iy + ih - skip_h - 20;
        var skip_x2 = skip_x1 + skip_w;
        var skip_y2 = skip_y1 + skip_h;
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(skip_x1, skip_y1, skip_x2, skip_y2, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(skip_x1, skip_y1, skip_x2, skip_y2, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed((skip_x1 + skip_x2) * 0.5, (skip_y1 + skip_y2) * 0.5, "Passer", 0.7, 0.7, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    if (card_spr != -1 && reveal_stage == 2) {
        var spr = card_spr;
        var s = cscale_x;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx2 = end_x - cw * 0.5;
        var tly2 = cy - ch * 0.5;
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        var desc_x1  = layout.description.x1, desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
        var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
        var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
        if (font_exists(fontCardText)) draw_set_font(fontCardText);
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var fit_line = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var w0 = string_width(text);
            var h0 = base_line_h;
            var s_max = (h0 > 0) ? max_px / h0 : 1;
            var s_w = (w0 > 0) ? rw / w0 : s_max;
            var s_h = (h0 > 0) ? rh / h0 : s_max;
            return min(s_max, s_w, s_h);
        };
        var pad2 = 0;
        if (variable_struct_exists(card, "name")) {
            var txn = string(card.name);
            var mar2 = 7;
            var rw2 = (name_x2 - name_x1) * s - pad2 * 2 - mar2 * 2;
            var rh2 = (name_y2 - name_y1) * s - pad2 * 2;
            var scn = fit_line(txn, 20, rw2, rh2);
            scn = round(scn * 20) / 20;
            var leftn = tlx2 + name_x1 * s + pad2 + mar2;
            var topn  = tly2 + name_y1 * s + pad2;
            var base_line_h = string_height("Ag");
            var hscn = base_line_h * scn;
            leftn = round(leftn);
            var cyn = topn + max(0, (rh2 - hscn) * 0.5) + 2;
            cyn = round(cyn);
            draw_text_transformed(leftn, cyn, txn, scn, scn, 0);
        }
        if (variable_struct_exists(card, "mana_cost")) {
            var txm = string(card.mana_cost);
            var rw_m = (star_x2 - star_x1) * s - pad2 * 2;
            var rh_m = (star_y2 - star_y1) * s - pad2 * 2;
            var sc_m = fit_line(txm, 20, rw_m, rh_m);
            sc_m = round(sc_m * 20) / 20;
            var leftm = tlx2 + star_x1 * s + pad2;
            var topm  = tly2 + star_y1 * s + pad2;
            var wscm  = string_width(txm) * sc_m;
            var cxm   = leftm + max(0, (rw_m - wscm) * 0.5);
            cxm = round(cxm);
            topm = round(topm);
            draw_text_transformed(cxm, topm + 2, txm, sc_m, sc_m, 0);
        }
        if (variable_struct_exists(card, "genre")) {
            var txg = string(card.genre);
            var mar3 = 7;
            var rwg = (genre_x2 - genre_x1) * s - pad2 * 2 - mar3 * 2;
            var rhg = (genre_y2 - genre_y1) * s - pad2 * 2;
            var scg = fit_line(txg, 16, rwg, rhg);
            scg = round(scg * 20) / 20;
            var gx = tlx2 + genre_x1 * s + pad2 + mar3;
            var gy = tly2 + genre_y1 * s + pad2;
            gx = round(gx);
            gy = round(gy);
            draw_text_transformed(gx, gy + 2, txg, scg, scg, 0);
        }
        if (variable_struct_exists(card, "archetype")) {
            var txa = string(card.archetype);
            var mar4 = 7;
            var rwa = (arch_x2 - arch_x1) * s - pad2 * 2 - mar4 * 2;
            var rha = (arch_y2 - arch_y1) * s - pad2 * 2;
            var sca = fit_line(txa, 16, rwa, rha);
            sca = round(sca * 20) / 20;
            var ax = tlx2 + arch_x1 * s + pad2 + mar4;
            var ay = tly2 + arch_y1 * s + pad2;
            ax = round(ax);
            ay = round(ay);
            draw_text_transformed(ax, ay + 2, txa, sca, sca, 0);
        }
        if (variable_struct_exists(card, "description")) {
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var txd = string(card.description);
            var mar5 = 7;
            var rwd = (desc_x2 - desc_x1) * s - pad2 * 2 - mar5 * 2;
            var rhd = (desc_y2 - desc_y1) * s - pad2 * 2;
            var leftd = tlx2 + desc_x1 * s + pad2 + mar5;
            var topd  = tly2 + desc_y1 * s + pad2;
            var base_h = string_height("Ag");
            var sc0 = (base_h > 0) ? 20 / base_h : 1;
            var sc = sc0;
            for (var ii = 0; ii < 8; ii++) {
                var w_pre = (sc > 0) ? (rwd / sc) : rwd;
                var h_un = string_height_ext(txd, base_h, w_pre);
                var h_sc = h_un * sc;
                if (h_sc <= rhd) break;
                var k = rhd / max(1, h_sc);
                sc *= max(0.6, min(0.95, k));
                sc = min(sc, sc0);
            }
            sc = round(sc * 20) / 20;
            leftd = round(leftd);
            topd  = round(topd);
            var w_eff = round(rwd / sc);
            draw_text_ext_transformed(leftd, topd + 2, txd, base_h, w_eff, sc, sc, 0);
        }
        var is_magic = variable_struct_exists(card, "type") && string_lower(string(card.type)) == "magic";
        if (!is_magic && variable_struct_exists(card, "attack")) {
            var txa2 = string(card.attack);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var sc_atk = 1.2;
            var cxa = tlx2 + (atk_x1 + (atk_x2-atk_x1)/2) * s;
            var cya = tly2 + (atk_y1 + (atk_y2-atk_y1)/2) * s;
            cxa = round(cxa);
            cya = round(cya);
            var o_dist = 2;
            draw_set_color(c_black);
            draw_text_transformed(cxa - o_dist, cya, txa2, sc_atk, sc_atk, 0);
            draw_text_transformed(cxa + o_dist, cya, txa2, sc_atk, sc_atk, 0);
            draw_text_transformed(cxa, cya - o_dist, txa2, sc_atk, sc_atk, 0);
            draw_text_transformed(cxa, cya + o_dist, txa2, sc_atk, sc_atk, 0);
            draw_set_color(c_lime);
            draw_text_transformed(cxa, cya, txa2, sc_atk, sc_atk, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        if (!is_magic && (variable_struct_exists(card, "PV") || variable_struct_exists(card, "current_hp"))) {
            var hpVal = variable_struct_exists(card, "current_hp") ? card.current_hp : (variable_struct_exists(card, "PV") ? card.PV : 0);
            var txh2 = string(hpVal);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var sc_hp = 1.2;
            var cxh = tlx2 + (def_x1 + (def_x2-def_x1)/2) * s;
            var cyh = tly2 + (def_y1 + (def_y2-def_y1)/2) * s;
            cxh = round(cxh);
            cyh = round(cyh);
            var o_dist = 2;
            draw_set_color(c_black);
            draw_text_transformed(cxh - o_dist, cyh, txh2, sc_hp, sc_hp, 0);
            draw_text_transformed(cxh + o_dist, cyh, txh2, sc_hp, sc_hp, 0);
            draw_text_transformed(cxh, cyh - o_dist, txh2, sc_hp, sc_hp, 0);
            draw_text_transformed(cxh, cyh + o_dist, txh2, sc_hp, sc_hp, 0);
            draw_set_color(c_lime);
            draw_text_transformed(cxh, cyh, txh2, sc_hp, sc_hp, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }
    if (reveal_ready) {
        var btn_w = 200;
        var btn_h = 44;
        var btn_y = iy + ih - 30;
        var btn_left = ix + iw * 0.5 - btn_w * 0.5;
        var btn_right = btn_left + btn_w;
        var btn_top = btn_y - btn_h * 0.5;
        var btn_bottom = btn_y + btn_h * 0.5;
        draw_set_color(make_color_rgb(70, 60, 30));
        draw_rectangle(btn_left, btn_top, btn_right, btn_bottom, false);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(btn_left, btn_top, btn_right, btn_bottom, true);
        draw_set_font(fontStep);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed((btn_left + btn_right) * 0.5, btn_y, "Terminer", 0.7, 0.7, 0);
    }
}
