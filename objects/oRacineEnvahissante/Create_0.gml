event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Racine envahissante"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Gèle tous les serviteurs adverses.";
mana_cost = 3;
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_ENTRAVE,
        scope: "all",
        owner: "enemy",
        target_zone: "field"
    }
]
