/// @function get_hero_decks_chap2()
/// @description Deck héros unique pour Vespera — Chapitre 2 (Bêtes + Morts-vivants des Landes)
function get_hero_decks_chap2() {
    return [
        {
            id: "vespera_landes_sepulcre",
            name: "Vespera — Brumes et tombeaux",
            deck_name: "Brumes et tombeaux",
            portrait: "sPortraitVespera",
            description: "Bêtes et morts-vivants des Landes (hors boss bots : pas Vieille-Aube, Skarls putrides, Sang Pur, Reine Banshee). Courbe 1–5 allégée, fin 6–8. Farrow inclus.",
            cards: [
                // --- Monstres (30) — early 1–5 réduit, fin 6–8 (pas de boss / Reine Banshee) ---
                // 1 mana (4)
                "oSoldatSquelette", "oSoldatSquelette",
                "oOssomancienGivroeil", "oOssomancienGivroeil",

                // 2 mana (5)
                "oTitubantPestilentiel", "oTitubantPestilentiel",
                "oMortPourrissant",
                "oCadavreNoye", "oCadavreNoye",
                "oTisseNuitNocturne",

                // 3 mana (7) — Farrow + swarm cimetière
                "oMolosseDecrepit",
                "oSoldatCliquethorax",
                "oFarrowTuteurEveille",
                "oMacheOs",
                "oHurleNuitStrident",
                "oDevoreurOmbres",
                "oSombredogueSanguinaireSpectral",

                // 4 mana (6)
                "oCrocEntraveBrumes", "oCrocEntraveBrumes",
                "oBansheeSepulcrale",
                "oHurleVouteColossale",
                "oSombregueuleTraqueur",
                "oAbominationSanguinolente",

                // 5 mana (4)
                "oKodiakSepulcre",
                "oMatriarcheBoisNoirs",
                "oAileSangPenombre",
                "oSpectreDeletere",

                // 6 mana (2)
                "oHibernarOursPestifere", "oHibernarOursPestifere",

                // 7 mana (1)
                "oPatriarchePutrescent",

                // 8 mana (1)
                "oOursPestifereLandesSepuclre",

                // --- Magie / secrets / terrains (10) ---
                "oExhumationRapide",
                "oMarqueDecomposition",
                "oSiphonAme",
                "oTombeAffamee",
                "oMorsureContagieuse",
                "oAppelCrypte",
                "oContratNecromancien",
                "oNecropoleProfanee",
                "oBrouillardCimetiere",
                "oSporeNecrotique"
            ]
        }
    ];
}
