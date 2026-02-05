event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Saut du prédateur"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;

description = "Inflige des dégâts égaux à l'Attaque de votre Bête la plus puissante à un serviteur adverse.";
mana_cost = 2;
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        scope: "single",
        use_highest_attack_of_genre: "Bête",
        target_zone: "field",
        owner: "enemy",
        criteria: {
            type: "Monster"
        }
    }
]
