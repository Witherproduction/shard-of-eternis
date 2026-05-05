// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Hurlenuit stridente"
attack = 2;
PV = 4;
mana_cost = 3;
genre = "Bête"
race = "Chauve-souris";
tags = ["Bête", "Chauve-souris", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Purge le serviteur en face de lui."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_TARGET_FACING,
        label: "Eveil",
        flow: [
            { id: 2, effect_type: EFFECT_PURGE, scope: "single", owner: "enemy", target_source: "defender" }
        ]
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



