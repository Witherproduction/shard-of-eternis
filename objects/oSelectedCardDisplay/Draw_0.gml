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

    gpu_set_texfilter(false);
    if (font_exists(fontText)) draw_set_font(fontText);
    else if (font_exists(fontTitle)) draw_set_font(fontTitle);
    else if (font_exists(fontUI)) draw_set_font(fontUI);
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
    
    var base_title_size = 16;
    if (font_exists(fontTitle)) base_title_size = font_get_size(fontTitle);
    var base_text_size = 14;
    if (font_exists(fontText)) base_text_size = font_get_size(fontText);
    var get_font = function(kind, size) {
        if (variable_global_exists("get_runtime_font")) return global.get_runtime_font(kind, size);
        if (kind == "title") {
            if (font_exists(fontTitle)) return fontTitle;
            if (font_exists(fontText)) return fontText;
            if (font_exists(fontUI)) return fontUI;
        } else {
            if (font_exists(fontText)) return fontText;
            if (font_exists(fontTitle)) return fontTitle;
            if (font_exists(fontUI)) return fontUI;
        }
        return -1;
    };

    // --- NOM ---
    var display_name = "";
    if (variable_instance_exists(card, "name") && string_length(string_trim(card.name)) > 0) display_name = card.name;
    else display_name = object_get_name(card.object_index);
    
    if (font_exists(fontTitle)) draw_set_font(fontTitle);
    else if (font_exists(fontText)) draw_set_font(fontText);
    else if (font_exists(fontUI)) draw_set_font(fontUI);
    var tx = string(display_name);
    var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
    var rh = (name_y2 - name_y1) * s - pad * 2;
    var sc = fit_line(tx, 20 * rel, rw, rh);
    var want_px = base_title_size * sc;
    var want_size = max(8, floor(want_px));
    var f = get_font("title", want_size);
    if (f != -1) draw_set_font(f);
    var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
    draw_text_transformed(round(tlx + name_x1 * s + pad + mar), round(tly + name_y1 * s + pad + 2), tx, sc2, sc2, 0);
    if (font_exists(fontText)) draw_set_font(fontText);
    else if (font_exists(fontTitle)) draw_set_font(fontTitle);
    else if (font_exists(fontUI)) draw_set_font(fontUI);

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
        var want_px = base_title_size * sc_m;
        var want_size = max(8, floor(want_px));
        var f = get_font("title", want_size);
        if (f != -1) draw_set_font(f);
        var sc2 = (want_size > 0) ? (want_px / want_size) : sc_m;
        draw_text_transformed(round(cx_m), round(cy_m), string(manaVal), sc2, sc2, 0);
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
        var want_px = base_text_size * sc_g;
        var want_size = max(8, floor(want_px));
        var f = get_font("text", want_size);
        if (f != -1) draw_set_font(f);
        var sc2 = (want_size > 0) ? (want_px / want_size) : sc_g;
        draw_text_transformed(round(tlx + genre_x1 * s + pad + mar), round(tly + genre_y1 * s + pad + 2), tx_g, sc2, sc2, 0);
    }

    // --- RACE (formerly ARCHETYPE) ---
    if (variable_instance_exists(card, "race") && string_length(string_trim(card.race)) > 0) {
        var tx_a = string(card.race);
        var rw_a = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
        var rh_a = (arch_y2 - arch_y1) * s - pad * 2;
        var sc_a = fit_line(tx_a, 16 * rel, rw_a, rh_a);
        var want_px = base_text_size * sc_a;
        var want_size = max(8, floor(want_px));
        var f = get_font("text", want_size);
        if (f != -1) draw_set_font(f);
        var sc2 = (want_size > 0) ? (want_px / want_size) : sc_a;
        draw_text_transformed(round(tlx + arch_x1 * s + pad + mar), round(tly + arch_y1 * s + pad + 2), tx_a, sc2, sc2, 0);
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
        
        var want_px = base_title_size * (1.2 * rel);
        var want_size = max(8, floor(want_px));
        var f = get_font("title", want_size);
        if (f != -1) draw_set_font(f);
        var sc_atk = (want_size > 0) ? (want_px / want_size) : (1.2 * rel);
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
    if (font_exists(fontText)) draw_set_font(fontText);
    var want_px = 20 * rel;
    var want_size = max(6, floor(want_px));
    var f = get_font("text", want_size);
    if (f != -1) draw_set_font(f);
    var desc_scale = (want_size > 0) ? (want_px / want_size) : 1;
    desc_scale = min(desc_scale, 1.0);

    var base_h = string_height("Ag");
    var line_h = base_h * desc_scale;
    var space_w = string_width(" ") * desc_scale;
    var max_w = rw_d;

    var lines = [];
    var paragraphs = string_split(full_desc, "\n");
    for (var p_i = 0; p_i < array_length(paragraphs); p_i++) {
        var para = string_trim(paragraphs[p_i]);
        if (string_length(para) <= 0) {
            array_push(lines, "");
            continue;
        }
        var words = string_split(para, " ");
        var wi = 0;
        while (wi < array_length(words)) {
            var line = "";
            var line_w = 0;
            while (wi < array_length(words)) {
                var w = words[wi];
                if (string_length(w) <= 0) { wi += 1; continue; }
                var ww = string_width(w) * desc_scale;
                var plus_space = (line == "") ? 0 : space_w;
                if (line == "" || (line_w + plus_space + ww) <= max_w) {
                    line = (line == "") ? w : (line + " " + w);
                    line_w += plus_space + ww;
                    wi += 1;
                } else {
                    break;
                }
            }
            array_push(lines, line);
        }
    }
    
    // Logique de scroll (souris)
    var total_h = array_length(lines) * line_h;
    var maxScrollY = max(0, total_h - rh_d);
    
    var mx = mouse_x;
    var my = mouse_y;
    if (mx >= dx && mx <= dx + rw_d && my >= dy && my <= dy + rh_d) {
        if (mouse_wheel_down()) textScrollY = min(textScrollY + scrollSpeed, maxScrollY);
        if (mouse_wheel_up())   textScrollY = max(textScrollY - scrollSpeed, 0);
    } else {
        // Reset scroll si pas hover ? Non, on garde la position
    }
    textScrollY = clamp(textScrollY, 0, maxScrollY);

    var dxr = round(dx);
    var dyr = round(dy);
    var start_line = (line_h > 0) ? floor(textScrollY / line_h) : 0;
    start_line = clamp(start_line, 0, max(0, array_length(lines) - 1));
    var ty = dy + (start_line * line_h) - textScrollY;
    for (var li = start_line; li < array_length(lines); li++) {
        if (ty > dy + rh_d) break;
        if (ty + line_h >= dy) {
            draw_text_transformed(dxr, round(ty) + 2, lines[li], desc_scale, desc_scale, 0);
        }
        ty += line_h;
    }

    gpu_set_texfilter(true);

    // --- Affiche la carte en grand (après pour qu’elle soit toujours visible) ---
    if (card.isFaceDown && card.isHeroOwner) {
        draw_sprite_ext(card.sprite_index, 0, draw_x, draw_y, scale, scale, 0, c_white, 1);
    } else {
        draw_sprite_ext(card.sprite_index, card.image_index, draw_x, draw_y, scale, scale, 0, c_white, 1);
    }

    // --- Overlay texte sur la carte (zones précises, aligné Collection) ---
    {
        gpu_set_texfilter(false);
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
        if (font_exists(fontText)) draw_set_font(fontText);
        else if (font_exists(fontTitle)) draw_set_font(fontTitle);
        else if (font_exists(fontUI)) draw_set_font(fontUI);
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
        
        var base_title_size = 16;
        if (font_exists(fontTitle)) base_title_size = font_get_size(fontTitle);
        var base_text_size = 14;
        if (font_exists(fontText)) base_text_size = font_get_size(fontText);
        var get_font = function(kind, size) {
            if (variable_global_exists("get_runtime_font")) return global.get_runtime_font(kind, size);
            if (kind == "title") {
                if (font_exists(fontTitle)) return fontTitle;
                if (font_exists(fontText)) return fontText;
                if (font_exists(fontUI)) return fontUI;
            } else {
                if (font_exists(fontText)) return fontText;
                if (font_exists(fontTitle)) return fontTitle;
                if (font_exists(fontUI)) return fontUI;
            }
            return -1;
        };

        // NAME (centré verticalement dans sa zone, avec décalage +2px)
        if (variable_instance_exists(card, "name")) {
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
            var tx = string(card.name);
            var mar = 7;
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 20, rw, rh);
            var want_px = base_title_size * scale_tx;
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : scale_tx;
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            var base_line_h = string_height("Ag");
            var hsc = base_line_h * sc2;
            left = round(left);
            var cy = top + max(0, (rh - hsc) * 0.5) + 2;
            cy = round(cy);
            draw_text_transformed(left, cy, tx, sc2, sc2, 0);
            if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
        }

        // mana_cost (coût)
        if (variable_instance_exists(card, "mana_cost")) {
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
            var tx = string(card.mana_cost);
            var rw = (star_x2 - star_x1) * s - pad * 2;
            var rh = (star_y2 - star_y1) * s - pad * 2;
            var scale_tx = fit_line(tx, 20, rw, rh);
            var want_px = base_title_size * scale_tx;
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : scale_tx;
            var left = tlx + star_x1 * s + pad;
            var top  = tly + star_y1 * s + pad;
            var wsc  = string_width(tx) * sc2;
            var cx   = left + max(0, (rw - wsc) * 0.5);
            cx = round(cx);
            top = round(top);
            draw_text_transformed(cx, top + 2, tx, sc2, sc2, 0);
            if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        // GENRE
        if (variable_instance_exists(card, "genre")) {
            var tx = string_trim(string(card.genre));
            if (string_length(tx) <= 0) { tx = ""; }
            
            var mar = 7;
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            
            if (tx != "") {
                if (font_exists(fontText)) draw_set_font(fontText);
                else if (font_exists(fontTitle)) draw_set_font(fontTitle);
                else if (font_exists(fontUI)) draw_set_font(fontUI);
                
                var scale_tx = fit_line(tx, 16 * rel, rw, rh);
                var want_px = base_text_size * scale_tx;
                var want_size = max(6, floor(want_px));
                var f = get_font("text", want_size);
                if (f != -1) draw_set_font(f);
                var sc2 = (want_size > 0) ? (want_px / want_size) : scale_tx;
                
                var gx = tlx + genre_x1 * s + pad + mar;
                var gy = tly + genre_y1 * s + pad;
                gx = round(gx);
                gy = round(gy);
                var hsc = string_height("Ag") * sc2;
                var cy = gy + max(0, (rh - hsc) * 0.5) + 2;
                cy = round(cy);
                draw_text_transformed(gx, cy, tx, sc2, sc2, 0);
            }
        }

        // RACE (formerly ARCHETYPE location)
        if (variable_instance_exists(card, "race")) {
            var tx = string_trim(string(card.race));
            if (string_length(tx) <= 0) { tx = ""; }
            var mar = 7;
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            
            if (tx != "") {
                if (font_exists(fontText)) draw_set_font(fontText);
                else if (font_exists(fontTitle)) draw_set_font(fontTitle);
                else if (font_exists(fontUI)) draw_set_font(fontUI);
                
                var scale_tx = fit_line(tx, 16 * rel, rw, rh);
                var want_px = base_text_size * scale_tx;
                var want_size = max(6, floor(want_px));
                var f = get_font("text", want_size);
                if (f != -1) draw_set_font(f);
                var sc2 = (want_size > 0) ? (want_px / want_size) : scale_tx;
                
                var ax = tlx + arch_x1 * s + pad + mar;
                var ay = tly + arch_y1 * s + pad;
                ax = round(ax);
                ay = round(ay);
                var hsc = string_height("Ag") * sc2;
                var cy = ay + max(0, (rh - hsc) * 0.5) + 2;
                cy = round(cy);
                draw_text_transformed(ax, cy, tx, sc2, sc2, 0);
            }
        }

        // DESCRIPTION (wrap natif, mêmes réglages que Collection)
        if (variable_instance_exists(card, "description")) {
            if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
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
            var want_px = base_text_size * sc;
            var want_size = max(8, floor(want_px));
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            left = round(left);
            top  = round(top);
            var sep = string_height("Ag");
            var w_eff = round(rw / sc2);
            draw_text_ext_transformed(left, top + 2, tx, sep, w_eff, sc2, sc2, 0);
        }

        // ATK
        if (!is_magic && variable_instance_exists(card, "attack")) {
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
            var atkVal = card.attack;
            var origA = (variable_instance_exists(card, "original_attack")) ? card.original_attack : atkVal;
            var colA = c_lime; // Always Green per user request
            var tx = string(atkVal);
            
            // Centered alignment
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var want_px = base_title_size * (1.2 * rel);
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var scale_tx = (want_size > 0) ? (want_px / want_size) : (1.2 * rel);
            
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
            if (font_exists(fontTitle)) draw_set_font(fontTitle);
            else if (font_exists(fontText)) draw_set_font(fontText);
            else if (font_exists(fontUI)) draw_set_font(fontUI);
            var hpVal = (variable_instance_exists(card, "current_hp")) ? card.current_hp : card.PV;
            var hpMax = (variable_instance_exists(card, "max_hp")) ? card.max_hp : hpVal;
            var origPV = (variable_instance_exists(card, "original_PV")) ? card.original_PV : hpMax;
            
            var hpColor = c_lime; // Always Green per user request
            var tx = string(hpVal);
            
            // Centered alignment
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var want_px = base_title_size * (1.2 * rel);
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var scale_tx = (want_size > 0) ? (want_px / want_size) : (1.2 * rel);
            
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

    var normalize_keyword = function(s) {
        var t = string_lower(string(s));
        t = string_replace_all(t, "à", "a"); t = string_replace_all(t, "â", "a"); t = string_replace_all(t, "ä", "a");
        t = string_replace_all(t, "é", "e"); t = string_replace_all(t, "è", "e"); t = string_replace_all(t, "ê", "e"); t = string_replace_all(t, "ë", "e");
        t = string_replace_all(t, "î", "i"); t = string_replace_all(t, "ï", "i");
        t = string_replace_all(t, "ô", "o"); t = string_replace_all(t, "ö", "o");
        t = string_replace_all(t, "ù", "u"); t = string_replace_all(t, "û", "u"); t = string_replace_all(t, "ü", "u");
        t = string_replace_all(t, "ç", "c");
        t = string_replace_all(t, "’", "'"); t = string_replace_all(t, " ", ""); t = string_replace_all(t, "-", "");
        return t;
    };

    var effect_defs = {
        eveil:         { label: "Éveil",        desc: "Se déclenche quand la carte est invoquée." },
        aube:          { label: "Aube",         desc: "Se déclenche au début du tour." },
        crepuscule:    { label: "Crépuscule",   desc: "Se déclenche à la fin du tour." },
        brise:         { label: "Brisé",        desc: "Se déclenche quand la carte est détruite (envoyée au cimetière)." },
        rupture:       { label: "Rupture",      desc: "Se déclenche quand la carte est envoyée au cimetière." },
        defenseur:     { label: "Défenseur",    desc: "Se déclenche quand la carte défend." },
        camouflage:    { label: "Camouflage",   desc: "Ne peut pas être ciblé ni attaqué tant qu'il n'attaque pas." },
        charge:        { label: "Charge",       desc: "Peut attaquer immédiatement (le tour où il est invoqué)." },
        percee:        { label: "Percée",       desc: "Ignore la Ligne de Front pour les attaques directes." },
        provocation:   { label: "Provocation",  desc: "Bloque les attaques directes : doit être attaqué en priorité." },
        entrave:       { label: "Entrave",      desc: "Empêche la cible d'attaquer pendant un certain temps." },
        poison:        { label: "Poison",       desc: "Détruit les serviteurs qu'il blesse." },
        ambidextrie:   { label: "Ambidextrie",  desc: "Peut attaquer deux fois par tour." },
        illusion:      { label: "Illusion",     desc: "Annule la première destruction subie." },
        secret:        { label: "Secret",       desc: "Se pose face cachée et se déclenche sous une condition." },
        aura:          { label: "Aura",         desc: "Effet passif tant que la carte est en jeu." },
        combo:         { label: "Combo",        desc: "Effet bonus si la condition indiquée est remplie." },
        pillage:       { label: "Pillage",      desc: "Vole une carte du deck adverse et l'ajoute à votre main." }
    };

    var found_effect_keys = [];

    if (variable_instance_exists(card, "tags") && is_array(card.tags)) {
        for (var ti = 0; ti < array_length(card.tags); ti++) {
            var t0 = card.tags[ti];
            var nk = normalize_keyword(t0);
            var already = false;
            for (var i = 0; i < array_length(found_effect_keys); i++) {
                if (found_effect_keys[i] == nk) { already = true; break; }
            }
            if (!already) array_push(found_effect_keys, nk);
        }
    }

    if (variable_instance_exists(card, "effects") && is_array(card.effects) && array_length(card.effects) > 0) {
        for (var ei = 0; ei < array_length(card.effects); ei++) {
            var eff = card.effects[ei];
            var lbl = getEffectLabel(eff);
            var nk = normalize_keyword(lbl);
            var already = false;
            for (var i = 0; i < array_length(found_effect_keys); i++) {
                if (found_effect_keys[i] == nk) { already = true; break; }
            }
            if (!already) array_push(found_effect_keys, nk);
        }
    }

    if (variable_instance_exists(card, "description")) {
        var nd = normalize_keyword(card.description);
        var keys_to_scan = ["eveil", "aube", "crepuscule", "brise", "rupture", "defenseur", "camouflage", "charge", "percee", "provocation", "entrave", "poison", "ambidextrie", "illusion", "secret", "aura", "combo", "pillage"];
        for (var si = 0; si < array_length(keys_to_scan); si++) {
            var kscan = keys_to_scan[si];
            if (string_pos(kscan, nd) > 0) {
                var already = false;
                for (var i = 0; i < array_length(found_effect_keys); i++) {
                    if (found_effect_keys[i] == kscan) { already = true; break; }
                }
                if (!already) array_push(found_effect_keys, kscan);
            }
        }
    }

    var effect_keys = [];
    for (var fi = 0; fi < array_length(found_effect_keys); fi++) {
        var k = found_effect_keys[fi];
        if (variable_struct_exists(effect_defs, k)) array_push(effect_keys, k);
    }

    if (array_length(effect_keys) > 0) {
        var panel_w = sprite_w + 20;
        var pad = 14;
        var panel_x1 = draw_x - panel_w * 0.5;
        panel_x1 = max(20, min(panel_x1, room_width - panel_w - 20));
        var panel_y1 = draw_y + sprite_h * 0.5 + 20;
        panel_y1 = max(20, panel_y1);

        var scale_factor = 0.8;
        var base_title_size = 16;
        if (font_exists(fontTitle)) base_title_size = font_get_size(fontTitle);
        var base_text_size = 14;
        if (font_exists(fontText)) base_text_size = font_get_size(fontText);
        
        var title_font = (variable_global_exists("get_runtime_font")) ? global.get_runtime_font("title", max(8, round(base_title_size * scale_factor))) : fontTitle;
        var text_font = (variable_global_exists("get_runtime_font")) ? global.get_runtime_font("text", max(8, round(base_text_size * scale_factor))) : fontText;
        
        if (text_font != -1) draw_set_font(text_font);
        var sep = string_height("Ag");
        var max_w_eff = (panel_w - pad * 2);

        var lines = "";
        for (var li = 0; li < array_length(effect_keys); li++) {
            var k = effect_keys[li];
            var def = variable_struct_get(effect_defs, k);
            var line = def.label + " : " + def.desc;
            lines = (lines == "") ? line : (lines + "\n" + line);
        }

        var title = "Signification des effets";
        var text_h = string_height_ext(lines, sep, max_w_eff);
        if (title_font != -1) draw_set_font(title_font);
        var title_h = string_height(title) + 8;
        var panel_h = pad * 2 + title_h + text_h + 6;

        var panel_x2 = panel_x1 + panel_w;
        var panel_y2 = panel_y1 + panel_h;
        if (panel_y2 > room_height - 20) {
            var shift = panel_y2 - (room_height - 20);
            panel_y1 = max(20, panel_y1 - shift);
            panel_y2 = panel_y1 + panel_h;
        }

        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(20, 20, 20));
        draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(230, 200, 120));
        draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, true);

        if (title_font != -1) draw_set_font(title_font);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        draw_set_color(make_color_rgb(230, 200, 120));
        draw_text(panel_x1 + pad, panel_y1 + pad, title);

        if (text_font != -1) draw_set_font(text_font);
        draw_set_color(c_white);
        draw_text_ext(panel_x1 + pad, panel_y1 + pad + title_h, lines, sep, max_w_eff);

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

    gpu_set_texfilter(true);

