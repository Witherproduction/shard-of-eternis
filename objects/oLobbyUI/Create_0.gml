// === oLobbyUI - Create Event ===

show_debug_message("### oLobbyUI.Create_0 - Initialisation du lobby multijoueur");

mode_text = "Aucun";

ini_open("options.ini");
var _default_ip = "127.0.0.1";
var _default_port = 6510;
ip_input = ini_read_string("network", "last_ip", _default_ip);
var _ini_port = ini_read_real("network", "last_port", _default_port);
ini_close();

port_input = string(_ini_port);
status_text = "Sélectionne Héberger ou Rejoindre";

button_host_x = 480;
button_host_y = 540;
// === Gestion de la sélection de deck (Liste à droite) ===
load_decks_from_file();
selected_deck_idx = -1; // Aucun deck sélectionné au départ
global.selected_player_deck = noone;

// Variables pour la liste de decks
deck_list_x = 1550;
deck_list_y = 150;
deck_list_w = 300;
deck_list_h = 600;
deck_list_item_h = 50;
deck_list_scroll = 0;

// État multijoueur
global.remote_lobby_ready = false;
global.remote_lobby_deck_name = "";
local_ready = false;

// Repositionnement des boutons pour faire de la place
button_host_x = 480;
button_join_x = 1100; // Décalé vers la gauche
input_ip_x = 790;
input_port_x = 790;
deck_selector_x = -1000; // Désactivé (hors écran)

button_join_y = 540;
button_start_x = 960;
button_start_y = 720;
button_width = 220;
button_height = 60;

input_ip_y = 420;
input_port_y = 480;
input_width = 320;
input_height = 40;

is_typing_ip = false;
is_typing_port = false;

// IP affichées uniquement en mode admin (valeurs fixes)
public_ip = "85.69.106.102";
local_ip_display = "192.168.1.184";
get_ip_request = -1;
