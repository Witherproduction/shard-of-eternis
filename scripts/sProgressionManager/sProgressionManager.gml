/// @function progression_init()
/// @description Initialise les variables globales de progression et le mode admin
function progression_init() {
    if (!variable_global_exists("progression_data")) {
        global.progression_data = {
            unlocked_cards: [], // Tableau d'IDs de cartes (strings)
            unlocked_bots: [],  // Tableau d'IDs de bots (reals)
            chapters: {},       // Struct: "1": { act1: true, act2: false... }
            rewards: {}         // Struct générique pour autres récompenses
        };
        
        // Charger les données si le fichier existe
        progression_load();
    }
    
    if (!variable_global_exists("admin_mode")) {
        global.admin_mode = false;
    }
}

/// @function progression_reset()
/// @description Réinitialise la progression (utile pour le debug)
function progression_reset() {
    global.progression_data = {
        unlocked_cards: [],
        unlocked_bots: [],
        chapters: {},
        rewards: {}
    };
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
            show_debug_message("### Progression chargée.");
        } catch (e) {
            show_debug_message("### Erreur chargement progression : " + string(e));
        }
    }
}

// === GESTION DES CARTES ===

/// @function unlock_card(card_id)
/// @description Débloque une carte pour le joueur
function unlock_card(card_id) {
    var arr = global.progression_data.unlocked_cards;
    var found = false;
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == card_id) { found = true; break; }
    }
    if (!found) {
        array_push(global.progression_data.unlocked_cards, card_id);
        progression_save();
        show_debug_message("### Carte débloquée : " + string(card_id));
        return true; // Nouvelle carte
    }
    return false; // Déjà possédée
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
    if (chapter_id == 1) return true; // Chapitre 1 toujours ouvert (pour l'instant)
    
    var ch_key = string(chapter_id);
    if (!variable_struct_exists(global.progression_data.chapters, ch_key)) return false;
    
    if (variable_struct_exists(global.progression_data.chapters[$ ch_key], "unlocked")) {
        return global.progression_data.chapters[$ ch_key].unlocked;
    }
    return false;
}
