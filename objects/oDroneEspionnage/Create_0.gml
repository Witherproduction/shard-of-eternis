event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Drone d'espionnage"
genre = "Direct"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Jusqu'à la fin du tour, la main de votre adversaire est visible."
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_MAIN_PHASE,
    effect_type: EFFECT_REVEAL_HAND,
    description: "Jusqu'à la fin du tour : la main adverse est visible."
});