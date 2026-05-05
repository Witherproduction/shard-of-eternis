event_inherited();

// Définit les stats spécifiques de ce sort
name = "Appel des cryptes"
mana_cost = 4;
genre = "Sort"
race = "Ombre";
tags = ["Ombre", "Sort"];
rarity = "Epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Invoque un mort-vivant de niveau 3 ou moins sur votre terrain."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        from_deck_only: true,
        select_mode: "random",
        criteria: { type: "Monster", genre: "Mort-vivant", star_lte: 3 }
    }
]
