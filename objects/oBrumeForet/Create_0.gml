event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Brume de la forêt"
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "epique"
booster = "A la découverte du monde"
is_player_card = true;

description = "Confère +2 ATK et Camouflage à un serviteur allié.\nCombo (Camouflage) : Détruit un serviteur ennemi aléatoire."
mana_cost = 2;

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_DESTROY_TARGET,
        select_mode: "random",
        owner: "enemy",
        criteria: { type: "Monster" },
        condition: "control_camouflaged"
    },
    {
        id: 2,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        target_type: "monster",
        scope: "single",
        owner: "ally",
        atk: 2,
        PV: 0,
        grant_camouflage: true
    }
]
