event_inherited();
race = "Eau";

name = "Hurlement de la tribu";
mana_cost = 2;
genre = "Sort";
rarity = "commun";
booster = "Retour des Archontes";
is_player_card = true;

description = "DÃ©truisez un Abyssien alliÃ© pour donner +2/+2 Ã  tous vos autres monstres.";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY_TARGET,
        scope: "single",
        target_zone: "field",
        owner: "ally",
        criteria: { type: "Monster", name_contains: "Abyssien" },
        
        // Effet secondaire dÃ©clenchÃ© APRES la destruction rÃ©ussie
        flow_next: {
            effect_type: EFFECT_BUFF,
            scope: "all",
            owner: "ally",
            target_zone: "field",
            // Le monstre sacrifiÃ© est exclu automatiquement s'il est dÃ©truit
            ignore_context_stats: true,
            atk: 2,
            PV: 2
        }
    }
];
tags = ["Eau", "Abyssien", "Sort"];
