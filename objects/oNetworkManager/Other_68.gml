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
    } 
    // Note: Avec network_connect_async, le succès client arrive dans network_type_non_blocking_connect
    // Mais network_connect (bloquant) arrivait ici. On garde au cas où on repasse en bloquant.
    else if (n_id == client_socket) {
        show_debug_message("### oNetworkManager - connecte au serveur (bloquant)");
        var hello_client = {
            msg_type: MSG_HELLO,
            version: 1
        };
        sendGameAction(hello_client);
    }
    exit;
}

if (n_type == network_type_non_blocking_connect) {
    var succeeded = async_load[? "succeeded"];
    if (succeeded) {
        show_debug_message("### oNetworkManager - connecte au serveur (async)");
        if (instance_exists(oLobbyUI)) {
            oLobbyUI.status_text = "Connecté ! En attente de l'hôte...";
        }
        var hello_client_async = {
            msg_type: MSG_HELLO,
            version: 1
        };
        sendGameAction(hello_client_async);
    } else {
        show_debug_message("### oNetworkManager - ECHEC connexion async");
        // Informer le Lobby de l'échec
        if (instance_exists(oLobbyUI)) {
            oLobbyUI.status_text = "Échec connexion : Délai dépassé ou refusé.";
            oLobbyUI.mode_text = "Aucun"; 
        }
        network_destroy(client_socket);
        client_socket = -1;
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
    
    // Si une partie est en cours, le joueur restant gagne par abandon de l'autre
    if (instance_exists(oGame) && (!variable_instance_exists(oGame, "gameEnded") || !oGame.gameEnded)) {
        show_debug_message("### oNetworkManager - Déconnexion détectée en cours de partie. Victoire par abandon.");
        // Le quitter est l'autre joueur (celui qui vient de se déconnecter)
        // On suppose que oGame.local_player_index est correct (0 ou 1).
        var quitter = 1 - oGame.local_player_index; 
        var payload = { quitter_index: quitter };
        
        // On exécute l'action localement (l'autre n'est plus là)
        ExecuteGameAction(ACTION_SURRENDER, payload);
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
            
            if (instance_exists(oLobbyUI)) {
                oLobbyUI.status_text = "Liaison établie avec " + (global.NET_IS_HOST ? "le Client" : "l'Hôte");
            }
            
            // Si on est dans le lobby et qu'on a déjà choisi un deck, on renvoie l'info
            if (room == rLobby && instance_exists(oLobbyUI)) {
                with (oLobbyUI) {
                    if (local_ready && variable_global_exists("selected_player_deck")) {
                         var payload = {
                            msg_type: MSG_LOBBY_STATE,
                            ready: true,
                            deck_name: global.selected_player_deck.name,
                            deck_data: global.selected_player_deck
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
                
                // Synchroniser aussi l'UID de base des cartes pour que les UIDs concordent entre les deux machines
                global.nextCardInstanceUID = 100000;
            }
            room_goto(rDuel);
        } else if (t == MSG_LOBBY_STATE) {
            if (variable_struct_exists(msg, "ready")) global.remote_lobby_ready = msg.ready;
            if (variable_struct_exists(msg, "deck_name")) global.remote_lobby_deck_name = msg.deck_name;
            if (variable_struct_exists(msg, "deck_data")) global.remote_lobby_deck_data = msg.deck_data;
            show_debug_message("### oNetworkManager - MSG_LOBBY_STATE recu: ready=" + string(global.remote_lobby_ready));
        }
    }
}
