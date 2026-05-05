// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Mache-les-os"
attack = 2;
PV = 4;
mana_cost = 3;
genre = "Bête"
race = "Rapace";
tags = ["Bête", "Rapace", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Selectionnez un serviteur. Jusqu'a la fin du tour, il subit +1 dégats lors des attaques."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_MARK_ATTACK_DAMAGE,
        value: 1,
        owner: "both",
        target_zone: "field",
        criteria: { type: "Monster" },
        duration_mode: "until_end_of_turn",
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



