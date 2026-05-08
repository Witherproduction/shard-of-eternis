event_inherited();

// Définit les stats spécifiques de ce sort
name = "Interception"
mana_cost = 2;
genre = "Secret"
race = "Lumiere";
tags = ["Lumiere","Secret"];
rarity = "Rare"
booster = "Retour des Archontes"
is_player_card = true;

description = "Lorsqu'un monstre adverse attaque, redirige l'attaque vers un Humanoïde allié qui gagne +2 PV."

effects = [
    {
        id: 1,
        secret_activation: { direct_attack: true },
        effect_type: EFFECT_BUFF,
        scope: "single",
        owner: "ally",
        select_mode: "random",
        criteria: { type: "Monster", genre: "Humanoïde" },
        atk: 0,
        PV: 2,
        temporary: false,
        redirect_attack_to_target: true
    }
];
