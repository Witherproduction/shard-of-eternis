/// @function get_story_hero_decks(chapter_id)
/// @description Retourne les decks héros disponibles pour un chapitre donné
/// @param {real} chapter_id - Le numéro du chapitre
function get_story_hero_decks(chapter_id) {
    switch(chapter_id) {
        case 0: return get_hero_decks_tuto();
        case 1: return get_hero_decks_chap1();
        default: return [];
    }
}

/// @function get_story_bot_decks(chapter_id)
/// @description Retourne les decks bots disponibles pour un chapitre donné
/// @param {real} chapter_id - Le numéro du chapitre
function get_story_bot_decks(chapter_id) {
    switch(chapter_id) {
        case 0: return get_bot_decks_tuto();
        case 1: return get_bot_decks_chap1();
        default: return [];
    }
}

/// @function get_bot_deck_by_id_new(deck_id)
/// @description Récupère la structure complète d'un deck bot par son ID (cherche dans tous les chapitres)
/// @param {real|string} deck_id - L'ID du deck
function get_bot_deck_by_id_new(deck_id) {
    // Recherche dans tous les decks chargés
    var all_decks = get_all_bot_decks();
    for(var i = 0; i < array_length(all_decks); i++) {
        if (all_decks[i].id == deck_id) return all_decks[i];
    }
    return undefined;
}

/// @function get_bot_deck_cards_new(deck_id)
/// @description Wrapper de compatibilité pour récupérer juste les cartes
/// @param {real|string} deck_id - L'ID du deck
function get_bot_deck_cards_new(deck_id) {
    var deck = get_bot_deck_by_id_new(deck_id);
    if (!is_undefined(deck)) {
        return deck.cards;
    }
    return undefined;
}

/// @function get_all_bot_decks()
/// @description Retourne une liste agrégée de tous les decks de tous les chapitres pour le mode Contre IA
function get_all_bot_decks() {
    var all_decks = [];
    
    // Tuto
    if (script_exists(asset_get_index("get_bot_decks_tuto"))) {
        var chap0 = get_bot_decks_tuto();
        for(var i = 0; i < array_length(chap0); i++) array_push(all_decks, chap0[i]);
    }
    
    // Chapitres 1 à 10 (Dynamic)
    for (var i = 1; i <= 10; i++) {
        var func_name = "get_bot_decks_chap" + string(i);
        var func_index = asset_get_index(func_name);
        if (script_exists(func_index)) {
            var decks = script_execute(func_index);
            if (is_array(decks)) {
                for(var j = 0; j < array_length(decks); j++) array_push(all_decks, decks[j]);
            }
        }
    }
    
    return all_decks;
}

/// @function get_all_hero_decks()
/// @description Retourne une liste agrégée de tous les decks héros de tous les chapitres
function get_all_hero_decks() {
    var all_decks = [];
    
    // Tuto
    if (script_exists(asset_get_index("get_hero_decks_tuto"))) {
        var chap0 = get_hero_decks_tuto();
        for(var i = 0; i < array_length(chap0); i++) array_push(all_decks, chap0[i]);
    }
    
    // Chapitres 1 à 10 (Dynamic)
    for (var i = 1; i <= 10; i++) {
        var func_name = "get_hero_decks_chap" + string(i);
        var func_index = asset_get_index(func_name);
        if (script_exists(func_index)) {
            var decks = script_execute(func_index);
            if (is_array(decks)) {
                for(var j = 0; j < array_length(decks); j++) array_push(all_decks, decks[j]);
            }
        }
    }
    
    return all_decks;
}

/// @function load_hero_decks_from_file()
/// @description Charge les decks héros depuis les scripts uniquement (mode "à l'ancienne")
function load_hero_decks_from_file() {
    global.custom_hero_decks = get_all_hero_decks();
    show_debug_message("### Loaded hero decks from scripts only (JSON overrides disabled).");
}

/// @function load_bot_decks_from_file()
/// @description Charge les decks bots depuis les scripts uniquement (mode "à l'ancienne")
function load_bot_decks_from_file() {
    global.custom_bot_decks = get_all_bot_decks();
    show_debug_message("### Loaded bot decks from scripts only (JSON overrides disabled).");
}

/// @function save_hero_decks_to_file()
function save_hero_decks_to_file() {
    // Désactivé : on ne sauvegarde plus en JSON
    show_debug_message("### Save hero decks disabled by user request.");
}

/// @function save_bot_decks_to_file()
function save_bot_decks_to_file() {
    // Désactivé : on ne sauvegarde plus en JSON
    show_debug_message("### Save bot decks disabled by user request.");
}
