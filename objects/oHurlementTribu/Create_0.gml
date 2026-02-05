event_inherited();

name = "Hurlement de la tribu";
mana_cost = 2;
genre = "Sort";
archetype = "Forêt des voleurs";
rarity = "commun";
booster = "A la découverte du monde";
is_player_card = true;

description = "Détruisez un Abyssien allié pour donner +2/+2 à tous vos autres monstres.";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY_TARGET,
        scope: "single",
        target_zone: "field",
        owner: "ally",
        criteria: { type: "Monster", name_contains: "Abyssien" },
        
        // Effet secondaire déclenché APRES la destruction réussie
        secondary_effect: {
            effect_type: EFFECT_BUFF,
            scope: "all",
            owner: "ally",
            target_zone: "field",
            // Le monstre sacrifié est exclu automatiquement s'il est détruit, 
            // mais on peut ajouter une sécurité si nécessaire
            atk: 2,
            PV: 2
        }
    }
];

