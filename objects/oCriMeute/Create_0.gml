event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Cri de la meute"
mana_cost = 2;
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Vos Bêtes gagnent +1/+1."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" },
        atk: 1,
        PV: 1
    }
]
tags = ["Nature", "Bête"];
