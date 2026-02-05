event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "James la Calamité"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Crépuscule : Pille une carte du deck adverse"
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_END_TURN,
        effect_type: EFFECT_PILLAGE,
        operation: "steal",
        source_zone: "Deck",
        destination: "Hand",
        value: 1,
        random_select: true,
        label: "Crépuscule"
    }
]


