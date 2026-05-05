// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Oracle Sombre-branchie"
attack = 2;
PV = 4;
mana_cost = 4;
genre = "Humanoïde"
race = "Abyssien";
tags = ["Humanoïde", "Abyssien", "Epine", "Eveil", "Défense"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Epine (1). Eveil : Inflige 1 dégats à un serviteur adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        target_source: "attacker",
        conditions: { defender_is_self: true },
        label: "Epine"
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



