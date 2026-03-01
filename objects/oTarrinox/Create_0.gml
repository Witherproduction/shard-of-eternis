event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tarrinox"
attack = 5;
PV = 7;
mana_cost = 6;
genre = "Bête"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Donne +4/+4 aux Araignée forestière sur le terrain."
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


race = "Araignée";
tags = ["Bête", "Araignée", "Eveil"];
