// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Hibernard, ours pestiféré"
attack = 5;
PV = 5;
mana_cost = 6;
genre = "Bête"
race = "Ours";
tags = ["Bête", "Ours", "Charge", "Eveil"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
has_charge = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge. Eveil : Inflige 2 dégâts au serviteur ennemi en face de cette carte et l'entrave."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_TARGET_FACING,
        label: "Eveil",
        flow: [
            {
                id: 2,
                effect_type: EFFECT_DAMAGE_TARGET,
                value: 2,
                target_source: "defender"
            },
            {
                id: 3,
                effect_type: EFFECT_ENTRAVE,
                scope: "single",
                owner: "enemy",
                target_source: "defender"
            }
        ]
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster


