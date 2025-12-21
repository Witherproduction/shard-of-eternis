event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Sous-chef Tunnelin"
attack = 7;
defense = 5;
star = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Donne +2 ATK à tous vos serviteur sur le terrain"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        criteria: { type: "Monster" },
        atk: 2
    }
]

