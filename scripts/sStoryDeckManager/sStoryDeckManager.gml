/// @function get_story_hero_decks(chapter_id)
/// @description Retourne les decks héros disponibles pour un chapitre donné
/// @param {real} chapter_id - Le numéro du chapitre
function get_story_hero_decks(chapter_id) {
    switch(chapter_id) {
        case 0: return get_hero_decks_tuto();
        case 1: return get_hero_decks_chap1();
        case 2: return get_hero_decks_chap2();
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
        case 2: return get_bot_decks_chap2();
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

/// @function get_chapter_bot_order(chapter_id)
/// @description Ordre des decks bots d'un chapitre (source unique, même principe que ch1_order dans oGame).
/// Ch.1 : slots histoire 1–7. Ch.2 : slots histoire 8–14 (index 0 du tableau = bot 8).
function get_chapter_bot_order(chapter_id) {
    switch (chapter_id) {
        case 1:
            return [
                "Invasion_Gueule_Roche",
                "Essaim_Abyssien",
                "Bandit_Grand_Chemin",
                "Matriarche_Peau_Roc",
                "Recolteur_Recolte_Sournoise",
                "Armee_des_Skarls",
                "Terreur_de_la_foret"
            ];
        case 2:
            return [
                "Eclaireurs_Ordre_Sang_Pur",
                "Inquisiteur_Malvadius",
                "Gregor_Vieille_Aube",
                "Oeil_Putride",
                "Roi_Necromancien",
                "Kelthazar",
                "Grande_Pretresse_Sang_Pur"
            ];
        default:
            return [];
    }
}

/// @function get_chapter_bot_first_slot(chapter_id)
/// @description Premier numéro de slot histoire / Contre IA pour ce chapitre.
function get_chapter_bot_first_slot(chapter_id) {
    switch (chapter_id) {
        case 1: return 1;
        case 2: return 8;
        default: return 1;
    }
}

/// @function get_story_slot_for_bot_deck_id(deck_id)
/// @description Slot global 1–14 à partir d'un id string ou d'un numéro legacy.
function get_story_slot_for_bot_deck_id(deck_id) {
    if (deck_id == noone || deck_id == undefined) return 0;

    if (is_real(deck_id)) {
        var n = floor(deck_id);
        if (n >= 1 && n <= 14) return n;
    }

    var id_str = string(deck_id);
    if (id_str == "" || id_str == "0") return 0;

    if (string_digits(id_str) == id_str) {
        var num = floor(real(id_str));
        if (num >= 1 && num <= 14) return num;
    }

    for (var ch = 1; ch <= 2; ch++) {
        var order = get_chapter_bot_order(ch);
        var first = get_chapter_bot_first_slot(ch);
        for (var i = 0; i < array_length(order); i++) {
            if (order[i] == id_str) return first + i;
        }
    }
    return 0;
}

/// @function resolve_bot_deck_id_for_chapter(chapter_id, raw_id)
/// @description Convertit un slot numérique (ex. 8 ou "9") en id string canonique du deck.
function resolve_bot_deck_id_for_chapter(chapter_id, raw_id) {
    if (raw_id == noone || raw_id == undefined) return raw_id;

    var order = get_chapter_bot_order(chapter_id);
    if (array_length(order) == 0) return raw_id;

    var id_str = is_string(raw_id) ? string(raw_id) : string(raw_id);
    for (var i = 0; i < array_length(order); i++) {
        if (order[i] == id_str) return order[i];
    }

    var first = get_chapter_bot_first_slot(chapter_id);
    var slot = -1;
    if (is_real(raw_id)) {
        slot = floor(raw_id);
    } else if (string_digits(id_str) == id_str && id_str != "") {
        slot = floor(real(id_str));
    }

    if (slot >= first && slot < first + array_length(order)) {
        return order[slot - first];
    }
    return raw_id;
}
