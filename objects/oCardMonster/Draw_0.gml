// === oCardMonster - Draw Event ===

// Hériter de l'affichage du parent (sprite de la carte)
event_inherited();

// Afficher les stats d'attaque et de défense seulement si la carte est sur le terrain
if (zone == "Field" || zone == "FieldSelected") {
    // Déterminer si on doit afficher les stats
    var should_show_stats = false;
    
    if (isHeroOwner) {
        // Côté héros : toujours afficher les stats
        should_show_stats = true;
    } else {
        // Côté adverse : afficher seulement si la carte est face découverte
        should_show_stats = !isFaceDown;
}

var __entrave_on = (variable_instance_exists(self, "entrave_turns_remaining") && entrave_turns_remaining > 0);
if (__entrave_on) {
    if (!(zone == "Field" || zone == "FieldSelected")) {
        // Dessiner les chaînes uniquement pour les cartes sur le terrain
    } else {
        var cw = sprite_get_width(sprite_index) * image_xscale;
        var ch = sprite_get_height(sprite_index) * image_yscale;
        var cx = x;
        var cy = y;
        var t = current_time / 1000.0;
        var pulse = 0.5 + 0.5 * (0.5 + 0.5 * sin(t * 6.283));
        var inset = 6 + 4 * (0.5 + 0.5 * sin(t * 3.1415));
        var spr_chain = asset_get_index("sChain");
        if (spr_chain != -1) {
            var chain_w = sprite_get_width(spr_chain);
            var orient = (variable_instance_exists(self, "orientation") ? string(orientation) : "Attack");
            var ang_off = (string_lower(orient) == "defense") ? 0 : 90;
            var x1a = cx - cw * 0.5 + inset;
            var y1a = cy - ch * 0.5 + inset;
            var x2a = cx + cw * 0.5 - inset;
            var y2a = cy + ch * 0.5 - inset;
            var x1b = cx + cw * 0.5 - inset;
            var y1b = cy - ch * 0.5 + inset;
            var x2b = cx - cw * 0.5 + inset;
            var y2b = cy + ch * 0.5 - inset;
            var L1 = point_distance(x1a, y1a, x2a, y2a);
            var L2 = point_distance(x1b, y1b, x2b, y2b);
            var a1 = point_direction(x1a, y1a, x2a, y2a) + ang_off;
            var a2 = point_direction(x1b, y1b, x2b, y2b) + ang_off;
            var mx1 = (x1a + x2a) * 0.5;
            var my1 = (y1a + y2a) * 0.5;
            var mx2 = (x1b + x2b) * 0.5;
            var my2 = (y1b + y2b) * 0.5;
            var scx1 = 1;
            var scx2 = 1;
            draw_set_alpha(0.6 + 0.4 * pulse);
            draw_sprite_ext(spr_chain, 0, mx1, my1, scx1, 1, a1, c_white, 1);
            draw_sprite_ext(spr_chain, 0, mx2, my2, scx2, 1, a2, c_white, 1);
            draw_set_alpha(1);
        }
    }
}

    // Camouflage: voile sombre + brume légère animée
    if (variable_instance_exists(self, "isCamouflage") && isCamouflage) {
        var cw_c = sprite_get_width(sprite_index) * image_xscale;
        var ch_c = sprite_get_height(sprite_index) * image_yscale;
        var x1_c = x - cw_c * 0.5;
        var y1_c = y - ch_c * 0.5;
        var x2_c = x + cw_c * 0.5;
        var y2_c = y + ch_c * 0.5;
        var sprOverlay = asset_get_index("sCamouflageOverlay");
        if (sprOverlay != -1) {
            var card_w = sprite_get_width(sprite_index);
            var card_h = sprite_get_height(sprite_index);
            var card_ox = sprite_get_xoffset(sprite_index);
            var card_oy = sprite_get_yoffset(sprite_index);
            var cx_off = (card_w * 0.5 - card_ox) * image_xscale;
            var cy_off = (card_h * 0.5 - card_oy) * image_yscale;
            var ang = image_angle;
            var rad = ang * pi / 180;
            var dx = cx_off * cos(rad) - cy_off * sin(rad);
            var dy = cx_off * sin(rad) + cy_off * cos(rad);
            var drawX = x + dx;
            var drawY = y + dy;
            var ow = sprite_get_width(sprOverlay);
            var oh = sprite_get_height(sprOverlay);
            var sx = cw_c / max(1, ow);
            var sy = ch_c / max(1, oh);
            draw_sprite_ext(sprOverlay, 0, drawX, drawY, sx, sy, ang, c_white, 0.5);
        } else {
            draw_set_alpha(0.5);
            draw_set_color(make_color_rgb(0, 0, 0));
            draw_rectangle(x1_c, y1_c, x2_c, y2_c, false);
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
        // Reset
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
    if (should_show_stats && variable_instance_exists(self, "attack") && variable_instance_exists(self, "defense")) {
        // Configuration du texte
        draw_set_font(fontCardDisplay);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Position des stats (en bas de la carte), avec rotation selon orientation
        var card_width = sprite_get_width(sprite_index) * image_xscale;
        var card_height = sprite_get_height(sprite_index) * image_yscale;

        var stats_y = y + (card_height / 2) + 6;
        var attack_x = x - (card_width / 4);
        var defense_x = x + (card_width / 4);
        stats_y = round(stats_y);
        attack_x = round(attack_x);
        defense_x = round(defense_x);

        // Ancien comportement: pas de rotation du texte
        
        // Déterminer les stats à afficher (effectives si disponibles)
        var dispAttack = (variable_instance_exists(self, "effective_attack") ? effective_attack : attack);
        var dispDefense = (variable_instance_exists(self, "effective_defense") ? effective_defense : defense);

        // Déterminer les couleurs selon variation (blanc = base, vert = augmenté, rouge = réduit)
        var baseAttack = attack;
        var baseDefense = defense;

        var attack_color = c_white;
        var defense_color = c_white;
        if (dispAttack > baseAttack) attack_color = c_green; else if (dispAttack < baseAttack) attack_color = c_red;
        if (dispDefense > baseDefense) defense_color = c_green; else if (dispDefense < baseDefense) defense_color = c_red;

        // Texte de l'attaque (blanc/vert/rouge)
        draw_set_color(attack_color);
        draw_text(attack_x, stats_y, string(dispAttack));

        // Texte de la défense (blanc/vert/rouge)
        draw_set_color(defense_color);
        draw_text(defense_x, stats_y, string(dispDefense));
        
        // Remettre les paramètres par défaut
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
