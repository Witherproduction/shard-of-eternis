show_debug_message("### oNetworkManager.create");

network_mode = "offline";
server_socket = -1;
client_socket = -1;
peer_sockets = ds_list_create();
remote_ip = "";
remote_port = 0;
handshake_done = false;
shared_seed = 0;

if (!variable_global_exists("NET_MODE")) {
    global.NET_MODE = "offline";
}
global.NET_HANDSHAKE_DONE = false;
global.NET_IS_HOST = false;
global.NET_SHARED_SEED = 0;

cleanupSockets = function() {
    if (ds_exists(peer_sockets, ds_type_list)) {
        var count = ds_list_size(peer_sockets);
        for (var i = 0; i < count; i++) {
            var sock = ds_list_find_value(peer_sockets, i);
            if (sock != -1) {
                network_destroy(sock);
            }
        }
        ds_list_clear(peer_sockets);
    }
    if (server_socket != -1) {
        network_destroy(server_socket);
        server_socket = -1;
    }
    if (client_socket != -1) {
        network_destroy(client_socket);
        client_socket = -1;
    }
};

HostGame = function(port) {
    if (argument_count >= 1) {
        port = argument[0];
    }
    if (!is_real(port) || port <= 0) {
        port = 6510;
    }

    cleanupSockets();

    server_socket = network_create_server(network_socket_tcp, port, 2);
    if (server_socket < 0) {
        show_debug_message("ERREUR: oNetworkManager.HostGame - creation serveur echouee");
        server_socket = -1;
        network_mode = "offline";
        global.NET_MODE = "offline";
        global.NET_IS_HOST = false;
        handshake_done = false;
        global.NET_HANDSHAKE_DONE = false;
        return false;
    }

    network_mode = "host";
    global.NET_MODE = "online";
    global.NET_IS_HOST = true;
    handshake_done = false;
    global.NET_HANDSHAKE_DONE = false;
    show_debug_message("### oNetworkManager.HostGame - serveur TCP sur port " + string(port));
    return true;
};

JoinGame = function(ip, port) {
    if (argument_count >= 1) {
        ip = argument[0];
    }
    if (argument_count >= 2) {
        port = argument[1];
    }
    if (!is_string(ip) || ip == "") {
        show_debug_message("ERREUR: oNetworkManager.JoinGame - IP invalide");
        return false;
    }
    if (!is_real(port) || port <= 0) {
        port = 6510;
    }

    cleanupSockets();

    client_socket = network_create_socket(network_socket_tcp);
    if (client_socket < 0) {
        show_debug_message("ERREUR: oNetworkManager.JoinGame - creation socket client echouee");
        client_socket = -1;
        return false;
    }

    // Utiliser network_connect_raw_async pour éviter de bloquer le jeu
    // Note: Dans GameMaker Studio 2 récent, network_connect_async est recommandé pour TCP
    // Mais network_connect standard est bloquant. On passe en async.
    var result = network_connect_async(client_socket, ip, port);
    if (result < 0) {
        show_debug_message("ERREUR: oNetworkManager.JoinGame - connexion immediate echouee a " + ip + ":" + string(port));
        // Note: En async, un retour < 0 signifie souvent une erreur de config locale, pas un timeout
        // Mais on laisse le socket ouvert pour voir si l'event Async Networking répond plus tard
        // sauf si c'est vraiment bloquant.
        // Pour l'instant, on retourne true pour dire "tentative lancée"
        // et on gérera l'échec dans l'event Async.
        
        // Update: Si network_connect_async renvoie < 0, c'est que ça n'a même pas pu essayer (format IP invalide etc.)
        network_destroy(client_socket);
        client_socket = -1;
        return false;
    }

    remote_ip = ip;
    remote_port = port;
    network_mode = "client";
    global.NET_MODE = "online";
    global.NET_IS_HOST = false;
    handshake_done = false;
    global.NET_HANDSHAKE_DONE = false;
    show_debug_message("### oNetworkManager.JoinGame - connexion en cours vers " + ip + ":" + string(port));
    return true;
};

sendGameAction = function(msg) {
    if (!is_struct(msg)) {
        show_debug_message("ERREUR: oNetworkManager.sendGameAction - msg invalide");
        return;
    }

    if (global.NET_MODE == "offline") {
        return;
    }

    var json = json_stringify(msg);
    var buf = buffer_create(string_length(json) + 4, buffer_grow, 1);
    buffer_seek(buf, buffer_seek_start, 0);
    buffer_write(buf, buffer_string, json);

    var size = buffer_tell(buf);

    if (network_mode == "host") {
        if (ds_exists(peer_sockets, ds_type_list)) {
            var count = ds_list_size(peer_sockets);
            for (var i = 0; i < count; i++) {
                var sock = ds_list_find_value(peer_sockets, i);
                if (sock != -1) {
                    buffer_seek(buf, buffer_seek_start, 0);
                    network_send_packet(sock, buf, size);
                }
            }
        }
    } else if (network_mode == "client") {
        if (client_socket != -1) {
            network_send_packet(client_socket, buf, size);
        }
    } else {
        show_debug_message("ERREUR: oNetworkManager.sendGameAction - mode reseau inconnu");
    }

    buffer_delete(buf);
};
