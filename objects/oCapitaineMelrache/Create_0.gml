// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Capitaine Melrache"
attack = 4;
PV = 5;
mana_cost = 5;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Egide", "Aura"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
hasEgide = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Egide. Aura : Réduit les dégats subis par vos monstre de 1 ( Min 1)"
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_AURA_DAMAGE_REDUCTION,
        owner: "ally",
        amount: 1
    },
    {
        id: 2,
        trigger: TRIGGER_ENTER_GRAVEYARD,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



