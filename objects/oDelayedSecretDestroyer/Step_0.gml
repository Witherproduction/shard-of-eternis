if (variable_global_exists("combat_fx_count") && global.combat_fx_count > 0) {
    exit;
}

if (target_card != noone && instance_exists(target_card)) {
    destroyCard(target_card);
}

instance_destroy();
