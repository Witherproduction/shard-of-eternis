/// @function get_bot_decks_chap2()
/// @description Retourne la liste des decks bots pour le Chapitre 2
function get_bot_decks_chap2() {
    return [
        {
            id: "Eclaireurs_Ordre_Sang_Pur",
            name: "Éclaireurs de l'Ordre du Sang Pur",
            profile: {
                summon_weight: 75,
                board_presence_weight: 65,
                continuous_weight: 40,
                manual_effect_weight: 50,
                secret_weight: 50,
                removal_weight: 45,
                draw_weight: 30,
                tutor_weight: 20,
                risk_tolerance: 55,
                attack_bias: 65,
                defense_bias: 40,
                defense_trigger_margin: 40,
                target_monster_policy: "weakest",
                target_spell_policy: "tempo",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oAvantGardeSangPur": "front",
                        "oNeophyteSangPur": "front",
                        "oCapitaineVachon": "front",
                        "oZeloteSangPur": "front",
                        "oMissionnaireSangPur": "back",
                        "oEclaireurSangPur": "back",
                        "oMoineSangPur": "back"
                    }
                }
            },
            deck_name: "Éveil de la croisade",
            difficulty: "Facile",
            portrait: "sPortraitSoldatSangPur",
            description: "Intro Ch.2 — Ordre du Sang Pur (fermiers + croisés) et bêtes des Landes. Pas de mort-vivant, pas de légendaire. Capitaine Vachon ×1.",
            cards: [
                // Monstres (30) — Humanoïdes SP + bêtes uniquement, pas de ×4
                // 1 mana (4) — fermiers des Landes (Sang Pur)
                "oJournalierLandeSepulcre", "oJournalierLandeSepulcre",
                "oMetayerLandesSepulcre", "oMetayerLandesSepulcre",

                // 2 mana (6)
                "oZeloteSangPur", "oZeloteSangPur",
                "oNeophyteSangPur", "oNeophyteSangPur",
                "oTisseNuitNocturne", "oTisseNuitNocturne",

                // 3 mana (9)
                "oEclaireurSangPur", "oEclaireurSangPur",
                "oMoineSangPur", "oMoineSangPur",
                "oMissionnaireSangPur", "oMissionnaireSangPur",
                "oAvantGardeSangPur", "oAvantGardeSangPur",
                "oMacheOs",

                // 4 mana (8)
                "oExecuteurSangPur", "oExecuteurSangPur",
                "oCapitaineVachon",
                "oCrocEntraveBrumes", "oCrocEntraveBrumes",
                "oHurleVouteColossale", "oHurleVouteColossale",

                // 5 mana (4)
                "oKodiakSepulcre", "oKodiakSepulcre",
                "oMatriarcheBoisNoirs", "oMatriarcheBoisNoirs",

                // Magie / secrets (10) — pas Cathédrale ni Loi martiale
                "oSermentCroise", "oSermentCroise",
                "oInquisition", "oInquisition",
                "oFrappeSanctifie", "oFrappeSanctifie",
                "oJugementZelote",
                "oInterception",
                "oDeclarationHeresie",
                "oBrouillardCimetiere"
            ]
        },
        {
            id: "Inquisiteur_Malvadius",
            name: "Inquisiteur Malvadius",
            profile: {
                summon_weight: 70,
                board_presence_weight: 75,
                continuous_weight: 50,
                manual_effect_weight: 60,
                secret_weight: 70,
                removal_weight: 55,
                draw_weight: 35,
                tutor_weight: 30,
                risk_tolerance: 40,
                attack_bias: 55,
                defense_bias: 55,
                defense_trigger_margin: 50,
                target_monster_policy: "strongest",
                target_spell_policy: "value",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oAvantGardeSangPur": "front",
                        "oNeophyteSangPur": "front",
                        "oCapitaineMelrache": "front",
                        "oBondisseurSombreBranchie": "front",
                        "oCapitainePerrine": "back",
                        "oOracleSombreBranchie": "back",
                        "oSismomancienSombreBranchie": "back",
                        "oMissionnaireSangPur": "back",
                        "oExecuteurSangPur": "back"
                    }
                }
            },
            deck_name: "Inquisition",
            difficulty: "Moyen",
            portrait: "sPortraitMalvidius",
            description: "Ch.2 — Sang Pur + Abyssiens Sombre-branchie. Pas de mort-vivant. Capitaines Melrache + Perrine ×1. 15 sorts d'inquisition.",
            cards: [
                // Monstres (26) — Sang Pur + Abyssiens, max ×2, pas de bêtes
                // 1 mana (6)
                "oJournalierLandeSepulcre", "oJournalierLandeSepulcre",
                "oMetayerLandesSepulcre", "oMetayerLandesSepulcre",
                "oLanceEclairSombreBranchie", "oLanceEclairSombreBranchie",

                // 2 mana (6)
                "oZeloteSangPur", "oZeloteSangPur",
                "oNeophyteSangPur", "oNeophyteSangPur",
                "oBondisseurSombreBranchie", "oBondisseurSombreBranchie",

                // 3 mana (6)
                "oEclaireurSangPur", "oEclaireurSangPur",
                "oMoineSangPur", "oMoineSangPur",
                "oMarcheBoueSombreBranchie", "oMarcheBoueSombreBranchie",
                "oAvantGardeSangPur",

                // 4 mana (6) — dont Capitaine Perrine
                "oMissionnaireSangPur", "oMissionnaireSangPur",
                "oExecuteurSangPur", "oExecuteurSangPur",
                "oOracleSombreBranchie", "oOracleSombreBranchie",
                "oSismomancienSombreBranchie",
                "oCapitainePerrine",

                // 5 mana (1) — Capitaine Melrache
                "oCapitaineMelrache",

                // Magie / secrets (14) — pas Cathédrale ni Loi martiale
                "oInquisition", "oInquisition",
                "oSermentCroise", "oSermentCroise",
                "oFrappeSanctifie", "oFrappeSanctifie",
                "oDecretBucher", "oDecretBucher",
                "oJugementZelote",
                "oInterception",
                "oDeclarationHeresie",
                "oBrouillardCimetiere",
                "oPurificationSangPur",
                "oNegationMortuaire"
            ]
        },
        {
            id: "Gregor_Vieille_Aube",
            name: "Grégor Vieille-Aube",
            profile: {
                summon_weight: 75,
                board_presence_weight: 70,
                continuous_weight: 55,
                manual_effect_weight: 50,
                secret_weight: 40,
                removal_weight: 45,
                draw_weight: 45,
                tutor_weight: 40,
                risk_tolerance: 50,
                attack_bias: 50,
                defense_bias: 50,
                defense_trigger_margin: 48,
                target_monster_policy: "strongest",
                target_spell_policy: "value",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oPatriarchePutrescent": "front",
                        "oBriseOsPutrefie": "front",
                        "oAbominationSanguinolente": "front",
                        "oMolosseDecrepit": "front",
                        "oBansheeSepulcrale": "back",
                        "oSpectreDeletere": "back",
                        "oHurleVouteColossale": "back",
                        "oOssomancienGivroeil": "back"
                    }
                }
            },
            deck_name: "Serviteurs de la Vieille-Aube",
            difficulty: "Difficile",
            portrait: "sPortraitVieilleAube",
            description: "Ch.2 — Morts-vivants et bêtes des Landes (sans Grégor/Thalia/Devlin : ajoutés par script). Courbe 1–6, cimetière et Crépuscule.",
            cards: [
                // Monstres (30) — MV + bêtes, max ×2, pas de Vieille-Aube
                // 1 mana (4)
                "oSoldatSquelette", "oSoldatSquelette",
                "oOssomancienGivroeil", "oOssomancienGivroeil",

                // 2 mana (6)
                "oTitubantPestilentiel", "oTitubantPestilentiel",
                "oCadavreNoye", "oCadavreNoye",
                "oMortPourrissant", "oMortPourrissant",

                // 3 mana (8) — MV + bêtes
                "oMolosseDecrepit", "oMolosseDecrepit",
                "oAbominationSanguinolente", "oAbominationSanguinolente",
                "oMacheOs", "oMacheOs",
                "oDevoreurOmbres", "oDevoreurOmbres",

                // 4 mana (8)
                "oBansheeSepulcrale", "oBansheeSepulcrale",
                "oSpectreDeletere", "oSpectreDeletere",
                "oCrocEntraveBrumes", "oCrocEntraveBrumes",
                "oBriseOsPutrefie", "oBriseOsPutrefie",

                // 5 mana (3)
                "oPatriarchePutrescent",
                "oKodiakSepulcre", "oKodiakSepulcre",
                "oMatriarcheBoisNoirs",

                // Magie (10) — nécromancie / cimetière
                "oExhumationRapide", "oExhumationRapide",
                "oMorsureContagieuse", "oMorsureContagieuse",
                "oSiphonAme",
                "oMarqueDecomposition",
                "oAppelCrypte",
                "oTombeAffamee",
                "oNecropoleProfanee",
                "oContratNecromancien",
                "oSporeNecrotique"
            ]
        },
        {
            id: "Oeil_Putride",
            name: "Œil putride",
            profile: {
                summon_weight: 70,
                board_presence_weight: 65,
                continuous_weight: 50,
                manual_effect_weight: 45,
                secret_weight: 35,
                removal_weight: 40,
                draw_weight: 50,
                tutor_weight: 35,
                risk_tolerance: 55,
                attack_bias: 45,
                defense_bias: 55,
                defense_trigger_margin: 52,
                target_monster_policy: "utility",
                target_spell_policy: "value",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oProfanateurPutride": "back",
                        "oEspritVagabond": "back",
                        "oEspritTourmenteur": "back",
                        "oBatardPutride": "front",
                        "oDecerebrePutride": "front",
                        "oBriseOsPutrefie": "front",
                        "oMolosseDecrepit": "front"
                    }
                }
            },
            deck_name: "Attaque des Skarls putrides",
            difficulty: "Difficile",
            portrait: "sPortraitOeilPutride",
            description: "Ch.2 — Skarls Poil-Putride + morts-vivants + bêtes. Disruption main adverse. Œil putride via script. 30 monstres / 10 sorts.",
            cards: [
                // Monstres (30) — Skarls + MV + bêtes, max ×2
                // 1 mana (4)
                "oSoldatSquelette", "oSoldatSquelette",
                "oOssomancienGivroeil", "oOssomancienGivroeil",

                // 2 mana (6)
                "oTitubantPestilentiel", "oTitubantPestilentiel",
                "oCadavreNoye", "oCadavreNoye",
                "oMortPourrissant", "oMortPourrissant",

                // 3 mana (11) — Skarls + MV + bêtes
                "oDecerebrePutride", "oDecerebrePutride",
                "oBriseOsPutrefie", "oBriseOsPutrefie",
                "oMolosseDecrepit", "oMolosseDecrepit",
                "oMacheOs", "oMacheOs",
                "oAbominationSanguinolente",
                "oEspritVagabond", "oEspritVagabond",
                "oEspritTourmenteur",

                // 4 mana (6)
                "oBatardPutride", "oBatardPutride",
                "oSoldatCliquethorax", "oSoldatCliquethorax",
                "oCrocEntraveBrumes", "oCrocEntraveBrumes",

                // 5 mana (3) — Skarls (Œil putride via script)
                "oProfanateurPutride", "oProfanateurPutride",
                "oEspritTourmenteur",
                "oKodiakSepulcre",

                // Magie (10) — attrition / cimetière / main adverse
                "oMarqueDecomposition", "oMarqueDecomposition",
                "oMorsureContagieuse", "oMorsureContagieuse",
                "oExhumationRapide",
                "oSiphonAme",
                "oContratNecromancien",
                "oMoissonMacabre",
                "oSporeNecrotique",
                "oTombeAffamee",
                "oAppelCrypte"
            ]
        },
        {
            id: "Roi_Necromancien",
            name: "Roi nécromancien",
            profile: {
                summon_weight: 65,
                board_presence_weight: 70,
                continuous_weight: 60,
                manual_effect_weight: 55,
                secret_weight: 45,
                removal_weight: 50,
                draw_weight: 50,
                tutor_weight: 45,
                risk_tolerance: 45,
                attack_bias: 50,
                defense_bias: 50,
                defense_trigger_margin: 48,
                target_monster_policy: "strongest",
                target_spell_policy: "value",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oPatriarchePutrescent": "front",
                        "oAbominationSanguinolente": "front",
                        "oMolosseDecrepit": "front",
                        "oBansheeSepulcrale": "back",
                        "oNecropoleProfanee": "back",
                        "oEspritTourmenteur": "back",
                        "oSpectreDeletere": "back"
                    }
                }
            },
            deck_name: "Domination nécrotique",
            difficulty: "Très difficile",
            portrait: "sPortraitRoiNecromancien",
            description: "Ch.2 — Suprématie mort-vivant : swarm, DoT, cimetière. Roi nécromancien via script. Patriarche finisseur.",
            cards: [
                // Monstres (30) — MV + quelques bêtes DoT, max ×2, Roi/Reine via script
                // 1 mana (4) — DoT / swarm
                "oSoldatSquelette", "oSoldatSquelette",
                "oTitubantPestilentiel", "oTitubantPestilentiel",

                // 2 mana (6)
                "oCadavreNoye", "oCadavreNoye",
                "oMortPourrissant", "oMortPourrissant",
                "oTisseNuitNocturne", "oTisseNuitNocturne",

                // 3 mana (10) — valeur cimetière + ping
                "oOssomancienGivroeil", "oOssomancienGivroeil",
                "oMolosseDecrepit", "oMolosseDecrepit",
                "oAbominationSanguinolente", "oAbominationSanguinolente",
                "oSoldatCliquethorax", "oSoldatCliquethorax",
                "oEspritTourmenteur", "oEspritTourmenteur",

                // 4 mana (6) — contrôle + DoT
                "oBansheeSepulcrale", "oBansheeSepulcrale",
                "oCrocEntraveBrumes", "oCrocEntraveBrumes",
                "oSpectreDeletere", "oSpectreDeletere",

                // 5 mana (2) — DoT fin de tour
                "oMatriarcheBoisNoirs", "oMatriarcheBoisNoirs",

                // 7 mana (1) — scaling cimetière
                "oPatriarchePutrescent",

                // Magie (10) — nécropole / réanimation / poison
                "oNecropoleProfanee",
                "oTombeAffamee",
                "oExhumationRapide", "oExhumationRapide",
                "oAppelCrypte", "oAppelCrypte",
                "oContratNecromancien",
                "oSporeNecrotique",
                "oMoissonMacabre",
                "oMarqueDecomposition",
                "oSiphonAme"
            ]
        },
        {
            id: "Kelthazar",
            name: "Généralissime du Sang-pur",
            profile: {
                summon_weight: 85,
                board_presence_weight: 85,
                continuous_weight: 50,
                manual_effect_weight: 60,
                secret_weight: 45,
                removal_weight: 60,
                draw_weight: 30,
                tutor_weight: 25,
                risk_tolerance: 60,
                attack_bias: 75,
                defense_bias: 45,
                defense_trigger_margin: 40,
                target_monster_policy: "strongest",
                target_spell_policy: "tempo",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oAvantGardeSangPur": "front",
                        "oCapitaineVachon": "front",
                        "oCapitaineMelrache": "front",
                        "oNeophyteSangPur": "front",
                        "oExecuteurSangPur": "front",
                        "oMissionnaireSangPur": "back",
                        "oEclaireurSangPur": "back",
                        "oCapitainePerrine": "back",
                        "oMoineSangPur": "back"
                    }
                }
            },
            deck_name: "Bastion du Sang Pur",
            difficulty: "Très difficile",
            portrait: "sPortraitKelthazar",
            description: "Ch.2 — Armée Sang Pur + 3 capitaines. Généralissime via script. 30 monstres / 10 sorts.",
            cards: [
                // Monstres (30) — Sang Pur, limites : commun/rare ×3, épique ×2, légendaire ×1
                // 1 mana (6) — commun ×3
                "oJournalierLandeSepulcre", "oJournalierLandeSepulcre", "oJournalierLandeSepulcre",
                "oMetayerLandesSepulcre", "oMetayerLandesSepulcre", "oMetayerLandesSepulcre",

                // 2 mana (6) — commun ×3
                "oZeloteSangPur", "oZeloteSangPur", "oZeloteSangPur",
                "oNeophyteSangPur", "oNeophyteSangPur", "oNeophyteSangPur",

                // 3 mana (11) — commun ×3, missionnaire rare ×2
                "oEclaireurSangPur", "oEclaireurSangPur", "oEclaireurSangPur",
                "oMoineSangPur", "oMoineSangPur", "oMoineSangPur",
                "oAvantGardeSangPur", "oAvantGardeSangPur", "oAvantGardeSangPur",
                "oMissionnaireSangPur", "oMissionnaireSangPur",

                // 4 mana (5) — exécuteur rare ×2, capitaines
                "oExecuteurSangPur", "oExecuteurSangPur",
                "oCapitaineVachon", "oCapitaineVachon",
                "oCapitainePerrine",

                // 5 mana (2) — épique ×2
                "oCapitaineMelrache", "oCapitaineMelrache",

                // Magie (10) — rare ×3 max
                "oSermentCroise", "oSermentCroise", "oSermentCroise",
                "oInquisition", "oInquisition",
                "oFrappeSanctifie", "oFrappeSanctifie",
                "oDecretBucher",
                "oLoiMartiale",
                "oCathedraleSangPur"
            ]
        },
        {
            id: "Grande_Pretresse_Sang_Pur",
            name: "Grande prêtresse du Sang Pur",
            profile: {
                summon_weight: 70,
                board_presence_weight: 80,
                continuous_weight: 55,
                manual_effect_weight: 55,
                secret_weight: 50,
                removal_weight: 50,
                draw_weight: 35,
                tutor_weight: 25,
                risk_tolerance: 45,
                attack_bias: 55,
                defense_bias: 65,
                defense_trigger_margin: 52,
                target_monster_policy: "utility",
                target_spell_policy: "value",
                custom_rules: {
                    placement_strategy: "tank_front_dps_back",
                    placement_priority: {
                        "oAvantGardeSangPur": "front",
                        "oCapitaineVachon": "front",
                        "oCapitaineMelrache": "front",
                        "oNeophyteSangPur": "front",
                        "oExecuteurSangPur": "front",
                        "oMissionnaireSangPur": "back",
                        "oEclaireurSangPur": "back",
                        "oCapitainePerrine": "back",
                        "oMoineSangPur": "back"
                    }
                }
            },
            deck_name: "Lumière du Sang Pur",
            difficulty: "Très difficile",
            portrait: "sPortraitGrandePretresse",
            description: "Ch.2 — Même armée que le Généralissime. Grande prêtresse + Généralissime via script. 3 capitaines dans le deck.",
            cards: [
                // Monstres (30) — identique au Généralissime (boss légendaires via script)
                // 1 mana (6) — commun ×3
                "oJournalierLandeSepulcre", "oJournalierLandeSepulcre", "oJournalierLandeSepulcre",
                "oMetayerLandesSepulcre", "oMetayerLandesSepulcre", "oMetayerLandesSepulcre",

                // 2 mana (6) — commun ×3
                "oZeloteSangPur", "oZeloteSangPur", "oZeloteSangPur",
                "oNeophyteSangPur", "oNeophyteSangPur", "oNeophyteSangPur",

                // 3 mana (11) — commun ×3, missionnaire rare ×2
                "oEclaireurSangPur", "oEclaireurSangPur", "oEclaireurSangPur",
                "oMoineSangPur", "oMoineSangPur", "oMoineSangPur",
                "oAvantGardeSangPur", "oAvantGardeSangPur", "oAvantGardeSangPur",
                "oMissionnaireSangPur", "oMissionnaireSangPur",

                // 4 mana (5) — exécuteur rare ×2, capitaines
                "oExecuteurSangPur", "oExecuteurSangPur",
                "oCapitaineVachon", "oCapitaineVachon",
                "oCapitainePerrine",

                // 5 mana (2) — épique ×2
                "oCapitaineMelrache", "oCapitaineMelrache",

                // Magie (10) — rare ×3 max
                "oSermentCroise", "oSermentCroise", "oSermentCroise",
                "oInquisition", "oInquisition",
                "oFrappeSanctifie", "oFrappeSanctifie",
                "oDecretBucher",
                "oLoiMartiale",
                "oCathedraleSangPur"
            ]
        }
    ];
}
