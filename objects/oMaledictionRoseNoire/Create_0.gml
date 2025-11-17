event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Malédiction de la Rose noire"
genre = "Continue"
archetype = "Rose noire"
rarity = "commun"
booster = "Chemin perdu"
is_player_card = true;

description = "Les monstres sur le terrain perdent 500/500. Tombe : Inflige 500 dégâts à votre adversaire pour chaque monstre Rose noire sur le terrain."

// === EFFETS DE LA CARTE ===
if (!variable_instance_exists(id, "effects")) effects = [];
effects[0] = {
    trigger: TRIGGER_CONTINUOUS,
    effect_type: EFFECT_AURA_ALL_MONSTERS_DEBUFF,
    atk: -500,
    def: -500
};

// Nettoyage de l’aura quand la carte quitte le terrain
effects[1] = {
    trigger: TRIGGER_LEAVE_FIELD,
    effect_type: EFFECT_AURA_CLEANUP_SOURCE
};

// Effet Tombe : dégâts par monstre Rose noire sur le terrain
effects[2] = {
    trigger: TRIGGER_ON_DESTROY,
    effect_type: EFFECT_POINTS,
    scope: "lp",
    op: "damage",
    lp_owner: "enemy",
    value_per_card: 500,
    target_zone: "field",
    count_owner: "both",
    criteria: { archetype: "Rose noire", type: "Monster" }
};