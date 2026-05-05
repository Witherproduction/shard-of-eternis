// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Hurle-voûte colossal"
attack = 3;
PV = 2;
mana_cost = 4;
genre = "Bête"
race = "Chauve-souris";
tags = ["Bête", "Chauve-souris", "Eveil"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Purge tous les serviteurs ennemis de la ligne de front."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PURGE,
        scope: "all",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        field_position_in: [0, 1, 2, 3],
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



