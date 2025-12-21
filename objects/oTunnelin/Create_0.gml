event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Tunnelin"
attack = 3;
defense = 3;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Selectionne et réduit de 1 l'ATK d'un serviteur."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "enemy",
        criteria: { type: "Monster" },
        conditions: { summon_mode: "Summon" },
        atk: -1,
        def: 0
    }
]

