/// @description GUI — journal (petit texte, déplaçable, redimensionnable)
if (room != rDuel) exit;
if (!variable_global_exists("duel_log")) exit;

var px = panel_x;
var py = panel_y;
var pw = panel_w;
var ph = panel_h;
var pad = padding;
var ts = text_scale;
var step = line_step;
var slots = panel_collapsed ? 0 : visible_line_count;

var colHeader = make_color_rgb(170, 185, 210);
var colGrip = make_color_rgb(120, 130, 150);
draw_set_alpha(0.78);
draw_set_color(make_color_rgb(10, 12, 18));
draw_rectangle(px, py, px + pw, py + ph, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(55, 65, 88));
draw_rectangle(px, py, px + pw, py + ph, true);

draw_set_alpha(0.35);
draw_set_color(make_color_rgb(40, 48, 70));
draw_rectangle(px + 1, py + 1, px + pw - 1, py + header_click_h, false);
draw_set_alpha(1);

var fnt = font_exists(fontUI) ? fontUI : (font_exists(fontText) ? fontText : -1);
if (fnt != -1) draw_set_font(fnt);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Flèche replier + titre
var ax = px + pad;
var ay = py + 3;
drawGuiFoldArrow(ax, ay, arrow_size, panel_collapsed, colHeader);

var titleX = ax + toggle_zone_w;
var titleTxt = "Journal";
draw_set_color(c_black);
draw_text_transformed(titleX + 1, py + 3, titleTxt, ts, ts, 0);
draw_set_color(colHeader);
draw_text_transformed(titleX, py + 2, titleTxt, ts, ts, 0);

// Poignée redimensionnement (3 lignes diagonales)
if (!panel_collapsed) {
    drawGuiResizeGrip(px, py, pw, ph, colGrip);
}

if (panel_collapsed) {
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// Barre de filtres
var fs = filter_scale;
var chipW = getFilterChipWidth();
for (var fi = 0; fi < array_length(filter_ids); fi++) {
    var fr = getFilterChipRect(fi);
    var active = (log_filter == filter_ids[fi]);
    var chipCol = active ? make_color_rgb(90, 120, 170) : make_color_rgb(35, 40, 55);
    var txtCol = active ? c_white : make_color_rgb(170, 175, 190);
    draw_set_alpha(1);
    draw_set_color(chipCol);
    draw_rectangle(fr[0], fr[1], fr[2], fr[3], false);
    draw_set_color(make_color_rgb(70, 80, 100));
    draw_rectangle(fr[0], fr[1], fr[2], fr[3], true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(txtCol);
    draw_text_transformed((fr[0] + fr[2]) * 0.5, (fr[1] + fr[3]) * 0.5, filter_labels[fi], fs, fs, 0);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var ly = py + log_top;

var displayLines = buildLogDisplayLines();
var totalDisplay = array_length(displayLines);
var scroll = variable_global_exists("duel_log_scroll") ? global.duel_log_scroll : 0;
var startDisp = max(0, totalDisplay - slots - scroll);
var endDisp = min(totalDisplay, startDisp + slots);

for (var di = startDisp; di < endDisp; di++) {
    var dline = displayLines[di];
    var kind = variable_struct_exists(dline, "kind") ? dline.kind : "";
    var lineTxt = dline.text;

    var col = make_color_rgb(220, 225, 235);
    switch (kind) {
        case "damage": col = make_color_rgb(255, 130, 110); break;
        case "heal": col = make_color_rgb(120, 230, 150); break;
        case "attack": col = make_color_rgb(255, 200, 100); break;
        case "destroy": col = make_color_rgb(200, 160, 255); break;
        case "play": col = make_color_rgb(140, 200, 255); break;
        case "phase": col = make_color_rgb(150, 160, 175); break;
        case "script": col = make_color_rgb(255, 200, 130); break;
        case "effect": col = make_color_rgb(180, 220, 255); break;
        case "draw": col = make_color_rgb(160, 200, 180); break;
    }

    draw_set_color(c_black);
    draw_text_transformed(px + pad + 1, ly + 1, lineTxt, ts, ts, 0);
    draw_set_color(col);
    draw_text_transformed(px + pad, ly, lineTxt, ts, ts, 0);
    ly += step;
}

if (totalDisplay == 0) {
    draw_set_color(make_color_rgb(130, 135, 150));
    var emptyMsg = (log_filter == "all") ? "…" : "(aucune entrée)";
    draw_text_transformed(px + pad, ly, emptyMsg, ts, ts, 0);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
