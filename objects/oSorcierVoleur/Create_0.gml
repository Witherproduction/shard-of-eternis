event_inherited();
race = "Humain";  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Sorcier voleur"
attack = 2;
PV = 2;
mana_cost = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Vole un sort du deck adverse."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_PILLAGE,
        source_zone: "Deck",
        destination: "Hand",
        random_select: true,
        criteria: { is_magic: true }
    }
]


tags = ["Humanoïde", "Humain", "Eveil", "Pillage"];
