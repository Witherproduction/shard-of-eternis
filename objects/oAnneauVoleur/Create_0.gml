event_inherited();

name = "Anneau du voleur";
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "epique";
booster = "A la découverte du monde";
is_player_card = true;

description = "Vole une carte aléatoire du deck de votre adversaire et l'ajoute à votre main.";
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_PILLAGE,
        operation: "steal",
        source_zone: "Deck",
        destination: "Hand",
        random_select: true,
        value: 1
    }
];
