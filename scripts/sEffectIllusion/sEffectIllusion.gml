
function sEffectIllusion(card, effect, context) {
    var target = variable_struct_exists(context, "target") ? context.target : noone;
    
    if (target == noone || !instance_exists(target)) {
        return false; 
    }
    
    // Appliquer l'état Illusion
    // destroyCard détectera cet état et l'utilisera pour prévenir la destruction
    target.illusion = 1;
    
    show_debug_message("### EffectIllusion applied on " + string(target.id));
    return true;
}
