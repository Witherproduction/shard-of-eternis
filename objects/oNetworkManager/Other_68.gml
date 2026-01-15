var n_id = async_load[? "id"];
var n_type = async_load[? "type"];

if (n_type == network_type_connect) {
    if (n_id == server_socket) {
        var sock = async_load[? "socket"];
        if (ds_exists(peer_sockets, ds_type_list)) {
            ds_list_add(peer_sockets, sock);
        }
        show_debug_message("### oNetworkManager - nouvelle connexion client " + string(sock));
        var hello = {
            msg_type: MSG_HELLO,
            version: 1
        };
        sendGameAction(hello);
    } else if (n_id == client_socket) {
        show_debug_message("### oNetworkManager - connecte au serveur");
        var hello_client = {
            msg_type: MSG_HELLO,
            version: 1
        };
        sendGameAction(hello_client);
    }
    exit;
}

if (n_type == network_type_disconnect) {
    if (ds_exists(peer_sockets, ds_type_list)) {
        var sock_disc = async_load[? "socket"];
        var idx = ds_list_find_index(peer_sockets, sock_disc);
        if (idx != -1) {
            ds_list_delete(peer_sockets, idx);
        }
    }
    handshake_done = false;
    global.NET_HANDSHAKE_DONE = false;
    show_debug_message("### oNetworkManager - deconnexion socket " + string(async_load[? "socket"]));
    exit;
}

if (n_type == network_type_data) {
    var buf = async_load[? "buffer"];
    buffer_seek(buf, buffer_seek_start, 0);
    var msg_string = buffer_read(buf, buffer_string);

    var msg = json_parse(msg_string);
    if (is_struct(msg) && variable_struct_exists(msg, "msg_type")) {
        var t = msg.msg_type;
        if (t == MSG_GAME_ACTION) {
            ProcessRemoteGameAction(msg);
        } else if (t == MSG_HELLO) {
            handshake_done = true;
            global.NET_HANDSHAKE_DONE = true;
            show_debug_message("### oNetworkManager - handshake MSG_HELLO recu");
            
            // Si on est dans le lobby et qu'on a déjà choisi un deck, on renvoie l'info
            if (room == rLobby && instance_exists(oLobbyUI)) {
                with (oLobbyUI) {
                    if (local_ready && variable_global_exists("selected_player_deck")) {
                         var payload = {
                            msg_type: MSG_LOBBY_STATE,
                            ready: true,
                            deck_name: global.selected_player_deck.name
                        };
                        other.sendGameAction(payload);
                    }
                }
            }
        } else if (t == MSG_GAME_START) {
            if (variable_struct_exists(msg, "seed")) {
                shared_seed = msg.seed;
                global.NET_SHARED_SEED = shared_seed;
                random_set_seed(shared_seed);
                show_debug_message("### oNetworkManager - MSG_GAME_START recu, seed=" + string(shared_seed));
            }
            room_goto(rDuel);
        } else if (t == MSG_LOBBY_STATE) {
            if (variable_struct_exists(msg, "ready")) global.remote_lobby_ready = msg.ready;
            if (variable_struct_exists(msg, "deck_name")) global.remote_lobby_deck_name = msg.deck_name;
            show_debug_message("### oNetworkManager - MSG_LOBBY_STATE recu: ready=" + string(global.remote_lobby_ready));
        }
    }
}
