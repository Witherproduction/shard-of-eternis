// === oDeckList - Draw Event ===
// Affiche le sprite sDeckBuilder à droite de l'écran et la liste des decks sauvegardés

// Position à droite de l'écran avec décalage de 55 pixels (décalé de 20 pixels vers la gauche)
var sprite_x = room_width - sprite_get_width(sDeckBuilder) + 55;
var sprite_y = -10; // Décaler vers le haut pour dépasser davantage
var sprW = sprite_get_width(sDeckBuilder);

// Calculer l'échelle pour dépasser légèrement en haut et en bas (120 pixels de plus)
var scale_y = (room_height + 10) / sprite_get_height(sDeckBuilder);
// Calculer l'échelle horizontale pour rétrécir davantage
var scale_x = (sprW - 100) / sprW;
var scaled_w = sprW * scale_x;
sprite_x = room_width - scaled_w + 55 - 55;

// Dessiner le sprite sDeckBuilder étiré sur toute la hauteur et allongé de 30 pixels
draw_sprite_ext(sDeckBuilder, 0, sprite_x, sprite_y, scale_x, scale_y, 0, c_white, 1);

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

// Dessiner le bouton "nouveau deck" à 1/3 de la hauteur, remonté de 140 pixels
var button_x = sprite_x + 50;
var button_y = room_height / 3 - 270;
var baseW_btn = sprite_get_width(sButton);
var baseH_btn = sprite_get_height(sButton);
var button_width = round(baseW_btn * 0.8);
var button_height = round(baseH_btn * 0.8);

// --- Bouton Toggle Mode ---
if (variable_global_exists("admin_mode") && global.admin_mode) {
    // Mode admin désactivé temporairement pour simplifier l'interface
    // Pour réactiver, décommenter le bloc ci-dessous
    /*
    var mode_btn_y = button_y - 60;
    draw_sprite_stretched(sButton, 0, button_x, mode_btn_y, button_width, button_height);
    var mode_label = "Mode: Joueur";
    if (list_mode == "bot") mode_label = "Mode: Bots";
    else if (list_mode == "hero") mode_label = "Mode: Héros";
    
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_x + button_width/2 + 2, mode_btn_y + button_height/2 + 2, mode_label);
    draw_set_color(make_color_rgb(100, 200, 255)); // Bleu clair pour distinguer
    draw_text(button_x + button_width/2, mode_btn_y + button_height/2, mode_label);
    */
    
    // Forcer le mode joueur même en admin pour l'instant
    if (list_mode != "player") list_mode = "player";
} else {
    // Si pas admin, forcer le mode joueur
    if (list_mode != "player") list_mode = "player";
}
// --------------------------

// Dessiner le bouton avec le sprite sButton (comme les autres boutons)
draw_sprite_stretched(sButton, 0, button_x, button_y, button_width, button_height);

// Dessiner le texte "nouveau deck" centré avec légère ombre
var f_title_btn = get_font("text", 18);
if (f_title_btn != -1) draw_set_font(f_title_btn);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(button_x + button_width/2 + 2, button_y + button_height/2 + 2, "nouveau deck");
draw_set_color(make_color_rgb(230, 200, 120));
draw_text(button_x + button_width/2, button_y + button_height/2, "nouveau deck");

// === Affichage des decks sauvegardés ===
var current_list = [];
if (list_mode == "player") {
    if (variable_global_exists("saved_decks")) current_list = global.saved_decks;
} else if (list_mode == "bot") {
    // Utiliser get_all_bot_decks() pour avoir TOUS les decks (custom + histoire)
    current_list = get_all_bot_decks();
} else if (list_mode == "hero") {
    // Utiliser get_all_hero_decks() pour avoir TOUS les decks héros (custom + histoire)
    current_list = get_all_hero_decks();
}

// Vérifier si des decks sont sauvegardés ET si le deck builder n'est pas affiché
if (!show_deck_builder && array_length(current_list) > 0) {
    var deck_list_y = button_y + button_height + 20; // Commencer sous le bouton "nouveau deck"
    var deck_item_height = 35;
    var deck_item_width = button_width;
    
    // Titre de la section
    var title_text = "Decks Joueur:";
    if (list_mode == "bot") title_text = "Decks Bots:";
    else if (list_mode == "hero") title_text = "Decks Héros:";
    var f_title_list = get_font("text", 14);
    if (f_title_list != -1) draw_set_font(f_title_list);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_x + button_width/2 + 1, deck_list_y - 10 + 1, title_text);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text(button_x + button_width/2, deck_list_y - 10, title_text);
    
    // Afficher chaque deck sauvegardé
    for (var i = 0; i < array_length(current_list); i++) {
        var deck = current_list[i];
        var item_y = deck_list_y + (i * (deck_item_height + 5));
        
        // Vérifier si on dépasse l'écran
        if (item_y + deck_item_height > room_height - 50) {
            break; // Arrêter si on dépasse l'écran
        }
        
        // Dessiner le fond du deck
        draw_set_color(c_ltgray);
        draw_rectangle(button_x, item_y, button_x + deck_item_width, item_y + deck_item_height, false);
        draw_set_color(c_black);
        draw_rectangle(button_x, item_y, button_x + deck_item_width, item_y + deck_item_height, true);
        
        // Dessiner le nom du deck
        var f_name = get_font("text", 14);
        if (f_name != -1) draw_set_font(f_name);
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var dName = variable_struct_exists(deck, "name") ? deck.name : "Sans nom";
        draw_text(button_x + 5, item_y + 3, dName);
        
        // Dessiner le nombre de cartes
        var f_count = get_font("text", 12);
        if (f_count != -1) draw_set_font(f_count);
        draw_set_color(c_gray);
        var cCount = variable_struct_exists(deck, "card_count") ? deck.card_count : (variable_struct_exists(deck, "cards") ? array_length(deck.cards) : 0);
        draw_text(button_x + 5, item_y + 18, string(cCount) + " cartes");
    }
}

// Remettre les paramètres par défaut
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
