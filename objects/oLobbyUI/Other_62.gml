// === oLobbyUI - HTTP Event ===
if (ds_map_find_value(async_load, "id") == get_ip_request) {
    if (ds_map_find_value(async_load, "status") == 0) {
        public_ip = ds_map_find_value(async_load, "result");
    } else {
        public_ip = "Inconnue (Erreur)";
    }
}