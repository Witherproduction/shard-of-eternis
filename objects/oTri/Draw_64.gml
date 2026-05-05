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
    
    draw_set_color(isActive ? bubble_active_color : bubble_normal_color);
    draw_circle(buttonX, buttonY, buttonRadius, false);
    draw_set_color(border_color);
    draw_circle(buttonX, buttonY, buttonRadius, true);
    
    var icon_frame = -1;
    switch (mode) {
        case "attack": icon_frame = 0; break;
        case "PV": icon_frame = 1; break;
        case "level": icon_frame = 2; break;
        case "type": icon_frame = 3; break;
        case "race": icon_frame = 4; break;
        case "rarity": icon_frame = 5; break;
        case "alpha": icon_frame = 6; break;
    }
    
    var spr = sTribouton;
    var sw = sprite_get_width(spr);
    var sh = sprite_get_height(spr);
    var sc = (max(1, (buttonRadius * 2 + 2)) / max(sw, sh));
    draw_sprite_ext(spr, icon_frame, sx, sy, sc, sc, 0, c_black, 1);
    draw_sprite_ext(spr, icon_frame, rx, ry, sc, sc, 0, c_white, 1);
}

// Dessiner le bouton d'inversion de tri
var invertButtonX = startX + (7 * buttonSpacing);
draw_set_color(bubble_normal_color);
draw_circle(invertButtonX, buttonY, buttonRadius, false);
draw_set_color(border_color);
draw_circle(invertButtonX, buttonY, buttonRadius, true);

var spr_inv = sTribouton;
var sw_inv = sprite_get_width(spr_inv);
var sh_inv = sprite_get_height(spr_inv);
var sc_inv = (max(1, (buttonRadius * 2 + 2)) / max(sw_inv, sh_inv));
draw_sprite_ext(spr_inv, 7, invertButtonX + 2, buttonY + 2, sc_inv, sc_inv, 0, c_black, 1);
draw_sprite_ext(spr_inv, 7, invertButtonX, buttonY, sc_inv, sc_inv, 0, c_white, 1);
// Remettre les parametres par defaut
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
