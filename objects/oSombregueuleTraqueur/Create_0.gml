// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Sombregueule traqueur"
attack = 4;
PV = 1;
mana_cost = 3;
genre = "Bête"
race = "Loup";
tags = ["Bête", "Loup", "Charge", "Eveil"];
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
has_charge = true;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Charge. Eveil : Réduit de 2 l'ATK d'un monstres adverse aléatoire jusqu'a la fin du tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_LOSE_ATTACK,
        value: 2,
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        select_mode: "random",
        duration_mode: "until_end_of_turn",
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



