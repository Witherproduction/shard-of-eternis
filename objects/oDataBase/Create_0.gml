// === Base de données des cartes ===
// Assurer la persistance pour que la DB soit accessible partout
persistent = true;

if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}
show_debug_message("### oDataBase.create");

// Structure principale de la base de données
cardDatabase = {};

// Fonction pour ajouter une carte à la base de données
addCard = function(cardId, cardData) {
    cardDatabase[$ cardId] = cardData;
    show_debug_message("Carte ajoutée: " + cardId);
};

// Fonction pour récupérer une carte par son ID
getCard = function(cardId) {
    if (variable_struct_exists(cardDatabase, cardId)) {
        return cardDatabase[$ cardId];
    }
    show_debug_message("Carte non trouvée: " + cardId);
    return undefined;
};

// Fonction pour rechercher des cartes par type
getCardsByType = function(cardType) {
    var results = [];
    var keys = variable_struct_get_names(cardDatabase);
    
    for (var i = 0; i < array_length(keys); i++) {
        var card = cardDatabase[$ keys[i]];
        if (card.type == cardType) {
            array_push(results, card);
        }
    }
    
    return results;
};

// Fonction pour rechercher des cartes par nom
getCardsByName = function(searchName) {
    var results = [];
    var keys = variable_struct_get_names(cardDatabase);
    
    for (var i = 0; i < array_length(keys); i++) {
        var card = cardDatabase[$ keys[i]];
        if (string_pos(string_lower(searchName), string_lower(card.name)) > 0) {
            array_push(results, card);
        }
    }
    
    return results;
};

// Fonction pour obtenir toutes les cartes
getAllCards = function() {
    var results = [];
    var keys = variable_struct_get_names(cardDatabase);
    
    for (var i = 0; i < array_length(keys); i++) {
        array_push(results, cardDatabase[$ keys[i]]);
    }
    
    return results;
};

// Fonction pour rechercher des cartes par race
getCardsByRace = function(raceName) {
    var results = [];
    var keys = variable_struct_get_names(cardDatabase);
    
    for (var i = 0; i < array_length(keys); i++) {
        var card = cardDatabase[$ keys[i]];
        if (variable_struct_exists(card, "race") && string_lower(card.race) == string_lower(raceName)) {
            array_push(results, card);
        }
    }
    
    return results;
};

// Fonction pour obtenir les cartes par rareté
getCardsByRarity = function(rarity) {
    var results = [];
    var keys = variable_struct_get_names(cardDatabase);
    
    for (var i = 0; i < array_length(keys); i++) {
        var card = cardDatabase[$ keys[i]];
        if (card.rarity == rarity) {
            array_push(results, card);
        }
    }
    
    return results;
};

// Initialiser la base de données avec les cartes existantes
    // IMPORTANT: On utilise la nouvelle fonction robuste de sDeckPersistence
    // Cette fonction gère automatiquement:
    // 1. La synchronisation (Mise à jour AppData si Install > AppData)
    // 2. La réparation (Copie Install -> AppData si AppData vide/corrompu)
    // 3. Le chargement (Lecture depuis AppData uniquement)
    // load_cards_database_from_file(); // DÉPLACÉ PLUS BAS

    // --- MISE A JOUR DB FORCEE DEPUIS LES OBJETS (DEV TOOL) ---
    // Cette ligne régénère le JSON à partir des objets GML (oCardParent children)
    // Utile quand les stats dans l'IDE ont changé mais pas le JSON.
    // À désactiver en release ou une fois la DB à jour.
    // regenerate_database_from_objects();
    
    // NETTOYAGE CACHE FORCE : Pour s'assurer que la nouvelle DB générée est bien chargée
    // On supprime le fichier du cache AppData pour forcer la copie depuis les Included Files
    if (variable_global_exists("dev_force_db_cache_clear") && global.dev_force_db_cache_clear && file_exists(CARDS_DATABASE_SAVE_FILE)) {
        file_delete(CARDS_DATABASE_SAVE_FILE);
        show_debug_message("### DEV: Cache DB supprimé pour forcer la mise à jour.");
    }
    // -----------------------------------------------------------
    
    // Amorçage des decks: copier vers AppData si absent
    var wd_decks_datafile = DECK_SAVE_FILE;      // working_directory/datafiles/saved_decks.json
    var wd_decks_rootfile = "saved_decks.json"; // working_directory/saved_decks.json
    var has_wd_decks = file_exists(wd_decks_datafile) || file_exists(wd_decks_rootfile);
    if (!has_wd_decks) {
        var exe_decks_df = program_directory + "datafiles/saved_decks.json";
        var exe_decks_root = program_directory + "saved_decks.json";
        show_debug_message("### Seed check: WD has decks? " + string(has_wd_decks) + ", probing EXE...");
        if (file_exists(exe_decks_df)) {
            directory_create("datafiles");
            var okd = file_copy(exe_decks_df, wd_decks_datafile);
            show_debug_message("### Seed copy DECKS from EXE datafiles -> WD: " + string(okd));
        } else if (file_exists(exe_decks_root)) {
            var okdr = file_copy(exe_decks_root, wd_decks_rootfile);
            show_debug_message("### Seed copy DECKS from EXE root -> WD: " + string(okdr));
        } else {
            show_debug_message("### Seed failed: no decks file found beside EXE");
        }
    }
    
    // Essayer de charger la base de données sauvegardée d'abord
    if (variable_global_exists("dev_regen_db_on_boot") && global.dev_regen_db_on_boot) {
        directory_create("datafiles");
        if (script_exists(asset_get_index("regenerate_database_from_objects"))) {
            regenerate_database_from_objects();
        } else {
            show_debug_message("### DEV: Auto-regen activée mais script regenerate_database_from_objects introuvable (sDevTools pas dans le projet).");
        }
    }
    var database_loaded = load_cards_database_from_file();
    
    if (!database_loaded) {
        show_debug_message("Base de données initialisée avec " + string(array_length(variable_struct_get_names(cardDatabase))) + " cartes par défaut");
        dbRemoveTestCards();
        show_debug_message("Base de données après suppression des cartes de test: " + string(array_length(variable_struct_get_names(cardDatabase))) + " cartes");
        save_cards_database_to_file();
    }
    
    var _keys = variable_struct_get_names(cardDatabase);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _card = cardDatabase[$ _keys[_i]];
        if (is_struct(_card) && variable_struct_exists(_card, "booster")) {
            var _b = string(_card.booster);
            var _n = string_lower(_b);
            _n = string_replace_all(_n, "�", "e");
            _n = string_replace_all(_n, "é", "e");
            if (string_pos("a la decouverte du monde", _n) > 0) {
                _card.booster = "Retour des Archontes";
            }
        }
    }
    
    // Charger les decks sauvegardés
    var decks_loaded = load_decks_from_file();
    show_debug_message("Decks chargés: " + string(get_deck_count()) + " deck(s)");

    // Charger les favoris sauvegardés
    // Amorçage des favoris: copier vers AppData si absent
    var wd_fav_datafile = FAVORITES_SAVE_FILE;      // working_directory/datafiles/favorite_cards.json
    var wd_fav_rootfile = "favorite_cards.json";   // working_directory/favorite_cards.json
    var has_wd_fav = file_exists(wd_fav_datafile) || file_exists(wd_fav_rootfile);
    if (!has_wd_fav) {
        var exe_fav_df = program_directory + "datafiles/favorite_cards.json";
        var exe_fav_root = program_directory + "favorite_cards.json";
        show_debug_message("### Seed check: WD has favorites? " + string(has_wd_fav) + ", probing EXE...");
        if (file_exists(exe_fav_df)) {
            directory_create("datafiles");
            var okf = file_copy(exe_fav_df, wd_fav_datafile);
            show_debug_message("### Seed copy FAVORITES from EXE datafiles -> WD: " + string(okf));
        } else if (file_exists(exe_fav_root)) {
            var okfr = file_copy(exe_fav_root, wd_fav_rootfile);
            show_debug_message("### Seed copy FAVORITES from EXE root -> WD: " + string(okfr));
        } else {
            show_debug_message("### Seed failed: no favorites file found beside EXE");
        }
    }

    // Charger les favoris sauvegardés
    load_favorites_from_file();
    show_debug_message("Favoris chargés: " + string(get_favorites_count()) + " cartes favorites");

   show_debug_message("Base de données finale: " + string(array_length(variable_struct_get_names(cardDatabase))) + " cartes au total");
