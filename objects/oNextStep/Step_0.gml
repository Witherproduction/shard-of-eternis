// === oNextStep - Step Event ===
// Manage visual state based on turn

if (instance_exists(oGame)) {
    var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
    
    if (isOnline) {
        if (oGame.is_local_turn) {
            image_alpha = 1;
            image_blend = c_white;
        } else {
            image_alpha = 0.5;
            image_blend = c_gray;
        }
    } else {
        // Offline mode - always active (or follow existing logic if any)
        image_alpha = 1;
        image_blend = c_white;
    }
}
