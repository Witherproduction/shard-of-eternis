// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Reine Banshee, archère d'ombre"
attack = 5;
PV = 7;
mana_cost = 6;
genre = "Mort-vivant"
race = "Eveillé";
tags = ["Mort-vivant", "Eveillé", "Attaque", "Brisé"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Quand cette carte attaque, inflige 2 dégâts à un serviteur ennemi aléatoire et au héros adverse. Brisé : Invoque Reine banshee, forme spectrale."
effects = [
    {
        id: 1,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_RANDOM_PROJECTILES,
        damage: 2,
        count: 1,
        include_enemy_hero: false,
        label: "Attaque",
        conditions: { attacker_is_self: true }
    },
    {
        id: 2,
        trigger: TRIGGER_AFTER_ATTACK,
        effect_type: EFFECT_POINTS,
        scope: "lp",
        op: "damage",
        value: 2,
        owner: "enemy",
        label: "Attaque",
        conditions: { attacker_is_self: true }
    },
    {
        id: 3,
        trigger: TRIGGER_ON_DESTROY,
        effect_type: EFFECT_SUMMON,
        summon_mode: "named",
        object_name: "oReineBansheeFormeSpectral",
        placement_criteria: { relative_role: "same" },
        label: "Brisé"
    }
]

event_inherited();  // Hérite des variables et comportement de oCardMonster



