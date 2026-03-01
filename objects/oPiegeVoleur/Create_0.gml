event_inherited();
race = "Nature";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Piège du voleur"
genre = "Secret"
rarity = "rare"
booster = "Retour des Archontes"
is_player_card = true;

mana_cost = 2;

description = "S'active lorsque votre adversaire invoque un monstre : l'entrave et lui inflige -2 d'attaque.";
effects = [
    {
        id: 1,
        secret_activation: { on_summon: true },
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        target_source: "summoned",
        flow: [
            {
                effect_type: EFFECT_LOSE_ATTACK_PERMANENT,
                value: 2
            }
        ]
    }
]
tags = ["Sort", "Secret", "Entrave"];
