event_inherited();

name = "Sournoiserie";
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "rare";
booster = "A la découverte du monde";
is_player_card = true;

description = "Inflige 2 dégâts à un serviteur ennemi et l'Entrave.";
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        damage: 2,
        scope: "single",
        target_zone: "field",
        owner: "enemy",
        criteria: { type: "Monster" },
        flow: [
            { effect_type: EFFECT_ENTRAVE, scope: "single" }
        ]
    }
];
