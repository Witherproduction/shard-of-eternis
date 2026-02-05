event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Ruisselier Abyssien"
attack = 2;
PV = 3;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Chaque fois que vous invoquez un Abyssien, gagne +1ATK"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_MONSTER_SUMMON,
        effect_type: EFFECT_BUFF,
        scope: "single",
        atk: 1,
        conditions: {
            source_owner: "ally",
            source_name_contains: "Abyssien",
            source_is_not_self: true
        }
    }
]


