
/// @description Initialisation du Quest Manager
// Ce gestionnaire est PERSISTANT
persistent = true;

// === VARIABLES ===
quest_slots = {
    "A": noone, // Instance de Quest
    "B": noone,
    "C": noone
};

reroll_available = true;
last_reset_date = ""; // YYYY-MM-DD
next_reset_time = 0;  // Timestamp
check_timer = 0;      // Timer pour vérifier le reset périodiquement

// === INITIALISATION ===
function init_quests() {
    // Tenter de charger depuis la sauvegarde globale
    if (variable_global_exists("progression_data") && variable_struct_exists(global.progression_data, "daily_quests")) {
        load_quest_data(global.progression_data.daily_quests);
    } else {
        // Première fois : Générer tout
        generate_new_quests();
        save_quest_data();
    }
    
    // Vérifier si un reset est nécessaire (4h du matin)
    check_daily_reset();
}

function check_daily_reset() {
    var now = date_current_datetime();
    var today_str = string(date_get_year(now)) + "-" + string(date_get_month(now)) + "-" + string(date_get_day(now));
    
    // Si pas de date de dernier reset, on initialise
    if (last_reset_date == "") {
        last_reset_date = today_str;
        // Calculer le prochain reset (Demain 4h00)
        var tomorrow = date_inc_day(now, 1);
        next_reset_time = date_create_datetime(date_get_year(tomorrow), date_get_month(tomorrow), date_get_day(tomorrow), 4, 0, 0);
        return;
    }
    
    // Vérifier si on a dépassé l'heure de reset
    // Logique simplifiée : Si on est un nouveau jour ET qu'il est passé 4h
    // OU si on a dépassé le timestamp prévu
    
    var _current_hour = date_get_hour(now);
    
    // Si la date stockée est différente d'aujourd'hui
    if (last_reset_date != today_str) {
        // Si on est après 4h du matin, c'est un nouveau jour de jeu
        if (_current_hour >= 4) {
             perform_daily_reset();
        } else {
            // On est avant 4h du matin, donc on est techniquement encore dans la "journée de jeu" d'hier
            // Sauf si le last_reset_date date d'avant-hier...
            // Pour faire simple : on compare les jours absolus
            var days_diff = date_day_span(date_create_datetime(real(string_copy(last_reset_date, 1, 4)), real(string_copy(last_reset_date, 6, 2)), real(string_copy(last_reset_date, 9, 2)), 4, 0, 0), now);
            if (days_diff >= 1.0) {
                 perform_daily_reset();
            }
        }
    }
}

function perform_daily_reset() {
    show_debug_message("### DAILY QUEST RESET ###");
    
    // Reset des flags
    reroll_available = true;
    
    // Générer de nouvelles quêtes (ou reset progress ?)
    // Le user dit : "Les quete se reset automatiquement" -> Nouvelles quêtes
    generate_new_quests();
    
    // Update date
    var now = date_current_datetime();
    // Si avant 4h, on considère que le reset a eu lieu pour "la veille" (cas rare de reset forcé)
    // Mais ici on vient de passer 4h.
    last_reset_date = string(date_get_year(now)) + "-" + string(date_get_month(now)) + "-" + string(date_get_day(now));
    
    save_quest_data();
}

function generate_new_quests() {
    // Slot A : Toujours Win 3 - Reward 60
    quest_slots.A = new Quest("win_3", "A", "Gagner 3 parties", 3, 60);
    
    // Slot B : Random Type B
    var id_b = get_random_quest_id_by_type("B");
    var def_b = get_quest_database()[$ id_b];
    // Force reward to 25 for Type B
    quest_slots.B = new Quest(id_b, "B", def_b.desc, def_b.target, 25);
    
    // Slot C : Random Type C
    var id_c = get_random_quest_id_by_type("C");
    var def_c = get_quest_database()[$ id_c];
    // Force reward to 25 for Type C
    quest_slots.C = new Quest(id_c, "C", def_c.desc, def_c.target, 25);
}

function reroll_quest(_slot_key) { // "B" ou "C"
    if (!reroll_available) return false;
    if (_slot_key == "A") return false; // Slot A fixe
    
    var old_quest = quest_slots[$ _slot_key];
    if (old_quest == noone) return false;
    if (old_quest.claimed) return false; // Déjà fini
    
    var new_id = get_random_quest_id_by_type(_slot_key, old_quest.id);
    if (new_id == "") return false;
    
    var def = get_quest_database()[$ new_id];
    var reward_val = 25; // Force 25 for rerolled quests B/C
    quest_slots[$ _slot_key] = new Quest(new_id, _slot_key, def.desc, def.target, reward_val);
    
    reroll_available = false;
    save_quest_data();
    return true;
}

function claim_reward(_slot_key) {
    var q = quest_slots[$ _slot_key];
    if (q != noone && !q.claimed && q.current_progress >= q.target_amount) {
        q.claimed = true;
        
        // Give Gold
        if (variable_global_exists("gold_coins")) {
            add_gold(q.reward_amount);
        }
        
        save_quest_data();
        return true;
    }
    return false;
}

// === SAUVEGARDE / CHARGEMENT ===

function save_quest_data() {
    var data = {
        last_reset: last_reset_date,
        reroll: reroll_available,
        quests: {}
    };
    
    if (quest_slots.A != noone) data.quests.A = quest_slots.A.to_save_struct();
    if (quest_slots.B != noone) data.quests.B = quest_slots.B.to_save_struct();
    if (quest_slots.C != noone) data.quests.C = quest_slots.C.to_save_struct();
    
    if (!variable_global_exists("progression_data")) global.progression_data = {};
    global.progression_data.daily_quests = data;
    
    // Sauvegarder physiquement via le ProgressionManager
    if (variable_instance_exists(oGlobalManager, "save_progression")) {
        // oGlobalManager ne gère pas la save directement, c'est sProgressionManager
        progression_save();
    } else {
        progression_save();
    }
}

function load_quest_data(_data) {
    if (variable_struct_exists(_data, "last_reset")) last_reset_date = _data.last_reset;
    if (variable_struct_exists(_data, "reroll")) reroll_available = _data.reroll;
    
    if (variable_struct_exists(_data, "quests")) {
        var qdata = _data.quests;
        var db = get_quest_database();
        
        // Helper to reconstruct
        var reconstruct = function(_slot, _q_struct, _db) {
            if (!variable_struct_exists(_q_struct, "id")) return noone;
            var def = _db[$ _q_struct.id];
            if (def == undefined) return noone; // Quête n'existe plus dans la DB
            
            var q = new Quest(_q_struct.id, def.type, def.desc, def.target, def.reward);
            q.load_from_struct(_q_struct);
            return q;
        };
        
        if (variable_struct_exists(qdata, "A")) quest_slots.A = reconstruct("A", qdata.A, db);
        if (variable_struct_exists(qdata, "B")) quest_slots.B = reconstruct("B", qdata.B, db);
        if (variable_struct_exists(qdata, "C")) quest_slots.C = reconstruct("C", qdata.C, db);
    }
    
    // Si des slots sont vides (bug ou 1ère fois partielle), on remplit
    if (quest_slots.A == noone) quest_slots.A = new Quest("win_3", "A", "Gagner 3 parties", 3, 100);
    if (quest_slots.B == noone) {
        var id_b = get_random_quest_id_by_type("B");
        var def_b = get_quest_database()[$ id_b];
        quest_slots.B = new Quest(id_b, "B", def_b.desc, def_b.target, def_b.reward);
    }
    if (quest_slots.C == noone) {
        var id_c = get_random_quest_id_by_type("C");
        var def_c = get_quest_database()[$ id_c];
        quest_slots.C = new Quest(id_c, "C", def_c.desc, def_c.target, def_c.reward);
    }
}

// === EVENT HOOKS ===

function notify_event(_type, _amount = 1, _context = undefined) {
    var changed = false;
    
    // Helper pour check une quête en utilisant la logique globale
    var check_q = function(q, _t, _a, _c) {
        if (q == noone || q.claimed || q.is_completed()) return false;
        
        // Utiliser la fonction globale définie dans sQuestSystem.gml
        if (check_quest_match(q, _t, _c)) {
            return q.update_progress(_a);
        }
        return false;
    };
    
    if (check_q(quest_slots.A, _type, _amount, _context)) changed = true;
    if (check_q(quest_slots.B, _type, _amount, _context)) changed = true;
    if (check_q(quest_slots.C, _type, _amount, _context)) changed = true;
    
    if (changed) {
        save_quest_data();
    }
}

// Démarrer
init_quests();
