if (variable_instance_exists(id, "bg_sound_asset_current") && bg_sound_asset_current != -1) {
    audio_stop_sound(bg_sound_asset_current);
    bg_sound_asset_current = -1;
}
if (variable_instance_exists(id, "bg2_sound_asset_current") && bg2_sound_asset_current != -1) {
    audio_stop_sound(bg2_sound_asset_current);
    bg2_sound_asset_current = -1;
}
