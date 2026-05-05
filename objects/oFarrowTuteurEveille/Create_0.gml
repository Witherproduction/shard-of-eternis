// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Farrow, tuteur des Eveillés"
attack = 2;
PV = 4;
mana_cost = 3;
genre = "Mort-vivant"
race = "Eveillé";
tags = ["Mort-vivant", "Eveillé", "Eveil"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Pioche un serviteur Mort-vivant aléatoire de votre deck."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SEARCH,
        search_sources: ["Deck"],
        destination: "Hand",
        max_targets: 1,
        random_select: true,
        owner: "ally",
        search_criteria: { genre: "Mort-vivant", type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



