event_inherited();
race = "Tunnelin";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Géomancien Tunnelin"
attack = 2;
PV = 2;
mana_cost = 4;
genre = "Humanoïde"
tags = ["Humanoïde", "Tunnelin", "Eveil", "Entrave"];archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur

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


