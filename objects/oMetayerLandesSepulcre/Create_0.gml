// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Métayer des Landes du sépulcre"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "Humanoïde"
race = "Humain";
tags = ["Humanoïde", "Humain", "Eveil"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Invoque un Journalier des Landes du Sépulcre."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        target_name: "oJournalierLandeSepulcre",
        placement_criteria: { role: "random" },
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



