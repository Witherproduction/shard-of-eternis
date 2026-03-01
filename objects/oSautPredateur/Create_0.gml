event_inherited();
race = "Nature";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Saut du prÃ©dateur"
genre = "Sort"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige des dÃ©gÃ¢ts Ã©gaux Ã  l'Attaque de votre BÃªte la plus puissante Ã  un serviteur adverse.";
mana_cost = 2;
element = "Nature";
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        conditions: {
            min_genre_count_on_field: {
                genre: "BÃªte",
                owner: "ally",
                count: 1
            }
        },
        scope: "single",
        select_mode: "target",
        use_highest_attack_of_genre: "BÃªte",
        highest_attack_source_owner: "ally",
        target_zone: "field",
        owner: "enemy",
        criteria: {
            type: "Monster"
        }
    }
]
tags = ["Sort", "Nature"];
