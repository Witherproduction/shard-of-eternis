event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "PiÃ¨ge de ronce"
genre = "Secret"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;
mana_cost = 2;

description = "Secret : Quand un ennemi vous attaque, inflige 2 dÃ©gÃ¢ts Ã  tous les serviteurs adverses."
element = "Nature";
effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        owner: "enemy",
        scope: "all",
        monster_type: "Monster",
        element: "multicible"
    }
];
tags = ["Sort", "Secret", "Canture"];
