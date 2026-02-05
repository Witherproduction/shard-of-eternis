// === Script de stockage des decks des bots ===
// Ce script contient les fonctions utilitaires pour la création des decks bots.
// Les données sont maintenant centralisées dans sStoryDeckManager.gml et les fichiers JSON.

/// @function get_bot_deck_cards(deck_id)
/// @description Retourne le tableau de cartes pour un deck spécifique (via le gestionnaire central)
/// @param {real|string} deck_id - L'ID du deck à récupérer
function get_bot_deck_cards(deck_id) {
    // Récupération via le gestionnaire central (JSON/Défauts)
    var new_deck_cards = get_bot_deck_cards_new(deck_id);
    
    if (!is_undefined(new_deck_cards)) {
        return new_deck_cards;
    }
    
    // Fallback vide si introuvable
    show_debug_message("Warning: Bot deck not found for ID " + string(deck_id));
    return [];
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


/// @function create_bot_deck_from_script(deck_id, bot_name)
/// @description Crée un objet deck complet à partir de l'ID (compatible avec l'ancien système)
/// @param {real|string} deck_id - L'ID du deck
/// @param {string} bot_name - Le nom du bot (utilisé si le deck n'a pas de nom spécifique)
function create_bot_deck_from_script(deck_id, bot_name) {
    var deck_data = get_bot_deck_by_id_new(deck_id);
    var deck_cards = [];
    var final_name = "Deck de " + bot_name;
    var profile_data = undefined;
    
    if (!is_undefined(deck_data)) {
        // Utiliser les données du JSON
        deck_cards = variable_struct_exists(deck_data, "cards") ? deck_data.cards : [];
        if (variable_struct_exists(deck_data, "deck_name")) final_name = deck_data.deck_name;
        if (variable_struct_exists(deck_data, "profile")) profile_data = deck_data.profile;
        
        // Si le nom du bot est fourni dans le deck, on pourrait l'utiliser, 
        // mais ici on garde le paramètre bot_name pour la compatibilité d'affichage si nécessaire
    } else {
        // Fallback (ne devrait pas arriver si les défauts sont chargés)
        deck_cards = get_bot_deck_cards(deck_id);
    }
    
    // Logique de remplissage / capping
    // Note: Pour les decks préconstruits (Story), on évite généralement de modifier les cartes
    // sauf pour les génériques qui doivent être remplis.
    
    var is_story_deck = (is_real(deck_id) && deck_id < 100) || (is_string(deck_id) && (deck_id == "Invasion_Gueule_Roche" || deck_id == "Essaim_Abyssien" || deck_id == "Bandit_Grand_Chemin")); 
    var should_fill = true;
    
    // Si le deck a déjà >= 30 cartes, on suppose qu'il est complet (ex: James, Abyssien)
    if (array_length(deck_cards) >= 30) should_fill = false;
    
    var max_copies = 3;
    if (deck_id == 5) max_copies = 5;
    // if (deck_id == 2) max_copies = 10; // Exception maintenue pour l'Abyssien (maintenant gérée par string)
    
    // On ne cap pas les copies si c'est un deck story pré-construit qui outrepasse les règles (ex: Abyssien)
    // Sauf si on veut forcer la règle. Ici on laisse tel quel pour les decks story précis.
    if (is_string(deck_id)) { 
        // Si c'est un deck nommé string (ex: "Invasion_Gueule_Roche"), on vérifie si c'est un des decks spéciaux
        if (deck_id == "Essaim_Abyssien") {
            max_copies = 10; // Exception pour l'Abyssien
        }
        
        // Pour les decks génériques (si d'autres strings existent), on applique les règles standard ?
        // Mais ici les decks story sont précis, donc on ne devrait pas capper/remplir si c'est déjà défini.
        // On laisse tel quel sauf si besoin.
    } else if (should_fill && array_length(deck_cards) < 40) {
        // Remplissage optionnel pour les petits decks story numériques (legacy)
        // deck_cards = fill_to_size(deck_cards, 40, max_copies);
    }
    
    var bot_deck = {
        name: final_name,
        cards: deck_cards,
        deck_id: deck_id,
        bot_name: bot_name,
        card_count: array_length(deck_cards),
        profile: profile_data
    };
    
    return bot_deck;
}



/// @function get_bot_deck_name(deck_id)
/// @description Retourne le nom du deck pour l'affichage
/// @param {real} deck_id - L'ID du deck
function get_bot_deck_name(deck_id) {
    var deck = get_bot_deck_by_id_new(deck_id);
    if (!is_undefined(deck)) {
        if (variable_struct_exists(deck, "name")) return deck.name; // Nom du bot/deck
        if (variable_struct_exists(deck, "deck_name")) return deck.deck_name;
    }
    return "Bot " + string(deck_id);
}

/// @function get_bot_deck_profile(deck_id)
/// @description Retourne le libellé de profil d'archétype pour affichage
/// @param {real|string} deck_id - L'ID du deck
function get_bot_deck_profile(deck_id) {
    var deck = get_bot_deck_by_id_new(deck_id);
    if (!is_undefined(deck) && variable_struct_exists(deck, "profile")) {
        var prof = deck.profile;
        if (is_string(prof)) return prof;
        // Si c'est un struct (ex: James), on retourne un libellé générique ou on cherche un champ "name"
        return "Personnalisé"; 
    }
    return "";
}

