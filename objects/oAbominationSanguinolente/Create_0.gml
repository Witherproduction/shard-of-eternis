// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Abomination sanguinolente"
attack = 4;
PV = 2;
mana_cost = 3;
genre = "Mort-vivant"
race = "Goule";
tags = ["Mort-vivant", "Goule", "Brisé"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : Ajoutez un serviteur aléatoire de votre cimetière à votre main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SEARCH,
        search_sources: ["Graveyard"],
        destination: "Hand",
        max_targets: 1,
        random_select: true,
        search_criteria: { type: "Monster" }
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



