// === Code de création de la room rCardCreator ===
show_debug_message("### rCardCreator - Room Creation Code");

// Crée l'instance de la base de données si elle n'existe pas
if (!instance_exists(oDataBase)) {
    show_debug_message("Création de oDataBase dans rCardCreator");
    instance_create_layer(0, 0, "UI", oDataBase);
} else {
    show_debug_message("oDataBase existe déjà dans rCardCreator");
}

show_debug_message("### rCardCreator initialisée");

// Musique de fond pour les rooms hors Duel
if (!variable_global_exists("bgm_asset")) {
    var _nm = "MainTheme";
    var _idx = asset_get_index(_nm);
    if (_idx == -1) { _idx = asset_get_index("sndMainTheme"); }
    global.bgm_asset = _idx;
}
if (!variable_global_exists("bgm_enabled")) global.bgm_enabled = true;
if (!variable_global_exists("bgm_should_resume")) global.bgm_should_resume = false;
if (global.bgm_enabled && global.bgm_asset != -1) {
    if (global.bgm_should_resume || !audio_is_playing(global.bgm_asset)) {
        audio_play_sound(global.bgm_asset, 0, true);
        global.bgm_should_resume = false;
    }
}