// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Sismomancien Sombre-branchie"
attack = 2;
PV = 7;
mana_cost = 4;
genre = "Humanoïde"
race = "Abyssien";
tags = ["Humanoïde", "Abyssien", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 1 dégats et purge un monstre adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PURGE,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



