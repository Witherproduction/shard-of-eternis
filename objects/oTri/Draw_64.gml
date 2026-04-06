// === Barre de tri a cote du filtre ===

// Position et dimensions basées sur `sButton`
var baseW = sprite_get_width(sButton);
var baseH = sprite_get_height(sButton);
var barWidth = round(baseW * (570.0 / 300.0)) * 0.8;
var barHeight = round(baseH * (90.0 / 100.0)) * 0.8;
// Placer en haut, à la suite de la barre de filtre
var spacing = 50;
var barY = 40;
var barX = 40;
if (instance_exists(oCardViewer)) {
    with (oCardViewer) {
        barY = dropdown_y;
        barX = dropdown_x + dropdown_w + spacing;
    }
}

// Dessiner le fond de la barre avec le sprite sButton (étiré sur la largeur/hauteur)
draw_sprite_stretched(sButton, 0, barX, barY, barWidth, barHeight);

// Parametres des boutons
var numButtons = 7;
var pad = 18;
var buttonRadius = min(18, max(12, floor(barHeight * 0.33)));
var totalButtonsWidth = 0;
var buttonSpacing = 60;
var availableW = barWidth - pad * 2;
buttonSpacing = min(buttonSpacing, floor((availableW - 2 * buttonRadius) / 7));
if (buttonSpacing < buttonRadius * 2 + 6) {
    buttonSpacing = buttonRadius * 2 + 6;
    var need = 7 * buttonSpacing + 2 * buttonRadius;
    if (need > availableW) {
        var k = availableW / need;
        buttonRadius = max(10, floor(buttonRadius * k));
        buttonSpacing = max(22, floor(buttonSpacing * k));
    }
}
totalButtonsWidth = (7 * buttonSpacing) + (2 * buttonRadius);
var startX = barX + (barWidth - totalButtonsWidth) / 2 + buttonRadius;
var buttonY = barY + barHeight / 2;

// Couleurs (thème UI, comme les autres boutons)
var bubble_normal_color = make_color_rgb(60, 45, 25);    // marron foncé
var bubble_active_color = make_color_rgb(120, 90, 45);   // marron clair (état actif)
var border_color = make_color_rgb(230, 200, 120);        // crème dorée
var text_shadow_color = c_black;      // ombre portée
var text_main_color = make_color_rgb(230, 200, 120);     // texte crème dorée

// Dessiner les 7 boutons ronds (ajout du tri alphabétique)
var buttons = ["attack", "PV", "level", "type", "race", "rarity", "alpha"];

// Configurer le texte
var f = fontText;
if (variable_global_exists("get_runtime_font")) {
    var rf = global.get_runtime_font("text", 14);
    if (rf != -1) f = rf;
}
if (f != -1) draw_set_font(f);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var draw_star = function(_cx, _cy, _r) {
    var pts = [];
    for (var ii = 0; ii < 5; ii++) {
        var ang = -90 + ii * 72;
        array_push(pts, _cx + lengthdir_x(_r, ang));
        array_push(pts, _cy + lengthdir_y(_r, ang));
        ang = -90 + ii * 72 + 36;
        array_push(pts, _cx + lengthdir_x(_r * 0.45, ang));
        array_push(pts, _cy + lengthdir_y(_r * 0.45, ang));
    }
    for (var jj = 0; jj < array_length(pts); jj += 2) {
        var nx = pts[(jj + 2) mod array_length(pts)];
        var ny = pts[(jj + 3) mod array_length(pts)];
        draw_line(pts[jj], pts[jj + 1], nx, ny);
    }
};

for (var i = 0; i < 7; i++) {
    var buttonX = startX + (i * buttonSpacing);
    
    // Verifier si ce bouton est actif
    var isActive = (sort_active_button == i);
    
    var mode = buttons[i];
    var ir = buttonRadius - 6;
    var rx = buttonX;
    var ry = buttonY;
    var sx = buttonX + 2;
    var sy = buttonY + 2;
    var r = max(6, ir);
    
    if (mode != "attack") {
        // Dessiner le cercle du bouton (couleur differente si actif)
        draw_set_color(isActive ? bubble_active_color : bubble_normal_color);
        draw_circle(buttonX, buttonY, buttonRadius, false);
        
        // Dessiner la bordure
        draw_set_color(border_color);
        draw_circle(buttonX, buttonY, buttonRadius, true);
    }
    
    draw_set_color(text_shadow_color);
    switch (mode) {
        case "attack":
            var spr = sTribouton;
            var sw = sprite_get_width(spr);
            var sh = sprite_get_height(spr);
            var sc = (max(1, (buttonRadius * 2 + 2)) / max(sw, sh));
            draw_sprite_ext(spr, 0, sx, sy, sc, sc, 0, c_black, 1);
            break;
        case "PV":
            var hr = max(3, floor(r * 0.26));
            var hy = sy - floor(hr * 0.2);
            draw_circle(sx - hr, hy, hr, false);
            draw_circle(sx + hr, hy, hr, false);
            draw_triangle(sx - hr * 2, hy, sx + hr * 2, hy, sx, sy + hr * 2, false);
            break;
        case "level":
            var cr = max(4, floor(r * 0.45));
            var cx1 = sx;
            var cy1 = sy - 1;
            draw_triangle(cx1, cy1 - cr, cx1 - floor(cr * 0.65), cy1, cx1 + floor(cr * 0.65), cy1, false);
            draw_triangle(cx1, cy1 + cr, cx1 - floor(cr * 0.65), cy1, cx1 + floor(cr * 0.65), cy1, false);
            break;
        case "type":
            var er = max(3, floor(r * 0.28));
            var off = floor(r * 0.52);
            draw_triangle(sx, sy - off - er, sx - er, sy - off + er, sx + er, sy - off + er, false);
            draw_circle(sx + off, sy - 1, er, false);
            draw_triangle(sx + off, sy + er + 1, sx + off - er, sy, sx + off + er, sy, false);
            draw_rectangle(sx - er, sy + off - er, sx + er, sy + off + er, false);
            draw_line(sx - off - er, sy - 2, sx - off + er, sy - 2);
            draw_line(sx - off - er, sy + 2, sx - off + er, sy + 2);
            break;
        case "race":
            var pr = max(3, floor(r * 0.24));
            draw_circle(sx, sy - floor(r * 0.45), pr, false);
            draw_rectangle(sx - floor(r * 0.28), sy - floor(r * 0.15), sx + floor(r * 0.28), sy + floor(r * 0.35), false);
            draw_line(sx - floor(r * 0.55), sy, sx + floor(r * 0.55), sy);
            draw_line(sx - floor(r * 0.18), sy + floor(r * 0.35), sx - floor(r * 0.45), sy + floor(r * 0.75));
            draw_line(sx + floor(r * 0.18), sy + floor(r * 0.35), sx + floor(r * 0.45), sy + floor(r * 0.75));
            break;
        case "rarity":
            draw_star(sx, sy, r);
            break;
        case "alpha":
            var _txt = "A-Z";
            var maxW = buttonRadius * 2 - 6;
            var maxH = buttonRadius * 2 - 6;
            var tw = string_width(_txt);
            var th = string_height(_txt);
            var sc = 1;
            if (tw > 0) sc = min(sc, maxW / tw);
            if (th > 0) sc = min(sc, maxH / th);
            sc = min(1, sc);
            draw_text_transformed(sx, sy, _txt, sc, sc, 0);
            break;
    }
    if (mode != "alpha") {
        draw_set_color(text_main_color);
        switch (mode) {
            case "attack":
                var spr = sTribouton;
                var sw = sprite_get_width(spr);
                var sh = sprite_get_height(spr);
                var sc = (max(1, (buttonRadius * 2 + 2)) / max(sw, sh));
                draw_sprite_ext(spr, 0, rx, ry, sc, sc, 0, c_white, 1);
                break;
            case "PV":
                var hr = max(3, floor(r * 0.26));
                var hy = ry - floor(hr * 0.2);
                draw_circle(rx - hr, hy, hr, false);
                draw_circle(rx + hr, hy, hr, false);
                draw_triangle(rx - hr * 2, hy, rx + hr * 2, hy, rx, ry + hr * 2, false);
                break;
            case "level":
                draw_set_color(make_color_rgb(80, 160, 255));
                var cr = max(4, floor(r * 0.45));
                var cx1 = rx;
                var cy1 = ry - 1;
                draw_triangle(cx1, cy1 - cr, cx1 - floor(cr * 0.65), cy1, cx1 + floor(cr * 0.65), cy1, false);
                draw_triangle(cx1, cy1 + cr, cx1 - floor(cr * 0.65), cy1, cx1 + floor(cr * 0.65), cy1, false);
                break;
            case "type":
                var er = max(3, floor(r * 0.28));
                var off = floor(r * 0.52);
                draw_set_color(make_color_rgb(240, 90, 60));
                draw_triangle(rx, ry - off - er, rx - er, ry - off + er, rx + er, ry - off + er, false);
                draw_set_color(make_color_rgb(80, 160, 255));
                draw_circle(rx + off, ry - 1, er, false);
                draw_triangle(rx + off, ry + er + 1, rx + off - er, ry, rx + off + er, ry, false);
                draw_set_color(make_color_rgb(130, 190, 90));
                draw_rectangle(rx - er, ry + off - er, rx + er, ry + off + er, false);
                draw_set_color(make_color_rgb(220, 220, 220));
                draw_line(rx - off - er, ry - 2, rx - off + er, ry - 2);
                draw_line(rx - off - er, ry + 2, rx - off + er, ry + 2);
                break;
            case "race":
                var pr = max(3, floor(r * 0.24));
                draw_circle(rx, ry - floor(r * 0.45), pr, false);
                draw_rectangle(rx - floor(r * 0.28), ry - floor(r * 0.15), rx + floor(r * 0.28), ry + floor(r * 0.35), false);
                draw_line(rx - floor(r * 0.55), ry, rx + floor(r * 0.55), ry);
                draw_line(rx - floor(r * 0.18), ry + floor(r * 0.35), rx - floor(r * 0.45), ry + floor(r * 0.75));
                draw_line(rx + floor(r * 0.18), ry + floor(r * 0.35), rx + floor(r * 0.45), ry + floor(r * 0.75));
                break;
            case "rarity":
                draw_star(rx, ry, r);
                break;
        }
    }
}

// Dessiner le bouton d'inversion de tri
var invertButtonX = startX + (7 * buttonSpacing);
draw_set_color(bubble_normal_color);
draw_circle(invertButtonX, buttonY, buttonRadius, false);
draw_set_color(border_color);
draw_circle(invertButtonX, buttonY, buttonRadius, true);

// Dessiner le symbole d'inversion (flèche haut/bas)
if (global.sort_descending) {
    draw_set_color(text_shadow_color);
    draw_line(invertButtonX - 5 + 2, buttonY - 5 + 2, invertButtonX + 2, buttonY + 5 + 2);
    draw_line(invertButtonX + 5 + 2, buttonY - 5 + 2, invertButtonX + 2, buttonY + 5 + 2);
    draw_set_color(text_main_color);
    draw_line(invertButtonX - 5, buttonY - 5, invertButtonX, buttonY + 5);
    draw_line(invertButtonX + 5, buttonY - 5, invertButtonX, buttonY + 5);
} else {
    draw_set_color(text_shadow_color);
    draw_line(invertButtonX - 5 + 2, buttonY + 5 + 2, invertButtonX + 2, buttonY - 5 + 2);
    draw_line(invertButtonX + 5 + 2, buttonY + 5 + 2, invertButtonX + 2, buttonY - 5 + 2);
    draw_set_color(text_main_color);
    draw_line(invertButtonX - 5, buttonY + 5, invertButtonX, buttonY - 5);
    draw_line(invertButtonX + 5, buttonY + 5, invertButtonX, buttonY - 5);
}
// Remettre les parametres par defaut
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
