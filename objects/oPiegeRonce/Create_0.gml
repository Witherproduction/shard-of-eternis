event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Piège de ronce"
genre = "Secret"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;
mana_cost = 2;

description = "Secret : Quand un ennemi vous attaque, inflige 2 dégâts à tous les serviteurs adverses."
effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        owner: "enemy",
        scope: "all"
    }
];
