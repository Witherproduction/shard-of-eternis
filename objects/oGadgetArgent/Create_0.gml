event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Gadget argent"
attack = 500;
defense = 500;
star = 2;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Appel : Invoque un Gadget bronze depuis votre deck, cimetière ou main."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ON_SUMMON,
    effect_type: EFFECT_SUMMON,
    summon_mode: "named",
    target_name: "Gadget bronze",
    allowed_sources: ["Deck", "Graveyard", "Hand"],
    description: "À l'invocation : Invoquez spécialement un Gadget bronze depuis le Deck, le Cimetière ou la Main."
});