event_inherited();
race = "Tunnelin";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Bougimencien Tunnelin"
attack = 2;
PV = 1;
mana_cost = 2;
genre = "HumanoÃ¯de"
tags = ["Tunnelin", "Eveil", "Entrave", "HumanoÃ¯de"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur

description = "Eveil : Entrave un serviteur adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        owner: "enemy",
        block_attack: true,
        block_position: true,
        duration_turns: 1,
        conditions: { summon_mode: "Summon" }
    }
]

