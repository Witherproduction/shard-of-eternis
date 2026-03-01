
// Initialisation du gestionnaire global
if (!instance_exists(oGlobalManager)) {
    instance_create_depth(0, 0, 0, oGlobalManager);
}

// Initialisation du gestionnaire de map (pour l'affichage du continent/masque)
if (!instance_exists(oMapManager)) {
    instance_create_depth(0, 0, 0, oMapManager);
}

// Initialisation du Quest Manager (Persistant)
if (!instance_exists(oQuestManager)) {
    instance_create_depth(0, 0, 0, oQuestManager);
}

// Bouton de Quête (UI Menu Principal)
if (!instance_exists(oQuestButton)) {
    instance_create_depth(0, 0, -500, oQuestButton);
}

// Note: L'initialisation des options est maintenant gérée par oGlobalManager
// qui est présent dans cette room.
if (variable_global_exists("bgm_asset") && global.bgm_asset != -1) {
    audio_stop_sound(global.bgm_asset);
}
global.bgm_enabled = false;
global.bgm_should_resume = false;
global.bgm_asset = -1;

if (asset_get_index("oCurrencyHUD") > -1) {
    if (!instance_exists(oCurrencyHUD)) {
        instance_create_layer(1880, 40, "UI", oCurrencyHUD);
    }
}
