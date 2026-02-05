event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Brume trompeuse"
mana_cost = 5;
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "legendaire"
booster = "A la découverte du monde"
is_player_card = true;

description = "Détruit tous les serviteurs qui n'ont pas Camouflage."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY,
        owner: "both",
        target_zone: "Field",
        target_types: ["Monster"],
        criteria: { exclude_camouflaged: true },
        select_all: true
    }
]
