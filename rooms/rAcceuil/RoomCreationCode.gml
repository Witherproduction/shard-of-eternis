// Initialisation du gestionnaire global
if (!instance_exists(oGlobalManager)) {
    instance_create_depth(0, 0, 0, oGlobalManager);
}

// Note: L'initialisation des options est maintenant gérée par oGlobalManager
// qui est présent dans cette room.
if (variable_global_exists("bgm_asset") && global.bgm_asset != -1) {
    audio_stop_sound(global.bgm_asset);
}
global.bgm_enabled = false;
global.bgm_should_resume = false;
global.bgm_asset = -1;

