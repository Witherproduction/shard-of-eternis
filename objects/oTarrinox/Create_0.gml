event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "Tarrinox"
attack = 5;
PV = 7;
mana_cost = 6;
genre = "BÃªte"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Eveil : Donne +4/+4 aux AraignÃ©e forestiÃ¨re sur le terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        criteria: { type: "Monster" },
        conditions: { summon_mode: "Summon" },
        bonus_if_names: ["oAraigneeForestiere"],
        atk_bonus: 4,
        def_bonus: 4
    }
]


race = "AraignÃ©e";
tags = ["BÃªte", "AraignÃ©e", "Eveil"];
