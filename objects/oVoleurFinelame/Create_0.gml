event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Voleur Finelame"
attack = 3;
PV = 2;
mana_cost = 3;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur

// Mécaniques spéciales
isPercee = true;

description = "Camouflage. Percée (Peut ignorer la ligne de front pour attaquer le Héros ou l'arrière-garde)."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    }
]
race = "Humain";
tags = ["Humanoïde", "Humain", "Camouflage", "Percee"];
