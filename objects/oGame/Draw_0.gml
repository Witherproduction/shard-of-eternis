var spr = asset_get_index("sDeckBuilder");
if (spr != -1) {
    var sw = sprite_get_width(spr);
    var sh = sprite_get_height(spr);
    var banner_h = 240 + 50;
    var scale_y = banner_h / max(1, sh);
    var scale_x = 0.5;
    var banner_x_center = 1650 + 80;
    var banner_y_center = 510;
    var panel_x = banner_x_center - (sw * scale_x * 0.5);
    var panel_y = banner_y_center - (banner_h * 0.5);
    draw_set_alpha(0.9);
    draw_sprite_ext(spr, 0, panel_x, panel_y, scale_x, scale_y, 0, c_white, 1);
    draw_set_alpha(1);
}
draw_set_font(fontStep);
var base_x = 1650 + 80;

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

draw_text_color(base_x, 414, turn_text, c_black, c_black, c_black, c_black, 1);
draw_set_color(turn_color);
draw_text(base_x, 410, turn_text);
draw_text_color(base_x, 514, phase[phase_current], c_black, c_black, c_black, c_black, 1);
draw_set_color(c_white);
draw_text(base_x, 510, phase[phase_current]);
draw_text_color(base_x, 614, "Tour " + string(nbTurn), c_black, c_black, c_black, c_black, 1);
draw_set_color(c_white);
draw_text(base_x, 610, "Tour " + string(nbTurn));

// --- MANA DISPLAY ---
// Dessiner le sprite sInfoMana pour le joueur
var spr_mana = asset_get_index("sInfoMana");

// Récupérer les positions des decks
var deck_hero_x = base_x; // Fallback
var deck_hero_y = 710 + 20;
var deck_enemy_x = base_x;
var deck_enemy_y = 810 + 20;
var decks_found = false;

if (instance_exists(oDeck)) {
    with (oDeck) {
        if (variable_instance_exists(id, "isHeroOwner")) {
            if (isHeroOwner) {
                deck_hero_x = x;
                deck_hero_y = y;
            } else {
                deck_enemy_x = x;
                deck_enemy_y = y;
            }
            decks_found = true;
        }
    }
}

if (spr_mana != -1) {
    var mana_scale = 0.75;
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
    draw_set_font(fontLP); 
    
    var mana_hero_str = string(global.mana_hero);
    var text_scale = 0.4; // Ajusté à 40%
    // Positionner dans la partie basse du sprite (vers le bas de l'écran pour le joueur)
    var text_y_offset = spr_h * 0.35; 

    // Ombre noire pour la lisibilité
    draw_text_transformed_color(mana_spr_x + 1, mana_spr_y + text_y_offset + 1, mana_hero_str, text_scale, text_scale, 0, c_black, c_black, c_black, c_black, 1);
    // Texte blanc
    draw_text_transformed_color(mana_spr_x, mana_spr_y + text_y_offset, mana_hero_str, text_scale, text_scale, 0, c_white, c_white, c_white, c_white, 1);
    
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
    draw_set_font(fontCardDisplay); 
    
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
