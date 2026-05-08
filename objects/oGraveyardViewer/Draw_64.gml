// === Paramètres ===
var columns = 4;              // Nombre de colonnes affichées (réduit de 5 à 4)
var rows = 3;                 // Nombre de lignes affichées
var spacing = 20;             // Espace horizontal/vertical entre les cartes
var scale = 0.25;             // Échelle d'affichage des cartes (remise comme avant)

// Taille d'une carte (par défaut)
var card_w = 100 * scale;
var card_h = 140 * scale;

// Adapter selon la première carte si disponible
if (array_length(linkedGraveyard.cards) > 0) {
    var first_cardData = linkedGraveyard.cards[0];
    card_w = sprite_get_width(first_cardData.sprite_index) * scale;
    card_h = sprite_get_height(first_cardData.sprite_index) * scale;
}

// === Géométrie du cadre sFond (origine centrée) ===
var sprFond = sCimetiere;
var fondW = sprite_get_width(sprFond);
var fondH = sprite_get_height(sprFond);
var centerX = room_width * 0.5;
var centerY = room_height * 0.5;
var frameScaleX = 1;
var frameScaleY = 1;
var scaledW = fondW * frameScaleX;
var scaledH = fondH * frameScaleY;
var frame_left = centerX - scaledW * 0.5;
var frame_top = centerY - scaledH * 0.5;
var frame_right = centerX + scaledW * 0.5;
var frame_bottom = centerY + scaledH * 0.5;

// === Position des cartes ===
// Démarrer dans la zone intérieure du cadre avec une marge
var inner_margin = 40;
var start_x = frame_left + inner_margin;
var start_y = frame_top + inner_margin;

// Grille fixe basée sur la zone intérieure du cadre
var content_w = scaledW - 2 * inner_margin;
var content_h = scaledH - 2 * inner_margin;
var cell_w = (content_w - (columns - 1) * spacing) / columns;
var cell_h = (content_h - (rows - 1) * spacing) / rows;

// === Affiche le fond ===
draw_sprite_ext(sprFond, 0, centerX, centerY, frameScaleX, frameScaleY, 0, c_white, 1);

// Dessine le fond du cimetière à l'intérieur du cadre

// === Vérification de sécurité ===
if (linkedGraveyard == noone || !instance_exists(linkedGraveyard)) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(960, 540, "Erreur: Cimetière non trouvé"); // Centré dans le nouveau cadre
    return;
}

// === Dessiner les cartes ===
var list = linkedGraveyard.cards;   // Récupère la liste des cartes
var total = array_length(list);     // Nombre total de cartes
var visible_cards = columns * rows; // Nombre max de cartes affichables

// En-tête discret: nombre de cartes
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(frame_left + 20, frame_top + 10, "Cartes: " + string(total));

// Clamp de sécurité pour le scroll
maxScroll = max(0, total - visible_cards);
scrollIndex = clamp(scrollIndex, 0, maxScroll);

// Si le cimetière est vide, afficher un message
if (total == 0) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(960, 540, "Cimetière vide"); // Centré dans le nouveau cadre
    return;
}

maxScroll = max(0, total - visible_cards);
scrollIndex = clamp(scrollIndex, 0, maxScroll);
var avail = max(0, total - scrollIndex);
var count = min(avail, visible_cards);

for (var i = 0; i < count; i++) {
    var index = total - 1 - (i + scrollIndex);
    index = clamp(index, 0, total - 1);
    var cardData = list[index];
    
    // Vérifier que les données de carte existent
    if (cardData != undefined) {
        var col = i mod columns;  // Colonne
        var row = i div columns;  // Ligne

        var sprLocal = cardData.sprite_index;
        if (sprLocal == -1 && variable_struct_exists(cardData, "object_index")) {
            sprLocal = object_get_sprite(cardData.object_index);
        }
        var cw_src = sprite_get_width(sprLocal);
        var ch_src = sprite_get_height(sprLocal);
        var s_local = (cw_src > 0 && ch_src > 0) ? min(cell_w / cw_src, cell_h / ch_src) * 0.95 : scale;

        var draw_x_top_left = start_x + col * (cell_w + spacing); // Position X du coin supérieur gauche
        var draw_y_top_left = start_y + row * (cell_h + spacing); // Position Y du coin supérieur gauche

        // Zone de dessin centrée (pas de cadre ni debug)

        // Ajuster draw_x et draw_y pour qu'ils soient le centre de la carte, car l'origine du sprite est centrée
        var draw_x = draw_x_top_left + cell_w * 0.5;
        var draw_y = draw_y_top_left + cell_h * 0.5;

        if (sprite_exists(sprLocal) && sprite_get_width(sprLocal) > 0 && sprite_get_height(sprLocal) > 0) {
            draw_sprite_ext(sprLocal, cardData.image_index, draw_x, draw_y, s_local, s_local, 0, c_white, 1);
            gpu_set_texfilter(false);

            var s = s_local;
            var spr = sprLocal;
            var cw = cw_src * s;
            var ch = ch_src * s;
            var layout = global.card_layout;
            var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
            var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
            var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
            var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
            var desc_x1  = layout.description.x1,  desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
            var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
            var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
            var is_magic = (variable_struct_exists(cardData, "cardType") && string_lower(string(cardData.cardType)) == "magic");
            if (font_exists(fontText)) draw_set_font(fontText);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_black);
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
                var sc = (base_line_h > 0) ? max_px / base_line_h : 1;
                for (var it = 0; it < 3; it++) {
                    var sep = base_line_h;
                    var w_eff = (sc > 0) ? (rw / sc) : rw;
                    var h = string_height_ext(text, sep, w_eff);
                    if (h <= 0) break;
                    var s_h2 = rh / h;
                    sc = min(sc, s_h2);
                }
                return sc;
            };
            var pad = 0;
            var rel = s / 0.6;
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
            var tlx = draw_x - cw * 0.5;
            var tly = draw_y - ch * 0.5;
            if (variable_struct_exists(cardData, "name")) {
                var tx = string_trim(string(cardData.name));
                var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
                var rh = (name_y2 - name_y1) * s - pad * 2;
                var sc = fit_line(tx, 20 * rel, rw, rh);
                var want_px = base_title_size * sc;
                var want_size = max(6, floor(want_px));
                var f = get_font("title", want_size);
                while (want_size > 6 && f != -1) {
                    draw_set_font(f);
                    if (string_width(tx) <= rw && string_height("Ag") <= rh) break;
                    want_size -= 1;
                    f = get_font("title", want_size);
                }
                if (f != -1) draw_set_font(f);
                if (string_width(tx) > rw) {
                    var suffix = "...";
                    while (string_length(tx) > 1 && string_width(tx + suffix) > rw) {
                        tx = string_delete(tx, string_length(tx), 1);
                    }
                    tx += suffix;
                }
                var left = tlx + name_x1 * s + pad + mar;
                var top  = tly + name_y1 * s + pad;
                draw_text_transformed(round(left), round(top + 2), tx, 1, 1, 0);
            }
            if (variable_struct_exists(cardData, "mana_cost")) {
                var tx = string(cardData.mana_cost);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                var rw = (star_x2 - star_x1) * s;
                var rh = (star_y2 - star_y1) * s;
                var center_x = tlx + (star_x1 + (star_x2-star_x1)/2) * s;
                var center_y = tly + (star_y1 + (star_y2-star_y1)/2) * s;
                center_x -= 2;
                center_x = round(center_x);
                center_y = round(center_y);
                if (font_exists(fontTitle)) draw_set_font(fontTitle);
                var sc = fit_line(tx, 22 * rel, rw, rh);
                var want_px = base_title_size * sc;
                var want_size = max(6, floor(want_px));
                var f = get_font("title", want_size);
                while (want_size > 6 && f != -1) {
                    draw_set_font(f);
                    if (string_width(tx) <= rw && string_height("Ag") <= rh) break;
                    want_size -= 1;
                    f = get_font("title", want_size);
                }
                if (f != -1) draw_set_font(f);
                draw_text_transformed(center_x, center_y, tx, 1, 1, 0);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
            if (variable_struct_exists(cardData, "genre")) {
                var tx = string(cardData.genre);
                // Si la race est incluse dans le genre (format "Genre - Race"), on la retire pour l'affichage propre
                if (variable_struct_exists(cardData, "race") && string_length(cardData.race) > 0) {
                    var split = string_split(tx, " - ");
                    if (array_length(split) > 0) {
                        tx = split[0];
                    }
                }
                var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
                var rh = (genre_y2 - genre_y1) * s - pad * 2;
                var sc = fit_line(tx, 16 * rel, rw, rh);
                var left_g = tlx + genre_x1 * s + pad + mar;
                var top_g  = tly + genre_y1 * s + pad;
                draw_text_transformed(left_g, top_g, tx, sc, sc, 0);
            }
            var race_text = "";
            if (variable_struct_exists(cardData, "race") && string_length(string(cardData.race)) > 0) {
                race_text = string(cardData.race);
            } else if (variable_struct_exists(cardData, "archetype") && string_length(string(cardData.archetype)) > 0) {
                race_text = string(cardData.archetype);
            } else if (variable_struct_exists(cardData, "genre") && string_pos(" - ", string(cardData.genre)) > 0) {
                var gr_parts = string_split(string(cardData.genre), " - ");
                if (array_length(gr_parts) > 1) race_text = string(gr_parts[1]);
            }
            if (race_text != "") {
                var tx = race_text;
                var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
                var rh = (arch_y2 - arch_y1) * s - pad * 2;
                var sc = fit_line(tx, 16 * rel, rw, rh);
                var left_a = tlx + arch_x1 * s + pad + mar;
                var top_a  = tly + arch_y1 * s + pad;
                draw_text_transformed(left_a, top_a, tx, sc, sc, 0);
            }
            // Terrain style: pas de description sur la carte.

            if (!is_magic && variable_struct_exists(cardData, "attack")) {
                var txa = string(cardData.attack);
                var rw_a = (atk_x2 - atk_x1) * s - pad * 2;
                var rh_a = (atk_y2 - atk_y1) * s - pad * 2;
                var cx_a   = round(tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s) - 4;
                var cy_a   = round(tly + (atk_y1 + (atk_y2-atk_y1)/2) * s) - 5;
                if (font_exists(fontTitle)) draw_set_font(fontTitle);
                var want_px_a = base_title_size * (1.2 * rel);
                var want_size_a = max(6, floor(want_px_a));
                var f_a = get_font("title", want_size_a);
                while (want_size_a > 6 && f_a != -1) {
                    draw_set_font(f_a);
                    if (string_width(txa) <= rw_a && string_height("Ag") <= rh_a) break;
                    want_size_a -= 1;
                    f_a = get_font("title", want_size_a);
                }
                if (f_a != -1) draw_set_font(f_a);
                var sc_a = 1;
                
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(cx_a - o_dist, cy_a, txa, sc_a, sc_a, 0);
                draw_text_transformed(cx_a + o_dist, cy_a, txa, sc_a, sc_a, 0);
                draw_text_transformed(cx_a, cy_a - o_dist, txa, sc_a, sc_a, 0);
                draw_text_transformed(cx_a, cy_a + o_dist, txa, sc_a, sc_a, 0);
                
                draw_set_color(c_lime);
                draw_text_transformed(cx_a, cy_a, txa, sc_a, sc_a, 0);
            }

            if (!is_magic && variable_struct_exists(cardData, "PV")) {
                var txd = string(cardData.PV);
                var rw_d = (def_x2 - def_x1) * s - pad * 2;
                var rh_d = (def_y2 - def_y1) * s - pad * 2;
                var cx_d   = round(tlx + (def_x1 + (def_x2-def_x1)/2) * s) - 5;
                var cy_d   = round(tly + (def_y1 + (def_y2-def_y1)/2) * s) - 6;
                if (font_exists(fontTitle)) draw_set_font(fontTitle);
                var want_px_d = base_title_size * (1.2 * rel);
                var want_size_d = max(6, floor(want_px_d));
                var f_d = get_font("title", want_size_d);
                while (want_size_d > 6 && f_d != -1) {
                    draw_set_font(f_d);
                    if (string_width(txd) <= rw_d && string_height("Ag") <= rh_d) break;
                    want_size_d -= 1;
                    f_d = get_font("title", want_size_d);
                }
                if (f_d != -1) draw_set_font(f_d);
                var sc_d = 1;
                
                var o_dist = 2 * rel;
                draw_set_color(c_black);
                draw_text_transformed(cx_d - o_dist, cy_d, txd, sc_d, sc_d, 0);
                draw_text_transformed(cx_d + o_dist, cy_d, txd, sc_d, sc_d, 0);
                draw_text_transformed(cx_d, cy_d - o_dist, txd, sc_d, sc_d, 0);
                draw_text_transformed(cx_d, cy_d + o_dist, txd, sc_d, sc_d, 0);
                
                draw_set_color(c_lime);
                draw_text_transformed(cx_d, cy_d, txd, sc_d, sc_d, 0);
            }
            gpu_set_texfilter(true);
        }
    }
}

// === Bouton de fermeture ===
// En haut à droite du cadre avec une marge
var close_margin = 20;
var close_w = 30;
var close_h = 30;
var close_x1 = frame_right - close_margin - close_w;
var close_y1 = frame_top + close_margin;
var close_x2 = close_x1 + close_w;
var close_y2 = close_y1 + close_h;
draw_set_color(c_red);
draw_rectangle(close_x1, close_y1, close_x2, close_y2, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
gpu_set_texfilter(false);
draw_text((close_x1 + close_x2) * 0.5, (close_y1 + close_y2) * 0.5, "X");
gpu_set_texfilter(true);

// === Indicateur de scroll ===
var bar_w = 15;    // Largeur de la barre
var bar_margin_top = 60;
var bar_margin_bottom = 60;
var bar_x = frame_right - close_margin - bar_w; // près du bord droit
var bar_y = frame_top + bar_margin_top;   // sous le bouton
var bar_h = max(60, scaledH - (bar_margin_top + bar_margin_bottom));

// === Calcul de la taille du curseur ===
var indicator_height;
if (total > visible_cards) {
    indicator_height = max(bar_h * (visible_cards / total), 20);
} else {
    indicator_height = bar_h * 0.2; // 20% de la barre minimum
}

// Calcul du déplacement max possible
maxScroll = max(0, total - visible_cards);

// Position verticale du curseur dans la barre
var scroll_pos = 0;
if (maxScroll > 0) {
    scroll_pos = (scrollIndex / maxScroll) * (bar_h - indicator_height);
}

// === Dessin de la barre ===
draw_set_color(c_white); // Fond blanc pour bien la voir
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

draw_set_color(c_grey); // Cadre noir
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);


// === Dessin du curseur ===
draw_set_color(c_blue); // Fond bleu
draw_rectangle(bar_x, bar_y + scroll_pos, bar_x + bar_w, bar_y + scroll_pos + indicator_height, true);

draw_set_color(c_blue); // Contour bleu
draw_rectangle(bar_x, bar_y + scroll_pos, bar_x + bar_w, bar_y + scroll_pos + indicator_height, false);

// === Reset couleurs & alignements ===
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// === Dessin de la carte sélectionnée (preview) ===
if (selectedCard != noone) {
    var card = selectedCard;

    // Position de la carte
    var preview_draw_x = 150;
    var preview_draw_y = 250;
    var preview_scale = 0.50;

    // Taille réelle du sprite affiché
    var preview_sprite_w = sprite_get_width(card.sprite_index) * preview_scale;
    var preview_sprite_h = sprite_get_height(card.sprite_index) * preview_scale;

    // Bord bas de la carte (pour positionner le texte en-dessous)
    var preview_image_bottom = preview_draw_y + preview_sprite_h * 0.5;

    // --- Position du texte et du cadre ---
    var preview_margin_side = 15; // Marge à gauche et à droite du texte
    var preview_margin_top = 8;   // Marge au-dessus du texte
    var preview_margin_bottom = 8;

    var preview_text_x = preview_draw_x - preview_sprite_w * 0.5 + preview_margin_side; // Décalage plus à gauche
    var preview_text_y = preview_image_bottom + 10;

    var preview_text_width = preview_sprite_w - 2 * preview_margin_side;
    var preview_line_height = 16; // Plus petit pour éviter chevauchement

    // --- Police et alignement ---
    if (font_exists(fontText)) draw_set_font(fontText);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // --- Contenu à afficher ---
    var preview_lines = [];
    
    // Gestion du nom sur plusieurs lignes si nécessaire
    var preview_name_text = "Nom : " + string(card.name);
    var preview_name_words = string_split(preview_name_text, " ");
    var preview_name_line = "";
    
    for (var i = 0; i < array_length(preview_name_words); i++) {
        var preview_try_name_line = preview_name_line + preview_name_words[i] + " ";
        if (string_width(preview_try_name_line) > preview_text_width) {
            if (string_length(preview_name_line) > 0) {
                array_push(preview_lines, string_trim(preview_name_line));
                preview_name_line = preview_name_words[i] + " ";
            } else {
                // Si même un seul mot est trop long, on le force quand même
                array_push(preview_lines, preview_name_words[i]);
                preview_name_line = "";
            }
        } else {
            preview_name_line = preview_try_name_line;
        }
    }
    
    if (string_length(preview_name_line) > 0) {
        array_push(preview_lines, string_trim(preview_name_line));
    }

    // Afficher le niveau si c'est un monstre
    if (variable_instance_exists(card, "type") && card.type == "Monster") {
        if (variable_instance_exists(card, "mana_cost")) {
            array_push(preview_lines, "Niveau : " + string(card.mana_cost));
        }
    }

    // Afficher ATK et PV sur la même ligne si c'est un monstre
    if (variable_instance_exists(card, "type") && card.type == "Monster") {
        // N'affiche les stats que si la carte n'est pas face cachée ou si elle est possédée par le héros
        if (!card.isFaceDown || card.isHeroOwner) {
            var preview_atk_str = "";
            var preview_def_str = "";

            if (variable_instance_exists(card, "attack")) {
                preview_atk_str = "ATK : " + string(card.attack);
            }

            if (variable_instance_exists(card, "PV")) {
                preview_def_str = "PV : " + string(card.PV);
            }

            var preview_stats_line = preview_atk_str;
            if (string_length(preview_def_str) > 0) {
                preview_stats_line += "    " + preview_def_str;
            }

            array_push(preview_lines, preview_stats_line);
        }
    }

    // Texte multi-lignes pour la description
    if (variable_instance_exists(card, "description")) {
        var preview_desc = "Effet : " + string(card.description);
        var preview_words = string_split(preview_desc, " ");
        var preview_line = "";

        for (var i = 0; i < array_length(preview_words); i++) {
            var preview_try_line = preview_line + preview_words[i] + " ";
            if (string_width(preview_try_line) > preview_text_width) {
                array_push(preview_lines, string_trim(preview_line));
                preview_line = preview_words[i] + " ";
            } else {
                preview_line = preview_try_line;
            }
        }

        if (string_length(preview_line) > 0) {
            array_push(preview_lines, string_trim(preview_line));
        }
    }

    // Terrain style: pas de panneau texte additionnel sous la carte preview.
    // Ancien rendu du panneau de description conservé en commentaire pour réactivation éventuelle :
    /*
    var preview_total_height = array_length(preview_lines) * preview_line_height;
    var preview_rect_x1 = preview_text_x - 15;
    var preview_rect_y1 = preview_text_y - preview_margin_top;
    var preview_rect_x2 = preview_draw_x + preview_sprite_w * 0.5 - preview_margin_side + 15;
    var preview_rect_y2 = preview_text_y + preview_total_height + preview_margin_bottom;
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(preview_rect_x1, preview_rect_y1, preview_rect_x2, preview_rect_y2, false);
    draw_set_alpha(1);
    gpu_set_texfilter(false);
    draw_set_color(c_white);
    for (var i = 0; i < array_length(preview_lines); i++) {
        draw_text(preview_text_x, preview_text_y + i * preview_line_height, preview_lines[i]);
    }
    */

    // --- Affiche la carte en grand (après pour qu’elle soit toujours visible) ---
    gpu_set_texfilter(true);
    if (card.isFaceDown && card.isHeroOwner) {
        // Si la carte est face cachée mais appartient au héros, on affiche sa face visible
        draw_sprite_ext(card.sprite_index, 0, preview_draw_x, preview_draw_y, preview_scale, preview_scale, 0, c_white, 1);
    } else {
        draw_sprite_ext(card.sprite_index, card.image_index, preview_draw_x, preview_draw_y, preview_scale, preview_scale, 0, c_white, 1);
    }

    var face_down = (variable_instance_exists(card, "isFaceDown") && card.isFaceDown);
    var can_show_overlay = (!face_down) || (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    if (can_show_overlay) {
        gpu_set_texfilter(false);
        var spr = card.sprite_index;
        var s = preview_scale;
        var cw = sprite_get_width(spr) * s;
        var ch = sprite_get_height(spr) * s;
        var tlx = preview_draw_x - cw * 0.5;
        var tly = preview_draw_y - ch * 0.5;
        var layout = global.card_layout;
        var name_x1 = layout.name.x1,  name_y1 = layout.name.y1;  var name_x2 = layout.name.x2, name_y2 = layout.name.y2;
        var star_x1 = layout.mana.x1, star_y1 = layout.mana.y1;  var star_x2 = layout.mana.x2, star_y2 = layout.mana.y2;
        var genre_x1 = layout.genre.x1, genre_y1 = layout.genre.y1; var genre_x2 = layout.genre.x2, genre_y2 = layout.genre.y2;
        var arch_x1  = layout.archetype.x1, arch_y1  = layout.archetype.y1; var arch_x2  = layout.archetype.x2, arch_y2  = layout.archetype.y2;
        var desc_x1  = layout.description.x1,  desc_y1  = layout.description.y1; var desc_x2  = layout.description.x2, desc_y2  = layout.description.y2;
        var atk_x1   = layout.atk.x1, atk_y1   = layout.atk.y1; var atk_x2   = layout.atk.x2, atk_y2   = layout.atk.y2;
        var def_x1   = layout.hp.x1, def_y1   = layout.hp.y1; var def_x2   = layout.hp.x2, def_y2   = layout.hp.y2;
        var is_magic = object_is_ancestor(card.object_index, oCardMagic) || (variable_instance_exists(card, "type") && string_lower(string(card.type)) == "magic");
        if (font_exists(fontText)) draw_set_font(fontText);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_black);
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
            var sc = (base_line_h > 0) ? max_px / base_line_h : 1;
            for (var it = 0; it < 3; it++) {
                var sep = base_line_h;
                var w_eff = (sc > 0) ? (rw / sc) : rw;
                var h = string_height_ext(text, sep, w_eff);
                if (h <= 0) break;
                var s_h2 = rh / h;
                sc = min(sc, s_h2);
            }
            return sc;
        };
        var pad = 0;
        var rel = s / 0.6;
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
        var genre_font_size = -1;
        var genre_scale_draw = 1;
        if (variable_instance_exists(card, "name")) {
            var tx = string_trim(string(card.name));
            var rw = (name_x2 - name_x1) * s - pad * 2 - mar * 2;
            var rh = (name_y2 - name_y1) * s - pad * 2;
            var sc = fit_line(tx, 17 * rel, rw, rh);
            var want_px = base_title_size * sc;
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            var left = tlx + name_x1 * s + pad + mar;
            var top  = tly + name_y1 * s + pad;
            draw_text_transformed(round(left), round(top + 2), tx, sc2, sc2, 0);
        }
        if (variable_instance_exists(card, "mana_cost")) {
            var tx = string(card.mana_cost);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var rw = (star_x2 - star_x1) * s;
            var rh = (star_y2 - star_y1) * s;
            var cx = tlx + (star_x1 + (star_x2-star_x1)/2) * s - 3;
            var cy = tly + (star_y1 + (star_y2-star_y1)/2) * s;
            var sc = fit_line(tx, 18 * rel, rw, rh);
            var want_px = base_title_size * sc;
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            draw_text_transformed(round(cx), round(cy), tx, sc2, sc2, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        if (variable_instance_exists(card, "genre")) {
            var tx = string(card.genre);
            // Si la race est incluse dans le genre (format "Genre - Race"), on la retire pour l'affichage propre
            if (variable_instance_exists(card, "race") && string_length(card.race) > 0) {
                var split = string_split(tx, " - ");
                if (array_length(split) > 0) {
                    tx = split[0];
                }
            }
            var rw = (genre_x2 - genre_x1) * s - pad * 2 - mar * 2;
            var rh = (genre_y2 - genre_y1) * s - pad * 2;
            var sc = fit_line(tx, 18 * rel, rw, rh);
            var want_px = base_text_size * sc;
            var want_size = max(8, floor(want_px));
            genre_font_size = want_size;
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            genre_scale_draw = sc2;
            var left_g = tlx + genre_x1 * s + pad + mar;
            var top_g  = tly + genre_y1 * s + pad;
            draw_text_transformed(round(left_g), round(top_g + 2), tx, sc2, sc2, 0);
        }
        if (variable_instance_exists(card, "race")) {
            var tx = string(card.race);
            var rw = (arch_x2 - arch_x1) * s - pad * 2 - mar * 2;
            var rh = (arch_y2 - arch_y1) * s - pad * 2;
            var sc = fit_line(tx, 18 * rel, rw, rh);
            var want_px = base_text_size * sc;
            var want_size = max(8, floor(want_px));
            if (genre_font_size > 0) want_size = genre_font_size;
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = genre_scale_draw;
            var left_a = tlx + arch_x1 * s + pad + mar;
            var top_a  = tly + arch_y1 * s + pad;
            draw_text_transformed(round(left_a), round(top_a + 1), tx, sc2, sc2, 0);
        }
        if (variable_instance_exists(card, "description")) {
            var tx = string(card.description);
            var rw = (desc_x2 - desc_x1) * s - pad * 2 - mar * 2;
            var rh = (desc_y2 - desc_y1) * s - pad * 2;
            var sc = fit_block(tx, 12 * rel, rw, rh);
            var want_px = base_text_size * sc;
            var want_size = max(6, floor(want_px));
            var f = get_font("text", want_size);
            if (f != -1) draw_set_font(f);
            var sc2 = (want_size > 0) ? (want_px / want_size) : sc;
            var left = tlx + desc_x1 * s + pad + mar;
            var top  = tly + desc_y1 * s + pad;
            var sep = string_height("Ag");
            var w_eff = max(1, round(rw));
            draw_text_ext_transformed(round(left), round(top + 2), tx, sep, w_eff, sc2, sc2, 0);
        }
        if (!is_magic && variable_instance_exists(card, "attack")) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var txA = string(card.attack);
            var rwA = (atk_x2 - atk_x1) * s - pad * 2;
            var rhA = (atk_y2 - atk_y1) * s - pad * 2;
            var cxA = tlx + (atk_x1 + (atk_x2-atk_x1)/2) * s - 1;
            var cyA = tly + (atk_y1 + (atk_y2-atk_y1)/2) * s;
            var want_px = base_title_size * (0.8 * rel);
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var scA = 1;
            var o_dist = 2 * rel;
            draw_set_color(c_black);
            draw_text_transformed(round(cxA - o_dist), round(cyA), txA, scA, scA, 0);
            draw_text_transformed(round(cxA + o_dist), round(cyA), txA, scA, scA, 0);
            draw_text_transformed(round(cxA), round(cyA - o_dist), txA, scA, scA, 0);
            draw_text_transformed(round(cxA), round(cyA + o_dist), txA, scA, scA, 0);
            draw_set_color(c_lime);
            draw_text_transformed(round(cxA), round(cyA), txA, scA, scA, 0);
        }
        if (!is_magic && variable_instance_exists(card, "PV")) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var txD = string(card.PV);
            var rwD = (def_x2 - def_x1) * s - pad * 2;
            var rhD = (def_y2 - def_y1) * s - pad * 2;
            var cxD = tlx + (def_x1 + (def_x2-def_x1)/2) * s - 1;
            var cyD = tly + (def_y1 + (def_y2-def_y1)/2) * s - 1;
            var want_px = base_title_size * (0.8 * rel);
            var want_size = max(8, floor(want_px));
            var f = get_font("title", want_size);
            if (f != -1) draw_set_font(f);
            var scD = 1;
            var o_dist = 2 * rel;
            draw_set_color(c_black);
            draw_text_transformed(round(cxD - o_dist), round(cyD), txD, scD, scD, 0);
            draw_text_transformed(round(cxD + o_dist), round(cyD), txD, scD, scD, 0);
            draw_text_transformed(round(cxD), round(cyD - o_dist), txD, scD, scD, 0);
            draw_text_transformed(round(cxD), round(cyD + o_dist), txD, scD, scD, 0);
            draw_set_color(c_lime);
            draw_text_transformed(round(cxD), round(cyD), txD, scD, scD, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        gpu_set_texfilter(true);
    }
}

