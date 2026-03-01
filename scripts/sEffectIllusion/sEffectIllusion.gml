
function sEffectIllusion(card, effect, context) {
    var target = variable_struct_exists(context, "target") ? context.target : noone;
    
    // Support for self-targeting if explicitly requested
    if (target == noone) {
        if (variable_struct_exists(effect, "target_source") && effect.target_source == "self") {
            target = card;
        } else if (variable_struct_exists(effect, "select_mode") && effect.select_mode == "self") {
            target = card;
        }
    }
    
    if (target == noone || !instance_exists(target)) {
        return false; 
    }
    
    // Appliquer l'état Illusion
    // destroyCard détectera cet état et l'utilisera pour prévenir la destruction
    target.HasIllusion = true;
    
    show_debug_message("### EffectIllusion applied on " + string(target.id));
    return true;
}
