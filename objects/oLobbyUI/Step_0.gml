// === oLobbyUI - Step Event ===

if (instance_exists(oPanelOptions)) { exit; }

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rMode);
    exit;
}

var mx = mouse_x;
var my = mouse_y;

// Gestion de la saisie de texte
if (is_typing_ip) {
    if (string_length(keyboard_string) > 15) {
        keyboard_string = string_copy(keyboard_string, 1, 15);
    }
    ip_input = keyboard_string;
}
if (is_typing_port) {
    // Filtrer pour ne garder que les chiffres
    var _digits = string_digits(keyboard_string);
    if (string_length(_digits) > 5) {
        _digits = string_copy(_digits, 1, 5);
    }
    if (_digits != keyboard_string) {
        keyboard_string = _digits;
    }
    port_input = _digits;
}

if (mouse_check_button_pressed(mb_left)) {
    var host_left = button_host_x - button_width / 2;
    var host_top = button_host_y - button_height / 2;
    var host_right = button_host_x + button_width / 2;
    var host_bottom = button_host_y + button_height / 2;
    
    var join_left = button_join_x - button_width / 2;
    var join_top = button_join_y - button_height / 2;
    var join_right = button_join_x + button_width / 2;
    var join_bottom = button_join_y + button_height / 2;

    // Zones de texte (inputs)
    var ip_left = input_ip_x - input_width / 2;
    var ip_top = input_ip_y - input_height / 2;
    var ip_right = input_ip_x + input_width / 2;
    var ip_bottom = input_ip_y + input_height / 2;

    var port_left = input_port_x - input_width / 2;
    var port_top = input_port_y - input_height / 2;
    var port_right = input_port_x + input_width / 2;
    var port_bottom = input_port_y + input_height / 2;

    // Bouton Retour (mêmes coordonnées que dans Draw)
    var back_btn_w = 220;
    var back_btn_h = 60;
    var back_btn_x = 200;
    var back_btn_y = 1000;
    var back_left = back_btn_x - back_btn_w / 2;
    var back_top = back_btn_y - back_btn_h / 2;
    var back_right = back_btn_x + back_btn_w / 2;
    var back_bottom = back_btn_y + back_btn_h / 2;
    
    // Vérifier si on clique sur les champs de texte
    if (mx >= ip_left && mx <= ip_right && my >= ip_top && my <= ip_bottom) {
        is_typing_ip = true;
        is_typing_port = false;
        keyboard_string = ip_input;
        exit; // On sort pour ne pas cliquer sur un bouton en dessous par erreur
    } else if (mx >= port_left && mx <= port_right && my >= port_top && my <= port_bottom) {
        is_typing_ip = false;
        is_typing_port = true;
        keyboard_string = port_input;
        exit;
    } else {
        // Si on clique ailleurs, on désactive la saisie
    is_typing_ip = false;
    is_typing_port = false;
}

    // Bouton Retour
    if (mx >= back_left && mx <= back_right && my >= back_top && my <= back_bottom) {
        clear_selected_decks();
        room_goto(rMode);
        exit;
    }

    // Gestion de la liste de decks (géométrie identique à oDeckList)
    if (variable_global_exists("saved_decks") && array_length(global.saved_decks) > 0) {
        var sprite_x = room_width - sprite_get_width(sDeckBuilder) + 55;
        var sprW = sprite_get_width(sDeckBuilder);
        var scale_x = (sprW - 100) / sprW;
        var scaled_w = sprW * scale_x;
        sprite_x = room_width - scaled_w + 55 - 55;

        var list_button_x = sprite_x + 50;
        var list_button_y = room_height / 3 - 270;
        var baseW_btn = sprite_get_width(sButton);
        var baseH_btn = sprite_get_height(sButton);
        var list_button_width = round(baseW_btn * 0.8);
        var list_button_height = round(baseH_btn * 0.8);

        var deck_list_y = list_button_y + list_button_height + 20;
        var deck_item_height = 35;
        var deck_item_width = list_button_width;

        if (mx >= list_button_x && mx <= list_button_x + deck_item_width && my >= deck_list_y && my <= room_height - 50) {
            var relative_y = my - deck_list_y;
            var clicked_idx = floor(relative_y / (deck_item_height + 5));

            if (clicked_idx >= 0 && clicked_idx < array_length(global.saved_decks)) {
                selected_deck_idx = clicked_idx;
                global.selected_player_deck = global.saved_decks[selected_deck_idx];
                local_ready = true;

                if (instance_exists(oNetworkManager) && global.NET_HANDSHAKE_DONE) {
                    var payload = {
                        msg_type: MSG_LOBBY_STATE,
                        ready: true,
                        deck_name: global.selected_player_deck.name
                    };
                    Network_SendGameAction(payload);
                }
            }
            exit;
        }
    }

if (mx >= host_left && mx <= host_right && my >= host_top && my <= host_bottom) {
        mode_text = "Host";
        status_text = "Création du serveur...";
        if (instance_exists(oNetworkManager)) {
            with (oNetworkManager) {
                HostGame(real(other.port_input));
            }
            status_text = "Serveur en attente de joueur...";
        } else {
            status_text = "Erreur: oNetworkManager introuvable";
        }
    } else if (mx >= join_left && mx <= join_right && my >= join_top && my <= join_bottom) {
        mode_text = "Client";
        status_text = "Connexion en cours...";

        ini_open("options.ini");
        ini_write_string("network", "last_ip", ip_input);
        ini_write_real("network", "last_port", real(port_input));
        ini_close();

        if (instance_exists(oNetworkManager)) {
            with (oNetworkManager) {
                JoinGame(other.ip_input, real(other.port_input));
            }
            status_text = "Connexion demandée, surveille la console";
        } else {
            status_text = "Erreur: oNetworkManager introuvable";
        }
    } else {
        if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST && variable_global_exists("NET_HANDSHAKE_DONE") && global.NET_HANDSHAKE_DONE) {
            var start_left = button_start_x - button_width / 2;
            var start_top = button_start_y - button_height / 2;
            var start_right = button_start_x + button_width / 2;
            var start_bottom = button_start_y + button_height / 2;
            if (mx >= start_left && mx <= start_right && my >= start_top && my <= start_bottom) {
                if (!local_ready || !global.remote_lobby_ready) {
                    // Clic ignoré si les conditions ne sont pas remplies
                    exit;
                }
                if (instance_exists(oNetworkManager)) {
                    with (oNetworkManager) {
                        if (!is_real(shared_seed) || shared_seed <= 0) {
                            shared_seed = irandom(2147483647);
                        }
                        global.NET_SHARED_SEED = shared_seed;
                        random_set_seed(shared_seed);
                        var start_msg = {
                            msg_type: MSG_GAME_START,
                            seed: shared_seed
                        };
                        sendGameAction(start_msg);
                    }
                }
                global.nextCardInstanceUID = 100000;
                room_goto(rDuel);
            }
        }
    }
}

if (variable_global_exists("NET_HANDSHAKE_DONE") && global.NET_HANDSHAKE_DONE) {
    if (mode_text == "Host") {
        status_text = "Client connecté, prêt à lancer le duel";
    } else if (mode_text == "Client") {
        status_text = "Connecté à l'hôte, en attente du lancement";
    }
}
