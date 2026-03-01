event_inherited();
race = "Tunnelin";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Mineur Tunnelin"
attack = 2;
PV = 2;
mana_cost = 2;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
projectile_rotate = false; // L'animation de l'effet ne doit pas tourner
description = "Eveil : Inflige 1 dÃ©gÃ¢t Ã  un serviteur adverse."
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


tags = ["HumanoÃ¯de", "Tunnelin", "Eveil"];
