event_inherited();
race = "Tunnelin";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Mineur Tunnelin"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "Humanoïde"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
projectile_rotate = false; // L'animation de l'effet ne doit pas tourner
description = "Eveil : Inflige 1 dégât à un serviteur adverse."
element = "Nature";
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DAMAGE_TARGET,
        owner: "enemy",
        scope: "single",
        select_mode: "target",
        value: 1,
        conditions: { summon_mode: "Summon" },
        criteria: { type: "Monster" }
    }
]


tags = ["Humanoïde", "Tunnelin", "Eveil"];
