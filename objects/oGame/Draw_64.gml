if (!is_undefined(animEffectDrawAll)) animEffectDrawAll();

// Note: L'affichage du mode ADMIN est désormais géré par oGlobalManager
// Ce code est commenté pour éviter les doublons
/*
if (variable_global_exists("admin_mode") && global.admin_mode) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_red);
    draw_set_font(fontTitle); // Utiliser une police existante
    draw_text(display_get_gui_width() - 10, display_get_gui_height() - 10, "ADMIN MODE ACTIVE");
    draw_set_color(c_white);
}
*/

// --- DESSIN DU PILE OU FACE (Overlay plein écran GUI) ---
if (variable_instance_exists(id, "coin_toss_active") && coin_toss_active) {
    // Fond semi-transparent sombre sur TOUT l'écran GUI
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
    
    // Position centrale
    var cx = gui_w / 2;
    var cy = gui_h / 2;
    var radius = 100;
    
    // Calcul de l'échelle X pour l'effet 3D de rotation
    var scale_x = dcos(coin_toss_angle);
    var is_front = (scale_x > 0);
    
    // Dessin de la pièce
    // Couleur : Or (Front/Pile) ou Argent (Back/Face)
    var coin_color = is_front ? make_color_rgb(255, 215, 0) : make_color_rgb(192, 192, 192);
    var text_color = is_front ? c_black : c_black;
    var label = is_front ? "PILE" : "FACE";
    
    // Ombre (ellipse décalée)
    draw_set_color(c_dkgray);
    draw_ellipse(cx - radius * abs(scale_x), cy - radius + 10, cx + radius * abs(scale_x), cy + radius + 10, false);
    
    // Corps de la pièce
    draw_set_color(coin_color);
    draw_ellipse(cx - radius * abs(scale_x), cy - radius, cx + radius * abs(scale_x), cy + radius, false);
    
    // Contour
    draw_set_color(make_color_rgb(100, 80, 0));
    draw_ellipse(cx - radius * abs(scale_x), cy - radius, cx + radius * abs(scale_x), cy + radius, true);
    draw_ellipse(cx - radius * abs(scale_x) * 0.8, cy - radius * 0.8, cx + radius * abs(scale_x) * 0.8, cy + radius * 0.8, true);
    
    // Texte sur la pièce (si visible)
    if (abs(scale_x) > 0.3) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(text_color);
        // On étire le texte avec la pièce
        draw_text_transformed(cx, cy, label, abs(scale_x), 1, 0);
    }
    
    // Texte de résultat (Phase 2)
    if (coin_toss_phase == 2) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        
        if (font_exists(fontTitle)) draw_set_font(fontTitle);
        else draw_set_font(fontUI);
        
        var res_text = coin_toss_is_heads ? "VOUS COMMENCEZ !" : "L'ADVERSAIRE COMMENCE";
        var res_col = coin_toss_is_heads ? c_lime : c_red;
        
        var text_scale = (draw_get_font() == fontUI) ? 2.0 : 1.0;
        
        draw_text_transformed_color(cx, cy + 150, res_text, text_scale, text_scale, 0, res_col, res_col, res_col, res_col, 1);
        
        draw_set_font(fontUI);
    } else {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(cx, cy - 150, "QUI COMMENCE ?");
    }
    
    // Reset
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

if (!(variable_instance_exists(id, "coin_toss_active") && coin_toss_active)) {
    var deckHeroInst = noone;
    var deckEnemyInst = noone;
    var _deck_n = instance_number(oDeck);
    for (var _i = 0; _i < _deck_n; _i++) {
        var _d = instance_find(oDeck, _i);
        if (_d != noone && variable_instance_exists(_d, "isHeroOwner")) {
            if (_d.isHeroOwner) deckHeroInst = _d;
            else deckEnemyInst = _d;
        }
    }

    var mx_gui = device_mouse_x_to_gui(0);
    var my_gui = device_mouse_y_to_gui(0);

    var is_mouse_over_inst = function(inst, mx, my) {
        if (inst == noone || !instance_exists(inst)) return false;
        var spr = inst.sprite_index;
        if (spr == -1) return false;
        var sx = inst.image_xscale;
        var sy = inst.image_yscale;
        var pad = 10;
        var left = inst.x - sprite_get_xoffset(spr) * sx - pad;
        var top = inst.y - sprite_get_yoffset(spr) * sy - pad;
        var right = left + sprite_get_width(spr) * sx + pad * 2;
        var bottom = top + sprite_get_height(spr) * sy + pad * 2;
        var x1 = min(left, right);
        var y1 = min(top, bottom);
        var x2 = max(left, right);
        var y2 = max(top, bottom);
        return point_in_rectangle(mx, my, x1, y1, x2, y2);
    };

    var draw_deck_tooltip = function(isHero, mx, my, deckHeroInst, deckEnemyInst) {
        var dInst = isHero ? deckHeroInst : deckEnemyInst;
        if (dInst == noone || !instance_exists(dInst)) return;

        var deckCount = 0;
        if (variable_instance_exists(dInst, "cards") && ds_exists(dInst.cards, ds_type_list)) {
            deckCount = ds_list_size(dInst.cards);
        }

        var hInst = isHero ? handHero : handEnemy;
        var handCount = 0;
        if (instance_exists(hInst) && variable_instance_exists(hInst, "cards") && ds_exists(hInst.cards, ds_type_list)) {
            handCount = ds_list_size(hInst.cards);
        }

        var title = isHero ? "Joueur" : "Adversaire";
        var lines = "Deck : " + string(deckCount) + "\nMain : " + string(handCount);

        var pad = 12;
        var w = 200;
        var textScale = 0.9;
        var sep = string_height("Ag");
        var max_w = (w - pad * 2) / textScale;
        var th = string_height(title) * textScale + 6;
        var lh = string_height_ext(lines, sep, max_w) * textScale;
        var h = pad * 2 + th + lh + 4;

        var gui_w = display_get_gui_width();
        var gui_h = display_get_gui_height();
        var x1 = mx + 18;
        var y1 = my - h - 10;
        x1 = max(10, min(x1, gui_w - w - 10));
        y1 = max(10, min(y1, gui_h - h - 10));
        var x2 = x1 + w;
        var y2 = y1 + h;

        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(20, 20, 20));
        draw_rectangle(x1, y1, x2, y2, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(x1, y1, x2, y2, true);

        if (font_exists(fontTitle)) draw_set_font(fontTitle);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text_transformed(x1 + pad, y1 + pad, title, textScale, textScale, 0);
        draw_set_color(c_white);
        draw_text_ext_transformed(x1 + pad, y1 + pad + th, lines, sep, max_w, textScale, textScale, 0);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    };

    if (is_mouse_over_inst(deckHeroInst, mx_gui, my_gui)) {
        draw_deck_tooltip(true, mx_gui, my_gui, deckHeroInst, deckEnemyInst);
    } else if (is_mouse_over_inst(deckEnemyInst, mx_gui, my_gui)) {
        draw_deck_tooltip(false, mx_gui, my_gui, deckHeroInst, deckEnemyInst);
    }
}
