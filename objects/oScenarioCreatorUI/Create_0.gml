var k = min(room_width / 1920, room_height / 1080);
if (!variable_global_exists("current_chapter")) global.current_chapter = 1;
if (!variable_global_exists("current_act")) global.current_act = 1;

 speaker1 = { x: room_width * 0.25, y: room_height * 0.55, w: 420 * k, h: 640 * k };
 speaker2 = { x: room_width * 0.75, y: room_height * 0.55, w: 420 * k, h: 640 * k };
 speaker3 = { x: room_width * 0.50, y: room_height * 0.55, w: 420 * k, h: 640 * k };
textbox  = { x: 1012, y: 967.4, w: 1200 * k, h: 220 * k, margin: 24 * k };
object1  = { x: room_width * 0.35, y: room_height * 0.30, w: 300 * k, h: 300 * k };
object2  = { x: room_width * 0.65, y: room_height * 0.30, w: 300 * k, h: 300 * k };

dragging = "";
offset_x = 0;
offset_y = 0;
resizing = "";
resize_start_mouse_x = 0;
resize_start_mouse_y = 0;
resize_start_w = 0;
resize_start_h = 0;
resize_handle_size = 28 * k;
min_resize_w = 120 * k;
min_resize_h = 120 * k;

function rect_contains(r, px, py) {
    var l = r.x - r.w * 0.5;
    var t = r.y - r.h * 0.5;
    var rt = r.x + r.w * 0.5;
    var b = r.y + r.h * 0.5;
    return (px >= l && px <= rt && py >= t && py <= b);
}

 timeline = [];
  current = { speaker: 1, text: "", bg_name: "", portrait1_name: "", portrait2_name: "", portrait3_name: "", obj1_name: "", obj2_name: "", duel_deck_hero: "", duel_deck_bot: "", duel_bot_id: 0, duel_player_deck: noone, bg_sound: "", bg_sound2: "", speaker1_flip: false, speaker2_flip: false, speaker3_flip: false, obj1_flip: false, obj2_flip: false, wait_after_ms: 600, duel_reward_type: "None", duel_reward_value: "" };
input_mode = "";
str_input = "";
cursor_pos = 0;

btn_w = 280 * k;
btn_h = 64 * k;
btn_margin = 24 * k;
btn_save_hover = false;
btn_delete_hover = false;
btn_export_hover = false;
btn_save_x1 = 0;
btn_save_y1 = 0;
btn_save_x2 = 0;
btn_save_y2 = 0;
btn_export_x1 = 0;
btn_export_y1 = 0;
btn_export_x2 = 0;
btn_export_y2 = 0;
btn_delete_x1 = 0;
btn_delete_y1 = 0;
btn_delete_x2 = 0;
btn_delete_y2 = 0;
btn_load_hover = false;
btn_load_x1 = 0;
btn_load_y1 = 0;
btn_load_x2 = 0;
 btn_load_y2 = 0;
 btn_addsound_x1 = 0;
 btn_addsound_y1 = 0;
 btn_addsound_x2 = 0;
 btn_addsound_y2 = 0;
 btn_addsound_hover = false;
 sounds_field_x1 = 0; sounds_field_y1 = 0; sounds_field_x2 = 0; sounds_field_y2 = 0;
 btn_sounds_minus_x1 = 0; btn_sounds_minus_y1 = 0; btn_sounds_minus_x2 = 0; btn_sounds_minus_y2 = 0;
 btn_sounds_plus_x1 = 0; btn_sounds_plus_y1 = 0; btn_sounds_plus_x2 = 0; btn_sounds_plus_y2 = 0;
btn_scene_minus_hover = false;
btn_scene_plus_hover = false;
btn_scene_minus_x1 = 0;
btn_scene_minus_y1 = 0;
btn_scene_minus_x2 = 0;
btn_scene_minus_y2 = 0;
btn_scene_plus_x1 = 0;
btn_scene_plus_y1 = 0;
btn_scene_plus_x2 = 0;
btn_scene_plus_y2 = 0;

editor_scenes = [];
scene_idx = -1;
line_idx = -1;

field_focused = "";
sp1_field_x1 = 0; sp1_field_y1 = 0; sp1_field_x2 = 0; sp1_field_y2 = 0;
sp2_field_x1 = 0; sp2_field_y1 = 0; sp2_field_x2 = 0; sp2_field_y2 = 0;
obj1_field_x1 = 0; obj1_field_y1 = 0; obj1_field_x2 = 0; obj1_field_y2 = 0;
obj2_field_x1 = 0; obj2_field_y1 = 0; obj2_field_x2 = 0; obj2_field_y2 = 0;
text_field_x1 = 0; text_field_y1 = 0; text_field_x2 = 0; text_field_y2 = 0;
bg_field_x1 = 0; bg_field_y1 = 0; bg_field_x2 = 0; bg_field_y2 = 0;
btn_bg_x1 = 0; btn_bg_y1 = 0; btn_bg_x2 = 0; btn_bg_y2 = 0; btn_bg_hover = false;

sp3_field_x1 = 0; sp3_field_y1 = 0; sp3_field_x2 = 0; sp3_field_y2 = 0;
sp3_flip_btn_x1 = 0; sp3_flip_btn_y1 = 0; sp3_flip_btn_x2 = 0; sp3_flip_btn_y2 = 0;
bg_sound_field_x1 = 0; bg_sound_field_y1 = 0; bg_sound_field_x2 = 0; bg_sound_field_y2 = 0;
bg_sound2_field_x1 = 0; bg_sound2_field_y1 = 0; bg_sound2_field_x2 = 0; bg_sound2_field_y2 = 0;

chap_field_x1 = 0; chap_field_y1 = 0; chap_field_x2 = 0; chap_field_y2 = 0;
act_field_x1 = 0; act_field_y1 = 0; act_field_x2 = 0; act_field_y2 = 0;
scene_field_x1 = 0; scene_field_y1 = 0; scene_field_x2 = 0; scene_field_y2 = 0;
btn_chap_minus_x1 = 0; btn_chap_minus_y1 = 0; btn_chap_minus_x2 = 0; btn_chap_minus_y2 = 0; btn_chap_minus_hover = false;
btn_chap_plus_x1 = 0; btn_chap_plus_y1 = 0; btn_chap_plus_x2 = 0; btn_chap_plus_y2 = 0; btn_chap_plus_hover = false;
btn_act_minus_x1 = 0; btn_act_minus_y1 = 0; btn_act_minus_x2 = 0; btn_act_minus_y2 = 0; btn_act_minus_hover = false;
btn_act_plus_x1 = 0; btn_act_plus_y1 = 0; btn_act_plus_x2 = 0; btn_act_plus_y2 = 0; btn_act_plus_hover = false;

duel_field_x1 = 0; duel_field_y1 = 0; duel_field_x2 = 0; duel_field_y2 = 0;

btn_quit_x1 = 0; btn_quit_y1 = 0; btn_quit_x2 = 0; btn_quit_y2 = 0; btn_quit_hover = false;

btn_anchor_x1 = 0; btn_anchor_y1 = 0; btn_anchor_x2 = 0; btn_anchor_y2 = 0; btn_anchor_hover = false;
anchor_locked = false;

 dropdown_open_for = "";
dd_x1 = 0; dd_y1 = 0; dd_x2 = 0; dd_y2 = 0; dd_item_h = 0;
 sp1_eff_btn_x1 = 0; sp1_eff_btn_y1 = 0; sp1_eff_btn_x2 = 0; sp1_eff_btn_y2 = 0;
 sp2_eff_btn_x1 = 0; sp2_eff_btn_y1 = 0; sp2_eff_btn_x2 = 0; sp2_eff_btn_y2 = 0;
 sp3_eff_btn_x1 = 0; sp3_eff_btn_y1 = 0; sp3_eff_btn_x2 = 0; sp3_eff_btn_y2 = 0;
obj1_eff_btn_x1 = 0; obj1_eff_btn_y1 = 0; obj1_eff_btn_x2 = 0; obj1_eff_btn_y2 = 0;
obj2_eff_btn_x1 = 0; obj2_eff_btn_y1 = 0; obj2_eff_btn_x2 = 0; obj2_eff_btn_y2 = 0;
text_eff_btn_x1 = 0; text_eff_btn_y1 = 0; text_eff_btn_x2 = 0; text_eff_btn_y2 = 0;

effect_options = ["Aucune", "Fondu", "FonduInverse", "DeplacementAB", "SlideGauche", "SlideDroite", "SlideHaut", "SlideBas", "SlideGaucheInverse", "SlideDroiteInverse", "SlideHautInverse", "SlideBasInverse", "Pop", "Pulse", "Glow", "RotationIn"];
 selected_effect_portrait1 = "Aucune";
 selected_effect_portrait2 = "Aucune";
 selected_effect_portrait3 = "Aucune";
selected_effect_obj1 = "Aucune";
selected_effect_obj2 = "Aucune";
selected_effect_text = "Aucune";

 line_field_x1 = 0; line_field_y1 = 0; line_field_x2 = 0; line_field_y2 = 0;
 btn_line_minus_x1 = 0; btn_line_minus_y1 = 0; btn_line_minus_x2 = 0; btn_line_minus_y2 = 0; btn_line_minus_hover = false;
 btn_line_plus_x1 = 0; btn_line_plus_y1 = 0; btn_line_plus_x2 = 0; btn_line_plus_y2 = 0; btn_line_plus_hover = false;
 btn_line_add_x1 = 0; btn_line_add_y1 = 0; btn_line_add_x2 = 0; btn_line_add_y2 = 0; btn_line_add_hover = false;
 btn_line_del_x1 = 0; btn_line_del_y1 = 0; btn_line_del_x2 = 0; btn_line_del_y2 = 0; btn_line_del_hover = false;
 timer_field_x1 = 0; timer_field_y1 = 0; timer_field_x2 = 0; timer_field_y2 = 0;
 btn_spkr1_x1 = 0; btn_spkr1_y1 = 0; btn_spkr1_x2 = 0; btn_spkr1_y2 = 0; btn_spkr1_hover = false;
 btn_spkr2_x1 = 0; btn_spkr2_y1 = 0; btn_spkr2_x2 = 0; btn_spkr2_y2 = 0; btn_spkr2_hover = false;

 // Flags d'activation des cadres
 sp1_enabled = true; sp2_enabled = true; sp3_enabled = false; obj1_enabled = true; obj2_enabled = true; textbox_enabled = true;
 speakers_count = 2;
 objects_count = 2;
 sounds_count = 0;

// Boutons ON/OFF pour les cadres
btn_sp1_toggle_x1 = 0; btn_sp1_toggle_y1 = 0; btn_sp1_toggle_x2 = 0; btn_sp1_toggle_y2 = 0; btn_sp1_toggle_hover = false;
 btn_sp2_toggle_x1 = 0; btn_sp2_toggle_y1 = 0; btn_sp2_toggle_x2 = 0; btn_sp2_toggle_y2 = 0; btn_sp2_toggle_hover = false;
 btn_sp3_toggle_x1 = 0; btn_sp3_toggle_y1 = 0; btn_sp3_toggle_x2 = 0; btn_sp3_toggle_y2 = 0; btn_sp3_toggle_hover = false;
 speakers_field_x1 = 0; speakers_field_y1 = 0; speakers_field_x2 = 0; speakers_field_y2 = 0;
 btn_speakers_minus_x1 = 0; btn_speakers_minus_y1 = 0; btn_speakers_minus_x2 = 0; btn_speakers_minus_y2 = 0;
 btn_speakers_plus_x1 = 0; btn_speakers_plus_y1 = 0; btn_speakers_plus_x2 = 0; btn_speakers_plus_y2 = 0;
 objects_field_x1 = 0; objects_field_y1 = 0; objects_field_x2 = 0; objects_field_y2 = 0;
 btn_objects_minus_x1 = 0; btn_objects_minus_y1 = 0; btn_objects_minus_x2 = 0; btn_objects_minus_y2 = 0;
 btn_objects_plus_x1 = 0; btn_objects_plus_y1 = 0; btn_objects_plus_x2 = 0; btn_objects_plus_y2 = 0;
btn_obj1_toggle_x1 = 0; btn_obj1_toggle_y1 = 0; btn_obj1_toggle_x2 = 0; btn_obj1_toggle_y2 = 0; btn_obj1_toggle_hover = false;
btn_obj2_toggle_x1 = 0; btn_obj2_toggle_y1 = 0; btn_obj2_toggle_x2 = 0; btn_obj2_toggle_y2 = 0; btn_obj2_toggle_hover = false;
btn_text_toggle_x1 = 0; btn_text_toggle_y1 = 0; btn_text_toggle_x2 = 0; btn_text_toggle_y2 = 0; btn_text_toggle_hover = false;

// --- GESTION DES DECKS DUEL ---
load_decks_from_file();

refresh_deck_options = function() {
    // Initialisation des options de decks Joueur (priorité aux decks histoire du chapitre)
    player_deck_options = [];
    var story_hero_decks = get_story_hero_decks(global.current_chapter);

    // On ajoute les decks histoire
    if (is_array(story_hero_decks)) {
        for (var i = 0; i < array_length(story_hero_decks); i++) {
            array_push(player_deck_options, story_hero_decks[i]);
        }
    }

    // On ajoute aussi les decks personnalisés du joueur (optionnel, après les decks histoire)
    if (variable_global_exists("saved_decks") && is_array(global.saved_decks)) {
        for (var i = 0; i < array_length(global.saved_decks); i++) {
            array_push(player_deck_options, global.saved_decks[i]);
        }
    }

    player_deck_index = -1;
    if (array_length(player_deck_options) > 0) {
        player_deck_index = 0;
    }

    // Initialisation des options de decks Bot (priorité aux decks histoire du chapitre)
    bot_deck_options = [];
    var story_bot_decks = get_story_bot_decks(global.current_chapter);

    if (is_array(story_bot_decks) && array_length(story_bot_decks) > 0) {
        bot_deck_options = story_bot_decks;
    } else {
        // Fallback sur les anciens decks statiques si aucun deck histoire n'est trouvé
        bot_deck_options = [
            {id: 1, name: "Bête (Normal)"},
            {id: 2, name: "Abyssien (Moyen)"},
            {id: 3, name: "Voleur (Aggro)"},
            {id: 4, name: "Skarl (Control)"},
            {id: 5, name: "Maître (Difficile)"},
            {id: 11, name: "Guerrier"},
            {id: 12, name: "Magique"},
            {id: 13, name: "Support"},
            {id: 14, name: "Hybride"}
        ];
    }
    bot_deck_index = 0;
};

act_reward_type = "None";
act_reward_value = "";
show_act_settings_window = false;

// Initial call
refresh_deck_options();

btn_duel_config_x1 = 0; btn_duel_config_y1 = 0; btn_duel_config_x2 = 0; btn_duel_config_y2 = 0; btn_duel_config_hover = false;
btn_duel_test_x1 = 0; btn_duel_test_y1 = 0; btn_duel_test_x2 = 0; btn_duel_test_y2 = 0; btn_duel_test_hover = false;

// Duel Configuration Window
show_duel_window = false;
duel_window_x = 0;
duel_window_y = 0;
duel_window_w = 1000 * k;
duel_window_h = 700 * k;
duel_list_scroll_player = 0;
duel_list_scroll_bot = 0;

// Notification system
save_notification_timer = 0;
save_notification_text = "";
export_notification_timer = 0;
export_notification_text = "";

scenario_export_project_root = "";
scenario_export_last_target_path = "";
scenario_export_last_error = "";

scenario_read_text_file = function(path) {
    if (!file_exists(path)) return "";
    var buff = buffer_load(path);
    if (buff == -1) return "";
    var content = buffer_read(buff, buffer_text);
    buffer_delete(buff);
    if (string_length(content) > 0 && string_ord_at(content, 1) == 65279) content = string_delete(content, 1, 1);
    return content;
};

scenario_parse_json_safe = function(s) {
    try {
        return json_parse(s);
    } catch (e) {
        show_debug_message("### ScenarioCreatorUI: JSON parse error: " + string(e));
        return undefined;
    }
};

// Répétition des touches pour l'édition de texte
key_repeat_key = -1;
key_repeat_timer = 0;
key_repeat_delay = 20;
key_repeat_interval = 3;

load_scene_data = function(sc) {
    current.bg_name = sc.bg;
    if (variable_struct_exists(sc, "bg_sound")) current.bg_sound = sc.bg_sound; else current.bg_sound = "";
    if (variable_struct_exists(sc, "bg_sound2")) current.bg_sound2 = sc.bg_sound2; else current.bg_sound2 = "";
    if (variable_struct_exists(sc, "portrait1_name")) current.portrait1_name = sc.portrait1_name; else current.portrait1_name = "";
    if (variable_struct_exists(sc, "speaker1_flip")) current.speaker1_flip = sc.speaker1_flip; else current.speaker1_flip = false;
    if (variable_struct_exists(sc, "portrait2_name")) current.portrait2_name = sc.portrait2_name; else current.portrait2_name = "";
    if (variable_struct_exists(sc, "speaker2_flip")) current.speaker2_flip = sc.speaker2_flip; else current.speaker2_flip = false;
    if (variable_struct_exists(sc, "portrait3_name")) current.portrait3_name = sc.portrait3_name; else current.portrait3_name = "";
    if (variable_struct_exists(sc, "speaker3_flip")) current.speaker3_flip = sc.speaker3_flip; else current.speaker3_flip = false;
    if (variable_struct_exists(sc, "obj1_name")) current.obj1_name = sc.obj1_name; else current.obj1_name = "";
    if (variable_struct_exists(sc, "obj1_flip")) current.obj1_flip = sc.obj1_flip; else current.obj1_flip = false;
    if (variable_struct_exists(sc, "obj2_name")) current.obj2_name = sc.obj2_name; else current.obj2_name = "";
    if (variable_struct_exists(sc, "obj2_flip")) current.obj2_flip = sc.obj2_flip; else current.obj2_flip = false;
    
    if (variable_struct_exists(sc, "speaker1_x")) speaker1.x = sc.speaker1_x;
    if (variable_struct_exists(sc, "speaker1_y")) speaker1.y = sc.speaker1_y;
    if (variable_struct_exists(sc, "speaker1_w")) speaker1.w = sc.speaker1_w;
    if (variable_struct_exists(sc, "speaker1_h")) speaker1.h = sc.speaker1_h;
    if (variable_struct_exists(sc, "speaker2_x")) speaker2.x = sc.speaker2_x;
    if (variable_struct_exists(sc, "speaker2_y")) speaker2.y = sc.speaker2_y;
    if (variable_struct_exists(sc, "speaker2_w")) speaker2.w = sc.speaker2_w;
    if (variable_struct_exists(sc, "speaker2_h")) speaker2.h = sc.speaker2_h;
    if (variable_struct_exists(sc, "speaker3_x")) speaker3.x = sc.speaker3_x;
    if (variable_struct_exists(sc, "speaker3_y")) speaker3.y = sc.speaker3_y;
    if (variable_struct_exists(sc, "speaker3_w")) speaker3.w = sc.speaker3_w;
    if (variable_struct_exists(sc, "speaker3_h")) speaker3.h = sc.speaker3_h;
    
    if (variable_struct_exists(sc, "obj1_x")) object1.x = sc.obj1_x;
    if (variable_struct_exists(sc, "obj1_y")) object1.y = sc.obj1_y;
    if (variable_struct_exists(sc, "obj1_w")) object1.w = sc.obj1_w;
    if (variable_struct_exists(sc, "obj1_h")) object1.h = sc.obj1_h;
    if (variable_struct_exists(sc, "obj2_x")) object2.x = sc.obj2_x;
    if (variable_struct_exists(sc, "obj2_y")) object2.y = sc.obj2_y;
    if (variable_struct_exists(sc, "obj2_w")) object2.w = sc.obj2_w;
    if (variable_struct_exists(sc, "obj2_h")) object2.h = sc.obj2_h;
    
    if (variable_struct_exists(sc, "textbox_x")) textbox.x = sc.textbox_x;
    if (variable_struct_exists(sc, "textbox_y")) textbox.y = sc.textbox_y;
    
    if (variable_struct_exists(sc, "duel_bot_id")) current.duel_bot_id = sc.duel_bot_id; else current.duel_bot_id = 0;
    if (variable_struct_exists(sc, "duel_player_deck")) current.duel_player_deck = sc.duel_player_deck; else current.duel_player_deck = noone;
    
    if (variable_struct_exists(sc, "portrait1_effect")) selected_effect_portrait1 = sc.portrait1_effect; else selected_effect_portrait1 = "Aucune";
    if (variable_struct_exists(sc, "portrait2_effect")) selected_effect_portrait2 = sc.portrait2_effect; else selected_effect_portrait2 = "Aucune";
    if (variable_struct_exists(sc, "portrait3_effect")) selected_effect_portrait3 = sc.portrait3_effect; else selected_effect_portrait3 = "Aucune";
    if (variable_struct_exists(sc, "obj1_effect")) selected_effect_obj1 = sc.obj1_effect; else selected_effect_obj1 = "Aucune";
    if (variable_struct_exists(sc, "obj2_effect")) selected_effect_obj2 = sc.obj2_effect; else selected_effect_obj2 = "Aucune";
    if (variable_struct_exists(sc, "text_effect")) selected_effect_text = sc.text_effect; else selected_effect_text = "Aucune";
    
    if (variable_struct_exists(sc, "sp1_enabled")) sp1_enabled = sc.sp1_enabled; else sp1_enabled = true;
    if (variable_struct_exists(sc, "sp2_enabled")) sp2_enabled = sc.sp2_enabled; else sp2_enabled = true;
    if (variable_struct_exists(sc, "obj1_enabled")) obj1_enabled = sc.obj1_enabled; else obj1_enabled = true;
    if (variable_struct_exists(sc, "obj2_enabled")) obj2_enabled = sc.obj2_enabled; else obj2_enabled = true;
    if (variable_struct_exists(sc, "textbox_enabled")) textbox_enabled = sc.textbox_enabled; else textbox_enabled = true;
    
    if (variable_struct_exists(sc, "is_act_end")) current.is_act_end = sc.is_act_end; else current.is_act_end = false;
    if (variable_struct_exists(sc, "act_reward_type")) act_reward_type = sc.act_reward_type; else act_reward_type = "None";
    if (variable_struct_exists(sc, "act_reward_value")) act_reward_value = sc.act_reward_value; else act_reward_value = "";
    
    timeline = is_array(sc.lines) ? sc.lines : [];
    if (array_length(timeline) > 0) {
        line_idx = 0;
        var line_data = timeline[line_idx];
        current.speaker = line_data.speaker;
        current.text = line_data.text;
        
        if (variable_struct_exists(line_data, "portrait1_name")) current.portrait1_name = line_data.portrait1_name;
        if (variable_struct_exists(line_data, "portrait2_name")) current.portrait2_name = line_data.portrait2_name;
        if (variable_struct_exists(line_data, "portrait3_name")) current.portrait3_name = line_data.portrait3_name;
        if (variable_struct_exists(line_data, "obj1_name")) current.obj1_name = line_data.obj1_name;
        if (variable_struct_exists(line_data, "obj2_name")) current.obj2_name = line_data.obj2_name;
        
        if (variable_struct_exists(line_data, "wait_after_ms")) current.wait_after_ms = line_data.wait_after_ms; else if (variable_struct_exists(line_data, "wait_after")) current.wait_after_ms = line_data.wait_after; else current.wait_after_ms = 600;
        
        if (variable_struct_exists(line_data, "speaker1_flip")) current.speaker1_flip = line_data.speaker1_flip;
        if (variable_struct_exists(line_data, "speaker2_flip")) current.speaker2_flip = line_data.speaker2_flip;
        if (variable_struct_exists(line_data, "speaker3_flip")) current.speaker3_flip = line_data.speaker3_flip;
        if (variable_struct_exists(line_data, "obj1_flip")) current.obj1_flip = line_data.obj1_flip;
        if (variable_struct_exists(line_data, "obj2_flip")) current.obj2_flip = line_data.obj2_flip;
        
        if (variable_struct_exists(line_data, "portrait1_effect")) selected_effect_portrait1 = line_data.portrait1_effect;
        if (variable_struct_exists(line_data, "portrait2_effect")) selected_effect_portrait2 = line_data.portrait2_effect;
        if (variable_struct_exists(line_data, "portrait3_effect")) selected_effect_portrait3 = line_data.portrait3_effect;
        if (variable_struct_exists(line_data, "obj1_effect")) selected_effect_obj1 = line_data.obj1_effect;
        if (variable_struct_exists(line_data, "obj2_effect")) selected_effect_obj2 = line_data.obj2_effect;
        if (variable_struct_exists(line_data, "text_effect")) selected_effect_text = line_data.text_effect;
        
        if (variable_struct_exists(line_data, "speaker1_x")) speaker1.x = line_data.speaker1_x;
        if (variable_struct_exists(line_data, "speaker1_y")) speaker1.y = line_data.speaker1_y;
        if (variable_struct_exists(line_data, "speaker1_w")) speaker1.w = line_data.speaker1_w;
        if (variable_struct_exists(line_data, "speaker1_h")) speaker1.h = line_data.speaker1_h;
        if (variable_struct_exists(line_data, "speaker2_x")) speaker2.x = line_data.speaker2_x;
        if (variable_struct_exists(line_data, "speaker2_y")) speaker2.y = line_data.speaker2_y;
        if (variable_struct_exists(line_data, "speaker2_w")) speaker2.w = line_data.speaker2_w;
        if (variable_struct_exists(line_data, "speaker2_h")) speaker2.h = line_data.speaker2_h;
        if (variable_struct_exists(line_data, "speaker3_x")) speaker3.x = line_data.speaker3_x;
        if (variable_struct_exists(line_data, "speaker3_y")) speaker3.y = line_data.speaker3_y;
        if (variable_struct_exists(line_data, "speaker3_w")) speaker3.w = line_data.speaker3_w;
        if (variable_struct_exists(line_data, "speaker3_h")) speaker3.h = line_data.speaker3_h;
        
        if (variable_struct_exists(line_data, "obj1_x")) object1.x = line_data.obj1_x;
        if (variable_struct_exists(line_data, "obj1_y")) object1.y = line_data.obj1_y;
        if (variable_struct_exists(line_data, "obj1_w")) object1.w = line_data.obj1_w;
        if (variable_struct_exists(line_data, "obj1_h")) object1.h = line_data.obj1_h;
        if (variable_struct_exists(line_data, "obj2_x")) object2.x = line_data.obj2_x;
        if (variable_struct_exists(line_data, "obj2_y")) object2.y = line_data.obj2_y;
        if (variable_struct_exists(line_data, "obj2_w")) object2.w = line_data.obj2_w;
        if (variable_struct_exists(line_data, "obj2_h")) object2.h = line_data.obj2_h;
        
        if (variable_struct_exists(line_data, "textbox_x")) textbox.x = line_data.textbox_x;
        if (variable_struct_exists(line_data, "textbox_y")) textbox.y = line_data.textbox_y;
    } else {
        line_idx = -1;
        current.text = "";
    }
};

load_current_act_data = function() {
    var chap = global.current_chapter;
    var actn = global.current_act;
    var base_name = "scenario_chapter_" + string(chap) + "_act_" + string(actn) + ".json";
    var candidates = [
        "scenarios/ch" + string(chap) + "/" + base_name,
        "datafiles/scenarios/ch" + string(chap) + "/" + base_name,
        program_directory + "datafiles/scenarios/ch" + string(chap) + "/" + base_name,
        base_name
    ];
    var data = undefined;
    var path = "";
    var data_empty = undefined;
    var path_empty = "";
    for (var i = 0; i < array_length(candidates); i++) {
        var p = candidates[i];
        var content = scenario_read_text_file(p);
        if (content != "") {
            var parsed = scenario_parse_json_safe(content);
            if (!is_undefined(parsed)) {
                var has_scenes = variable_struct_exists(parsed, "scenes") && is_array(parsed.scenes) && array_length(parsed.scenes) > 0;
                if (has_scenes) {
                    data = parsed;
                    path = p;
                    break;
                } else if (is_undefined(data_empty)) {
                    data_empty = parsed;
                    path_empty = p;
                }
            }
        }
    }
    if (is_undefined(data) && !is_undefined(data_empty)) {
        data = data_empty;
        path = path_empty;
    }
    
    if (!is_undefined(data)) {
        show_debug_message("### ScenarioCreatorUI: LOAD_CURRENT wd=" + working_directory + " path=" + path);
        editor_scenes = data.scenes;
        scene_idx = 0;
        line_idx = 0;
        var scenes_count = array_length(editor_scenes);
        var total_lines = 0;
        var i_lines = 0;
        while (i_lines < scenes_count) {
            var scn = editor_scenes[i_lines];
            if (variable_struct_exists(scn, "lines") && is_array(scn.lines)) total_lines += array_length(scn.lines);
            i_lines += 1;
        }
        show_debug_message("### ScenarioCreatorUI: LOAD_CURRENT chap=" + string(chap) + " act=" + string(actn) + " scenes=" + string(scenes_count) + " lines=" + string(total_lines));
        if (array_length(editor_scenes) > 0) {
            load_scene_data(editor_scenes[0]);
        } else {
            scene_idx = -1;
            line_idx = -1;
            current.text = "";
            timeline = [];
        }
    } else {
        editor_scenes = [];
        scene_idx = -1;
        line_idx = -1;
        current.text = "";
        timeline = [];
    }
};

scenario_export_normalize_dir = function(p) {
    p = string_replace_all(string(p), "\\", "/");
    if (string_length(p) > 0 && string_char_at(p, string_length(p)) != "/") p += "/";
    return p;
};

scenario_export_load_settings = function() {
    ini_open("scenario_export.ini");
    scenario_export_project_root = ini_read_string("export", "project_root", "");
    ini_close();
    scenario_export_project_root = scenario_export_normalize_dir(scenario_export_project_root);
    return scenario_export_project_root;
};

scenario_export_save_settings = function(root) {
    ini_open("scenario_export.ini");
    ini_write_string("export", "project_root", scenario_export_normalize_dir(root));
    ini_close();
    scenario_export_project_root = scenario_export_normalize_dir(root);
};

scenario_export_to_included_files = function(chap, actn, json_str) {
    scenario_export_last_error = "";
    
    var base_name = "scenario_chapter_" + string(chap) + "_act_" + string(actn) + ".json";
    directory_create("datafiles");
    directory_create("datafiles/scenarios");
    directory_create("datafiles/scenarios/ch" + string(chap));
    var target = "datafiles/scenarios/ch" + string(chap) + "/" + base_name;
    var fh = file_text_open_write(target);
    if (fh < 0) {
        scenario_export_last_error = "Impossible d'ecrire dans: " + target;
        return false;
    }
    file_text_write_string(fh, json_str);
    file_text_close(fh);
    scenario_export_last_target_path = working_directory + target;
    return file_exists(target);
};

