event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Dispositif d'évacuation forcée"
genre = "Secret"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "S'active lorsque l'adversaire attaque directement. Renvoie le monstre attaquant dans la main."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    effect_type: EFFECT_RETURN_TO_HAND,
    secret_activation: { direct_attack: true },
    target_source: "attacker",
    description: "Lors d'une attaque directe adverse : renvoie l'attaquant dans la main."
});