event_inherited();

// Définit les stats spécifiques de ce sort
name = "MoissonMacabre"
mana_cost = 5;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Détruisez un serviteur allié. Inflige des dégats répartie aléatoirement parmis les ennemies égaux au PV du monstre détruit."

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SACRIFICE_TARGET,
        owner: "ally",
        criteria: { type: "Monster" },
        flow_next: {
            effect_type: EFFECT_RANDOM_PROJECTILES,
            use_context_def_value_as_count: true,
            damage: 1,
            include_enemy_hero: true,
            element: "ombre"
        }
    }
];
