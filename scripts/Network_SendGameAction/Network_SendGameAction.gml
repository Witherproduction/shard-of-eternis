function Network_SendGameAction(msg) {
    if (!is_struct(msg)) {
        show_debug_message("ERREUR: Network_SendGameAction - msg invalide");
        return;
    }
    
    if (!instance_exists(oNetworkManager)) {
        show_debug_message("ERREUR: Network_SendGameAction - oNetworkManager introuvable (message non envoyé)");
        return;
    }
    
    with (oNetworkManager) {
        if (variable_instance_exists(id, "sendGameAction")) {
            sendGameAction(msg);
        } else {
            show_debug_message("ERREUR: oNetworkManager.sendGameAction manquant");
        }
    }
}

