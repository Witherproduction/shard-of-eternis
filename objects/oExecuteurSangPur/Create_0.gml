// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Exécuteur du Sang-Pur"
attack = 3;
PV = 3;
mana_cost = 4;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 2 dégâts à un serviteur ennemi. S'il survit, il est marqué : jusqu'à votre prochain tour, il subit +1 dégât des attaques."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        owner: "enemy",
        criteria: { type: "Monster" },
        label: "Eveil",
        flow: [
            {
                id: 2,
                effect_type: EFFECT_MARK_ATTACK_DAMAGE,
                value: 1
            }
        ]
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



