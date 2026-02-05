function story_progress_section_name(chapter_id) {
    return "chapter_" + string(chapter_id);
}

function story_progress_read_chapter(chapter_id) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    var hero_name = ini_read_string(sec, "hero_name", "");
    var act1 = ini_read_real(sec, "act1_complete", 0);
    var act2 = ini_read_real(sec, "act2_complete", 0);
    var act3 = ini_read_real(sec, "act3_complete", 0);
    var act4 = ini_read_real(sec, "act4_complete", 0);
    ini_close();
    return {
        hero_name: hero_name,
        hero_name_revealed: (act1 == 1),
        acts_completed: [act1, act2, act3, act4]
    };
}

function story_progress_set_act_complete(chapter_id, act_num, hero_name_opt) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    ini_write_real(sec, "act" + string(act_num) + "_complete", 1);
    if (act_num == 1) {
        if (is_string(hero_name_opt) && string_length(hero_name_opt) > 0) ini_write_string(sec, "hero_name", hero_name_opt);
    }
    ini_close();
}

function story_progress_is_act_complete(chapter_id, act_num) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    var v = ini_read_real(sec, "act" + string(act_num) + "_complete", 0);
    ini_close();
    return v == 1;
}

function story_progress_unlock_reward(reward_id) {
    ini_open("progress.ini");
    ini_write_real("rewards", string(reward_id), 1);
    ini_close();
}

function story_progress_is_reward_unlocked(reward_id) {
    ini_open("progress.ini");
    var v = ini_read_real("rewards", string(reward_id), 0);
    ini_close();
    return v == 1;
}

/// @function story_progress_save_talent(hero_id, tier_index, choice_index)
/// @description Sauvegarde le choix de talent pour un tier donné (0 ou 1, ou -1 pour aucun)
function story_progress_save_talent(hero_id, tier_index, choice_index) {
    var sec = "talents_" + string(hero_id);
    ini_open("progress.ini");
    ini_write_real(sec, "tier_" + string(tier_index), choice_index);
    ini_close();
}

/// @function story_progress_get_talents(hero_id)
/// @description Retourne un tableau des choix de talents (index 0 ou 1) pour chaque tier
function story_progress_get_talents(hero_id) {
    var sec = "talents_" + string(hero_id);
    var tree = get_hero_talent_tree(hero_id);
    var results = array_create(array_length(tree), -1);
    
    ini_open("progress.ini");
    for (var i = 0; i < array_length(tree); i++) {
        results[i] = ini_read_real(sec, "tier_" + string(i), -1);
    }
    ini_close();
    return results;
}

function story_progress_read_last_scene(chapter_id) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    var li = ini_read_real(sec, "last_scene_index", 0);
    var la = ini_read_real(sec, "last_act", 1);
    ini_close();
    return { scene_index: li, act: la };
}

function story_progress_write_last_scene(chapter_id, scene_index, act_num) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    ini_write_real(sec, "last_scene_index", max(0, scene_index));
    ini_write_real(sec, "last_act", max(1, act_num));
    ini_close();
}

function story_progress_get_resume_act(chapter_id) {
    var sec = story_progress_section_name(chapter_id);
    ini_open("progress.ini");
    var act1 = ini_read_real(sec, "act1_complete", 0);
    var act2 = ini_read_real(sec, "act2_complete", 0);
    var act3 = ini_read_real(sec, "act3_complete", 0);
    var act4 = ini_read_real(sec, "act4_complete", 0);
    var la = ini_read_real(sec, "last_act", 0);
    ini_close();
    
    // If last_act is valid, use it. Otherwise, find first incomplete act.
    if (la >= 1 && la <= 4) return la;
    
    if (act1 == 0) return 1;
    if (act2 == 0) return 2;
    if (act3 == 0) return 3;
    if (act4 == 0) return 4;
    return 1; // Default to 1 if all complete or error
}
