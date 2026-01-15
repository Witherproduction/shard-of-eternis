if (ds_exists(peer_sockets, ds_type_list)) {
    ds_list_destroy(peer_sockets);
}

if (server_socket != -1) {
    network_destroy(server_socket);
    server_socket = -1;
}

if (client_socket != -1) {
    network_destroy(client_socket);
    client_socket = -1;
}

