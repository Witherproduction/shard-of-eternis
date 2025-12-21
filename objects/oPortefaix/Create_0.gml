event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Portefaix"
attack = 4;
defense = 5;
star = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Eveil : Détruit un sort aléatoire sur le terrain adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_DESTROY,
        owner: "enemy",
        target_zone: "Field",
        target_types: ["Magic"],
        random_select: true,
        value: 1,
        conditions: { summon_mode: "Summon" }
    }
]

