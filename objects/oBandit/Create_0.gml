event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Bandit"
attack = 3;
defense = 3;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Pille une carte de la main adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PILLAGE,
        operation: "steal",
        source_zone: "Hand",
        destination: "Hand",
        value: 1,
        random_select: true,
        conditions: { summon_mode: "Summon" }
    }
]

