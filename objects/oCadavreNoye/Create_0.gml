// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Cadavre noyé"
attack = 1;
PV = 1;
mana_cost = 2;
genre = "Mort-vivant"
race = "Zombie";
tags = ["Mort-vivant", "Zombie", "Brisé", "Entrave"];
booster = "Retour des Archontes"
rarity = "commun"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Brisé : Entrave tous les serviteurs ennemis sur la ligne de retrait pendant 1 tour."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_ENTRAVE,
        scope: "all",
        owner: "enemy",
        back_line_only: true
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



