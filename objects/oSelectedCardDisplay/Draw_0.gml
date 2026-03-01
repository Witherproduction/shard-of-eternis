var card = noone;
if (variable_instance_exists(self, "selected")) {
    var sel = selected;
    // Aucune sélection: "" ou noone
    if (sel == "" || sel == noone) {
        // show_debug_message("### oSelectedCardDisplay.Draw - aucune sélection"); // désactivé pour éviter le spam
        exit;
    }
    // Accepter les références d'instance (type "ref") et ids numériques
    if (is_undefined(sel) || sel == noone) {
        // show_debug_message("### oSelectedCardDisplay.Draw - sélection undefined/noone, type=" + string(typeof(sel)) + ", valeur=" + string(sel));
        exit;
    }
    if (instance_exists(sel)) {
        card = sel;
        // show_debug_message("### oSelectedCardDisplay.Draw - carte sélectionnée id=" + string(card) + ", type=" + string(typeof(sel)));
    } else {
        // show_debug_message("### oSelectedCardDisplay.Draw - l'instance sélectionnée n'existe plus, type=" + string(typeof(sel)) + ", valeur=" + string(sel));
        exit;
    }
} else {
    // show_debug_message("### oSelectedCardDisplay.Draw - variable 'selected' absente sur l'instance");
    exit;
}
    // Initialisation du scroll pour la description
    if (!variable_instance_exists(self, "textScrollY")) textScrollY = 0;
    if (!variable_instance_exists(self, "scrollSpeed")) scrollSpeed = 20;
    if (!variable_instance_exists(self, "prev_card")) prev_card = noone;
    if (prev_card != card) {
        textScrollY = 0;
        prev_card = card;
    }

    var draw_x = 150;
    var draw_y = 250;
    // Échelle du viewer en duel (revenue à 0.50 comme demandé)
    var scale = 0.50;
    // Échelle relative par rapport à la référence de la collection (0.6)
    var rel = scale / 0.6;

    // Taille réelle du sprite affiché
    var sprite_w = sprite_get_width(card.sprite_index) * scale;
    var sprite_h = sprite_get_height(card.sprite_index) * scale;

    // Bord bas de la carte (pour positionner le texte en-dessous)
    var image_bottom = draw_y + sprite_h * 0.5;

    // --- Position du texte et du cadre ---
    // Utilisation du style "Carte" comme dans la collection
    var tlx = draw_x - sprite_w * 0.5;
    var tly = draw_y - sprite_h * 0.5;
    var s = scale;
    var rel = scale / 0.6; // Ratio par rapport à la collection

    // Fond semi-transparent derrière la carte
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(tlx - 10, tly - 10, tlx + sprite_w + 10, tly + sprite_h + 10, false);
    draw_set_alpha(1);

    // Affichage de la carte
    draw_sprite_ext(card.sprite_index, card.image_index, draw_x, draw_y, s, s, 0, c_white, 1);

    // --- Bordure de rareté ---
    if (variable_instance_exists(card, "rarity")) {
        var rarity_color = getRarityColor(card.rarity);
        var glow_intensity = getRarityGlowIntensity(card.rarity);
        
        if (glow_intensity > 0) {
            draw_set_color(rarity_color);
            draw_set_alpha(glow_intensity);
            var border_thickness = 4;
            for (var i = 1; i <= border_thickness; i++) {
                draw_rectangle(tlx - i, tly - i, tlx + sprite_w + i, tly + sprite_h + i, true);
            }
            draw_set_alpha(1);
            draw_set_color(c_black);
        }
    }

    // --- TEXTE SUR LA CARTE (Layout Global) ---
    var layout = global.card_layout;
    var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
    var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
    var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
    var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
    var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
    var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
    
    // Description (via Layout Global)
    var desc_x1  = layout.description.x1, desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;

    // --- DEBUG FRAMES ---
    if (variable_global_exists("show_green_frames") && global.show_green_frames) {
        var active_field = (variable_global_exists("debug_selected_field")) ? global.debug_selected_field : "";
        
        var draw_debug_rect = function(f_name, x1, y1, x2, y2, tlx, tly, s, active_f) {
            if (f_name == active_f) {
                draw_set_color(c_red);
                draw_set_alpha(0.6);
            } else {
                draw_set_color(c_lime);
                draw_set_alpha(0.3);
            }
            draw_rectangle(tlx + x1 * s, tly + y1 * s, tlx + x2 * s, tly + y2 * s, false);
            draw_set_alpha(1);
            draw_rectangle(tlx + x1 * s, tly + y1 * s, tlx + x2 * s, tly + y2 * s, true);
        };
        
        draw_debug_rect("name", name_x1, name_y1, name_x2, name_y2, tlx, tly, s, active_field);
        draw_debug_rect("mana", star_x1, star_y1, star_x2, star_y2, tlx, tly, s, active_field);
        draw_debug_rect("genre", genre_x1, genre_y1, genre_x2, genre_y2, tlx, tly, s, active_field);
        draw_debug_rect("race", arch_x1, arch_y1, arch_x2, arch_y2, tlx, tly, s, active_field);
        draw_debug_rect("description", desc_x1, desc_y1, desc_x2, desc_y2, tlx, tly, s, active_field);
        draw_debug_rect("atk", atk_x1, atk_y1, atk_x2, atk_y2, tlx, tly, s, active_field);
        draw_debug_rect("hp", def_x1, def_y1, def_x2, def_y2, tlx, tly, s, active_field);
        
        draw_set_color(c_black);
    }

    if (font_exists(fontCardText)) draw_set_font(fontCardText);
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var fit_line = function(text, max_px, rw, rh) {
        var base_line_h = string_height("Ag");
        var w0 = string_width(text);
        var h0 = base_line_h;
        var s_max = (h0 > 0) ? max_px / h0 : 1;
        var s_w = (w0 > 0) ? rw / w0 : s_max;
        var s_h = (h0 > 0) ? rh / h0 : s_max;
        return min(s_max, s_w, s_h);
    };

    var pad = 0;
    var mar = 7;

    // --- NOM ---
    var display_name = "";
    if (variable_instance_exists(card, "name") && string_length(string_trim(card.name)) > 0) display_name = card.name;
    else display_name = object_get_name(card.object_index);
    
    var tx = string(display_name);
    var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
    var rh = (name_y2 - name_y1) * s - pad * 2;
    var sc = fit_line(tx, 20 * rel, rw, rh);
    sc = round(sc * 20) / 20;
    draw_text_transformed(round(tlx + name_x1 * s + pad + mar), round(tly + name_y1 * s + pad + 2), tx, sc, sc, 0);

    // --- COUT MANA ---
    var manaVal = (variable_instance_exists(card, "mana_cost")) ? card.mana_cost : 0;
    // Si mana est 0 mais défini, on l'affiche (ou pas ? oCardParent l'affiche si > 0 ou défini)
    if (manaVal > 0 || variable_instance_exists(card, "mana_cost")) {
        // Cercle bleu (optionnel, retiré selon demande précédente mais présent dans le layout)
        // Texte
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var rw_m = (star_x2 - star_x1) * s;
        var rh_m = (star_y2 - star_y1) * s;
        var cx_m = tlx + (star_x1 + (star_x2-star_x1)/2) * s;
        var cy_m = tly + (star_y1 + (star_y2-star_y1)/2) * s;
        var sc_m = fit_line(string(manaVal), 22 * rel, rw_m, rh_m);
        sc_m = round(sc_m * 20) / 20;
        draw_text_transformed(round(cx_m), round(cy_m), string(manaVal), sc_m, sc_m, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // --- GENRE ---
    if (variable_instance_exists(card, "genre") && string_length(string_trim(card.genre)) > 0) {
        var tx_g = string(card.genre);
        // Si la race est incluse dans le genre (format "Genre - Race"), on la retire pour l'affichage propre
        if (variable_instance_exists(card, "race") && string_length(card.race) > 0) {
            var split = string_split(tx_g, " - ");
            if (array_length(split) > 0) {
                tx_g = split[0];
            }
        }
        var rw_g = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
        var rh_g = (genre_y2 - genre_y1) * s - pad * 2;
        var sc_g = fit_line(tx_g, 16 * rel, rw_g, rh_g);
        sc_g = round(sc_g * 20) / 20;
        draw_text_transformed(round(tlx + genre_x1 * s + pad + mar), round(tly + genre_y1 * s + pad + 2), tx_g, sc_g, sc_g, 0);
    }

    // --- RACE (formerly ARCHETYPE) ---
    if (variable_instance_exists(card, "race") && string_length(string_trim(card.race)) > 0) {
        var tx_a = string(card.race);
        var rw_a = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
        var rh_a = (arch_y2 - arch_y1) * s - pad * 2;
        var sc_a = fit_line(tx_a, 16 * rel, rw_a, rh_a);
        sc_a = round(sc_a * 20) / 20;
        draw_text_transformed(round(tlx + arch_x1 * s + pad + mar), round(tly + arch_y1 * s + pad + 2), tx_a, sc_a, sc_a, 0);
    }

    // --- STATS (ATK/HP) ---
    var is_magic = object_is_ancestor(card.object_index, oCardMagic) || (variable_instance_exists(card, "type") && string_lower(string(card.type)) == "magic");
    if (!is_magic) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        // ATK
        var atkVal = (variable_instance_exists(card, "attack")) ? card.attack : 0;
        var origA = (variable_instance_exists(card, "original_attack")) ? card.original_attack : atkVal;
        var colA = c_lime; // Always Green per user request
        
        var cx_a = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s;
        var cy_a = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
        
        var sc_atk = 1.2 * rel;
        // Outline
        var o_dist = 2 * rel;
        draw_set_color(c_black);
        draw_text_transformed(round(cx_a - o_dist), round(cy_a), string(atkVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_a + o_dist), round(cy_a), string(atkVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_a), round(cy_a - o_dist), string(atkVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_a), round(cy_a + o_dist), string(atkVal), sc_atk, sc_atk, 0);
        
        draw_set_color(colA);
        draw_text_transformed(round(cx_a), round(cy_a), string(atkVal), sc_atk, sc_atk, 0);

        // HP
        var hpVal = (variable_instance_exists(card, "current_hp")) ? card.current_hp : ((variable_instance_exists(card, "PV")) ? card.PV : 0);
        var hpMax = (variable_instance_exists(card, "max_hp")) ? card.max_hp : hpVal;
        var origPV = (variable_instance_exists(card, "original_PV")) ? card.original_PV : hpMax;
        
        var hpColor = c_lime; // Always Green per user request
        
        var cx_h = tlx + (def_x1 + (def_x2-def_x1)/2) * s;
        var cy_h = tly + (def_y1 + (def_y2-def_y1)/2) * s;
        
        var o_dist = 2 * rel;
        draw_set_color(c_black);
        draw_text_transformed(round(cx_h - o_dist), round(cy_h), string(hpVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_h + o_dist), round(cy_h), string(hpVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_h), round(cy_h - o_dist), string(hpVal), sc_atk, sc_atk, 0);
        draw_text_transformed(round(cx_h), round(cy_h + o_dist), string(hpVal), sc_atk, sc_atk, 0);
        
        draw_set_color(hpColor);
        draw_text_transformed(round(cx_h), round(cy_h), string(hpVal), sc_atk, sc_atk, 0);
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_black);
    }

    // --- DESCRIPTION COMPLETE (Keywords + Rareté + Texte) ---
    var full_desc = "";
    
    // Keywords
    var keywords = "";
    if (variable_instance_exists(card, "has_taunt") && card.has_taunt) keywords += "[Provocation] ";
    if (variable_instance_exists(card, "isCamouflage") && card.isCamouflage) keywords += "[Furtif] ";
    if (variable_instance_exists(card, "charge") && card.charge) keywords += "[Charge] ";
    if (keywords != "") full_desc += keywords + "\n";
    
    // Rareté
    if (variable_instance_exists(card, "rarity")) {
        full_desc += "Rareté: " + string(card.rarity) + "\n";
    }

    // Description texte
    if (variable_instance_exists(card, "description")) {
        full_desc += string(card.description);
    }

    // Affichage Description avec Scroll
    var rw_d = (desc_x2 - desc_x1) * s;
    var rh_d = (desc_y2 - desc_y1) * s;
    var dx = tlx + desc_x1 * s;
    var dy = tly + desc_y1 * s;

    // Calcul du wrapping et scroll
    // On utilise une méthode simplifiée: draw_text_ext dans une surface ou clipping
    // Mais pour rester simple sans surface:
    var sep = string_height("Ag");
    var w_eff = rw_d; // Largeur effective
    // Scale du texte description (on garde 1.0 ou adapté)
    var desc_scale = fit_line("A", 20 * rel, 100, 100); // Juste pour avoir une taille de base ~20px
    desc_scale = min(desc_scale, 1.0); // Pas trop gros
    
    // NOTE: Pour le scroll, on réutilise textScrollY
    // On doit dessiner le texte décalé et couper ce qui dépasse
    // GameMaker draw_text_ext ne supporte pas le clipping natif simple sans surface/shader
    // On va afficher tout le texte pour l'instant, ou utiliser un algo simple
    
    draw_text_ext_transformed(dx, dy - textScrollY, full_desc, sep, w_eff / desc_scale, desc_scale, desc_scale, 0);
    
    // Logique de scroll (souris)
    var total_h = string_height_ext(full_desc, sep, w_eff / desc_scale) * desc_scale;
    var maxScrollY = max(0, total_h - rh_d);
    
    var mx = mouse_x;
    var my = mouse_y;
    if (mx >= dx && mx <= dx + rw_d && my >= dy && my <= dy + rh_d) {
        if (mouse_wheel_down()) textScrollY = min(textScrollY + scrollSpeed, maxScrollY);
        if (mouse_wheel_up())   textScrollY = max(textScrollY - scrollSpeed, 0);
    } else {
        // Reset scroll si pas hover ? Non, on garde la position
    }

    // --- Affiche la carte en grand (après pour qu’elle soit toujours visible) ---
    if (card.isFaceDown && card.isHeroOwner) {
        draw_sprite_ext(card.sprite_index, 0, draw_x, draw_y, scale, scale, 0, c_white, 1);
    } else {
        draw_sprite_ext(card.sprite_index, card.image_index, draw_x, draw_y, scale, scale, 0, c_white, 1);
    }

    // --- Overlay texte sur la carte (zones précises, aligné Collection) ---
    {
        var spr = card.sprite_index;
        // Utiliser la même échelle que la carte pour l'overlay texte
        var s = scale;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx = draw_x - cw * 0.5;
        var tly = draw_y - ch * 0.5;

        // Détection carte magique pour masquer coût et ATK/PV
        var is_magic = object_is_ancestor(card.object_index, oCardMagic) || (variable_instance_exists(card, "type") && string_lower(string(card.type)) == "magic");

        // Coordonnées des zones (référence scale 1.0) - Utilisation du Layout Global
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        var desc_x1  = layout.description.x1, desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
        var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
        var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;

        // Police et couleur
        if (font_exists(fontCardText)) draw_set_font(fontCardText);
        draw_set_color(c_black);

        // Helpers d’échelle
        var fit_line = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var w0 = string_width(text);
            var h0 = base_line_h;
            var s_max = (h0 > 0) ? max_px / h0 : 1;
            var s_w = (w0 > 0) ? rw / w0 : s_max;
            var s_h = (h0 > 0) ? rh / h0 : s_max;
            return min(s_max, s_w, s_h);
        };

        var fit_block = function(text, max_px, rw, rh) {
            var base_line_h = string_height("Ag");
            var s = (base_line_h > 0) ? max_px / base_line_h : 1;
            for (var it = 0; it < 3; it++) {
                var sep = base_line_h;               // séparation à l'échelle 1
                var w_eff = (s > 0) ? (rw / s) : rw; // largeur efficace à scale 1
                var h = string_height_ext(text, sep, w_eff);
                if (h <= 0) break;
                var s_h = rh / h;                    // cible: h*s <= rh
                s = min(s, s_h);
            }
            return s;
        };

        var pad = 0;

        // NAME (centré verticalement dans sa zone, avec décalage +2px)
        if (variable_instance_exists(card, "name")) {
            var tx = string(card.name);
            var mar = 7;
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 20, rw, rh);
            scale_tx = round(scale_tx * 20) / 20;
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            var base_line_h = string_height("Ag");
            var hsc = base_line_h * scale_tx;
            left = round(left);
            var cy = top + max(0, (rh - hsc) * 0.5) + 2;
            cy = round(cy);
            draw_text_transformed(left, cy, tx, scale_tx, scale_tx, 0);
        }

        // mana_cost (coût)
        if (variable_instance_exists(card, "mana_cost")) {
            var tx = string(card.mana_cost);
            var rw = (star_x2 - star_x1) * s - pad * 2;
            var rh = (star_y2 - star_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 20, rw, rh);
            scale_tx = round(scale_tx * 20) / 20;
            var left = tlx + star_x1 * s + pad;
            var top  = tly + star_y1 * s + pad;
            var wsc  = string_width(tx) * scale_tx;
            var cx   = left + max(0, (rw - wsc) * 0.5);
            cx = round(cx);
            top = round(top);
            draw_text_transformed(cx, top + 2, tx, scale_tx, scale_tx, 0);
        }

        // GENRE
        if (variable_instance_exists(card, "genre")) {
            var tx = string(card.genre);
            
            var mar = 7;
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 16, rw, rh);
            scale_tx = round(scale_tx * 20) / 20;
            var gx = tlx + genre_x1 * s + pad + mar;
            var gy = tly + genre_y1 * s + pad;
            gx = round(gx);
            gy = round(gy);
            draw_text_transformed(gx, gy + 2, tx, scale_tx, scale_tx, 0);
        }

        // RACE (formerly ARCHETYPE location)
        if (variable_instance_exists(card, "race")) {
            var tx = string(card.race);
            var mar = 7;
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 16, rw, rh);
            scale_tx = round(scale_tx * 20) / 20;
            var ax = tlx + arch_x1 * s + pad + mar;
            var ay = tly + arch_y1 * s + pad;
            ax = round(ax);
            ay = round(ay);
            draw_text_transformed(ax, ay + 2, tx, scale_tx, scale_tx, 0);
        }

        // DESCRIPTION (wrap natif, mêmes réglages que Collection)
        if (variable_instance_exists(card, "description")) {
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var tx = string(card.description);
            var mar = 7;
            var rw = (desc_x2 - desc_x1) * s - pad * 2 - mar * 2;
            var rh = (desc_y2 - desc_y1) * s - pad * 2;
            var left = tlx + desc_x1 * s + pad + mar;
            var top  = tly + desc_y1 * s + pad;
            var base_h = string_height("Ag");
            var sc0 = (base_h > 0) ? 20 / base_h : 1;
            var sc = sc0;
            for (var ii = 0; ii < 8; ii++) {
                var w_pre = (sc > 0) ? (rw / sc) : rw;
                var h_un = string_height_ext(tx, base_h, w_pre);
                var h_sc = h_un * sc;
                if (h_sc <= rh) break;
                var k = rh / max(1, h_sc);
                sc *= max(0.6, min(0.95, k));
                sc = min(sc, sc0);
            }
            sc = round(sc * 20) / 20;
            left = round(left);
            top  = round(top);
            var w_eff = round(rw / sc);
            draw_text_ext_transformed(left, top + 2, tx, base_h, w_eff, sc, sc, 0);
        }

        // ATK
        if (!is_magic && variable_instance_exists(card, "attack")) {
            var atkVal = card.attack;
            var origA = (variable_instance_exists(card, "original_attack")) ? card.original_attack : atkVal;
            var colA = c_lime; // Always Green per user request
            var tx = string(atkVal);
            
            // Centered alignment
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var scale_tx = 1.2 * rel;
            
            var cx = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s;
            var cy = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
            cx = round(cx);
            cy = round(cy);
            
            // Outline
            var o_dist = 2 * rel;
            draw_set_color(c_black);
            draw_text_transformed(cx - o_dist, cy, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx + o_dist, cy, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx, cy - o_dist, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx, cy + o_dist, tx, scale_tx, scale_tx, 0);
            
            draw_set_color(colA);
            draw_text_transformed(cx, cy, tx, scale_tx, scale_tx, 0);
            
            // Reset alignment
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }

        // PV
        if (!is_magic && variable_instance_exists(card, "PV")) {
            var hpVal = (variable_instance_exists(card, "current_hp")) ? card.current_hp : card.PV;
            var hpMax = (variable_instance_exists(card, "max_hp")) ? card.max_hp : hpVal;
            var origPV = (variable_instance_exists(card, "original_PV")) ? card.original_PV : hpMax;
            
            var hpColor = c_lime; // Always Green per user request
            var tx = string(hpVal);
            
            // Centered alignment
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var scale_tx = 1.2 * rel;
            
            var cx = tlx + (def_x1 + (def_x2-def_x1)/2) * s;
            var cy = tly + (def_y1 + (def_y2-def_y1)/2) * s;
            cx = round(cx);
            cy = round(cy);
            
            // Outline
            var o_dist = 2 * rel;
            draw_set_color(c_black);
            draw_text_transformed(cx - o_dist, cy, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx + o_dist, cy, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx, cy - o_dist, tx, scale_tx, scale_tx, 0);
            draw_text_transformed(cx, cy + o_dist, tx, scale_tx, scale_tx, 0);
            
            draw_set_color(hpColor);
            draw_text_transformed(cx, cy, tx, scale_tx, scale_tx, 0);
            
            // Reset alignment
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }

    // === Panneau latéral droit pour les effets ===
    var side_width = 320;
    var side_x1 = draw_x + sprite_w * 0.5 + 20;
    var side_y1 = draw_y - sprite_h * 0.5;
    var side_x2 = side_x1 + side_width;
    var side_y2 = draw_y + sprite_h * 0.5;

    // Clamp pour rester dans l'écran
    if (side_x2 > room_width - 10) {
        side_x2 = room_width - 10;
        side_x1 = side_x2 - side_width;
    }
    if (side_x1 < 10) {
        side_x1 = 10;
        side_x2 = side_x1 + side_width;
    }
    if (side_y1 < 10) side_y1 = 10;
    if (side_y2 > room_height - 10) side_y2 = room_height - 10;

    draw_set_font(fontCardDisplay);
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var eff_x = side_x1 + 10;
    var eff_y = side_y1 + 10;

    // Bloc 2 (rDuel) avec la même logique d'affichage que rCollection, mais à droite
    var has_named_effect = false;
    var named_index = -1;
    var selected_label = "";
    // Détection poison passif via flag isPoisoner
    if (variable_instance_exists(card, "isPoisoner") && card.isPoisoner) {
        has_named_effect = true;
        named_index = -1;
        selected_label = "poison";
    }
    if (!has_named_effect && variable_instance_exists(card, "effects") && is_array(card.effects) && array_length(card.effects) > 0) {
        var fr_labels2 = array_create(12);
        fr_labels2[0] = "Eveil"; fr_labels2[1] = "Eveil spécialisé"; fr_labels2[2] = "rupture";
        fr_labels2[3] = "brisé"; fr_labels2[4] = "Aube"; fr_labels2[5] = "Crépuscule"; fr_labels2[6] = "défenseur"; fr_labels2[7] = "poison"; fr_labels2[8] = "protecteur"; fr_labels2[9] = "Protecteur"; fr_labels2[10] = "attaque"; fr_labels2[11] = "post-attaque";
        for (var e = 0; e < array_length(card.effects); e++) {
            var effn = card.effects[e];
            var lbl2 = getEffectLabel(effn);
            var ok2 = false;
            for (var w2 = 0; w2 < array_length(fr_labels2); w2++) {
                if (lbl2 == fr_labels2[w2]) { ok2 = true; break; }
            }
            if (ok2) {
                has_named_effect = true;
                named_index = e;
                selected_label = lbl2;
                break;
            }
        }
    }

    if (has_named_effect) {
        var line_height = string_height("Ag");
        // Construire la phrase: "<label> = ..." selon le trigger du premier effet correspondant
        var label = selected_label;
        var desc_text = label + " = ";
        if (named_index >= 0 && variable_instance_exists(card, "effects") && is_array(card.effects) && named_index < array_length(card.effects)) {
            var effd = card.effects[named_index];
            if (variable_instance_exists(effd, "trigger")) {
                desc_text += getTriggerDetailedDescription(effd.trigger);
            } else {
                desc_text += "activation manuelle";
            }
        } else {
            // Poison passif: description générique
            desc_text += "effet passif en combat";
        }
    
        // Dimensions: même logique de largeur que rCollection, adaptées au panneau droit
        var desc_width = max(100, floor(min(sprite_w, max(200, side_width - 20)) * 0.5));
        var wrap_width = desc_width; // largeur de retour à la ligne
        
        // Préparer les lignes pour connaître la hauteur
        var words = string_split(desc_text, " ");
        var current_line = "";
        var desc_lines2 = array_create(0);
        for (var j2 = 0; j2 < array_length(words); j2++) {
            var try_line2 = current_line + words[j2] + " ";
            if (string_width(try_line2) > wrap_width && string_length(current_line) > 0) {
                array_push(desc_lines2, string_trim(current_line));
                current_line = words[j2] + " ";
            } else {
                current_line = try_line2;
            }
        }
        if (string_length(current_line) > 0) {
            array_push(desc_lines2, string_trim(current_line));
        }
        
        // Cadre autour du bloc 2 (même style que rCollection)
        var frame_pad2 = 5;
        var rect2_x1 = eff_x - frame_pad2;
        var rect2_y1 = eff_y - frame_pad2;
        var rect2_x2 = eff_x + wrap_width + frame_pad2;
        var rect2_y2 = eff_y + array_length(desc_lines2) * line_height + frame_pad2;
        draw_set_alpha(0.8);
        draw_set_color(c_black);
        draw_rectangle(rect2_x1, rect2_y1, rect2_x2, rect2_y2, false);
        draw_set_alpha(1);
        draw_set_color(c_black);
        
        // Affichage des lignes
        for (var i2 = 0; i2 < array_length(desc_lines2); i2++) {
            draw_text(eff_x, eff_y + i2 * line_height, desc_lines2[i2]);
        }
    } else {
        draw_set_color(c_gray);
        draw_text(eff_x, eff_y, "Aucun effet");
        draw_set_color(c_black);
    }

    // --- Bloc 1: infos principales (nom, niveau, genre, archetype) ---
    // var right_panel_x = x + 260; // panneau à droite
    // var panel_margin = 12;
    // var line_height = 20;
    // var info_y = y - 120; // zone info sous le titre
    // 
    // var info_lines = array_create(0);
    // array_push(info_lines, "Nom: " + string(card.name));
    // if (variable_instance_exists(card, "mana_cost")) {
    //     array_push(info_lines, "Niveau: " + string(card.mana_cost));
    // }
    // if (variable_instance_exists(card, "genre") && string_length(string_trim(card.genre)) > 0) {
    //     array_push(info_lines, "Genre: " + string(card.genre));
    // }
    // if (variable_instance_exists(card, "archetype") && string_length(string_trim(card.archetype)) > 0) {
    //     array_push(info_lines, "Archetype: " + string(card.archetype));
    // }
    // 
    // // Affichage des infos
    // for (var i = 0; i < array_length(info_lines); i++) {
    //     draw_text(right_panel_x + panel_margin, info_y + i * line_height, info_lines[i]);
    // }
    
    // --- Bloc 2: description rapprochée de la carte --- (désactivé)
    // Supprimé pour éviter le cadre long à droite

