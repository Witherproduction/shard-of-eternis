event_inherited();
race = "Ombre";  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Attaque furtive"
genre = "Sort"
race = "Ombre";tags = ["Ombre", "Sort", "Combo"];archetype = "Forêt des voleurs"
rarity = "epique"
booster = "Retour des Archontes"
is_player_card = true;

description = "Combo : camouflage\nInflige 2 dégâts. Si vous contrôlez un serviteur avec Camouflage, inflige 4 dégâts à la place."
mana_cost = 1;

// L'élément détermine l'animation (ex: "Ombre" pour sBouleOmbre)
element = "Ombre";

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DAMAGE_TARGET,
        value: 2,
        // criteria: { type: "Monster" }, // Supprimé pour permettre de cibler le héros adverse
        scope: "field", 
        select_mode: "target", // Indispensable pour utiliser context.target et déclencher l'animation ciblée
        element: "Ombre", // Ajout explicite pour l'animation
        owner: "enemy",
        bonus_condition: "control_camouflaged",
        bonus_value: 4,
        replace_base_value: true
    }
]
