event_inherited();  // Hérite des variables et comportement de oCardMagic

// Définit les stats spécifiques de ce sort
name = "Armement : Griffe explosive"
genre = "Artéfact"
archetype = "Robot d'assaut"
rarity = "commun"
booster = "Usine robotique"
is_player_card = true;

description = "Ne peut être équipé que sur un Méca. Lorsque le monstre équipé attaque un monstre, détruit les deux monstres avant le calcul des dommages."

effects = [];
array_push(effects, { trigger: TRIGGER_MAIN_PHASE, effect_type: EFFECT_EQUIP_SELECT_TARGET, allowed_genres: ["Méca"], ally_only: false, description: "Choisissez un Méca à équiper; posez cette carte." });
array_push(effects, { trigger: TRIGGER_ON_ATTACK, effect_type: EFFECT_DESTROY_TARGET, target_source: "defender", conditions: { attacker_is_equipped_target: true, requires_defender_monster: true }, description: "Quand le monstre équipé attaque un monstre : détruisez les deux.", flow: [ { effect_type: EFFECT_DESTROY_TARGET, target_source: "attacker" } ] });
array_push(effects, { trigger: TRIGGER_ON_DESTROY, effect_type: EFFECT_EQUIP_CLEANUP, description: "Réinitialise le monstre équipé et détache la cible." });