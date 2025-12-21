// === Script de stockage des decks des bots ===
// Ce script contient tous les decks préconfigurés pour les bots

/// @function get_bot_deck_cards(deck_id)
/// @description Retourne le tableau de cartes pour un deck spécifique
/// @param {real} deck_id - L'ID du deck à récupérer
function get_bot_deck_cards(deck_id) {
    
    // Tenter de récupérer via le nouveau gestionnaire par chapitre
    var new_deck_cards = get_bot_deck_cards_new(deck_id);
    if (!is_undefined(new_deck_cards)) {
        return new_deck_cards;
    }

    switch(deck_id) {
        // Decks génériques pour les bots 6-29
        case "Guerrier": // Deck agressif
            return [
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire",
                "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire"
            ];
            
        case "Magique": // Deck magique
            return [
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire",
                "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oDragonDivinRagnarok"
            ];
            
        case "Support": // Deck support
            return [
                "oDragonDivinRagnarok", "oSorciereDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oDragonDivinRagnarok", "oSorciereDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire",
                "oDragonDivinRagnarok", "oSorciereDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oDragonDivinRagnarok", "oSorciereDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire"
            ];
            
        case "Hybride": // Deck mixte
            return [
                "oSorciereDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oSorciereDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire",
                "oSorciereDeLaRoseNoire", "oChevalDeLaRoseNoire", "oChevalDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oDragonDivinRagnarok", "oDragonDivinRagnarok", "oDragonDivinRagnarok", "oDragonDivinRagnarok", "oDragonDivinRagnarok"
            ];
            
        default:
            // Deck par défaut
            return [
                "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire",
                "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire", "oCorbeauDeLaRoseNoire"
            ];
    }
}

// Fonction utilitaire: limite à 3 copies de chaque carte lors de la création du deck
function cap_card_copies(deck_cards, max_copies) {
    var counts = {};
    var capped = [];
    for (var i = 0; i < array_length(deck_cards); i++) {
        var card_id = deck_cards[i];
        var current = variable_struct_exists(counts, card_id) ? variable_struct_get(counts, card_id) : 0;
        if (current < max_copies) {
            variable_struct_set(counts, card_id, current + 1);
            array_push(capped, card_id);
        }
    }
    return capped;
}

// Compte le nombre de copies d'une carte dans le tableau
function count_card_copies(deck_cards, card_id) {
    var count = 0;
    for (var i = 0; i < array_length(deck_cards); i++) {
        if (deck_cards[i] == card_id) count++;
    }
    return count;
}

// Remplit le deck avec des monstres d'autres thématiques jusqu'à la taille cible
function fill_to_size(deck_cards, target_size, max_copies) {
    var pool = [
        "oChevalForet", "oSorciereForet", "oEruditForet", "oNueeCorbeaux", "oLoupAlphaForet",
        "oOmbreClairLune", "oPetaleRose", "oSqueletteReanime", "oChevalierSqueletteReanime",
        "oChevalDeLaRoseNoire", "oAraigneeSombreForet", "oDragonnetForet"
    ];
    var i = 0;
    var pool_len = array_length(pool);
    var safety = 0;
    while (array_length(deck_cards) < target_size && safety < 2000) {
        var cand = pool[i % pool_len];
        if (count_card_copies(deck_cards, cand) < max_copies) {
            array_push(deck_cards, cand);
        }
        i++;
        safety++;
    }
    return deck_cards;
}

/// @function create_bot_deck_from_script(deck_id, bot_name)
/// @description Crée un objet deck à partir du script
/// @param {real} deck_id - L'ID du deck
/// @param {string} bot_name - Le nom du bot
function create_bot_deck_from_script(deck_id, bot_name) {
    var deck_cards = get_bot_deck_cards(deck_id);
    var max_copies = (deck_id == 5) ? 5 : 3;
    deck_cards = cap_card_copies(deck_cards, max_copies);
    deck_cards = fill_to_size(deck_cards, 40, max_copies);
    
    var bot_deck = {
        name: "Deck de " + bot_name,
        cards: deck_cards,
        deck_id: deck_id,
        bot_name: bot_name,
        card_count: array_length(deck_cards)
    };
    
    return bot_deck;
}

// === Fonctions utilitaires ===

/// @function get_random_deck_type()
/// @description Retourne un type de deck aléatoire pour les bots génériques
function get_random_deck_type() {
    var deck_types = ["Guerrier", "Magique", "Support", "Hybride"];
    return deck_types[irandom(array_length(deck_types) - 1)];
}

/// @function get_bot_deck_name(deck_id)
/// @description Retourne le nom du deck pour l'affichage
/// @param {real} deck_id - L'ID du deck
function get_bot_deck_name(deck_id) {
    var deck = get_bot_deck_by_id_new(deck_id);
    if (!is_undefined(deck) && variable_struct_exists(deck, "name")) return deck.name;

    switch(deck_id) {
        // Decks génériques pour les bots 6-29
        default: return "Bot " + string(deck_id);
    }
}

/// @function get_bot_deck_profile(deck_id)
/// @description Retourne le libellé de profil d'archétype pour affichage
/// @param {real} deck_id - L'ID du deck
function get_bot_deck_profile(deck_id) {
    var deck = get_bot_deck_by_id_new(deck_id);
    if (!is_undefined(deck) && variable_struct_exists(deck, "profile")) return deck.profile;

    switch(deck_id) {
        // Profils génériques
        default: return "";
    }
}