/// @function chap2_bot_grande_pretresse_is_duel()
function chap2_bot_grande_pretresse_is_duel() {
    return (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id == "Grande_Pretresse_Sang_Pur");
}

/// @function chap2_hero_mana_ramp_bonus()
/// @description Bonus de ramp mana héros (duel spécifique). Kelthazar : +1 max par tour héros.
function chap2_hero_mana_ramp_bonus() {
    if (!variable_global_exists("selected_bot_deck_id")) return 0;
    if (global.selected_bot_deck_id == "Kelthazar") return 1;
    return 0;
}

/// @function chap2_hero_uses_flat_mana_ten()
/// @description Grande prêtresse : 10 mana max remplis à chaque tour héros.
function chap2_hero_uses_flat_mana_ten() {
    return chap2_bot_grande_pretresse_is_duel();
}

/// @function chap2_hero_mana_per_turn_total()
/// @description Total de mana max gagné à chaque tour héros (1 + bonus).
function chap2_hero_mana_per_turn_total() {
    return 1 + chap2_hero_mana_ramp_bonus();
}

/// @function chap2_hero_mana_boost_is_active()
function chap2_hero_mana_boost_is_active() {
    return (chap2_hero_mana_ramp_bonus() > 0);
}

/// @function chap2_bot_try_show_mana_boost_toast(game_inst)
/// @description Toast unique Vespera — explique le bonus mana (duel Kelthazar).
function chap2_bot_try_show_mana_boost_toast(game_inst) {
    if (!chap2_hero_mana_boost_is_active()) return false;
    if (!variable_instance_exists(game_inst, "ch2_mana_boost_toast_done")) game_inst.ch2_mana_boost_toast_done = false;
    if (game_inst.ch2_mana_boost_toast_done) return false;
    game_inst.ch2_mana_boost_toast_done = true;

    return chap2_bot_show_vespera_toast(game_inst, "Le don de la reine me renforce, j'accumule la mana plus vite !");
}

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
            description: "Ch.2 — Finale Sang Pur. Grande prêtresse sur le terrain (PV liés au bot). Brûlure et mana 10 pour Vespera.",
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

/// @function chap2_bot_story_context_ok(game_inst)
function chap2_bot_story_context_ok(game_inst) {
    if (game_inst == noone || !instance_exists(game_inst)) return false;
    if (!variable_global_exists("selected_bot_deck_id")) return false;
    if (!variable_global_exists("previous_room_before_duel") || global.previous_room_before_duel != rScenario) return false;
    if (!variable_instance_exists(game_inst, "timerEnabledMulligan") || game_inst.timerEnabledMulligan) return false;
    if (!variable_instance_exists(game_inst, "player_current")) return false;
    if (game_inst.player_current != 1) return false;
    return true;
}

/// @function chap2_bot_story_context_ok_hero(game_inst)
function chap2_bot_story_context_ok_hero(game_inst) {
    if (game_inst == noone || !instance_exists(game_inst)) return false;
    if (!variable_global_exists("selected_bot_deck_id")) return false;
    if (!variable_global_exists("previous_room_before_duel") || global.previous_room_before_duel != rScenario) return false;
    if (!variable_instance_exists(game_inst, "timerEnabledMulligan") || game_inst.timerEnabledMulligan) return false;
    if (!variable_instance_exists(game_inst, "player_current")) return false;
    var heroIdx = (variable_instance_exists(game_inst, "local_player_index")) ? game_inst.local_player_index : 0;
    if (game_inst.player_current != heroIdx) return false;
    return true;
}

/// @function chap2_bot_show_vespera_toast(game_inst, text)
function chap2_bot_show_vespera_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitVespera", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_soldat_toast(game_inst, text)
function chap2_bot_show_soldat_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitSoldatSangPur", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_kelthazar_toast(game_inst, text)
function chap2_bot_show_kelthazar_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitKelthazar", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_roi_necromancien_toast(game_inst, text)
function chap2_bot_show_roi_necromancien_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitRoiNecromancien", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_oeil_putride_toast(game_inst, text)
function chap2_bot_show_oeil_putride_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitOeilPutride", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_gregor_toast(game_inst, text)
/// @description Répliques de Grégor (portrait famille Vieille-Aube)
function chap2_bot_show_gregor_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitVieilleAube", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_show_grande_pretresse_toast(game_inst, text)
function chap2_bot_show_grande_pretresse_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitGrandePretresse", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_sync_linked_boss_hp_from_lp()
/// @description Met à jour les PV affichés de la Grande prêtresse liée selon oLP_Enemy.
function chap2_bot_sync_linked_boss_hp_from_lp() {
    if (!chap2_bot_grande_pretresse_is_duel()) return;
    var lpE = instance_find(oLP_Enemy, 0);
    if (lpE == noone) return;
    with (oCardMonster) {
        if (!isHeroOwner && variable_instance_exists(id, "ch2_boss_lp_linked") && ch2_boss_lp_linked) {
            current_hp = lpE.nbLP;
            max_hp = max(max_hp, current_hp);
        }
    }
}

/// @function chap2_bot_grande_pretresse_apply_boss_link()
function chap2_bot_grande_pretresse_apply_boss_link() {
    if (!chap2_bot_grande_pretresse_is_duel()) return false;
    var lpE = instance_find(oLP_Enemy, 0);
    if (lpE == noone) return false;
    var linked = false;
    with (oCardMonster) {
        if (!isHeroOwner && object_index == oGrandePretresseSangPur) {
            ch2_boss_lp_linked = true;
            current_hp = lpE.nbLP;
            max_hp = max(max_hp, lpE.nbLP);
            linked = true;
        }
    }
    return linked;
}

/// @function chap2_bot_grande_pretresse_try_field_setup(game_inst)
function chap2_bot_grande_pretresse_try_field_setup(game_inst) {
    if (!chap2_bot_grande_pretresse_is_duel()) return false;
    if (game_inst == noone || !instance_exists(game_inst)) return false;
    if (!variable_instance_exists(game_inst, "ch2_gp_field_setup_done")) game_inst.ch2_gp_field_setup_done = false;
    if (game_inst.ch2_gp_field_setup_done) return false;
    if (variable_instance_exists(game_inst, "timerEnabledMulligan") && game_inst.timerEnabledMulligan) return false;
    if (variable_instance_exists(game_inst, "ch2_duel_rules_blocking") && game_inst.ch2_duel_rules_blocking) return false;

    if (chap2_bot_grande_pretresse_apply_boss_link()) {
        game_inst.ch2_gp_field_setup_done = true;
        return false;
    }

    if (chap2_bot_count_free_enemy_monster_slots(game_inst) < 1) {
        game_inst.ch2_gp_field_setup_done = true;
        return false;
    }

    game_inst.story_pending_summon_asset = "oGrandePretresseSangPur";
    game_inst.story_pending_summon_cost = 0;
    game_inst.story_pending_summon_force_cost = true;
    game_inst.story_pending_summon_count = 1;
    game_inst.story_pending_summon_prefer_front = true;
    game_inst.story_pending_summon_trigger_as_summon = true;
    game_inst.story_pause_after_enemy_draw = true;
    game_inst.ch2_gp_pending_start_turn = true;
    return true;
}

/// @function chap2_bot_grande_pretresse_on_hero_start(game_inst)
function chap2_bot_grande_pretresse_on_hero_start(game_inst) {
    if (!chap2_bot_grande_pretresse_is_duel()) return false;
    if (!chap2_bot_story_context_ok_hero(game_inst)) return false;
    if (!variable_instance_exists(game_inst, "phase_current")) return false;
    if (!variable_instance_exists(game_inst, "phase")) return false;
    if (game_inst.phase[game_inst.phase_current] != "Start") return false;

    var lpH = instance_find(oLP_Hero, 0);
    var lpE = instance_find(oLP_Enemy, 0);
    if (lpH == noone) return false;

    var burn = 1;
    if (lpE != noone && lpE.nbLP <= 20) burn = 2;

    if (lpE != noone && lpE.nbLP <= 20) {
        if (!variable_instance_exists(game_inst, "ch2_gp_enrage_toast_done")) game_inst.ch2_gp_enrage_toast_done = false;
        if (!game_inst.ch2_gp_enrage_toast_done) {
            game_inst.ch2_gp_enrage_toast_done = true;
            damageCard(lpH, burn, noone);
            return chap2_bot_show_grande_pretresse_toast(game_inst, "Assez ! Que la lumière vous consume !");
        }
    }

    if (burn > 0) damageCard(lpH, burn, noone);
    return false;
}

/// @function chap2_bot_grande_pretresse_rules_lines()
function chap2_bot_grande_pretresse_rules_lines() {
    return [
        "Objectif : Vaincre la grande prêtresse.",
        "Condition : Réduire à 0 les PV de la grande prêtresse. Les PV de la carte sont liés à son propriétaire.",
        "Malus : Vous subissez des dégâts à chaque tour."
    ];
}

/// @function chap2_bot_show_malvadius_toast(game_inst, text)
function chap2_bot_show_malvadius_toast(game_inst, _text) {
    if (instance_exists(oStoryToast)) return true;
    var toast = instance_create_layer(0, 0, "UI", oStoryToast);
    toast.setPortrait("sPortraitMalvidius", 96);
    toast.setText(_text);
    return true;
}

/// @function chap2_bot_count_free_enemy_monster_slots(game_inst)
function chap2_bot_count_free_enemy_monster_slots(game_inst) {
    var freeSlots = 0;
    var fm = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
    if (fm != noone && instance_exists(fm)) {
        var monsterField = fm.getField("Monster");
        if (monsterField != noone && instance_exists(monsterField)) {
            for (var i = 0; i < array_length(monsterField.cards); i++) {
                if (monsterField.cards[i] == 0) freeSlots++;
            }
        }
    }
    return freeSlots;
}

/// @function chap2_bot_malvadius_on_progress(game_inst)
function chap2_bot_malvadius_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    if (!variable_instance_exists(game_inst, "ch2_malvadius_phase1_done")) game_inst.ch2_malvadius_phase1_done = false;
    if (!game_inst.ch2_malvadius_phase1_done) {
        var mustM1 = (lpvE <= 40) || (game_inst.nbTurn == 4);
        if (mustM1) {
            game_inst.ch2_malvadius_phase1_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oZeloteSangPur";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 2;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oZeloteSangPur";
            }

            return chap2_bot_show_malvadius_toast(game_inst, "Zélotes, au jugement !");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_malvadius_phase2_done")) game_inst.ch2_malvadius_phase2_done = false;
    if (!game_inst.ch2_malvadius_phase2_done && game_inst.ch2_malvadius_phase1_done) {
        var mustM2 = (lpvE <= 30) || (game_inst.nbTurn == 6);
        if (mustM2) {
            game_inst.ch2_malvadius_phase2_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oMoineSangPur";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oMoineSangPur";
            }

            return chap2_bot_show_malvadius_toast(game_inst, "Le croisé tranchera — appuyez-la.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_malvadius_phase3_done")) game_inst.ch2_malvadius_phase3_done = false;
    if (!game_inst.ch2_malvadius_phase3_done && game_inst.ch2_malvadius_phase2_done) {
        var mustM3 = (lpvE <= 20) || (game_inst.nbTurn == 10);
        if (mustM3) {
            game_inst.ch2_malvadius_phase3_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oCapitaineMelrache";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitaineMelrache";
            }

            return chap2_bot_show_malvadius_toast(game_inst, "Capitaine Melrache ! Tenez la ligne sacrée.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_malvadius_phase4_done")) game_inst.ch2_malvadius_phase4_done = false;
    if (!game_inst.ch2_malvadius_phase4_done && game_inst.ch2_malvadius_phase3_done) {
        var mustM4 = (lpvE <= 15) || (game_inst.nbTurn == 16);
        if (mustM4) {
            game_inst.ch2_malvadius_phase4_done = true;

            var freeM4 = chap2_bot_count_free_enemy_monster_slots(game_inst);
            if (freeM4 >= 3) {
                game_inst.story_pending_summon_asset = "oCapitainePerrine";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;

                game_inst.story_pending_summon_asset2 = "oAvantGardeSangPur";
                game_inst.story_pending_summon_cost2 = 0;
                game_inst.story_pending_summon_force_cost2 = true;
                game_inst.story_pending_summon_count2 = 2;
                game_inst.story_pending_summon_prefer_front2 = true;
            } else if (freeM4 >= 2) {
                game_inst.story_pending_summon_asset = "oCapitainePerrine";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;

                game_inst.story_pending_summon_asset2 = "oAvantGardeSangPur";
                game_inst.story_pending_summon_cost2 = 0;
                game_inst.story_pending_summon_force_cost2 = true;
                game_inst.story_pending_summon_count2 = 1;
                game_inst.story_pending_summon_prefer_front2 = true;
                game_inst.story_pending_add_to_hand_asset = "oAvantGardeSangPur";
            } else if (freeM4 >= 1) {
                game_inst.story_pending_summon_asset = "oCapitainePerrine";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
                game_inst.story_pending_add_to_hand_asset = "oAvantGardeSangPur";
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitainePerrine";
                game_inst.story_pending_add_to_hand_asset2 = "oAvantGardeSangPur";
            }

            return chap2_bot_show_malvadius_toast(game_inst, "Capitaine Perrine ! Marquez-les pour l'exécution.");
        }
    }

    return false;
}

/// @function chap2_bot_gregor_on_progress(game_inst)
/// @description Script Grégor Vieille-Aube — Thalia (4) T8, Grégor (5) T10, Devlin (8) T16
function chap2_bot_gregor_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    // Phase 1 — serviteurs (T4, mana 2)
    if (!variable_instance_exists(game_inst, "ch2_gregor_phase1_done")) game_inst.ch2_gregor_phase1_done = false;
    if (!game_inst.ch2_gregor_phase1_done) {
        var mustG1 = (lpvE <= 40) || (game_inst.nbTurn == 4);
        if (mustG1) {
            game_inst.ch2_gregor_phase1_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oSoldatSquelette";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 2;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oSoldatSquelette";
            }

            return chap2_bot_show_gregor_toast(game_inst, "Serviteurs des cryptes — aux moulins ! Retenez-les !");
        }
    }

    // Phase 2 — Thalia (4 mana, moins chère) T8
    if (!variable_instance_exists(game_inst, "ch2_gregor_phase2_done")) game_inst.ch2_gregor_phase2_done = false;
    if (!game_inst.ch2_gregor_phase2_done && game_inst.ch2_gregor_phase1_done) {
        var mustG2 = (lpvE <= 35) || (game_inst.nbTurn == 8);
        if (mustG2) {
            game_inst.ch2_gregor_phase2_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oThaliaVieilleAube";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oThaliaVieilleAube";
            }

            return chap2_bot_show_gregor_toast(game_inst, "Thalia ! Empêche-les d'atteindre les moulins !");
        }
    }

    // Phase 3 — Grégor (5 mana) T10
    if (!variable_instance_exists(game_inst, "ch2_gregor_phase3_done")) game_inst.ch2_gregor_phase3_done = false;
    if (!game_inst.ch2_gregor_phase3_done && game_inst.ch2_gregor_phase2_done) {
        var mustG3 = (lpvE <= 25) || (game_inst.nbTurn == 10);
        if (mustG3) {
            game_inst.ch2_gregor_phase3_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oGregorVieilleAube";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oGregorVieilleAube";
            }

            return chap2_bot_show_gregor_toast(game_inst, "Je viens te soutenir ! Ils ne nous pilleront pas !");
        }
    }

    // Phase 4 — Devlin (8 mana) T16
    if (!variable_instance_exists(game_inst, "ch2_gregor_phase4_done")) game_inst.ch2_gregor_phase4_done = false;
    if (!game_inst.ch2_gregor_phase4_done && game_inst.ch2_gregor_phase3_done) {
        var mustG4 = (lpvE <= 15) || (game_inst.nbTurn == 16);
        if (mustG4) {
            game_inst.ch2_gregor_phase4_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oDevlinVieilleAube";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oDevlinVieilleAube";
            }

            return chap2_bot_show_gregor_toast(game_inst, "Devlin ! Venge-nous ! Détruis-les !");
        }
    }

    return false;
}

/// @function chap2_bot_oeil_putride_on_progress(game_inst)
/// @description Script Œil putride — Skarls : Décérébré T6, Bâtard T8, Profanateur T10, Œil T16
function chap2_bot_oeil_putride_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    if (!variable_instance_exists(game_inst, "ch2_oeil_phase1_done")) game_inst.ch2_oeil_phase1_done = false;
    if (!game_inst.ch2_oeil_phase1_done) {
        var mustO1 = (lpvE <= 40) || (game_inst.nbTurn == 6);
        if (mustO1) {
            game_inst.ch2_oeil_phase1_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oDecerebrePutride";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oDecerebrePutride";
            }

            return chap2_bot_show_oeil_putride_toast(game_inst, "Ils foulent nos terres… leurs têtes sont encore tendres.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_oeil_phase2_done")) game_inst.ch2_oeil_phase2_done = false;
    if (!game_inst.ch2_oeil_phase2_done && game_inst.ch2_oeil_phase1_done) {
        var mustO2 = (lpvE <= 35) || (game_inst.nbTurn == 8);
        if (mustO2) {
            game_inst.ch2_oeil_phase2_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oBatardPutride";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
                game_inst.story_pending_summon_trigger_as_summon = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oBatardPutride";
            }

            return chap2_bot_show_oeil_putride_toast(game_inst, "Qu'ils ne pensent plus qu'à fuir — la proie s'affaiblit.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_oeil_phase3_done")) game_inst.ch2_oeil_phase3_done = false;
    if (!game_inst.ch2_oeil_phase3_done && game_inst.ch2_oeil_phase2_done) {
        var mustO3 = (lpvE <= 25) || (game_inst.nbTurn == 10);
        if (mustO3) {
            game_inst.ch2_oeil_phase3_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oProfanateurPutride";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oProfanateurPutride";
            }

            return chap2_bot_show_oeil_putride_toast(game_inst, "Ouvrez les tombes ! Sous la pierre, les cervelles attendent.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_oeil_phase4_done")) game_inst.ch2_oeil_phase4_done = false;
    if (!game_inst.ch2_oeil_phase4_done && game_inst.ch2_oeil_phase3_done) {
        var mustO4 = (lpvE <= 15) || (game_inst.nbTurn == 16);
        if (mustO4) {
            game_inst.ch2_oeil_phase4_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oOeilPutride";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oOeilPutride";
            }

            return chap2_bot_show_oeil_putride_toast(game_inst, "Assez. L'Œil a faim — bientôt, je goûterai le vôtre.");
        }
    }

    return false;
}

/// @function chap2_bot_roi_necromancien_on_hero_start(game_inst)
/// @description Phase 0 — Reine dans la main de Vespera (tour 3 héros)
function chap2_bot_roi_necromancien_on_hero_start(game_inst) {
    if (!chap2_bot_story_context_ok_hero(game_inst)) return false;
    if (global.selected_bot_deck_id != "Roi_Necromancien") return false;
    if (!variable_instance_exists(game_inst, "phase_current")) return false;
    if (!variable_instance_exists(game_inst, "phase")) return false;
    if (game_inst.phase[game_inst.phase_current] != "Start") return false;
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;
    if (game_inst.nbTurn != 3) return false;

    if (!variable_instance_exists(game_inst, "ch2_roi_phase0_done")) game_inst.ch2_roi_phase0_done = false;
    if (game_inst.ch2_roi_phase0_done) return false;
    game_inst.ch2_roi_phase0_done = true;

    game_inst.story_pending_add_to_hero_hand_asset = "oReineBansheeArchereOmbre";
    return chap2_bot_show_vespera_toast(game_inst, "La reine est à mes côtés, nous ne pouvons pas perdre !");
}

/// @function chap2_bot_roi_necromancien_on_progress(game_inst)
/// @description Script Roi nécromancien — Appel cryptes T6, Patriarche T12, Roi T18 (pas de Reine en script)
function chap2_bot_roi_necromancien_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    if (!variable_instance_exists(game_inst, "ch2_roi_phase1_done")) game_inst.ch2_roi_phase1_done = false;
    if (!game_inst.ch2_roi_phase1_done) {
        var mustR1 = (lpvE <= 40) || (game_inst.nbTurn == 6);
        if (mustR1) {
            game_inst.ch2_roi_phase1_done = true;

            game_inst.story_pending_cast_spell_asset = "oAppelCrypte";
            game_inst.story_pending_cast_spell_cost = 0;
            game_inst.story_pending_cast_spell_force_cost = true;

            return chap2_bot_show_roi_necromancien_toast(game_inst, "Les cryptes répondent… levez-vous et frappez.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_roi_phase2_done")) game_inst.ch2_roi_phase2_done = false;
    if (!game_inst.ch2_roi_phase2_done && game_inst.ch2_roi_phase1_done) {
        var mustR2 = (lpvE <= 30) || (game_inst.nbTurn == 12);
        if (mustR2) {
            game_inst.ch2_roi_phase2_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oPatriarchePutrescent";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oPatriarchePutrescent";
            }

            return chap2_bot_show_roi_necromancien_toast(game_inst, "Tu crois vaincre la mort, Vespera ? Regarde ton armée se liquéfier.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_roi_phase3_done")) game_inst.ch2_roi_phase3_done = false;
    if (!game_inst.ch2_roi_phase3_done && game_inst.ch2_roi_phase2_done) {
        var mustR3 = (lpvE <= 15) || (game_inst.nbTurn == 18);
        if (mustR3) {
            game_inst.ch2_roi_phase3_done = true;

            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oRoiNecromancien";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oRoiNecromancien";
            }

            return chap2_bot_show_roi_necromancien_toast(game_inst, "Vespera… vous servirez la mort avant la fin.");
        }
    }

    return false;
}

/// @function chap2_bot_eclaireurs_on_progress(game_inst)
function chap2_bot_eclaireurs_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    if (!variable_instance_exists(game_inst, "ch2_eclaireurs_phase1_done")) game_inst.ch2_eclaireurs_phase1_done = false;
    if (!game_inst.ch2_eclaireurs_phase1_done) {
        var mustP1 = (lpvE <= 40) || (game_inst.nbTurn == 6);
        if (mustP1) {
            game_inst.ch2_eclaireurs_phase1_done = true;

            var canSummonP1 = (getLeftmostFreeMonsterSlot(false) != noone);
            if (canSummonP1) {
                game_inst.story_pending_summon_asset = "oAvantGardeSangPur";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oAvantGardeSangPur";
            }

            return chap2_bot_show_soldat_toast(game_inst, "Vous ne le sauverez pas !");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_eclaireurs_phase2_done")) game_inst.ch2_eclaireurs_phase2_done = false;
    if (!game_inst.ch2_eclaireurs_phase2_done && game_inst.ch2_eclaireurs_phase1_done) {
        var mustP2 = (lpvE <= 30) || (game_inst.nbTurn == 12);
        if (mustP2) {
            game_inst.ch2_eclaireurs_phase2_done = true;

            var canSummonP2 = (getLeftmostFreeMonsterSlot(false) != noone);
            if (canSummonP2) {
                game_inst.story_pending_summon_asset = "oEclaireurSangPur";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 2;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oEclaireurSangPur";
            }

            return chap2_bot_show_soldat_toast(game_inst, "Éclaireurs — serrez le cercle ! Elle ne passe pas.");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_eclaireurs_phase3_done")) game_inst.ch2_eclaireurs_phase3_done = false;
    if (!game_inst.ch2_eclaireurs_phase3_done && game_inst.ch2_eclaireurs_phase2_done) {
        var mustP3 = (lpvE <= 20) || (game_inst.nbTurn == 16);
        if (mustP3) {
            game_inst.ch2_eclaireurs_phase3_done = true;

            var freeSlotsP3 = 0;
            var fmP3 = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
            if (fmP3 != noone && instance_exists(fmP3)) {
                var monsterFieldP3 = fmP3.getField("Monster");
                if (monsterFieldP3 != noone && instance_exists(monsterFieldP3)) {
                    for (var iP3 = 0; iP3 < array_length(monsterFieldP3.cards); iP3++) {
                        if (monsterFieldP3.cards[iP3] == 0) freeSlotsP3++;
                    }
                }
            }

            if (freeSlotsP3 >= 2) {
                game_inst.story_pending_summon_asset = "oCapitaineVachon";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;

                game_inst.story_pending_summon_asset2 = "oEclaireurSangPur";
                game_inst.story_pending_summon_cost2 = 0;
                game_inst.story_pending_summon_force_cost2 = true;
                game_inst.story_pending_summon_count2 = 1;
                game_inst.story_pending_summon_prefer_back2 = true;
            } else if (freeSlotsP3 >= 1) {
                game_inst.story_pending_summon_asset = "oCapitaineVachon";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
                game_inst.story_pending_add_to_hand_asset = "oEclaireurSangPur";
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitaineVachon";
                game_inst.story_pending_add_to_hand_asset2 = "oEclaireurSangPur";
            }

            return chap2_bot_show_soldat_toast(game_inst, "Capitaine Vachon ! L'intruse tient encore — à vous !");
        }
    }

    return false;
}

/// @function chap2_bot_kelthazar_on_progress(game_inst)
/// @description Kelthazar — 3 capitaines (T8/T10/T12) puis Généralissime + Éveil (T14)
function chap2_bot_kelthazar_on_progress(game_inst) {
    var lpE = instance_find(oLP_Enemy, 0);
    var lpvE = (lpE != noone && variable_instance_exists(lpE, "nbLP")) ? lpE.nbLP : 999999;

    if (!variable_instance_exists(game_inst, "ch2_kelth_phase1_done")) game_inst.ch2_kelth_phase1_done = false;
    if (!game_inst.ch2_kelth_phase1_done) {
        var mustK1 = (lpvE <= 40) || (game_inst.nbTurn == 8);
        if (mustK1) {
            game_inst.ch2_kelth_phase1_done = true;
            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oCapitaineVachon";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitaineVachon";
            }
            return chap2_bot_show_kelthazar_toast(game_inst, "Tenez la porte de la cathédrale !");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_kelth_phase2_done")) game_inst.ch2_kelth_phase2_done = false;
    if (!game_inst.ch2_kelth_phase2_done && game_inst.ch2_kelth_phase1_done) {
        var mustK2 = (lpvE <= 35) || (game_inst.nbTurn == 10);
        if (mustK2) {
            game_inst.ch2_kelth_phase2_done = true;
            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oCapitaineMelrache";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_front = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitaineMelrache";
            }
            return chap2_bot_show_kelthazar_toast(game_inst, "Qu'elle n'entre pas dans le sanctuaire !");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_kelth_phase3_done")) game_inst.ch2_kelth_phase3_done = false;
    if (!game_inst.ch2_kelth_phase3_done && game_inst.ch2_kelth_phase2_done) {
        var mustK3 = (lpvE <= 25) || (game_inst.nbTurn == 12);
        if (mustK3) {
            game_inst.ch2_kelth_phase3_done = true;
            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oCapitainePerrine";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oCapitainePerrine";
            }
            return chap2_bot_show_kelthazar_toast(game_inst, "Dernier rempart avant l'autel !");
        }
    }

    if (!variable_instance_exists(game_inst, "ch2_kelth_phase4_done")) game_inst.ch2_kelth_phase4_done = false;
    if (!game_inst.ch2_kelth_phase4_done && game_inst.ch2_kelth_phase3_done) {
        var mustK4 = (lpvE <= 15) || (game_inst.nbTurn == 14);
        if (mustK4) {
            game_inst.ch2_kelth_phase4_done = true;
            if (chap2_bot_count_free_enemy_monster_slots(game_inst) >= 1) {
                game_inst.story_pending_summon_asset = "oGeneralissimeSangPur";
                game_inst.story_pending_summon_cost = 0;
                game_inst.story_pending_summon_force_cost = true;
                game_inst.story_pending_summon_count = 1;
                game_inst.story_pending_summon_prefer_back = true;
                game_inst.story_pending_summon_trigger_as_summon = true;
            } else {
                game_inst.story_pending_add_to_hand_asset = "oGeneralissimeSangPur";
            }
            return chap2_bot_show_kelthazar_toast(game_inst, "Soldats du Sang Pur — levez-vous !");
        }
    }

    return false;
}

/// @function chap2_bot_events_on_progress(game_inst)
function chap2_bot_events_on_progress(game_inst) {
    if (!chap2_bot_story_context_ok(game_inst)) return false;
    if (!variable_instance_exists(game_inst, "phase_current")) return false;
    if (!variable_instance_exists(game_inst, "phase")) return false;
    if (game_inst.phase[game_inst.phase_current] != "Start") return false;
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;

    var botID = global.selected_bot_deck_id;
    if (botID == "Inquisiteur_Malvadius") return chap2_bot_malvadius_on_progress(game_inst);
    if (botID == "Gregor_Vieille_Aube") return chap2_bot_gregor_on_progress(game_inst);
    if (botID == "Oeil_Putride") return chap2_bot_oeil_putride_on_progress(game_inst);
    if (botID == "Roi_Necromancien") return chap2_bot_roi_necromancien_on_progress(game_inst);
    if (botID == "Kelthazar") return chap2_bot_kelthazar_on_progress(game_inst);
    if (botID == "Eclaireurs_Ordre_Sang_Pur") return chap2_bot_eclaireurs_on_progress(game_inst);
    return false;
}

/// @function chap2_bot_events_on_hero_start(game_inst)
function chap2_bot_events_on_hero_start(game_inst) {
    if (global.selected_bot_deck_id == "Grande_Pretresse_Sang_Pur") {
        return chap2_bot_grande_pretresse_on_hero_start(game_inst);
    }
    if (global.selected_bot_deck_id == "Roi_Necromancien") {
        return chap2_bot_roi_necromancien_on_hero_start(game_inst);
    }
    return false;
}

/// @function chap2_bot_events_on_enemy_draw(game_inst)
function chap2_bot_events_on_enemy_draw(game_inst) {
    if (!chap2_bot_story_context_ok(game_inst)) return false;
    if (!variable_instance_exists(game_inst, "nbTurn")) return false;
    if (game_inst.nbTurn != 2) return false;

    var botID = global.selected_bot_deck_id;

    if (botID == "Inquisiteur_Malvadius") {
        if (!variable_instance_exists(game_inst, "ch2_malvadius_intro_done")) game_inst.ch2_malvadius_intro_done = false;
        if (game_inst.ch2_malvadius_intro_done) return false;
        game_inst.ch2_malvadius_intro_done = true;
        return chap2_bot_show_malvadius_toast(game_inst, "Votre hérésie répondra devant notre lumière !");
    }

    if (botID == "Gregor_Vieille_Aube") {
        if (!variable_instance_exists(game_inst, "ch2_gregor_intro_done")) game_inst.ch2_gregor_intro_done = false;
        if (game_inst.ch2_gregor_intro_done) return false;
        game_inst.ch2_gregor_intro_done = true;
        return chap2_bot_show_gregor_toast(game_inst, "Nos moulins ne tourneront pas pour les étrangers ! La famille Vieille-Aube défend ce qui est sien.");
    }

    if (botID == "Oeil_Putride") {
        if (!variable_instance_exists(game_inst, "ch2_oeil_intro_done")) game_inst.ch2_oeil_intro_done = false;
        if (game_inst.ch2_oeil_intro_done) return false;
        game_inst.ch2_oeil_intro_done = true;
        return chap2_bot_show_oeil_putride_toast(game_inst, "Ces terres sont nôtres. Qui s'y avance nourrit la fange.");
    }

    if (botID == "Roi_Necromancien") {
        if (!variable_instance_exists(game_inst, "ch2_roi_intro_done")) game_inst.ch2_roi_intro_done = false;
        if (game_inst.ch2_roi_intro_done) return false;
        game_inst.ch2_roi_intro_done = true;
        return chap2_bot_show_roi_necromancien_toast(game_inst, "À la fin, tous servent la mort.");
    }

    if (botID == "Kelthazar") {
        if (!variable_instance_exists(game_inst, "ch2_kelth_intro_done")) game_inst.ch2_kelth_intro_done = false;
        if (game_inst.ch2_kelth_intro_done) return false;
        game_inst.ch2_kelth_intro_done = true;
        return chap2_bot_show_kelthazar_toast(game_inst, "Vous frappez la cathédrale ? Le Sang Pur ne recule pas.");
    }

    if (botID == "Eclaireurs_Ordre_Sang_Pur") {
        if (!variable_instance_exists(game_inst, "ch2_eclaireurs_intro_done")) game_inst.ch2_eclaireurs_intro_done = false;
        if (game_inst.ch2_eclaireurs_intro_done) return false;
        game_inst.ch2_eclaireurs_intro_done = true;
        return chap2_bot_show_soldat_toast(game_inst, "Recule — l'interrogatoire n'est pas terminé.");
    }

    if (botID == "Grande_Pretresse_Sang_Pur") {
        if (!variable_instance_exists(game_inst, "ch2_gp_intro_done")) game_inst.ch2_gp_intro_done = false;
        if (game_inst.ch2_gp_intro_done) return false;
        game_inst.ch2_gp_intro_done = true;
        return chap2_bot_show_grande_pretresse_toast(game_inst, "La lumière du Sang Pur ne pardonne pas. À genoux.");
    }

    return false;
}
