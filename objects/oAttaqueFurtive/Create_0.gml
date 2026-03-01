event_inherited();
race = "Ombre";  // HÃ©rite des variables et comportement de oCardMagic

// DÃ©finit les stats spÃ©cifiques de ce sort
name = "Attaque furtive"
genre = "Sort"
race = "Ombre";tags = ["Ombre", "Sort", "Combo"];
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Combo : camouflage\nInflige 2 dÃ©gÃ¢ts. Si vous contrÃ´lez un serviteur avec Camouflage, inflige 4 dÃ©gÃ¢ts Ã  la place."
mana_cost = 1;

// L'Ã©lÃ©ment dÃ©termine l'animation (ex: "Ombre" pour sBouleOmbre)
element = "Ombre";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        // criteria: { type: "Monster" }, // SupprimÃ© pour permettre de cibler le hÃ©ros adverse
        scope: "field", 
        select_mode: "target", // Indispensable pour utiliser context.target et dÃ©clencher l'animation ciblÃ©e
        element: "Ombre", // Ajout explicite pour l'animation
        owner: "enemy",
        bonus_condition: "control_camouflaged",
        bonus_value: 4,
        replace_base_value: true
    }
]

