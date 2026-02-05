event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Chasse en meute"
mana_cost = 3;
genre = "Sort"
archetype = "Forêt des voleurs"
rarity = "commun"
booster = "A la découverte du monde"
is_player_card = true;
element = "physique"

description = "Inflige 2 dégats à votre adversaire pour chaque Bête que vous contrôlez."
effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_POINTS,
        scope: "lp",
        owner: "enemy",
        operation: "damage",
        value_per_card: 2,
        count_owner: "ally",
        target_zone: "field",
        criteria: { type: "Monster", genre: "Bête" }
    }
]
