event_inherited();
race = "Tunnelin";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Sous-chef Tunnelin"
attack = 6;
PV = 7;
mana_cost = 6;
genre = "Humanoïde"
booster = "Retour des Archontes"
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


tags = ["Humanoïde", "Tunnelin", "Eveil"];
