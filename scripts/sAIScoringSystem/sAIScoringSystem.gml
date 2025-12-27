/// sAIScoringSystem.gml
/// Système central de scoring pour l'IA (Refonte 2025)

// --- CONSTANTES DE PONDERATION (WEIGHTS) ---
#macro SCORE_PER_ATK 1.0           // 1 point d'attaque = 1 point de score
#macro SCORE_PER_DEF 0.5           // 1 point de défense = 0.5 point de score
#macro SCORE_MONSTER_EXIST 500     // Bonus pour la simple présence d'un monstre (Body)
#macro SCORE_CARD_HAND 1500        // Valeur d'une carte en main (Card Advantage)
#macro SCORE_KILL_BONUS 800        // Bonus pour la destruction d'un monstre adverse
#macro SCORE_SURVIVAL 5000         // Bonus critique si on évite la défaite
#macro SCORE_LETHAL 999999         // Priorité absolue si victoire possible

// --- FONCTIONS D'EVALUATION ---

/// @function AI_Evaluate_BoardState()
/// @description Calcule un score global représentant l'avantage actuel de l'IA.
/// @return {real} Le score (Positif = IA gagne, Négatif = IA perd)
function AI_Evaluate_BoardState() {
    var totalScore = 0;
    
    // Récupération du profil IA
    var profile = AI_Config_GetBotProfile(1);
    var p_board = (profile != undefined) ? (profile.board_presence_weight / 50.0) : 1.0;
    var p_hand = (profile != undefined) ? (profile.draw_weight / 50.0) : 1.0; // Approximation pour Card Advantage
    var p_risk = (profile != undefined) ? (profile.risk_tolerance / 50.0) : 1.0;

    // 1. Évaluation des Monstres de l'IA (Positif)
    if (instance_exists(oFieldMonsterEnemy)) {
        var myMonsters = oFieldMonsterEnemy.cards;
        for (var i = 0; i < array_length(myMonsters); i++) {
            var card = myMonsters[i];
            if (card != 0 && instance_exists(card)) {
                totalScore += AI_GetCardScore(card) * p_board;
            }
        }
    }

    // 2. Évaluation des Monstres du Joueur (Négatif)
    if (instance_exists(oFieldMonsterHero)) {
        var enemyMonsters = oFieldMonsterHero.cards;
        for (var i = 0; i < array_length(enemyMonsters); i++) {
            var card = enemyMonsters[i];
            if (card != 0 && instance_exists(card)) {
                totalScore -= AI_GetCardScore(card); // On ne pondère pas l'ennemi par notre style, sauf si on veut ignorer le board
            }
        }
    }

    // 3. Card Advantage (Main de l'IA)
    if (instance_exists(oHandEnemy)) {
        var handSize = 0;
        if (variable_instance_exists(oHandEnemy, "cards")) {
             // Vérifier si c'est une liste (ds_list) ou un array
             if (ds_exists(oHandEnemy.cards, ds_type_list)) {
                 handSize = ds_list_size(oHandEnemy.cards);
             } else if (is_array(oHandEnemy.cards)) {
                 handSize = array_length(oHandEnemy.cards);
             }
        }
        totalScore += handSize * SCORE_CARD_HAND * p_hand;
    }

    // 4. Points de Vie (HP)
    var heroLP = 0;
    var enemyLP = 0;
    var lpHeroInst = instance_find(oLP_Hero, 0);
    var lpEnemyInst = instance_find(oLP_Enemy, 0);

    if (lpHeroInst != noone) heroLP = lpHeroInst.nbLP;
    if (lpEnemyInst != noone) enemyLP = lpEnemyInst.nbLP;

    // Si l'IA est morte, score très bas
    if (enemyLP <= 0) return -SCORE_LETHAL;
    // Si le joueur est mort, score très haut (Victoire)
    if (heroLP <= 0) return SCORE_LETHAL;

    // Pondération des PV (Plus on est bas, plus chaque PV compte)
    var hpScore = (enemyLP - heroLP) * 2; // Base : 1 PV = 2 points
    if (enemyLP < 2000) hpScore -= (2000 - enemyLP) * 5 * (1.0 / p_risk); // Panique si PV bas (inversement prop au risque)

    totalScore += hpScore;

    return totalScore;
}

/// @function AI_GetCardScore(card)
/// @description Calcule la valeur heuristique d'une carte spécifique sur le terrain.
function AI_GetCardScore(card) {
    if (card == noone || !instance_exists(card)) return 0;

    // FORCE RECOMPUTE: Ensure AI sees the most up-to-date stats (buffs/debuffs)
    if (script_exists(asset_get_index("buffRecompute"))) {
        buffRecompute(card);
    }

    var profile = AI_Config_GetBotProfile(1);
    var p_atk = (profile != undefined) ? (profile.attack_bias / 50.0) : 1.0;
    var p_def = (profile != undefined) ? (profile.defense_bias / 50.0) : 1.0;

    var currentScoreVal = SCORE_MONSTER_EXIST;
    
    // Récupération sécurisée des stats
    var atk = variable_instance_exists(card, "effective_attack") ? card.effective_attack : (variable_instance_exists(card, "attack") ? card.attack : 0);
    var def = variable_instance_exists(card, "effective_defense") ? card.effective_defense : (variable_instance_exists(card, "defense") ? card.defense : 0);

    // Bonus ATK/DEF pondéré par le profil
    currentScoreVal += atk * SCORE_PER_ATK * p_atk;
    currentScoreVal += def * SCORE_PER_DEF * p_def;

    // Bonus si position d'attaque (menace active)
    if (variable_instance_exists(card, "orientation") && card.orientation == "Attack") {
        currentScoreVal += 200 * p_atk; 
    }

    // Ici on pourra ajouter des bonus pour les Effets (Mots-clés)
    // Ex: if (card.hasTaunt) currentScoreVal += 300 * p_def;

    return currentScoreVal;
}

/// @function AI_GetCardScore_Predicted(card)
/// @description Estime la valeur d'une carte (monstre) avant qu'elle ne soit sur le terrain.
function AI_GetCardScore_Predicted(card) {
    // Similaire à AI_GetCardScore mais lit les stats de base
    var profile = AI_Config_GetBotProfile(1);
    var p_atk = (profile != undefined) ? (profile.attack_bias / 50.0) : 1.0;
    var p_def = (profile != undefined) ? (profile.defense_bias / 50.0) : 1.0;

    var atk = (is_struct(card) && variable_struct_exists(card, "attack")) ? card.attack : (variable_instance_exists(card, "attack") ? card.attack : 0);
    var def = (is_struct(card) && variable_struct_exists(card, "defense")) ? card.defense : (variable_instance_exists(card, "defense") ? card.defense : 0);
    
    var currentScoreVal = SCORE_MONSTER_EXIST;
    currentScoreVal += atk * SCORE_PER_ATK * p_atk;
    currentScoreVal += def * SCORE_PER_DEF * p_def;
    
    // Analyse board pour prédiction
    var strongestEnemyAtk = 0;
    if (instance_exists(oFieldMonsterHero)) {
         var enemies = oFieldMonsterHero.cards;
         for(var e=0; e<array_length(enemies); e++) {
             var en = enemies[e];
             if (en!=0 && instance_exists(en)) {
                 var eAtk = variable_instance_exists(en, "attack") ? en.attack : 0;
                 if (eAtk > strongestEnemyAtk) strongestEnemyAtk = eAtk;
             }
         }
    }
    
    // Détermination orientation probable
    var orientation = "Attack";
    if (def > atk) orientation = "Defense";
    if (atk > strongestEnemyAtk) orientation = "Attack"; // Control/Aggro

    var hasFlip = false;
    var effects = (is_struct(card) && variable_struct_exists(card, "effects")) ? card.effects : ((variable_instance_exists(card, "effects")) ? card.effects : undefined);
    
    if (is_array(effects)) {
         for(var i=0; i<array_length(effects); i++) {
             var ef = effects[i];
             if (variable_struct_exists(ef, "trigger") && ef.trigger == "flip") {
                 hasFlip = true;
                 break;
             }
         }
    }

    if (hasFlip) {
         currentScoreVal += 200 * p_def; // Bonus pour poser un monstre Flip
    } else {
         if (orientation == "Attack") currentScoreVal += 200 * p_atk; 
         else currentScoreVal += 200 * p_def;
    }
    
    return currentScoreVal;
}
