event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Attaque furtive"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Combo : camouflage\nInflige 2 dégâts. Si vous contrôlez un serviteur avec Camouflage, inflige 4 dégâts à la place."
mana_cost = 1;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        criteria: { type: "Monster" },
        owner: "enemy",
        bonus_condition: "control_camouflaged",
        bonus_value: 4,
        replace_base_value: true
    }
]

