if (room != rBoutique) exit;
var click = mouse_check_button_pressed(mb_left);
var process_buy_qty_input = function() {
    var s = keyboard_string;
    if (string_length(s) > 0) {
        buy_qty_input += s;
        keyboard_string = "";
    }
    var filtered = "";
    for (var ii = 1; ii <= string_length(buy_qty_input); ii++) {
        var ch = string_copy(buy_qty_input, ii, 1);
        if (ord(ch) >= ord("0") && ord(ch) <= ord("9")) {
            filtered += ch;
        }
    }
    buy_qty_input = filtered;
    if (keyboard_check_pressed(vk_backspace)) {
        if (string_length(buy_qty_input) > 0) {
            buy_qty_input = string_copy(buy_qty_input, 1, string_length(buy_qty_input) - 1);
        }
    }
    if (keyboard_check_pressed(vk_enter)) {
        var val = real(buy_qty_input);
        if (val <= 0) val = 1;
        buy_quantity = clamp(val, 1, 50);
        buy_qty_input = "";
        buy_qty_edit_mode = false;
    }
    if (keyboard_check_pressed(vk_escape)) {
        buy_qty_input = "";
        buy_qty_edit_mode = false;
    }
};
if (!click) {
    if (buy_qty_edit_mode) { process_buy_qty_input(); }
    if (pack_timer > 0) { pack_timer--; }
    if (reveal_active) { reveal_anim_t++; }
    if (reveal_active) { reveal_t++; }
    if (loading_active) {
        loading_timer--;
        loading_elapsed++;
        loading_angle += 6;
        if (loading_timer <= 0 && loading_elapsed >= loading_min_frames) {
            loading_active = false;
            reveal_active = true;
            portal_state = 1;
            portal_scale = 0;
            reveal_t = 0;
            reveal_stage = -1;
        }
    }
    if (portal_state == 1) {
        var grow_frames = 18;
        var p = clamp(reveal_t / grow_frames, 0, 1);
        portal_scale = lerp(0, 1.5, p);
        if (reveal_t >= grow_frames) { portal_state = 0; reveal_t = 0; reveal_stage = 0; }
    } else if (portal_state == 6) {
        var shrink_frames = 18;
        var p2 = clamp(reveal_t / shrink_frames, 0, 1);
        portal_scale = lerp(1.5, 0, p2);
        if (reveal_t >= shrink_frames) { portal_state = 0; reveal_t = 0; }
    }
    exit;
}
var mx = device_mouse_x(0);
var my = device_mouse_y(0);
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cw = floor(gw * 2 / 3);
var ch = floor(gh * 2 / 3);
var cx = floor((gw - cw) / 2);
var cy = floor((gh - ch) / 2);
var pad = 24;
var ix = cx + pad;
var iy = cy + pad;
var iw = cw - pad * 2;
var ih = ch - pad * 2;
var gap = 24;
var bw = floor((iw - gap * 2) / 3);
var bh = floor(ih * 0.65);
if (reveal_active) {
    var panel_w = iw;
    var panel_h = ih;
    var left_w = floor(panel_w * 0.35);
    var right_w = panel_w - left_w;
    var left_x1 = ix;
    var left_x2 = ix + left_w;
    var right_x1 = left_x2;
    var right_x2 = ix + panel_w;
        var arrow_h = 60;
        var arrow_w = 60;
        var mid_y = iy + panel_h * 0.5;
        var end_x = ix + iw * 0.5;
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
    if (reveal_ready && mx >= left_ax1 && mx <= left_ax2 && my >= left_ay1 && my <= left_ay2) {
        reveal_index = min(array_length(reveal_cards) - 1, reveal_index + 1);
        reveal_stage = 2;
        reveal_t = 0;
        reveal_face = 0;
        exit;
    }
    if (reveal_ready && mx >= right_ax1 && mx <= right_ax2 && my >= right_ay1 && my <= right_ay2) {
        reveal_index = max(0, reveal_index - 1);
        reveal_stage = 2;
        reveal_t = 0;
        reveal_face = 0;
        exit;
    }
    if (!reveal_ready) {
        var skip_w = 160;
        var skip_h = 40;
        var skip_x1 = ix + iw - skip_w - 20;
        var skip_y1 = iy + ih - skip_h - 20;
        var skip_x2 = skip_x1 + skip_w;
        var skip_y2 = skip_y1 + skip_h;
        if (mx >= skip_x1 && mx <= skip_x2 && my >= skip_y1 && my <= skip_y2) {
            reveal_index = max(0, array_length(reveal_cards) - 1);
            reveal_stage = 2;
            reveal_t = 0;
            reveal_sequence = false;
            portal_done = true;
            reveal_ready = true;
            exit;
        }
    }
    if (!reveal_ready) {
        if (array_length(reveal_cards) > 0) {
            if (reveal_index < array_length(reveal_cards) - 1) {
                reveal_index++;
                reveal_stage = 0;
                reveal_t = 0;
                reveal_face = 0;
            } else {
                portal_state = 6;
                reveal_t = 0;
                portal_done = true;
                reveal_ready = true;
                reveal_sequence = false;
            }
            exit;
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
        if (mx >= btn_left && mx <= btn_right && my >= btn_top && my <= btn_bottom) {
            reveal_active = false;
            reveal_ready = false;
            reveal_sequence = false;
            portal_state = 0;
            // Optionally clear arrays/timers
            pack_timer = 0;
            portal_scale = 0;
            portal_done = false;
            reveal_cards = [];
            reveal_index = 0;
            confirm_open = false;
            exit;
        }
    }
    exit;
}
if (confirm_open) {
    var dlg_w = floor(iw * 0.5);
    var dlg_h = 180;
    var dlg_x1 = ix + (iw - dlg_w) * 0.5;
    var dlg_y1 = iy + (ih - dlg_h) * 0.5;
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
    if (mx >= ok_x1 && mx <= ok_x2 && my >= ok_y1 && my <= ok_y2) {
        confirm_open = false;
        if (!can_afford(cost * buy_quantity)) { exit; }
        if (!spend_gold(cost * buy_quantity)) { exit; }
        var got_all = [];
        var allCards = dbGetAllCards();
        var commons_base = [];
        var rares_base = [];
        var epics_base = [];
        var legends_base = [];
        for (var k = 0; k < array_length(allCards); k++) {
            var c = allCards[k];
            if (!variable_struct_exists(c, "booster")) continue;
            if (string(c.booster) != "Retour des Archontes") continue;
            var isToken = false;
            if (variable_struct_exists(c, "genre") && string_lower(string(c.genre)) == "jeton") isToken = true;
            if (!isToken && variable_struct_exists(c, "id")) {
                var cid = string_lower(string(c.id));
                if (string_copy(cid, 1, 6) == "jeton_") isToken = true;
            }
            if (isToken) continue;
            var r = variable_struct_exists(c, "rarity") ? string_lower(string(c.rarity)) : "commun";
            if (r == "legendaire") {
                array_push(legends_base, c);
            } else if (r == "epique") {
                array_push(epics_base, c);
            } else if (r == "rare") {
                array_push(rares_base, c);
            } else {
                array_push(commons_base, c);
            }
        }
        for (var q = 0; q < buy_quantity; q++) {
            var commons = [];
            for (var ci = 0; ci < array_length(commons_base); ci++) { array_push(commons, commons_base[ci]); }
            var rares = [];
            for (var ri = 0; ri < array_length(rares_base); ri++) { array_push(rares, rares_base[ri]); }
            var epics = [];
            for (var ei = 0; ei < array_length(epics_base); ei++) { array_push(epics, epics_base[ei]); }
            var legends = [];
            for (var li = 0; li < array_length(legends_base); li++) { array_push(legends, legends_base[li]); }
            var got = [];
            if (array_length(rares) > 0) {
                var idx_r = irandom(array_length(rares) - 1);
                var sel_r = rares[idx_r];
                array_delete(rares, idx_r, 1);
                array_push(got, sel_r);
            } else if (array_length(epics) > 0) {
                var idx_e = irandom(array_length(epics) - 1);
                var sel_e = epics[idx_e];
                array_delete(epics, idx_e, 1);
                array_push(got, sel_e);
            } else if (array_length(commons) > 0) {
                var idx_c = irandom(array_length(commons) - 1);
                var sel_c = commons[idx_c];
                array_delete(commons, idx_c, 1);
                array_push(got, sel_c);
            }
            var n = max(0, pack_size - array_length(got));
            for (var t = 0; t < n; t++) {
                var target = "commun";
                var roll = random(1);
                if (roll < p_upgrade_legendary) {
                    target = "legendaire";
                } else if (roll < p_upgrade_legendary + p_upgrade_epic) {
                    target = "epique";
                } else if (roll < p_upgrade_legendary + p_upgrade_epic + p_upgrade_rare) {
                    target = "rare";
                }
                var chosen = noone;
                if (target == "legendaire" && array_length(legends) > 0) {
                    var iL = irandom(array_length(legends) - 1);
                    chosen = legends[iL];
                    array_delete(legends, iL, 1);
                } else if (target == "epique" && array_length(epics) > 0) {
                    var iE = irandom(array_length(epics) - 1);
                    chosen = epics[iE];
                    array_delete(epics, iE, 1);
                } else if (target == "rare" && array_length(rares) > 0) {
                    var iR = irandom(array_length(rares) - 1);
                    chosen = rares[iR];
                    array_delete(rares, iR, 1);
                } else if (array_length(commons) > 0) {
                    var iC = irandom(array_length(commons) - 1);
                    chosen = commons[iC];
                    array_delete(commons, iC, 1);
                } else if (array_length(rares) > 0) {
                    var iR2 = irandom(array_length(rares) - 1);
                    chosen = rares[iR2];
                    array_delete(rares, iR2, 1);
                } else if (array_length(epics) > 0) {
                    var iE2 = irandom(array_length(epics) - 1);
                    chosen = epics[iE2];
                    array_delete(epics, iE2, 1);
                } else if (array_length(legends) > 0) {
                    var iL2 = irandom(array_length(legends) - 1);
                    chosen = legends[iL2];
                    array_delete(legends, iL2, 1);
                }
                if (chosen != noone) {
                    array_push(got, chosen);
                }
            }
            for (var m = 0; m < array_length(got); m++) {
                var csel = got[m];
                if (variable_struct_exists(csel, "id")) {
                    unlock_card(string(csel.id));
                }
                array_push(got_all, csel);
            }
        }
        last_pack_names = [];
        for (var j = 0; j < array_length(got_all); j++) {
            var nm = variable_struct_exists(got_all[j], "name") ? string(got_all[j].name) : (variable_struct_exists(got_all[j], "id") ? string(got_all[j].id) : "Carte");
            array_push(last_pack_names, nm);
        }
        reveal_cards = got_all;
        reveal_index = 0;
        reveal_active = false;
        reveal_t = 0;
        reveal_stage = -1;
        reveal_face = 1;
        portal_state = 0;
        portal_scale = 0;
        reveal_sequence = true;
        reveal_ready = false;
        portal_done = false;
        loading_active = true;
        loading_timer = room_speed; // ~1s de chargement
        // Pré-charger les sprites pour limiter les lags à l'affichage
        for (var pre = 0; pre < array_length(reveal_cards); pre++) {
            var cc = reveal_cards[pre];
            if (is_struct(cc) && variable_struct_exists(cc, "sprite")) {
                cc.cache_spr = asset_get_index(cc.sprite);
            }
        }
        pack_timer = room_speed * 5;
        exit;
    }
    if (mx >= cancel_x1 && mx <= cancel_x2 && my >= cancel_y1 && my <= cancel_y2) {
        confirm_open = false;
        exit;
    }
    exit;
}
for (var i = 0; i < 3; i++) {
    var bx = ix + i * (bw + gap);
    var by = iy;
    var label_y = by + bh + 32;
    var buy_y = label_y + 51;
    var buy_h = 55;
    var buy_left = bx + bw * 0.15;
    var buy_right = bx + bw * 0.85;
    var buy_top = buy_y - buy_h * 0.5;
    var buy_bottom = buy_y + buy_h * 0.5;
    if (mx >= buy_left && mx <= buy_right && my >= buy_top && my <= buy_bottom) {
        if (i == 0) {
            if (can_afford(cost * buy_quantity)) {
                confirm_open = true;
                exit;
            }
        }
        break;
    }
}
if (true) {
    var i = 0;
    var bx = ix + i * (bw + gap);
    var by = iy;
    var label_y = by + bh + 32;
    var buy_y = label_y + 51;
    var qty_w = 180;
    var qty_h = 36;
    var qty_y = buy_y + 60;
    var qty_left = bx + bw * 0.22;
    var qty_right = qty_left + qty_w;
    var qty_top = qty_y - qty_h * 0.5;
    var qty_bottom = qty_y + qty_h * 0.5;
    var minus_w = 36;
    var plus_w = 36;
    var minus_x1 = qty_left;
    var minus_x2 = minus_x1 + minus_w;
    var plus_x2 = qty_right;
    var plus_x1 = plus_x2 - plus_w;
    if (mx >= minus_x1 && mx <= minus_x2 && my >= qty_top && my <= qty_bottom) {
        buy_quantity = max(1, buy_quantity - 1);
        buy_qty_edit_mode = false;
        exit;
    }
    if (mx >= plus_x1 && mx <= plus_x2 && my >= qty_top && my <= qty_bottom) {
        buy_quantity = min(50, buy_quantity + 1);
        buy_qty_edit_mode = false;
        exit;
    }
    var center_x1 = minus_x2;
    var center_x2 = plus_x1;
    if (mx >= center_x1 && mx <= center_x2 && my >= qty_top && my <= qty_bottom) {
        if (!buy_qty_edit_mode) {
            buy_qty_input = "";
            keyboard_string = "";
        }
        buy_qty_edit_mode = true;
        exit;
    }
    buy_qty_edit_mode = false;
}
if (buy_qty_edit_mode) { process_buy_qty_input(); }
