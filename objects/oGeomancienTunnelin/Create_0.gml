event_inherited();
race = "Tunnelin";  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "GÃ©omancien Tunnelin"
attack = 2;
PV = 2;
mana_cost = 4;
genre = "HumanoÃ¯de"
tags = ["HumanoÃ¯de", "Tunnelin", "Eveil", "Entrave"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur

description = "Eveil : Entrave tous les serviteurs adverses"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_ENTRAVE,
        scope: "all",
        owner: "enemy",
        block_attack: true,
        block_position: true,
        duration_turns: 1,
        conditions: { summon_mode: "Summon" }
    }
];



