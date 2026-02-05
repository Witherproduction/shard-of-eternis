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
            var ang_off = 90; // Toujours vertical (Attack mode)
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

    // Camouflage handled in oCardParent now (Hearthstone style)
    
    // Stats (ATK/HP) handled in oCardParent now (Hearthstone style circles)
}
