// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Lance-éclair Sombre-branchie"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "Humanoïde"
race = "Abyssien";
tags = ["Humanoïde", "Abyssien", "Eveil"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Inflige 1 dégât à un ennemi aléatoire"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        select_mode: "random",
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



