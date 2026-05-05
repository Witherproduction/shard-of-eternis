// Définit les stats spécifiques de ce monstre (AVANT inherited pour que oCardParent initialise bien current_hp)
name = "Devlin Vieille-Aube"
attack = 5;
PV = 7;
mana_cost = 8;
genre = "Mort-vivant"
race = "Goule";
tags = ["Mort-vivant", "Goule", "Crépuscule"];
booster = "Retour des Archontes"
rarity = "legendaire"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Si Grégor Vieille-Aube est dans votre cimetière, gagne +3 ATK. Si Thalia Vieille-Aube est dans votre cimetière, gagne +3 PV. Si les deux sont dans votre cimetière : Crépuscule : inflige 2 dégâts d'Ombre à tous les ennemis."
effects = [];
array_push(effects, {
    id: 1,
    trigger: TRIGGER_CONTINUOUS,
    effect_type: EFFECT_TRACK_GRAVEYARD_PRESENCE,
    tracker_key: "devlin",
    checks: [
        { key: "gregor", object_name: "oGregorVieilleAube" },
        { key: "thalia", object_name: "oThaliaVieilleAube" }
    ],
    activate_effect_ids: [2, 3]
});
array_push(effects, {
    id: 2,
    trigger: TRIGGER_PASSIVE,
    effect_type: EFFECT_SET_SELF_BUFF_CONTRIB,
    contrib_key: "devlin_gregor",
    atk: 3,
    PV: 0,
    presence_key: "gregor"
});
array_push(effects, {
    id: 3,
    trigger: TRIGGER_PASSIVE,
    effect_type: EFFECT_SET_SELF_BUFF_CONTRIB,
    contrib_key: "devlin_thalia",
    atk: 0,
    PV: 3,
    presence_key: "thalia"
});
array_push(effects, {
    id: 4,
    trigger: TRIGGER_END_TURN,
    effect_type: EFFECT_CONDITIONAL_FLOW,
    conditions: { owner_turn: true },
    cond: { type: "tracker_flags", tracker_key: "devlin", all: ["gregor", "thalia"] },
    flow: {
        id: 41,
        effect_type: EFFECT_DAMAGE_ALL,
        value: 2,
        owner: "enemy",
        target_zone: "field",
        monster_type: "Monster",
        visual_fx: "multicible",
        element: "ombre"
    }
});
array_push(effects, { id: 5, trigger: TRIGGER_ENTER_GRAVEYARD, effect_type: EFFECT_REMOVE_SELF_BUFF_CONTRIBS, contrib_keys: ["devlin_gregor", "devlin_thalia"] });

event_inherited();  // Hérite des variables et comportement de oCardMonster



