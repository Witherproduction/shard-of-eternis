event_inherited();

name = "Coquillage des marées";
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "rare";
booster = "A la découverte du monde";
is_player_card = true;

description = "Donne +2 PV à tous vos serviteurs.";
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "all",
        target_zone: "field",
        owner: "ally",
        criteria: { type: "Monster" },
        atk: 0,
        PV: 2
    }
];
