// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Guetteuse des conduits"
attack = 2;
PV = 2;
mana_cost = 3;
genre = "Bête"
race = "Araignée";
tags = ["Bête", "Araignée", "Camouflage", "Attaque"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Lorsque cette carte combat un serviteur, l'entrave."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        owner: "enemy",
        target_source: "defender",
        conditions: {
            attacker_is_self: true,
            requires_defender_monster: true
        },
        label: "Attaque"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



