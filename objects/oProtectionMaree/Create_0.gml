event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Protection de la marée";
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "commun";
booster = "A la découverte du monde";
is_player_card = true;

mana_cost = 2;

description = "Donne +2 PV à tous les Abyssiens sur votre terrain.";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all_allies",
        atk: 0,
        PV: 2,
        owner: "ally",
        criteria: {
            name_contains: "Abyssien",
            type: "monster"
        }
    }
];
