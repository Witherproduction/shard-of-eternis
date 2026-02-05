// oHeroPower - Draw Event

var frame_scale = 0.5; // 50% scale
radius = (150 * frame_scale) / 2; // Update radius based on sprite size (150px)

// Interaction Mouse
var mx = mouse_x;
var my = mouse_y;
hover = point_distance(mx, my, x, y) <= radius;

if (hover && mouse_check_button_pressed(mb_left)) {
    if (isHeroOwner && canActivate()) {
        activate();
    }
}

// Determine Tint Color
var tintColor = c_white;
if (canActivate()) {
    tintColor = c_white;
    if (hover) tintColor = merge_color(c_white, c_ltgray, 0.2);
} else {
    tintColor = hasUsedThisTurn ? c_dkgray : c_gray;
    // Optionnel: Teinter en rouge si pas assez de mana ?
    // if (!hasUsedThisTurn) tintColor = c_red; // Peut être trop agressif pour tout le sprite
}

// 1. Draw Hero Power Sprite (Background/Frame)
// On suppose que le sprite est le fond du bouton
draw_sprite_ext(sHeroPower, 0, x, y, frame_scale, frame_scale, 0, tintColor, 1);

// 2. Icone (Supprimé sur demande utilisateur)
// Le sprite sHeroPower est suffisant

// 3. Highlight Border (Optional, based on state)
if (canActivate()) {
    // Ajouter une lueur ou bordure verte/bleue si actif ?
    // Pour l'instant on se fie au sprite
    if (hover) {
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(sHeroPower, 0, x, y, frame_scale, frame_scale, 0, c_white, 0.3);
        gpu_set_blendmode(bm_normal);
    }
} else if (!hasUsedThisTurn) {
    // Pas assez de mana -> Croix ou sombre ?
}

// Coût en Mana (Petit cercle en bas)
var cost = variable_struct_exists(powerData, "mana_cost") ? powerData.mana_cost : 0;
var costX = x;
var costY = y + radius * 0.8; // Positionné vers le bas

draw_set_color(c_aqua);
draw_circle(costX, costY, 8, false);
draw_set_color(c_black);
draw_circle(costX, costY, 8, true);

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(costX, costY, string(cost), 0.5, 0.5, 0);

// Timer Tooltip
if (hover) {
    hoverTimer++;
} else {
    hoverTimer = 0;
}

// Tooltip au survol (avec délai)
if (hover && hoverTimer >= HOVER_THRESHOLD) {
    var tipX = x + radius + 10;
    var tipY = y;
    if (!isHeroOwner) { tipX = x - radius - 210; } // Afficher à gauche pour l'ennemi
    
    var tipW = 200;
    var tipH = 80;
    
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(tipX, tipY - tipH/2, tipX + tipW, tipY + tipH/2, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(tipX, tipY - tipH/2, tipX + tipW, tipY + tipH/2, true);
    
    var name = variable_struct_exists(powerData, "name") ? powerData.name : "Pouvoir";
    var desc = variable_struct_exists(powerData, "description") ? powerData.description : "";
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(tipX + 5, tipY - tipH/2 + 5, name);
    draw_text_ext_transformed(tipX + 5, tipY - tipH/2 + 25, desc, 12, tipW - 10, 0.8, 0.8, 0);
}
