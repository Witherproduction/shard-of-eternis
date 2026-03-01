event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Rugissement de la forêt"
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Donne +2 PV à toutes vos Bêtes.";
mana_cost = 2;
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 0,
        PV: 2
    }
]
tags = ["Sort", "Nature"];
