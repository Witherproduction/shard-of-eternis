event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Bougimencien Tunnelin"
attack = 3;
defense = 3;
star = 1;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil :Entrave un serviteur adverse"
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

