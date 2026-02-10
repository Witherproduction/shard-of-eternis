// oFX_ProceduralSpike - CleanUp Event
if (variable_global_exists("combat_fx_count")) {
    global.combat_fx_count--;
    if (global.combat_fx_count < 0) global.combat_fx_count = 0;
}
