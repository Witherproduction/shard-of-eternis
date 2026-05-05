// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Molosse du voile noir"
attack = 3;
PV = 1;
mana_cost = 3;
genre = "Bête"
race = "Loup";
tags = ["Bête", "Loup", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 2 dégâts au serviteur ennemi en face de cette carte. S'il survit, renvoyez-le dans la main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_TARGET_FACING,
        label: "Eveil",
        flow: [
            { id: 2, effect_type: EFFECT_DAMAGE_TARGET, value: 2, target_source: "defender" },
            {
                id: 3,
                effect_type: EFFECT_CONDITIONAL_FLOW,
                cond: { type: "target_alive" },
                flow: { id: 31, effect_type: EFFECT_RETURN_TO_HAND, target_source: "defender" }
            }
        ]
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



