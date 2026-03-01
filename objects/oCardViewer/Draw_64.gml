// === oCardViewer - Draw GUI Event ===

// Affiche les boutons uniquement dans la room rCollection
if (room == rCollection) {
    // --- Menu déroulant filtre booster ---
    draw_set_font(fontCardDisplay);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var drop_x = dropdown_x;
    var drop_y = dropdown_y;
    var drop_w = dropdown_w;
    var drop_h = dropdown_h;
    
    // Cadre
    var current_label = dropdown_items[dropdown_selected_index];
    var label_text = "Booster: " + current_label;
    var pad_btn = 18;
    draw_sprite_stretched(sButton, 0, drop_x, drop_y, drop_w, drop_h);
    var textScale = 0.85;
    var text_main_color = make_color_rgb(230, 200, 120);
    draw_set_color(text_main_color);
    draw_text_transformed(drop_x + pad_btn, drop_y + drop_h/2, label_text, textScale, textScale, 0);
    
    // Flèche
    var ax = drop_x + drop_w - 16;
    var ay = drop_y + drop_h/2;
    draw_triangle(ax - 6, ay - 3, ax + 6, ay - 3, ax, ay + 5, false);
    
    // Liste déroulante
    if (dropdown_open) {
        var item_h = drop_h;
        var list_h = array_length(dropdown_items) * item_h;
        var list_x1 = drop_x;
        var list_y1 = drop_y + drop_h + 2;
        var list_x2 = drop_x + drop_w;
        var list_y2 = list_y1 + list_h;
        draw_sprite_stretched(sButton, 0, list_x1, list_y1, (list_x2 - list_x1), (list_y2 - list_y1));
        
        for (var i = 0; i < array_length(dropdown_items); i++) {
            var iy = list_y1 + i * item_h;
            // séparateurs
            draw_set_color(c_gray);
            draw_line(list_x1 + 2, iy, list_x2 - 2, iy);
            draw_set_color(c_white);
            draw_text(list_x1 + 8, iy + item_h/2, dropdown_items[i]);
        }
    }

    // --- Pagination: flèches et label Page X centrés sous les cartes ---
    var grid_center_x = startX + ((cardsPerRow - 1) * cardSpacing) / 2; // centre horizontal de la grille
    var btn_w = 28;
    var btn_h = drop_h;
    var gui_h = display_get_gui_height();
    var last_row_y = startY + (maxRows - 1) * cardSpacingVertical; // position de la dernière ligne
    var page_y = min(last_row_y + cardSpacingVertical - 20, gui_h - btn_h - 20); // bien sous les cartes

    var left_x1 = grid_center_x - 100 - btn_w;
    var left_y1 = page_y;
    var left_x2 = left_x1 + btn_w;
    var left_y2 = left_y1 + btn_h;
    var right_x1 = grid_center_x + 100;
    var right_y1 = page_y;
    var right_x2 = right_x1 + btn_w;
    var right_y2 = right_y1 + btn_h;

    // Bouton gauche
    draw_set_color(c_dkgray);
    draw_rectangle(left_x1, left_y1, left_x2, left_y2, false);
    draw_set_color(c_black);
    draw_rectangle(left_x1, left_y1, left_x2, left_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text((left_x1 + left_x2)/2, (left_y1 + left_y2)/2, "<");

    // Bouton droit
    draw_set_color(c_dkgray);
    draw_rectangle(right_x1, right_y1, right_x2, right_y2, false);
    draw_set_color(c_black);
    draw_rectangle(right_x1, right_y1, right_x2, right_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text((right_x1 + right_x2)/2, (right_y1 + right_y2)/2, ">");

    // Label Page X au centre
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(grid_center_x, page_y + btn_h/2, "Page " + string(currentPage));
    draw_set_halign(fa_left);

    draw_set_font(fontCardDisplay);
    var inv_label = "Invocation";
    var inv_pad = 18;
    var inv_extra = 60;
    var inv_w = max(220, string_width(inv_label) + inv_pad * 2) + inv_extra;
    var inv_h = drop_h;
    var gui_w = display_get_gui_width();
    var inv_x1 = (gui_w * 0.5) - (inv_w * 0.5);
    var inv_y1 = drop_y;
    if (instance_exists(oRetour1)) {
        var ret = instance_find(oRetour1, 0);
        inv_y1 = ret.y; 
    }

    if (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode) {
        // Mode Invocation actif : Bouton vert
        draw_set_color(c_green);
        draw_sprite_stretched(sButton, 0, inv_x1, inv_y1, inv_w, inv_h);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(inv_x1 + inv_w/2, inv_y1 + inv_h/2, "Invocation Active");
        draw_set_halign(fa_left);
    } else {
        // Bouton normal
        draw_sprite_stretched(sButton, 0, inv_x1, inv_y1, inv_w, inv_h);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(inv_x1 + inv_w/2, inv_y1 + inv_h/2, "Mode Invocation");
        draw_set_halign(fa_left);
    }
}

// Animation Feedback Convoquer (sprite sSpecialSummon)
if (variable_instance_exists(id, "summonAnimState") && summonAnimState > 0) {
    var _alpha = 1;
    var _scale = 1;

    // Calculer l'état
    if (summonAnimState == 1) { // Zoom In
        var _progress = 1 - (summonAnimTimer / summonAnimDurationIn);
        _scale = _progress; // Zoom de 0 à 1
        _alpha = _progress; // Fade In
    } else if (summonAnimState == 2) { // Hold
        _scale = 1;
        _alpha = 1;
    } else if (summonAnimState == 3) { // Zoom Out
        var _progress = summonAnimTimer / summonAnimDurationOut;
        _scale = _progress; // Zoom de 1 à 0
        _alpha = _progress; // Fade Out
    }

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = (_gw / 2) - 300; // Décalé à gauche
    var _cy = _gh / 2;
    
    var _spr = asset_get_index("sSpecialSummon");
    if (_spr != -1) {
        draw_sprite_ext(_spr, 0, _cx, _cy, _scale, _scale, 0, c_white, _alpha);
    } else {
        // Fallback si le sprite n'existe pas : cadre rouge
        draw_set_alpha(_alpha);
        draw_set_color(c_red);
        var _w = 400 * _scale; 
        var _h = 300 * _scale;
        var _th = 5;
        if (_w > 0 && _h > 0) {
            for(var i=0; i<_th; i++) {
                draw_rectangle(_cx - _w/2 - i, _cy - _h/2 - i, _cx + _w/2 + i, _cy + _h/2 + i, true);
            }
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    // Afficher la carte convoquée en Zoom In pendant le Hold
    if (summonAnimState == 2 && variable_instance_exists(id, "summonAnimCard") && is_struct(summonAnimCard)) {
        // Progression du Zoom In de la carte pendant le Hold (sur 2s)
        var _cardProgress = 1 - (summonAnimTimer / summonAnimDurationHold);
        
        // Echelle: 0 à 0.5
        var _cardScale = _cardProgress * 0.5; 
        var _cardAlpha = _cardProgress; // Fade In de 0 à 1
        
        // La carte sort du portail (_cx, _cy) et va vers sa position finale (_gw/2 + 100, _gh/2)
        var _startX = _cx;
        var _startY = _cy;
        var _endX = _gw / 2 + 100;
        var _endY = _gh / 2;
        
        var _currentX = lerp(_startX, _endX, _cardProgress);
        var _currentY = lerp(_startY, _endY, _cardProgress);
        
        if (summonAnimCard.sprite != -1) {
            draw_sprite_ext(summonAnimCard.sprite, summonAnimCard.image, _currentX, _currentY, _cardScale, _cardScale, 0, c_white, _cardAlpha);
        }
    }
}
