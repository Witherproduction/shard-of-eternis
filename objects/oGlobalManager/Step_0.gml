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
}

// Reset Progression (Debug) : CTRL + ALT + R
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("R"))) {
    progression_reset();
    show_debug_message("### PROGRESSION RESET DEMANDÉ PAR L'UTILISATEUR");
}
