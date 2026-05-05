// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Capitaine Perrine"
attack = 3;
PV = 3;
mana_cost = 4;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Egide", "Aura"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
hasEgide = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Egide. Aura : Augmente de 1 les dégats subis par les monstres adverses. "
effects = [
    {
        id: 1,
        trigger: TRIGGER_CONTINUOUS,
        effect_type: EFFECT_AURA_DAMAGE_TAKEN_BONUS,
        owner: "enemy",
        amount: 1
    },
    {
        id: 2,
        trigger: TRIGGER_ENTER_GRAVEYARD,
        effect_type: EFFECT_AURA_CLEANUP_SOURCE
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster


