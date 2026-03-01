/// @function progression_init()
/// @description Initialise les variables globales de progression et le mode admin
function progression_init() {
    if (!variable_global_exists("progression_data")) {
        global.progression_data = {
            unlocked_cards: [], // Tableau d'IDs de cartes (strings)
            unlocked_bots: [],  // Tableau d'IDs de bots (reals)
            chapters: {},       // Struct: "1": { act1: true, act2: false... }
            rewards: {},        // Struct générique pour autres récompenses
            card_counts: {},    // Dictionnaire: id -> quantité possédée
            daily_quests: {},   // Données des quêtes journalières
            starter_deck_granted: false // Flag pour le deck de départ
        };
        
        // Charger les données si le fichier existe
        progression_load();
        
        show_debug_message("### DEBUG: progression_init complete. Unlocked cards count: " + string(array_length(global.progression_data.unlocked_cards)));

        // --- STARTER DECK INITIALIZATION ---
        // Vérification plus robuste : on vérifie si le flag est absent/faux OU si une carte clé (Tarrinox) est manquante
        // Cela permet de corriger le problème si le joueur a eu des IDs incorrects ("oTarrinox") lors d'une tentative précédente
        var needs_starter_deck = false;
        
        if (!variable_struct_exists(global.progression_data, "starter_deck_granted") || global.progression_data.starter_deck_granted == false) {
            needs_starter_deck = true;
        } else {
            // Vérifier si Tarrinox (ID correct) est présent
            var has_tarrinox = false;
            for (var i = 0; i < array_length(global.progression_data.unlocked_cards); i++) {
                if (global.progression_data.unlocked_cards[i] == "tarrinox") {
                    has_tarrinox = true;
                    break;
                }
            }
            if (!has_tarrinox) {
                needs_starter_deck = true;
                show_debug_message("### DEBUG: Starter deck flag true but 'tarrinox' missing. Forcing grant.");
            }
        }

        if (needs_starter_deck) {
            show_debug_message("### DEBUG: Granting Starter Deck (Corrected IDs)...");
            var starter_deck = [
                // Base Fixe (Bêtes) - IDs CORRECTS (snake_case sans 'o')
                "tarrinox", "tarrinox", 
                "tarentule_foret", "tarentule_foret", 
                "tortue_vagabonde", "tortue_vagabonde", 
                "loup_galeux", "loup_galeux", 
                "jeune_loup", "jeune_loup", 
                "renard_mystique", "renard_mystique", 
                "vieil_ours", "vieil_ours", 
                "griffe_predateur", "griffe_predateur", 
                "saut_predateur", "saut_predateur", 
                "feuillage_protecteur", "feuillage_protecteur", 
                
                // Base Variable (Chapitre 1)
                "bougimencien_tunnelin", "bougimencien_tunnelin", 
                "mineur_tunnelin", "mineur_tunnelin", 
                "tunnelin", "tunnelin", 
                "envahisseur_geule_roche", "envahisseur_geule_roche", // Note: "geule" dans l'ID JSON
                "araignee_forestiere", "araignee_forestiere", 
                "jeune_ours_foret", "jeune_ours_foret", 
                "loup_gris_foret", "loup_gris_foret", 
                "rugissement_foret", "rugissement_foret", 
                "cri_meute", "cri_meute", 
                "patte_brise_larmoyant", "patte_brise_larmoyant"
            ];
            
            show_debug_message("### Initialization: Granting Starter Deck (Chapter 1 Deck) with verified IDs");
            for (var i = 0; i < array_length(starter_deck); i++) {
                var c = starter_deck[i];
                unlock_card(c, false);
            }
            
            // Marquer comme donné
            global.progression_data.starter_deck_granted = true;
            progression_save();
            show_debug_message("### DEBUG: Starter Deck granted and saved. New count: " + string(array_length(global.progression_data.unlocked_cards)));
        } else {
             show_debug_message("### DEBUG: Starter deck already granted and verified. Skipping.");
        }
    }
    
    if (!variable_global_exists("admin_mode")) {
        global.admin_mode = false;
    }
    
    if (!variable_global_exists("gold_coins")) {
        if (variable_struct_exists(global.progression_data, "rewards") && variable_struct_exists(global.progression_data.rewards, "gold_coins")) {
            global.gold_coins = max(0, real(global.progression_data.rewards.gold_coins));
        } else {
            global.gold_coins = 0;
        }
    }
    if (!variable_global_exists("arcane_stones")) {
        if (variable_struct_exists(global.progression_data, "rewards") && variable_struct_exists(global.progression_data.rewards, "arcane_stones")) {
            global.arcane_stones = max(0, real(global.progression_data.rewards.arcane_stones));
        } else {
            global.arcane_stones = 0;
        }
    }
}

/// @function progression_reset()
/// @description Réinitialise la progression (utile pour le debug)
function progression_reset() {
    global.progression_data = {
        unlocked_cards: [],
        unlocked_bots: [],
        chapters: {},
        rewards: { gold_coins: 0, arcane_stones: 0 },
        starter_deck_granted: false,
        daily_quests: {}
    };
    global.gold_coins = 0;
    global.arcane_stones = 0;
    progression_save();
    
    // Réinitialiser également la progression héritée (INI)
    if (file_exists("progress.ini")) {
        file_delete("progress.ini");
    }
    
    show_debug_message("### PROGRESSION RÉINITIALISÉE (Reset)");
}

/// @function progression_save()
/// @description Sauvegarde la progression dans un fichier JSON
function progression_save() {
    if (!variable_struct_exists(global.progression_data, "rewards")) {
        global.progression_data.rewards = {};
    }
    global.progression_data.rewards[$ "gold_coins"] = max(0, real(global.gold_coins));
    global.progression_data.rewards[$ "arcane_stones"] = max(0, real(global.arcane_stones));
    var json_str = json_stringify(global.progression_data);
    var f = file_text_open_write("save_player.json");
    file_text_write_string(f, json_str);
    file_text_close(f);
    show_debug_message("### Progression sauvegardée.");
}

/// @function progression_load()
/// @description Charge la progression depuis le fichier JSON
function progression_load() {
    if (file_exists("save_player.json")) {
        var f = file_text_open_read("save_player.json");
        var json_str = "";
        while (!file_text_eof(f)) {
            json_str += file_text_read_string(f);
        }
        file_text_close(f);
        
        try {
            var data = json_parse(json_str);
            // Fusionner ou écraser les données globales
            // On s'assure que la structure est valide
            if (variable_struct_exists(data, "unlocked_cards")) global.progression_data.unlocked_cards = data.unlocked_cards;
            if (variable_struct_exists(data, "unlocked_bots")) global.progression_data.unlocked_bots = data.unlocked_bots;
            if (variable_struct_exists(data, "chapters")) global.progression_data.chapters = data.chapters;
            if (variable_struct_exists(data, "rewards")) global.progression_data.rewards = data.rewards;
            if (variable_struct_exists(data, "card_counts")) global.progression_data.card_counts = data.card_counts;
            if (variable_struct_exists(data, "daily_quests")) global.progression_data.daily_quests = data.daily_quests;
            if (variable_struct_exists(data, "starter_deck_granted")) global.progression_data.starter_deck_granted = data.starter_deck_granted;
            show_debug_message("### Progression chargée.");
        } catch (e) {
            show_debug_message("### Erreur chargement progression : " + string(e));
        }
        
        if (variable_struct_exists(global.progression_data, "rewards") && variable_struct_exists(global.progression_data.rewards, "gold_coins")) {
            global.gold_coins = max(0, real(global.progression_data.rewards.gold_coins));
        } else {
            global.gold_coins = 0;
        }
        if (variable_struct_exists(global.progression_data, "rewards") && variable_struct_exists(global.progression_data.rewards, "arcane_stones")) {
            global.arcane_stones = max(0, real(global.progression_data.rewards.arcane_stones));
        } else {
            global.arcane_stones = 0;
        }
        if (!variable_struct_exists(global.progression_data, "card_counts")) {
            global.progression_data.card_counts = {};
        }
    }
}

// === GESTION DES CARTES ===

/// @function unlock_card(card_id, auto_save)
/// @description Débloque une carte pour le joueur. auto_save (bool, défaut true)
function unlock_card(card_id, auto_save) {
    if (is_undefined(auto_save)) auto_save = true;
    
    if (!variable_struct_exists(global.progression_data, "card_counts")) {
        global.progression_data.card_counts = {};
    }
    var first_time = false;
    // Ajouter au tableau des cartes débloquées si première fois
    var arr = global.progression_data.unlocked_cards;
    var found = false;
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == card_id) { found = true; break; }
    }
    if (!found) {
        array_push(global.progression_data.unlocked_cards, card_id);
        first_time = true;
    }
    var prev = 0;
    if (variable_struct_exists(global.progression_data.card_counts, card_id)) {
        prev = real(global.progression_data.card_counts[$ card_id]);
    }
    var maxc = get_max_copies_for_card_id(card_id);
    if (prev >= maxc) {
        // ... conversion en arcane stones ...
        // (Pour simplifier, on ne convertit pas si auto_save=false, ou on laisse tel quel)
        // La conversion implique add_arcane_stones qui a son propre save ? 
        // add_arcane_stones n'est pas montré ici, mais probablement.
        
        // Pour ne pas complexifier, on laisse la logique de conversion
        var rar = "commun";
        // ... (logique de rareté) ...
        var allCards2 = dbGetAllCards();
        for (var ii = 0; ii < array_length(allCards2); ii++) {
            var cc = allCards2[ii];
            if (variable_struct_exists(cc, "id") && string(cc.id) == string(card_id)) {
                rar = variable_struct_exists(cc, "rarity") ? string_lower(string(cc.rarity)) : "commun";
                break;
            }
        }
        var reward = 1;
        if (rar == "rare") {
            reward = 4;
        } else if (rar == "epique") {
            reward = 20;
        } else if (rar == "legendaire") {
            reward = 80;
        }
        // add_arcane_stones(reward); // Supposons que ça existe
        // On remplace add_arcane_stones par modification directe pour contrôler le save
        global.arcane_stones += reward;
        if (variable_struct_exists(global.progression_data, "rewards")) {
            global.progression_data.rewards[$ "arcane_stones"] = global.arcane_stones;
        }
        
        show_debug_message("### Carte convertie en Pierre arcanique : " + string(card_id));
        if (auto_save) progression_save();
    } else {
        global.progression_data.card_counts[$ card_id] = prev + 1;
        show_debug_message("### Carte obtenue : " + string(card_id) + " (x" + string(prev + 1) + ")");
        if (auto_save) progression_save();
    }
    return first_time;
}

/// @function is_card_unlocked(card_id)
/// @description Vérifie si une carte est débloquée (ou si Admin)
function is_card_unlocked(card_id) {
    if (!variable_global_exists("progression_data")) progression_init();

    if (variable_global_exists("admin_mode") && global.admin_mode) return true;
    
    var arr = global.progression_data.unlocked_cards;
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == card_id) return true;
    }
    return false;
}

/// @function get_card_count(card_id)
/// @description Retourne la quantité possédée pour une carte (0 si inconnue)
function get_card_count(card_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    if (!variable_struct_exists(global.progression_data, "card_counts")) {
        global.progression_data.card_counts = {};
    }
    if (variable_global_exists("admin_mode") && global.admin_mode) {
        return get_max_copies_for_card_id(card_id);
    }
    if (variable_struct_exists(global.progression_data.card_counts, card_id)) {
        return max(0, floor(real(global.progression_data.card_counts[$ card_id])));
    }
    return 0;
}

/// @function get_max_copies_for_card_id(card_id)
/// @description Retourne la limite d'exemplaires selon la rareté pour l'ID donné
function get_max_copies_for_card_id(card_id) {
    var DEFAULT_MAX = 3;
    var maxCopies = DEFAULT_MAX;
    var allCards = dbGetAllCards();
    for (var i = 0; i < array_length(allCards); i++) {
        var c = allCards[i];
        if (variable_struct_exists(c, "id") && string(c.id) == string(card_id)) {
            var r = variable_struct_exists(c, "rarity") ? string_lower(string(c.rarity)) : "commun";
            if (r == "legendaire") return 1;
            if (r == "epique") return 2;
            return DEFAULT_MAX; // commun/rare
        }
    }
    return maxCopies;
}

// === GESTION DES BOTS ===

/// @function unlock_bot(bot_id)
/// @description Débloque un bot dans le mode Contre IA
function unlock_bot(bot_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    var arr = global.progression_data.unlocked_bots;
    var found = false;
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == bot_id) { found = true; break; }
    }
    if (!found) {
        array_push(global.progression_data.unlocked_bots, bot_id);
        progression_save();
        show_debug_message("### Bot débloqué : " + string(bot_id));
    }
}

/// @function is_bot_unlocked(bot_id)
function is_bot_unlocked(bot_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    if (variable_global_exists("admin_mode") && global.admin_mode) return true;
    
    var arr = global.progression_data.unlocked_bots;
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == bot_id) return true;
    }
    return false;
}

// === GESTION HISTOIRE ===

/// @function unlock_act_complete(chapter_id, act_num)
function unlock_act_complete(chapter_id, act_num) {
    if (!variable_global_exists("progression_data")) progression_init();
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) {
        global.progression_data.chapters[$ ch_key] = {};
    }
    var act_key = "act" + string(act_num);
    global.progression_data.chapters[$ ch_key][$ act_key] = true;
    progression_save();
    
    // Synchronisation avec le système INI (Legacy) pour l'affichage Carousel
    story_progress_set_act_complete(chapter_id, act_num);
    
    show_debug_message("### Acte complété : Chap " + string(chapter_id) + " Acte " + string(act_num));
}

/// @function is_act_complete(chapter_id, act_num)
function is_act_complete(chapter_id, act_num) {
    if (!variable_global_exists("progression_data")) progression_init();
    if (variable_global_exists("admin_mode") && global.admin_mode) return true;
    
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) return false;
    var act_key = "act" + string(act_num);
    if (!variable_struct_exists(global.progression_data.chapters[$ ch_key], act_key)) return false;
    
    return global.progression_data.chapters[$ ch_key][$ act_key];
}

/// @function unlock_chapter_access(chapter_id)
/// @description Débloque l'accès au chapitre (généralement le précédent est fini)
function unlock_chapter_access(chapter_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) {
        global.progression_data.chapters[$ ch_key] = {};
    }
    global.progression_data.chapters[$ ch_key].unlocked = true;
    progression_save();
}

/// @function is_chapter_unlocked(chapter_id)
function is_chapter_unlocked(chapter_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    if (variable_global_exists("admin_mode") && global.admin_mode) return true;
    if (chapter_id == 0) return true; // Chapitre 0 (Tuto) toujours ouvert
    
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) return false;
    
    if (variable_struct_exists(global.progression_data.chapters[$ ch_key], "unlocked")) {
        return global.progression_data.chapters[$ ch_key].unlocked;
    }
    return false;
}

function get_gold() {
    if (!variable_global_exists("gold_coins")) progression_init();
    return max(0, real(global.gold_coins));
}

function can_afford(cost) {
    var c = max(0, floor(real(cost)));
    if (!variable_global_exists("gold_coins")) progression_init();
    return global.gold_coins >= c;
}

function add_gold(amount) {
    var a = max(0, floor(real(amount)));
    if (a <= 0) return max(0, real(global.gold_coins));
    if (!variable_global_exists("gold_coins")) progression_init();
    var v = global.gold_coins + a;
    if (v > 2147483647) v = 2147483647;
    global.gold_coins = v;
    if (!variable_struct_exists(global.progression_data, "rewards")) global.progression_data.rewards = {};
    global.progression_data.rewards[$ "gold_coins"] = global.gold_coins;
    progression_save();
    return global.gold_coins;
}

function spend_gold(amount) {
    var a = max(0, floor(real(amount)));
    if (a <= 0) return true;
    if (!variable_global_exists("gold_coins")) progression_init();
    if (global.gold_coins < a) return false;
    var v = global.gold_coins - a;
    if (v < 0) v = 0;
    global.gold_coins = v;
    if (!variable_struct_exists(global.progression_data, "rewards")) global.progression_data.rewards = {};
    global.progression_data.rewards[$ "gold_coins"] = global.gold_coins;
    progression_save();
    return true;
}

function get_arcane_stones() {
    if (!variable_global_exists("arcane_stones")) progression_init();
    return max(0, real(global.arcane_stones));
}

function add_arcane_stones(amount) {
    var a = max(0, floor(real(amount)));
    if (a <= 0) return max(0, real(global.arcane_stones));
    if (!variable_global_exists("arcane_stones")) progression_init();
    var v = global.arcane_stones + a;
    if (v > 2147483647) v = 2147483647;
    global.arcane_stones = v;
    if (!variable_struct_exists(global.progression_data, "rewards")) global.progression_data.rewards = {};
    global.progression_data.rewards[$ "arcane_stones"] = global.arcane_stones;
    progression_save();
    return global.arcane_stones;
}

function spend_arcane_stones(amount) {
    var a = max(0, floor(real(amount)));
    if (a <= 0) return true;
    if (!variable_global_exists("arcane_stones")) progression_init();
    if (global.arcane_stones < a) return false;
    var v = global.arcane_stones - a;
    if (v < 0) v = 0;
    global.arcane_stones = v;
    if (!variable_struct_exists(global.progression_data, "rewards")) global.progression_data.rewards = {};
    global.progression_data.rewards[$ "arcane_stones"] = global.arcane_stones;
    progression_save();
    return true;
}

function reset_collection_cards() {
    if (!variable_global_exists("progression_data")) progression_init();
    global.progression_data.unlocked_cards = [];
    global.progression_data.card_counts = {};
    progression_save();
    return true;
}

/// @function give_chapter_reward(chapter_id)
/// @description Donne la récompense de fin de chapitre (Légendaire) si pas déjà obtenue
function give_chapter_reward(chapter_id) {
    if (!variable_global_exists("progression_data")) progression_init();
    
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) {
        global.progression_data.chapters[$ ch_key] = {};
    }
    
    // Vérifier si déjà récompensé
    if (variable_struct_exists(global.progression_data.chapters[$ ch_key], "reward_claimed") && global.progression_data.chapters[$ ch_key].reward_claimed) {
        return false;
    }
    
    // Définir la récompense selon le chapitre
    var card_id = "";
    var card_name = "";
    
    if (chapter_id == 1) {
        card_id = "gorrak"; // Légendaire Chapitre 1
        card_name = "Gorrak";
    }
    // Ajouter d'autres chapitres si nécessaire
    
    if (card_id != "") {
        global.progression_data.chapters[$ ch_key].reward_claimed = true;
        
        // Vérifier si la carte est déjà possédée
        var count = get_card_count(card_id);
        var max_copies = get_max_copies_for_card_id(card_id);
        
        if (count >= max_copies) {
            // Carte déjà possédée au max -> Récompense alternative (320 pierres)
            add_arcane_stones(320);
            show_debug_message("### Récompense Chapitre " + string(chapter_id) + " : " + card_name + " (Déjà possédé) -> +320 Pierres Arcaniques");
        } else {
            // Carte non possédée (ou pas au max) -> Débloquer la carte
            unlock_card(card_id);
            show_debug_message("### Récompense Chapitre " + string(chapter_id) + " : " + card_name + " (Débloqué)");
        }
        
        progression_save();
        return true;
    }
    return false;
}
