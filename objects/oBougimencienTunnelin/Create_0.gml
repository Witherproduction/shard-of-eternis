event_inherited();
race = "Tunnelin";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Bougimencien Tunnelin"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "Humanoïde"
tags = ["Tunnelin", "Eveil", "Entrave", "Humanoïde"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur

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

