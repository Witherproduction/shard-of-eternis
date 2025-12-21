var k = min(room_width / 1920, room_height / 1080);
if (!variable_global_exists("current_chapter")) global.current_chapter = 1;
if (!variable_global_exists("current_act")) global.current_act = 1;

 speaker1 = { x: room_width * 0.25, y: room_height * 0.55, w: 420 * k, h: 640 * k };
 speaker2 = { x: room_width * 0.75, y: room_height * 0.55, w: 420 * k, h: 640 * k };
 speaker3 = { x: room_width * 0.50, y: room_height * 0.55, w: 420 * k, h: 640 * k };
textbox  = { x: room_width * 0.5,  y: room_height * 0.88, w: 1200 * k, h: 220 * k, margin: 24 * k };
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
  current = { speaker: 1, text: "", bg_name: "", portrait1_name: "", portrait2_name: "", portrait3_name: "", obj1_name: "", obj2_name: "", duel_deck_hero: "", duel_deck_bot: "", bg_sound: "", bg_sound2: "", speaker1_flip: false, speaker2_flip: false, speaker3_flip: false, obj1_flip: false, obj2_flip: false, wait_after_ms: 600, duel_reward_type: "None", duel_reward_value: "" };
input_mode = "";
str_input = "";

btn_w = 280 * k;
btn_h = 64 * k;
btn_margin = 24 * k;
btn_save_hover = false;
btn_delete_hover = false;
btn_save_x1 = 0;
btn_save_y1 = 0;
btn_save_x2 = 0;
btn_save_y2 = 0;
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
