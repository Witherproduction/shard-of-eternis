event_inherited();

// Définit les stats spécifiques de ce sort
name = "Linceuil d'os"
mana_cost = 2;
genre = "Secret"
race = "Ombre";
tags = ["Ombre","Secret"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Lorsqu'un serviteur allié est ciblé par un sort, annule l'effet de la carte et donne +1/+1 à votre serviteur."

effects = [
    {
        id: 1,
        secret_activation: { on_spell_cast: true, only_if_targeted_ally: true },
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        criteria: { type: "Monster" },
        atk: 1,
        PV: 1,
        negate_source_spell: true
    }
];
