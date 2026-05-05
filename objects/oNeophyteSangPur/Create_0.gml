// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Néophyte du Sang-pur"
attack = 1;
PV = 1;
mana_cost = 2;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Défense", "Entrave"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Quand cette carte est attaquée, après le combat, Entrave l'attaquant."
effects = [
    {
        id: 1,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        owner: "enemy",
        target_source: "attacker",
        conditions: {
            defender_is_self: true
        },
        label: "Défense"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



