event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Mineur Tunnelin"
attack = 3;
defense = 4;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Réduit de 1 la DEF d'un serviteur adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "enemy",
        def: -1,
        criteria: { type: "Monster" },
        conditions: { summon_mode: "Summon" }
    }
]

