event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Saut du prédateur"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige des dégâts égaux à l'Attaque de votre Bête la plus puissante à un serviteur adverse.";
mana_cost = 2;
element = "Nature";
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        conditions: {
            min_genre_count_on_field: {
                genre: "Bête",
                owner: "ally",
                count: 1
            }
        },
        scope: "single",
        select_mode: "target",
        use_highest_attack_of_genre: "Bête",
        highest_attack_source_owner: "ally",
        target_zone: "field",
        owner: "enemy",
        criteria: {
            type: "Monster"
        }
    }
]
tags = ["Sort", "Nature"];
