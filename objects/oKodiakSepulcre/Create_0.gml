// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Kodiak du sépulcre"
attack = 3;
PV = 6;
mana_cost = 5;
genre = "Bête"
race = "Ours";
tags = ["Bête", "Ours"];
booster = "Retour des Archontes"
rarity = "epique"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Lorsque cette carte combat un monstre sur la ligne de retrait, il gagne temporairement +2ATK."

event_inherited();  // Hérite des variables et comportement de oCardMonster

effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_ATTACK,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_source: "self",
        conditions: {
            attacker_is_self: true,
            requires_defender_monster: true,
            defender_field_position_in: [4, 5, 6, 7]
        },
        atk: 2,
        PV: 0,
        temporary: true,
        label: "Attaque"
    }
]




