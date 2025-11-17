event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Robot Auto-destructeur"
attack = 0;
defense = 0;
star = 1;
genre = "Méca"
archetype = "Robot d'assaut"
booster = "Usine robotique"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Perdu : Détruit un monstre adverse aléatoire sur le terrain."

if (!variable_instance_exists(id, "effects")) effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_ENTER_GRAVEYARD,
    effect_type: EFFECT_DESTROY,
    owner: "enemy",
    target_zone: "Field",
    target_types: ["Monster"],
    random_select: true,
    destroy_count: 1,
    description: "Quand cette carte est envoyée au cimetière : Détruisez aléatoirement un monstre adverse sur le terrain."
});