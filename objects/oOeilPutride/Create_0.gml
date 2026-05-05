// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Oeil putride"
attack = 3;
PV = 4;
mana_cost = 5;
genre = "Mort-vivant"
race = "Skarl";
tags = ["Mort-vivant", "Skarl", "Ponction", "Aura"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Ponction. Aura : Les cartes dans la main adverse coûtent 1 de mana de plus."
hasPonction = true;
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_INCREASE_HAND_COST,
        value: 1,
        owner: "enemy",
        label: "Aura"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



