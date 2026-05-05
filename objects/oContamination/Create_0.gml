event_inherited();

// Définit les stats spécifiques de ce sort
name = "Contamination"
mana_cost = 4;
genre = "Sort"
race = "Ombre";
tags = ["Ombre"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Inflige 1 dégats à tout les monstres ennemis. Répète cet effet pour chaque serviteur mort durant le tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_ALL_REPEAT_PER_DEATHS_THIS_TURN,
        value: 1,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" }
    }
]
