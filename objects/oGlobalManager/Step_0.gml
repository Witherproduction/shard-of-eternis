// === GESTION DU MODE ADMIN ===
// Combinaison : CTRL + ALT + P
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("P"))) {
    if (variable_global_exists("admin_mode")) {
        global.admin_mode = !global.admin_mode;
        show_debug_message("### MODE ADMIN " + (global.admin_mode ? "ACTIVÉ" : "DÉSACTIVÉ"));
    } else {
        // Sécurité si progression_init n'a pas été appelé (ne devrait pas arriver avec oGlobalManager)
        global.admin_mode = true;
        show_debug_message("### MODE ADMIN ACTIVÉ (Force Init)");
    }
    
    // Mettre à jour l'affichage des mains immédiatement (pour voir/cacher la main adverse)
    if (instance_exists(oHand)) {
        with (oHand) {
            if (variable_instance_exists(id, "updateDisplay")) updateDisplay();
        }
    }
}

// Reset Progression (Debug) : CTRL + ALT + R
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("R"))) {
    progression_reset();
    show_debug_message("### PROGRESSION RESET DEMANDÉ PAR L'UTILISATEUR");
    show_message("Progression réinitialisée avec succès !");
    room_restart();
}
