event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Sonde d'exploration"
attack = 0;
defense = 0;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Défaussé : Pioche une carte"
if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_DRAW_CARDS,
    value: 1,
    conditions: { only_when_discard: true },
    description: "Quand cette carte est défaussée : Piochez 1 carte."
});