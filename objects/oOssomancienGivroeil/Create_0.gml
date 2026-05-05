// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Ossomancien givroeil"
attack = 1;
PV = 1;
mana_cost = 1;
genre = "Mort-vivant"
race = "Squelette";
tags = ["Mort-vivant", "Squelette", "Eveil", "Entrave"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Eveil : Entrave un serviteur ennemi aléatoire."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_SUMMON,
        effect_type: EFFECT_ENTRAVE,
        scope: "single",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" },
        select_mode: "random",
        label: "Eveil"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



