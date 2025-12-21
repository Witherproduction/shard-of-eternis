event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Double jeu"
genre = "Direct"
archetype = "Forêt des voleurs"
rarity = "rare"
booster = "A la découverte du monde"
is_player_card = true;

description = "Selectione un monstre adverse. Invoque une copie de ce monstre sur votre terrain. Il ne peut pas attaquer."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_SUMMON,
        summon_mode: "copy_target",
        scope: "single",
        owner: "enemy",
        target_zone: "field",
        criteria: { type: "Monster" }
    }
]
