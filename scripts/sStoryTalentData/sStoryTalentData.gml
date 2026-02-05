/// @function get_hero_talent_tree(hero_id)
/// @description Retourne l'arbre de talent pour un héros donné
function get_hero_talent_tree(hero_id) {
    // Structure: Tableau de "Tiers" (Paliers).
    // Chaque Tier est un tableau de 2 choix (Gauche/Droite).
    
    if (hero_id == "kaelen") {
        return [
            // Tier 1 (Débloqué après Chapitre 1)
            {
                req_chapter: 1,
                choices: [
                    {
                        id: "kaelen_t1_a",
                        name: "Ravitaillement",
                        description: "Le soldat coûte (1) mana de moins.",
                        effect_type: "cost_reduction",
                        value: 1
                    },
                    {
                        id: "kaelen_t1_b",
                        name: "Entraînement",
                        description: "Le soldat gagne +1/+1.",
                        effect_type: "stat_buff",
                        value: 1
                    }
                ]
            },
            // Tier 2 (Débloqué après Chapitre 2)
            {
                req_chapter: 2,
                choices: [
                    {
                        id: "kaelen_t2_a",
                        name: "Garde d'Elite",
                        description: "Le soldat a Provocation.",
                        effect_type: "keyword_taunt",
                        value: 1
                    },
                    {
                        id: "kaelen_t2_b",
                        name: "Embuscade",
                        description: "Le soldat a Charge.",
                        effect_type: "keyword_charge",
                        value: 1
                    }
                ]
            },
             // Tier 3 (Débloqué après Chapitre 3)
            {
                req_chapter: 3,
                choices: [
                    {
                        id: "kaelen_t3_a",
                        name: "Armée",
                        description: "Invoque 2 soldats au lieu d'un.",
                        effect_type: "double_summon",
                        value: 1
                    },
                    {
                        id: "kaelen_t3_b",
                        name: "Vétéran",
                        description: "Le soldat gagne Bouclier Divin.",
                        effect_type: "keyword_divine_shield",
                        value: 1
                    }
                ]
            }
        ];
    }
    
    return [];
}
