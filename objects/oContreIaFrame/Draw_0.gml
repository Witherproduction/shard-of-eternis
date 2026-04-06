// === oContreIaFrame - Draw Event ===
// Dessine un cadre à droite de l'écran en utilisant le sprite sDeckBuilder

// Position à droite de l'écran avec décalage de 55 pixels (comme dans rCollection)
var sprite_x = room_width - sprite_get_width(sDeckBuilder) + 55;
var sprite_y = -60; // Décaler vers le haut pour dépasser davantage

// Calculer l'échelle pour dépasser légèrement en haut et en bas (120 pixels de plus)
var scale_y = (room_height + 120) / sprite_get_height(sDeckBuilder);
// Calculer l'échelle horizontale pour rétrécir de 20 pixels
var scale_x = (sprite_get_width(sDeckBuilder) - 20) / sprite_get_width(sDeckBuilder);

// Dessiner le sprite sDeckBuilder étiré sur toute la hauteur
draw_sprite_ext(sDeckBuilder, 0, sprite_x, sprite_y, scale_x, scale_y, 0, c_white, 1);

var text_color = make_color_rgb(230, 200, 120);
var get_font = function(kind, size) {
    if (variable_global_exists("get_runtime_font")) {
        var rf = global.get_runtime_font(kind, size);
        if (rf != -1) return rf;
    }
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
var draw_shadow_text = function(_x, _y, _t, _col) {
    draw_set_color(c_black);
    draw_text(_x + 2, _y + 2, _t);
    draw_set_color(_col);
    draw_text(_x, _y, _t);
};

// Titre du cadre
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var f_title = get_font("title", 22);
if (f_title != -1) draw_set_font(f_title);
draw_shadow_text(sprite_x + (sprite_get_width(sDeckBuilder) * scale_x) / 2, 30, "Mes Decks", text_color);

// Récupérer la liste des decks sauvegardés
var saved_decks = global.saved_decks;
var deck_count = 0;

// Compter le nombre de decks disponibles
if (is_array(saved_decks)) {
    deck_count = array_length(saved_decks);
}

// Position de départ pour la liste des decks
var list_start_x = sprite_x + 20;
var list_start_y = sprite_y + deck_list_y + 20;
var list_width = (sprite_get_width(sDeckBuilder) * scale_x) - 40;
var item_inset = 28;
var item_gap = 6;
var item_x = list_start_x + item_inset;
var item_w = list_width - (item_inset * 2);

// Si aucun deck n'est disponible
if (deck_count == 0) {
    // Dessiner un cadre pour le message "aucun deck disponible"
    var msg_box_y = list_start_y + 100;
    var msg_box_height = 60;
    draw_sprite_stretched(sButton, 0, item_x, msg_box_y, item_w, msg_box_height);
    
    // Texte du message
    draw_set_font(fontTitle);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_shadow_text(item_x + item_w / 2, msg_box_y + msg_box_height / 2, "Aucun deck disponible", text_color);
} else {
    // Afficher la liste des decks
    draw_set_font(fontTitle);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Calculer le nombre de decks visibles
    var visible_count = min(deck_count, max_visible_decks);
    
    // Dessiner chaque deck visible
    for (var i = 0; i < visible_count; i++) {
        var deck_index = i + scroll_offset;
        if (deck_index >= deck_count) break;
        
        var deck = saved_decks[deck_index];
        var item_y = list_start_y + (i * (deck_item_height + item_gap));
        
        var subimg = 0;
        if (sprite_get_number(sButton) > 1 && deck_index == selected_deck_index) subimg = 1;
        draw_sprite_stretched(sButton, subimg, item_x, item_y, item_w, deck_item_height);
        
        // Dessiner le nom du deck
        draw_set_color(text_color);
        var deck_name = "Deck sans nom";
        if (variable_struct_exists(deck, "name") && deck.name != "") {
            deck_name = deck.name;
        }
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var cx = item_x + item_w / 2;
        var cy = item_y + deck_item_height / 2;
        draw_shadow_text(cx, cy - 8, deck_name, text_color);
        
        // Dessiner le nombre de cartes
        var card_count = 0;
        if (variable_struct_exists(deck, "cards") && is_array(deck.cards)) {
            card_count = array_length(deck.cards);
        }
        draw_shadow_text(cx, cy + 10, string(card_count) + " cartes", text_color);
    }
}

// (sélecteur de difficulté déplacé dans le cadre gauche)
// Remettre les alignements par défaut
draw_set_halign(fa_left);
draw_set_valign(fa_top);
