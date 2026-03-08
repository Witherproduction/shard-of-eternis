// Dimensions
width = 600;
height = 300; // Increased height to fit deck selector
x = (room_width - width) / 2;
y = (room_height - height) / 2;

// Button
btn_width = 160;
btn_height = 50;
btn_x = x + (width - btn_width) / 2;
btn_y = y + height - btn_height - 30;

// Custom Deck Selection Variables
use_custom_deck = false;
selected_custom_deck_index = 0;
custom_deck_list = [];

// Load decks if not present
if (!variable_global_exists("saved_decks") || array_length(global.saved_decks) == 0) {
    load_decks_from_file();
}
if (variable_global_exists("saved_decks")) {
    custom_deck_list = global.saved_decks;
}

// UI Coordinates
checkbox_x = x + width/2 - 100; // Centered somewhat
checkbox_y = y + 130;
checkbox_size = 20;

selector_x = x + width/2;
selector_y = y + 170;
selector_w = 300;
selector_h = 30;
selector_left_btn_x = selector_x - selector_w/2;
selector_right_btn_x = selector_x + selector_w/2 - 30; // 30px button width

text = "Un duel est sur le point de commencer !";

// Default setup (can be overridden but usually pulled from scenario runner)
selected_bot_deck_id = "Invasion_Gueule_Roche";
selected_player_deck = noone;

