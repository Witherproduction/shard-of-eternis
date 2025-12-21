
function sCamouflage(card, effect, context){
    var target = variable_struct_exists(context, "target") ? context.target : noone;
    var applyTo = (target != noone && instance_exists(target)) ? target : card;
    if (applyTo == noone || !instance_exists(applyTo)) return false;
    applyTo.isCamouflage = true;
    return true;
}