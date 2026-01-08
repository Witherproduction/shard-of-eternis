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
/// @param {real} deck_id - L'ID du deck
function get_bot_deck_by_id_new(deck_id) {
    // Recherche dans le chapitre 0
    var decks0 = get_bot_decks_tuto();
    for(var i = 0; i < array_length(decks0); i++) {
        if (decks0[i].id == deck_id) return decks0[i];
    }

    // Recherche dans le chapitre 1
    var decks = get_bot_decks_chap1();
    for(var i = 0; i < array_length(decks); i++) {
        if (decks[i].id == deck_id) return decks[i];
    }
    
    // Ajouter d'autres chapitres ici au fur et à mesure
    
    return undefined;
}

/// @function get_bot_deck_cards_new(deck_id)
/// @description Wrapper de compatibilité pour récupérer juste les cartes
/// @param {real} deck_id - L'ID du deck
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
    
    // Chapitre 0 (Tuto)
    var chap0 = get_bot_decks_tuto();
    for(var i = 0; i < array_length(chap0); i++) {
        array_push(all_decks, chap0[i]);
    }
    
    // Chapitre 1
    var chap1 = get_bot_decks_chap1();
    for(var i = 0; i < array_length(chap1); i++) {
        array_push(all_decks, chap1[i]);
    }
    
    // Future intégration du Chapitre 2
    // var chap2 = get_bot_decks_chap2();
    // for(var i = 0; i < array_length(chap2); i++) {
    //     array_push(all_decks, chap2[i]);
    // }
    
    return all_decks;
}
