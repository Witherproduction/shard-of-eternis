event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Double jeu"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;
mana_cost = 4;

description = "Choisissez un serviteur. Invoquez-en une copie sur votre terrain (Ligne de front). Elle ne peut pas attaquer."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SUMMON,
        summon_mode: "copy_target",
        scope: "single",
        owner: "both",
        target_zone: "field",
        criteria: { type: "Monster" },
        force_front_line: true
    }
]
tags = ["Ombre", "Sort"];
