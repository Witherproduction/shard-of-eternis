/// @function Quest(_id, _type, _desc, _target, _reward)
/// @description Constructeur de quête
function Quest(_id, _type, _desc, _target, _reward) constructor {
    id = _id;
    type = _type; // "A", "B", "C"
    description = _desc;
    target_amount = _target;
    reward_amount = _reward;
    
    current_progress = 0;
    claimed = false;
    
    /// @function update_progress(amount)
    static update_progress = function(_amount) {
        if (claimed) return false;
        if (current_progress >= target_amount) return false;
        
        current_progress += _amount;
        if (current_progress > target_amount) current_progress = target_amount;
        return true;
    }
    
    /// @function is_completed()
    static is_completed = function() {
        return current_progress >= target_amount;
    }
    
    /// @function to_save_struct()
    static to_save_struct = function() {
        return {
            id: id,
            progress: current_progress,
            claimed: claimed
        };
    }
    
    /// @function load_from_struct(data)
    static load_from_struct = function(_data) {
        if (variable_struct_exists(_data, "progress")) current_progress = _data.progress;
        if (variable_struct_exists(_data, "claimed")) claimed = _data.claimed;
    }
}

/// @function get_quest_database()
/// @description Retourne la base de données de toutes les quêtes possibles
function get_quest_database() {
    return {
        // QUETE A (Fixe)
        "win_3": { type: "A", desc: "Gagner 3 parties", target: 3, reward: 60 },
        
        // QUETES B (Mécaniques)
        "dmg_hero_60": { type: "B", desc: "Infliger 60 dégâts aux héros ennemis", target: 60, reward: 25 },
        "dmg_total_120": { type: "B", desc: "Infliger 120 dégâts totaux", target: 120, reward: 25 },
        "attack_15": { type: "B", desc: "Attaquer 15 fois", target: 15, reward: 25 },
        "destroy_10_minions": { type: "B", desc: "Détruire 10 serviteurs ennemis", target: 10, reward: 25 },
        "minion_dmg_20": { type: "B", desc: "Infliger des dégâts avec des serviteurs 20 fois", target: 20, reward: 25 },
        "survive_25_turns": { type: "B", desc: "Survivre à 25 tours cumulés", target: 25, reward: 25 },
        
        "play_10_eveil": { type: "B", desc: "Jouer 10 cartes avec le tag Eveil", target: 10, reward: 25 },
        "play_10_illusion": { type: "B", desc: "Jouer 10 cartes avec le tag Illusion", target: 10, reward: 25 },
        "ally_death_10": { type: "B", desc: "Faire mourir 10 serviteur allié", target: 10, reward: 25 },
        
        "entrave_8": { type: "B", desc: "Entraver 8 serviteur adverse", target: 8, reward: 25 },
        "attack_entraved_5": { type: "B", desc: "Attaquer une cible entraver 5 fois", target: 5, reward: 25 },
        
        "attack_ambidextrie_10": { type: "B", desc: "Attaquer 10 fois avec ambidextrie", target: 10, reward: 25 },
        "dmg_ambidextrie_40": { type: "B", desc: "Infliger 40 dégats avec ambidextrie", target: 40, reward: 25 },
        
        "play_20_cards": { type: "B", desc: "Jouer 20 cartes", target: 20, reward: 25 },
        "summon_15_minions": { type: "B", desc: "Invoquer 15 serviteur", target: 15, reward: 25 },
        "spend_mana_60": { type: "B", desc: "Dépenser 60 mana", target: 60, reward: 25 },
        "draw_15_cards": { type: "B", desc: "Piocher 15 cartes", target: 15, reward: 25 },
        
        "play_10_charge": { type: "B", desc: "Jouer 10 cartes avec le tag Charge", target: 10, reward: 25 },
        "play_10_camouflage": { type: "B", desc: "Jouer 10 cartes avec le tag Camouflage", target: 10, reward: 25 },
        "play_8_brise": { type: "B", desc: "Jouer 8 cartes avec le tag Brisé", target: 8, reward: 25 },
        "heal_40": { type: "B", desc: "Soigner 40 points de vie (alliés)", target: 40, reward: 25 },
        
        // QUETES C — genres : objectif 15 (sauf Terrain, peu de cartes)
        "play_15_spells": { type: "C", desc: "Jouer 15 cartes Sort", target: 15, reward: 25 },
        "play_15_beasts": { type: "C", desc: "Jouer 15 cartes Bête", target: 15, reward: 25 },
        "play_15_humanoids": { type: "C", desc: "Jouer 15 cartes Humanoïde", target: 15, reward: 25 },
        "play_15_undead": { type: "C", desc: "Jouer 15 cartes Mort-vivant", target: 15, reward: 25 },
        "play_15_secrets": { type: "C", desc: "Poser 15 cartes Secret", target: 15, reward: 25 },
        "play_5_terrain": { type: "C", desc: "Jouer 5 cartes Terrain", target: 5, reward: 25 },
        
        // QUETES C — races jouables (pas Ombre/Nature : magies spécifiques)
        "play_10_humans": { type: "C", desc: "Jouer 10 cartes Humain", target: 10, reward: 25 },
        "play_10_skarls": { type: "C", desc: "Jouer 10 cartes Skarl", target: 10, reward: 25 },
        "play_10_abyssians": { type: "C", desc: "Jouer 10 cartes Abyssien", target: 10, reward: 25 },
        "play_10_tunnelins": { type: "C", desc: "Jouer 10 cartes Tunnelin", target: 10, reward: 25 }
    };
}

/// @function create_quest_from_id(quest_id)
function create_quest_from_id(quest_id) {
    var db = get_quest_database();
    if (variable_struct_exists(db, quest_id)) {
        var data = db[$ quest_id];
        return new Quest(quest_id, data.type, data.desc, data.target, data.reward);
    }
    return undefined;
}

/// @function get_random_quest_id_by_type(type, exclude_id)
function get_random_quest_id_by_type(_type, _exclude_id = "") {
    var db = get_quest_database();
    var candidates = [];
    var names = variable_struct_get_names(db);
    
    for (var i = 0; i < array_length(names); i++) {
        var key = names[i];
        var data = db[$ key];
        if (data.type == _type && key != _exclude_id) {
            array_push(candidates, key);
        }
    }
    
    if (array_length(candidates) > 0) {
        return candidates[irandom(array_length(candidates) - 1)];
    }
    return "";
}

// === HELPERS ===

/// @function quest_helper_get_context_prop(ctx, prop)
function quest_helper_get_context_prop(ctx, prop) {
    if (ctx == undefined) return undefined;
    // Direct property (if ctx is the object)
    if (is_struct(ctx) && variable_struct_exists(ctx, prop)) return ctx[$ prop];
    if (instance_exists(ctx) && variable_instance_exists(ctx, prop)) return variable_instance_get(ctx, prop);
    
    // Wrapped card property
    if (is_struct(ctx)) {
        if (variable_struct_exists(ctx, "card")) {
            var c = ctx.card;
            if (is_struct(c) && variable_struct_exists(c, prop)) return c[$ prop];
            if (instance_exists(c) && variable_instance_exists(c, prop)) return variable_instance_get(c, prop);
        }
        if (variable_struct_exists(ctx, "source")) {
            var s = ctx.source;
            if (is_struct(s) && variable_struct_exists(s, prop)) return s[$ prop];
            if (instance_exists(s) && variable_instance_exists(s, prop)) return variable_instance_get(s, prop);
        }
    }
    return undefined;
}

/// @function quest_helper_normalize_str(s)
function quest_helper_normalize_str(s) {
    var r = string_lower(string(s));
    r = string_replace_all(r, "à", "a"); r = string_replace_all(r, "â", "a"); r = string_replace_all(r, "ä", "a");
    r = string_replace_all(r, "é", "e"); r = string_replace_all(r, "è", "e"); r = string_replace_all(r, "ê", "e"); r = string_replace_all(r, "ë", "e");
    r = string_replace_all(r, "î", "i"); r = string_replace_all(r, "ï", "i");
    r = string_replace_all(r, "ô", "o"); r = string_replace_all(r, "ö", "o");
    r = string_replace_all(r, "ù", "u"); r = string_replace_all(r, "û", "u"); r = string_replace_all(r, "ü", "u");
    r = string_replace_all(r, "ç", "c");
    return r;
}

/// @function quest_helper_check_tag_prop(ctx, tag_to_check)
function quest_helper_check_tag_prop(ctx, tag_to_check) {
    var tags_arr = quest_helper_get_context_prop(ctx, "tags");
    var target = quest_helper_normalize_str(tag_to_check);
    if (is_array(tags_arr)) {
        for (var i = 0; i < array_length(tags_arr); i++) {
            if (quest_helper_normalize_str(tags_arr[i]) == target) return true;
        }
    }
    return false;
}

/// @function quest_helper_match_play_filter(ctx, genre_keys, race_keys, tag_keys)
/// @description Vrai si la carte jouée correspond à un genre, une race ou un tag (tableaux de clés normalisées)
function quest_helper_match_play_filter(_ctx, _genre_keys, _race_keys, _tag_keys) {
    if (_ctx == undefined) return false;
    var card_genre = quest_helper_normalize_str(quest_helper_get_context_prop(_ctx, "genre"));
    var card_race = quest_helper_normalize_str(quest_helper_get_context_prop(_ctx, "race"));
    var card_type = quest_helper_normalize_str(quest_helper_get_context_prop(_ctx, "type"));
    
    if (is_array(_genre_keys)) {
        for (var gi = 0; gi < array_length(_genre_keys); gi++) {
            if (card_genre == _genre_keys[gi]) return true;
        }
    }
    if (is_array(_race_keys)) {
        for (var ri = 0; ri < array_length(_race_keys); ri++) {
            if (card_race == _race_keys[ri]) return true;
        }
    }
    if (is_array(_tag_keys)) {
        for (var ti = 0; ti < array_length(_tag_keys); ti++) {
            if (quest_helper_check_tag_prop(_ctx, _tag_keys[ti])) return true;
        }
    }
    // Secret : genre ou type dédié
    if (is_array(_genre_keys)) {
        for (var si = 0; si < array_length(_genre_keys); si++) {
            if (_genre_keys[si] == "secret" && (card_type == "secret" || card_genre == "secret")) return true;
        }
    }
    return false;
}

/// @function check_quest_match(quest, type, context)
function check_quest_match(_q, _t, _c) {
    var q = _q;
    var match = false;
    
    // Type A (Win)
    if (_t == "win" && q.id == "win_3") match = true;
    
    // Type B (Generic)
    if (q.type == "B") {
        if (_t == "damage_hero" && q.id == "dmg_hero_60") match = true;
        if (_t == "deal_damage") {
            if (q.id == "dmg_total_120") match = true;
            
            // Minion damage
            if (q.id == "minion_dmg_20") {
                var sType = quest_helper_normalize_str(quest_helper_get_context_prop(_c, "type"));
                var sGenre = quest_helper_normalize_str(quest_helper_get_context_prop(_c, "genre"));
                // Check if source is minion/monster/creature
                if (sType == "monster" || sType == "minion" || sType == "creature" || sGenre == "bête" || sGenre == "soldat") {
                    match = true;
                }
            }
            
            // Ambidextrie damage
            if (q.id == "dmg_ambidextrie_40") {
                if (quest_helper_check_tag_prop(_c, "ambidextrie")) match = true;
                if (quest_helper_get_context_prop(_c, "isAmbidextrous") == true) match = true;
                if (quest_helper_get_context_prop(_c, "has_ambidextrie") == true) match = true;
                // Check effects text or keyword if tag not present (fallback)
                var efText = quest_helper_get_context_prop(_c, "effects_text");
                if (is_string(efText) && string_pos("Ambidextrie", efText) > 0) match = true;
            }
        }
        
        if (_t == "attack") {
            if (q.id == "attack_15") match = true;
            
            // Ambidextrie attack
            if (q.id == "attack_ambidextrie_10") {
                if (quest_helper_check_tag_prop(_c, "ambidextrie")) match = true;
                if (quest_helper_get_context_prop(_c, "isAmbidextrous") == true) match = true;
                if (quest_helper_get_context_prop(_c, "has_ambidextrie") == true) match = true;
                var efText = quest_helper_get_context_prop(_c, "effects_text");
                if (is_string(efText) && string_pos("Ambidextrie", efText) > 0) match = true;
            }
        }
        
        if (_t == "destroy_minion" && q.id == "destroy_10_minions") match = true;
        
        if (_t == "end_turn" && q.id == "survive_25_turns") match = true;
        
        if (_t == "ally_minion_death" && q.id == "ally_death_10") match = true;
        
        if (_t == "apply_effect") {
            var ef = "";
            if (_c != undefined && variable_struct_exists(_c, "effect")) ef = _c.effect;
            
            if (q.id == "entrave_8" && ef == "Entrave") match = true;
        }
        
        if (_t == "attack_entraved" && q.id == "attack_entraved_5") match = true;
        
        if (_t == "summon") {
            if (q.id == "summon_15_minions") match = true; // Assuming only minions trigger "summon" usually
        }
        
        if (_t == "play_card") {
            if (q.id == "play_20_cards") match = true;
            if (q.id == "play_10_eveil" && quest_helper_check_tag_prop(_c, "eveil")) match = true;
            if (q.id == "play_10_illusion") {
                if (quest_helper_check_tag_prop(_c, "illusion")) match = true;
                if (quest_helper_get_context_prop(_c, "has_illusion") == true) match = true;
                var illVal = quest_helper_get_context_prop(_c, "illusion");
                if (illVal != undefined && illVal > 0) match = true;
            }
            if (q.id == "play_10_charge") {
                if (quest_helper_check_tag_prop(_c, "charge")) match = true;
                if (quest_helper_get_context_prop(_c, "has_charge") == true) match = true;
            }
            if (q.id == "play_10_camouflage" && quest_helper_check_tag_prop(_c, "camouflage")) match = true;
            if (q.id == "play_8_brise" && quest_helper_check_tag_prop(_c, "brisé")) match = true;
        }
        
        if (_t == "heal" && q.id == "heal_40") {
            if (_c != undefined && variable_struct_exists(_c, "owner_is_hero") && _c.owner_is_hero) match = true;
        }
        
        if (_t == "spend_mana" && q.id == "spend_mana_60") match = true;
        
        if (_t == "draw" && q.id == "draw_15_cards") match = true;
    }

    // Type C (Spécifique)
    if (_t == "play_card" && q.type == "C") {
        if (_c != undefined) {
            var card_genre = quest_helper_normalize_str(quest_helper_get_context_prop(_c, "genre"));
            var card_race = quest_helper_normalize_str(quest_helper_get_context_prop(_c, "race"));
            var card_type = quest_helper_normalize_str(quest_helper_get_context_prop(_c, "type"));
            
            if (q.id == "play_15_spells" && (card_type == "spell" || card_type == "sort" || card_type == "magic" || quest_helper_check_tag_prop(_c, "sort") || quest_helper_check_tag_prop(_c, "spell"))) match = true;
            if (q.id == "play_15_beasts" && quest_helper_match_play_filter(_c, ["bete"], ["bete"], ["bete"])) match = true;
            if (q.id == "play_15_humanoids" && quest_helper_match_play_filter(_c, ["humanoide"], ["humanoide"], ["humanoide"])) match = true;
            if (q.id == "play_15_undead" && quest_helper_match_play_filter(_c, ["mort-vivant"], ["zombie", "goule", "squelette", "fantome", "banshee"], ["mort-vivant"])) match = true;
            
            if (q.id == "play_10_abyssians" && quest_helper_match_play_filter(_c, noone, ["abyssien"], ["abyssien"])) match = true;
            if (q.id == "play_10_tunnelins" && quest_helper_match_play_filter(_c, noone, ["tunnelin"], ["tunnelin"])) match = true;
            if (q.id == "play_10_skarls" && quest_helper_match_play_filter(_c, noone, ["skarl"], ["skarl"])) match = true;
            if (q.id == "play_10_humans" && quest_helper_match_play_filter(_c, noone, ["humain"], ["humain"])) match = true;
            
            if (q.id == "play_15_secrets" && quest_helper_match_play_filter(_c, ["secret"], noone, ["secret"])) match = true;
            if (q.id == "play_5_terrain" && quest_helper_match_play_filter(_c, ["terrain"], noone, ["terrain"])) match = true;
        }
    }
    
    return match;
}