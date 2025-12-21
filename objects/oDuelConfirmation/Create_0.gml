// Dimensions
width = 600;
height = 200;
x = (room_width - width) / 2;
y = (room_height - height) / 2;

// Button
btn_width = 160;
btn_height = 50;
btn_x = x + (width - btn_width) / 2;
btn_y = y + height - btn_height - 30;

text = "Un duel est sur le point de commencer !";

// Default setup (can be overridden but usually pulled from scenario runner)
selected_bot_deck_id = 1;
selected_player_deck = noone;
