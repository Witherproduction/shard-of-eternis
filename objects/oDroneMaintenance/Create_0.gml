event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Drone de maintenance"
genre = "Direct"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Affiche les 3 cartes du dessus de votre deck. Placez les dans l'ordre de votre choix."
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_MAIN_PHASE,
    effect_type: EFFECT_DECK_REORDER_TOP3,
    description: "Affichez les 3 cartes du dessus du deck et réordonnez-les."
});