// === oContreIaFrameLeft - Draw Event ===
// Dessine un cadre gris à gauche de l'écran seulement si un bot est sélectionné

// Vérifier si un bot a été sélectionné dans oContreIaGrid
var grid_instance = instance_find(oContreIaGrid, 0);
if (grid_instance == noone || grid_instance.selected_bot == -1) {
    // Aucun bot sélectionné, ne pas dessiner le cadre
    exit;
}

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

var draw_shadow_text_ext = function(_x, _y, _t, _sep, _w, _col) {
    draw_set_color(c_black);
    draw_text_ext(_x + 2, _y + 2, _t, _sep, _w);
    draw_set_color(_col);
    draw_text_ext(_x, _y, _t, _sep, _w);
};

var fit_text_to_width = function(_t, _w) {
    if (string_width(_t) <= _w) return _t;
    var s = _t;
    while (string_length(s) > 0 && string_width(s + "...") > _w) {
        s = string_delete(s, string_length(s), 1);
    }
    if (string_length(s) <= 0) return "";
    return s + "...";
};

// Configuration du cadre
var frame_width = 400;
var frame_height = room_height;
var frame_x = 0;
var frame_y = 0;

// Couleurs
var border_color = c_gray;
var text_color = make_color_rgb(230, 200, 120);

draw_sprite_stretched(sDeckBuilder, 0, frame_x, frame_y, frame_width, frame_height);

// Obtenir les informations du bot depuis le système de données
var bot_id = grid_instance.selected_bot;
var bot_info = grid_instance.bot_data[bot_id];

// Rétablir le nom du bot et utiliser la description du deck
var bot_name = bot_info.name;
var bot_description = bot_info.description;

var bot_deck = bot_info.deck_name;

// Position de départ pour le contenu
var content_x = frame_x + 40;
var content_y = frame_y + 60;
var line_height = 25;
var content_w = frame_width - content_x - 40;

// === NOM DU BOT ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(get_font("text", 18));
draw_shadow_text(content_x, content_y, fit_text_to_width(bot_name, content_w), text_color);
content_y += 40;

// === PORTRAIT DU BOT ===
var portrait_x = content_x;
var portrait_y = content_y;
var portrait_width = 120;
var portrait_height = 120;

// Vérifier si un portrait est défini
var has_portrait = false;
if (variable_struct_exists(bot_info, "portrait") && bot_info.portrait != undefined) {
    var spr_idx = -1;
    if (is_string(bot_info.portrait)) {
        spr_idx = asset_get_index(bot_info.portrait);
    } else {
        spr_idx = bot_info.portrait;
    }
    
    if (spr_idx != -1) {
        // Dessiner le sprite adapté à la zone
        var spr_w = sprite_get_width(spr_idx);
        var spr_h = sprite_get_height(spr_idx);
        var scale_x = portrait_width / spr_w;
        var scale_y = portrait_height / spr_h;
        // Garder le ratio (fill) ou fit ? Fit est mieux pour ne pas couper.
        var scale = min(scale_x, scale_y);
        
        var ox = sprite_get_xoffset(spr_idx);
        var oy = sprite_get_yoffset(spr_idx);
        
        // Centrer
        var draw_px = portrait_x + (portrait_width - spr_w * scale) / 2;
        var draw_py = portrait_y + (portrait_height - spr_h * scale) / 2;
        
        // Ajuster pour l'origine du sprite
        draw_px += ox * scale;
        draw_py += oy * scale;
        
        draw_sprite_ext(spr_idx, 0, draw_px, draw_py, scale, scale, 0, c_white, 1);
        has_portrait = true;
    }
}

// Texte placeholder si pas de portrait
if (!has_portrait) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(get_font("text", 14));
    draw_shadow_text(portrait_x + portrait_width/2, portrait_y + portrait_height/2, "PORTRAIT\nPLACEHOLDER", text_color);
}

content_y += portrait_height + 30;

// === DESCRIPTION ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(get_font("text", 18));
draw_shadow_text(content_x, content_y, "Description:", text_color);
content_y += line_height;

// Dessiner la description (simple, sans retour à la ligne automatique)
draw_set_font(get_font("text", 16));
draw_shadow_text_ext(content_x, content_y, bot_description, line_height, content_w, text_color);
content_y += string_height_ext(bot_description, line_height, content_w);

content_y += 20;

// === DECK UTILISÉ ===
draw_set_font(get_font("text", 18));
// Afficher le nom thématique du deck
var deck_theme_name = bot_deck;
draw_shadow_text(content_x, content_y, fit_text_to_width(deck_theme_name, content_w), text_color);
content_y += 30;
content_y += 20;

// Remettre les alignements par défaut
draw_set_halign(fa_left);
draw_set_valign(fa_top);

content_y += 26;

var deck_cards = get_bot_deck_cards(bot_info.deck_id);
var counts = {};
for (var i = 0; i < array_length(deck_cards); i++) {
    var cid = deck_cards[i];
    var cur = variable_struct_exists(counts, cid) ? counts[$ cid] : 0;
    variable_struct_set(counts, cid, cur + 1);
}
var keys = variable_struct_get_names(counts);
var db = getDatabase();
for (var j = 0; j < array_length(keys); j++) {
    var objId = keys[j];
    var qty = counts[$ objId];
    var disp = objId;
    if (db != noone && instance_exists(db)) {
        var cards_all = dbGetAllCards();
        for (var k = 0; k < array_length(cards_all); k++) {
            var card = cards_all[k];
            if (variable_struct_exists(card, "objectId") && card.objectId == objId) { disp = card.name; break; }
        }
    }
    draw_set_font(get_font("text", 16));
    draw_shadow_text(content_x, content_y, fit_text_to_width("x" + string(qty) + " - " + disp, content_w), text_color);
    content_y += 22;
}
