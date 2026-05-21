var spr = asset_get_index("sDeckBuilder");
var banner_h = 240 + 50;
var scale_x = 0.5;
var banner_x_center = 1650 + 80;
var banner_y_center = 510;

var panel_x = banner_x_center - 150;
var panel_y = banner_y_center - (banner_h * 0.5);
var panel_w = 300;
var panel_h = banner_h;

if (spr != -1) {
    var sw = sprite_get_width(spr);
    var sh = sprite_get_height(spr);
    var scale_y = banner_h / max(1, sh);
    panel_w = sw * scale_x;
    panel_h = banner_h;
    panel_x = banner_x_center - (panel_w * 0.5);
    panel_y = banner_y_center - (banner_h * 0.5);
    draw_set_alpha(0.9);
    draw_sprite_ext(spr, 0, panel_x, panel_y, scale_x, scale_y, 0, c_white, 1);
    draw_set_alpha(1);
}

var draw_fit_center_shadow = function(cx, cy, tx, kind, px, min_px, max_w, max_h, col) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (variable_global_exists("get_runtime_font")) {
        var sz = max(min_px, floor(px));
        var f = global.get_runtime_font(kind, sz);
        while (sz > min_px && f != -1) {
            draw_set_font(f);
            if (string_width(tx) <= max_w && string_height("Ag") <= max_h) break;
            sz -= 1;
            f = global.get_runtime_font(kind, sz);
        }
        if (f != -1) draw_set_font(f);
        draw_set_color(c_black);
        draw_text(cx + 2, cy + 2, tx);
        draw_set_color(col);
        draw_text(cx, cy, tx);
    } else {
        if (kind == "title") {
            if (font_exists(fontUI)) draw_set_font(fontUI);
        } else {
            if (font_exists(fontUI)) draw_set_font(fontUI);
        }
        var sw0 = string_width(tx);
        var sh0 = string_height("Ag");
        var sc = 1;
        if (sw0 > 0) sc = min(sc, max_w / sw0);
        if (sh0 > 0) sc = min(sc, max_h / sh0);
        sc = min(1, sc);
        draw_set_color(c_black);
        draw_text_transformed(cx + 2, cy + 2, tx, sc, sc, 0);
        draw_set_color(col);
        draw_text_transformed(cx, cy, tx, sc, sc, 0);
    }
};

draw_set_font(fontUI);
var base_x = banner_x_center;

// Determine turn text and color
var turn_text = player[player_current];
var turn_color = c_white;

if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
    if (is_local_turn) {
        turn_text = "VOTRE TOUR";
        turn_color = c_lime;
    } else {
        turn_text = "TOUR ADVERSE";
        turn_color = c_red;
    }
} else {
    // Single player translation
    if (player[player_current] == "Hero") {
         turn_text = "TOUR JOUEUR";
         turn_color = c_white;
    } else {
         turn_text = "TOUR ENNEMI";
         turn_color = c_white;
    }
}

var inner_pad = 20;
var max_w = max(1, panel_w - inner_pad * 2);
var max_h_line = 52;
var y1 = panel_y + panel_h * 0.155;
var y2 = panel_y + panel_h * 0.500;
var y3 = panel_y + panel_h * 0.845;
draw_fit_center_shadow(banner_x_center, y1, turn_text, "title", 30, 12, max_w, max_h_line, turn_color);
draw_fit_center_shadow(banner_x_center, y2, string(phase[phase_current]), "title", 26, 12, max_w, max_h_line, c_white);
draw_fit_center_shadow(banner_x_center, y3, "Tour " + string(nbTurn), "title", 26, 12, max_w, max_h_line, c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// --- MANA DISPLAY ---
// Dessiner le sprite sInfoMana pour le joueur
var spr_mana = asset_get_index("sInfoMana");

// Récupérer les positions des decks
var deck_hero_x = base_x; // Fallback
var deck_hero_y = 710 + 20;
var deck_enemy_x = base_x;
var deck_enemy_y = 810 + 20;
var decks_found = false;

var _deck_n = instance_number(oDeck);
for (var _i = 0; _i < _deck_n; _i++) {
    var _d = instance_find(oDeck, _i);
    if (_d != noone && variable_instance_exists(_d, "isHeroOwner")) {
        if (_d.isHeroOwner) {
            deck_hero_x = _d.x;
            deck_hero_y = _d.y;
        } else {
            deck_enemy_x = _d.x;
            deck_enemy_y = _d.y;
        }
        decks_found = true;
    }
}

if (spr_mana != -1) {
    var mana_scale = 0.525;
    var spr_w = sprite_get_width(spr_mana) * mana_scale;
    var spr_h = sprite_get_height(spr_mana) * mana_scale;
    // Estimation de la demi-largeur d'un deck + demi-largeur mana + marge augmentée (+20px par rapport à avant)
    var offset_x = spr_w * 0.5 + 100; 

    // --- JOUEUR ---
    // Placer à DROITE du deck du joueur
    // Décalage vertical : 40px plus HAUT (-40)
    var mana_spr_x = decks_found ? (deck_hero_x + offset_x) : base_x;
    var mana_spr_y = decks_found ? (deck_hero_y - 40) : (710 + 20); 
    
    // Dessiner le sprite pour le joueur (scale 0.75)
    draw_sprite_ext(spr_mana, 0, mana_spr_x, mana_spr_y, mana_scale, mana_scale, 0, c_white, 1);
    
    // Afficher le mana actuel du joueur
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fontLife); 
    
    var mana_hero_str = string(global.mana_hero);
    var text_scale = 0.28;
    // Positionner dans la partie basse du sprite (vers le bas de l'écran pour le joueur)
    var text_y_offset = spr_h * 0.35; 

    // Ombre noire pour la lisibilité
    draw_text_transformed_color(mana_spr_x + 1, mana_spr_y + text_y_offset + 1, mana_hero_str, text_scale, text_scale, 0, c_black, c_black, c_black, c_black, 1);
    // Texte blanc
    draw_text_transformed_color(mana_spr_x, mana_spr_y + text_y_offset, mana_hero_str, text_scale, text_scale, 0, c_white, c_white, c_white, c_white, 1);

    // Indicateur bonus mana Vespera (duel Kelthazar)
    if (variable_instance_exists(id, "vespera_mana_boost_active") && vespera_mana_boost_active) {
        var boostLabel = "Don de la reine";
        var boostScale = 0.12;
        var boostY = mana_spr_y + spr_h * 0.55;
        draw_set_font(fontUI);
        draw_text_transformed_color(mana_spr_x + 1, boostY + 1, boostLabel, boostScale, boostScale, 0, c_black, c_black, c_black, c_black, 1);
        draw_text_transformed_color(mana_spr_x, boostY, boostLabel, boostScale, boostScale, 0, c_lime, c_lime, c_lime, c_lime, 1);
    }
    
    // --- ADVERSAIRE ---
    // Placer à GAUCHE du deck de l'adversaire
    // Décalage vertical : 40px plus BAS (+40)
    var enemy_mana_x = decks_found ? (deck_enemy_x - offset_x) : base_x;
    var enemy_mana_y = decks_found ? (deck_enemy_y + 40) : (810 + 20);
    
    // Rotation 180 degrés pour l'adversaire
    draw_sprite_ext(spr_mana, 0, enemy_mana_x, enemy_mana_y, mana_scale, mana_scale, 180, c_white, 1);
    
    // Afficher le mana actuel de l'adversaire
    var mana_enemy_str = string(global.mana_enemy);
    // Pour l'adversaire (rotation 180), la "partie basse" du sprite est visuellement en HAUT de l'écran
    // On applique l'offset inverse pour le placer au "fond" de la fiole inversée
    var enemy_text_y_offset = -text_y_offset;

    // Ombre noire
    draw_text_transformed_color(enemy_mana_x + 1, enemy_mana_y + enemy_text_y_offset + 1, mana_enemy_str, text_scale, text_scale, 0, c_black, c_black, c_black, c_black, 1);
    // Texte blanc
    draw_text_transformed_color(enemy_mana_x, enemy_mana_y + enemy_text_y_offset, mana_enemy_str, text_scale, text_scale, 0, c_white, c_white, c_white, c_white, 1);

    // Reset align
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fontUI); 
    
} else {
    // Fallback si le sprite n'existe pas
    var mana_text = "Mana: " + string(global.mana_hero) + "/" + string(global.mana_max_hero);
    draw_text_color(base_x, 714, mana_text, c_black, c_black, c_black, c_black, 1);
    draw_set_color(c_aqua); // Bleu cyan pour le mana
    draw_text(base_x, 710, mana_text);
    
    // Fallback Enemy
    var enemy_mana_text = "En. Mana: " + string(global.mana_enemy) + "/" + string(global.mana_max_enemy);
    draw_text_color(base_x, 814, enemy_mana_text, c_black, c_black, c_black, c_black, 1);
    draw_set_color(c_red); 
    draw_text(base_x, 810, enemy_mana_text);
    draw_set_color(c_white);
}

// Enemy Mana Text (Supprimé car remplacé par le sprite ou désactivé)
/*
var enemy_mana_text = "En. Mana: " + string(global.mana_enemy) + "/" + string(global.mana_max_enemy);
draw_text_color(base_x, 814, enemy_mana_text, c_black, c_black, c_black, c_black, 1);
draw_set_color(c_red); 
draw_text(base_x, 810, enemy_mana_text);
draw_set_color(c_white);
*/

// --- DESSIN DU PILE OU FACE (Déplacé dans Draw GUI) ---
if (variable_instance_exists(id, "coin_toss_active") && coin_toss_active) {
    // Le rendu est maintenant géré dans l'événement Draw GUI (Draw_64)
    // pour garantir un centrage parfait et une couverture plein écran.
}
