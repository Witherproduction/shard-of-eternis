var n = array_length(cards);
if (n <= 0) exit;
var scale = scaleView;
var totalW = 0;
for (var i = 0; i < n; i++) {
    var spr = cards[i].sprite_index;
    totalW += sprite_get_width(spr) * scale;
}
var gap = 40;
var allW = totalW + max(0, (n - 1)) * gap;
var startX = (room_width - allW) / 2;
var overlayY = room_height * 0.35;
draw_set_alpha(overlayAlpha);
for (var j = 0; j < n; j++) {
    var c = cards[j];
    var sprj = c.sprite_index;
    var wj = sprite_get_width(sprj) * scale;
    var hj = sprite_get_height(sprj) * scale;
    var xj = startX + j * (wj + gap) + wj / 2;
    draw_sprite_ext(sprj, 0, xj, overlayY, scale, scale, 0, c_white, 1);
    var s = scale;
    var cw = sprite_get_width(sprj) * s;
    var ch = sprite_get_height(sprj) * s;
    var tlx = xj - cw * 0.5;
    var tly = overlayY - ch * 0.5;
    var is_magic = object_is_ancestor(c.object_index, oCardMagic) || (variable_instance_exists(c, "type") && string_lower(string(c.type)) == "magic");
    var name_x1 = 24,  name_y1 = 16;  var name_x2 = 387, name_y2 = 59;
    var star_x1 = 388, star_y1 = 16;  var star_x2 = 438, star_y2 = 60;
    var genre_x1 = 29, genre_y1 = 394; var genre_x2 = 223, genre_y2 = 419;
    var arch_x1  = 228, arch_y1  = 394; var arch_x2  = 422, arch_y2  = 419;
    var desc_x1  = 23,  desc_y1  = 438; var desc_x2  = 421, desc_y2  = 592;
    var atk_x1   = 303, atk_y1   = 594; var atk_x2   = 348, atk_y2   = 609;
    var def_x1   = 383, def_y1   = 594; var def_x2   = 421, def_y2   = 608;
    if (font_exists(fontCardText)) draw_set_font(fontCardText);
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
    if (variable_instance_exists(c, "name")) {
        var txn = string(c.name);
        var mar_n = 7;
        var rwn = (name_x2 - name_x1) * s - pad * 2 - mar_n * 2;
        var rhn = (name_y2 - name_y1) * s - pad * 2;
        var scn = fit_line(txn, 20, rwn, rhn); scn = round(scn * 20) / 20;
        var leftn = tlx + name_x1 * s + pad + mar_n;
        var topn  = tly + name_y1 * s + pad;
        var bhn = string_height("Ag"); var hscn = bhn * scn;
        leftn = round(leftn); var cyn = topn + max(0, (rhn - hscn) * 0.5) + 2; cyn = round(cyn);
        draw_text_transformed(leftn, cyn, txn, scn, scn, 0);
    }
    if (!is_magic && variable_instance_exists(c, "star")) {
        var txs = string(c.star);
        var rws = (star_x2 - star_x1) * s - pad * 2;
        var rhs = (star_y2 - star_y1) * s - pad * 2;
        var scs = fit_line(txs, 20, rws, rhs); scs = round(scs * 20) / 20;
        var lefts = tlx + star_x1 * s + pad; var tops = tly + star_y1 * s + pad;
        var wscs  = string_width(txs) * scs; var cxs   = lefts + max(0, (rws - wscs) * 0.5); cxs = round(cxs); tops = round(tops);
        draw_text_transformed(cxs, tops + 2, txs, scs, scs, 0);
    }
    if (variable_instance_exists(c, "genre")) {
        var txg = string(c.genre);
        var marg = 7;
        var rwg = (genre_x2 - genre_x1) * s - pad * 2 - marg * 2;
        var rhg = (genre_y2 - genre_y1) * s - pad * 2;
        var scg = fit_line(txg, 16, rwg, rhg); scg = round(scg * 20) / 20;
        var gx = tlx + genre_x1 * s + pad + marg; var gy = tly + genre_y1 * s + pad; gx = round(gx); gy = round(gy);
        draw_text_transformed(gx, gy + 2, txg, scg, scg, 0);
    }
    if (variable_instance_exists(c, "archetype")) {
        var txa = string(c.archetype);
        var mara = 7;
        var rwa = (arch_x2 - arch_x1) * s - pad * 2 - mara * 2;
        var rha = (arch_y2 - arch_y1) * s - pad * 2;
        var sca = fit_line(txa, 16, rwa, rha); sca = round(sca * 20) / 20;
        var ax = tlx + arch_x1 * s + pad + mara; var ay = tly + arch_y1 * s + pad; ax = round(ax); ay = round(ay);
        draw_text_transformed(ax, ay + 2, txa, sca, sca, 0);
    }
    if (variable_instance_exists(c, "description")) {
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        var txd = string(c.description);
        var mard = 7;
        var rwd = (desc_x2 - desc_x1) * s - pad * 2 - mard * 2;
        var rhd = (desc_y2 - desc_y1) * s - pad * 2;
        var leftd = tlx + desc_x1 * s + pad + mard; var topd  = tly + desc_y1 * s + pad;
        var base_h = string_height("Ag"); var sc0 = (base_h > 0) ? 20 / base_h : 1; var scd = sc0;
        for (var ii = 0; ii < 6; ii++) {
            var w_pre = (scd > 0) ? (rwd / scd) : rwd; var h_un = string_height_ext(txd, base_h, w_pre);
            var h_sc = h_un * scd; if (h_sc <= rhd) break; var k = rhd / max(1, h_sc); scd *= max(0.6, min(0.95, k)); scd = min(scd, sc0);
        }
        scd = round(scd * 20) / 20; leftd = round(leftd); topd  = round(topd); var w_eff = round(rwd / scd);
        draw_text_ext_transformed(leftd, topd + 2, txd, base_h, w_eff, scd, scd, 0);
    }
    if (!is_magic && variable_instance_exists(c, "attack")) {
        draw_set_color(c_black);
        var txk = string(c.attack);
        var rwk = (atk_x2 - atk_x1) * s - pad * 2; var rhk = (atk_y2 - atk_y1) * s - pad * 2;
        var basek = string_height("Ag"); var sck = (basek > 0) ? 10 / basek : 1; sck = round(sck * 20) / 20;
        var leftk = tlx + atk_x1 * s + pad; var topk  = tly + atk_y1 * s + pad; var wssk  = string_width(txk) * sck;
        var cxk   = leftk + max(0, (rwk - wssk) * 0.5); var cyk   = topk  + max(0, (rhk - basek * sck) * 0.5) - 1; cxk = round(cxk); cyk = round(cyk);
        draw_text_transformed(cxk, cyk, txk, sck, sck, 0);
    }
    if (!is_magic && variable_instance_exists(c, "defense")) {
        draw_set_color(c_black);
        var txd2 = string(c.defense);
        var rwd2 = (def_x2 - def_x1) * s - pad * 2; var rhd2 = (def_y2 - def_y1) * s - pad * 2;
        var based2 = string_height("Ag"); var scd2 = (based2 > 0) ? 10 / based2 : 1; scd2 = round(scd2 * 20) / 20;
        var leftd2 = tlx + def_x1 * s + pad; var topd2  = tly + def_y1 * s + pad; var wssd2  = string_width(txd2) * scd2;
        var cxd2   = leftd2 + max(0, (rwd2 - wssd2) * 0.5); var cyd2   = topd2  + max(0, (rhd2 - based2 * scd2) * 0.5) - 1; cxd2 = round(cxd2); cyd2 = round(cyd2);
        draw_text_transformed(cxd2, cyd2, txd2, scd2, scd2, 0);
    }
    var num = selections[j];
    if (num > 0) {
        var bx = xj - wj / 2 + 14;
        var by = overlayY - hj / 2 + 14;
        draw_set_color(c_red);
        draw_circle(bx, by, 14, false);
        draw_set_color(c_white);
        draw_circle(bx, by, 14, true);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(bx, by, string(num));
        draw_set_halign(fa_left);
draw_set_valign(fa_top);
}

}
var btnW = 200;
var btnH = 60;
var btnX = room_width / 2 - btnW / 2;
var btnY = overlayY + 200;
var bg = make_color_rgb(0,150,0);
var frame = c_green;
draw_set_color(bg);
draw_rectangle(btnX, btnY, btnX + btnW, btnY + btnH, false);
draw_set_color(frame);
draw_rectangle(btnX, btnY, btnX + btnW, btnY + btnH, true);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btnX + btnW / 2, btnY + btnH / 2, "Valider");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
overlayBtnX = btnX;
overlayBtnY = btnY;
overlayBtnW = btnW;
overlayBtnH = btnH;
draw_set_alpha(1);