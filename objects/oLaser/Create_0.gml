event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Armement : laser"
genre = "Artéfact"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Ne peut être équipé que sur un Méca. Lorsque le monstre équipé attaque, détruit un sort adverse sur le terrain."

effects = [];
// Équipement: Méca uniquement
array_push(effects, { trigger: TRIGGER_MAIN_PHASE, effect_type: EFFECT_EQUIP_SELECT_TARGET, allowed_genres: ["Méca"], ally_only: false, description: "Choisissez un Méca à équiper; posez cette carte." });
// À l'attaque: détruire un sort adverse aléatoire sur le terrain
array_push(effects, {
    trigger: TRIGGER_ON_ATTACK,
    effect_type: EFFECT_DESTROY,
    owner: "enemy",
    target_zone: "Field",
    target_types: ["Magic"],
    random_select: true,
    destroy_count: 1,
    conditions: { attacker_is_equipped_target: true },
    description: "Quand le monstre équipé attaque : détruisez un sort adverse sur le terrain."
});
// Nettoyage à la destruction
array_push(effects, { trigger: TRIGGER_ON_DESTROY, effect_type: EFFECT_EQUIP_CLEANUP, description: "Réinitialise le monstre équipé et détache la cible." });