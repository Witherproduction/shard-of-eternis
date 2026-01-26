// Initialiser les cimetières une seule fois au début du jeu
if (!variable_instance_exists(id, "graveyardsInitialized") || !graveyardsInitialized) {
    if (instance_exists(oGraveyard)) {
        initializeGraveyards();
        graveyardsInitialized = true;
    }
}

// === GESTION DU MODE ADMIN ===
// Désactivé ici car géré par oGlobalManager (persistent)
// Le code est conservé commenté pour référence ou fallback si besoin
/*
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("P"))) {
    global.admin_mode = !global.admin_mode;
    show_debug_message("### MODE ADMIN " + (global.admin_mode ? "ACTIVÉ" : "DÉSACTIVÉ"));
}
*/

// --- GESTION DU PILE OU FACE (Début de partie PvP) ---
if (variable_instance_exists(id, "coin_toss_active") && coin_toss_active) {
    coin_toss_timer++;
    
    // Phase 0: Rotation rapide
    if (coin_toss_phase == 0) {
        coin_toss_angle += coin_toss_speed;
        if (coin_toss_timer > 60) { // Après 1 seconde
            coin_toss_phase = 1;
        }
    }
    // Phase 1: Ralentissement contrôlé
    else if (coin_toss_phase == 1) {
        coin_toss_speed = lerp(coin_toss_speed, 5, 0.05);
        coin_toss_angle += coin_toss_speed;
        
        // Si on est assez lent, on cherche à s'arrêter sur la bonne face
        if (coin_toss_speed <= 6 && coin_toss_timer > 120) {
            var current_face_up = (dcos(coin_toss_angle) > 0); // true si Pile (Or) visible
            var target_face_up = coin_toss_is_heads;
            
            // Si on est sur la bonne face et presque à plat (cos proche de 1 ou -1)
            // On force l'arrêt
            var cos_val = dcos(coin_toss_angle);
            
            // Si target est Heads, on veut cos > 0. Si target est Tails, on veut cos < 0.
            var is_aligned = (target_face_up && cos_val > 0.95) || (!target_face_up && cos_val < -0.95);
            
            if (is_aligned) {
                coin_toss_speed = 0;
                coin_toss_angle = target_face_up ? 0 : 180; // Force l'angle exact
                coin_toss_phase = 2;
                coin_toss_timer = 0; // Reset timer pour l'affichage du résultat
            }
        }
    }
    // Phase 2: Affichage du résultat puis fin
    else if (coin_toss_phase == 2) {
        if (coin_toss_timer > 120) { // 2 secondes d'affichage
            coin_toss_active = false;
        }
    }
    
    // Bloquer tout le reste du jeu pendant l'animation
    return;
}

// Sync HP (Host Only) - Synchronisation d'autorité des PV
if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST && instance_exists(LP_Hero) && instance_exists(LP_Enemy)) {
    if (!variable_instance_exists(id, "last_sync_hp_hero")) last_sync_hp_hero = -999;
    if (!variable_instance_exists(id, "last_sync_hp_enemy")) last_sync_hp_enemy = -999;
    
    var cur_h = LP_Hero.nbLP;
    var cur_e = LP_Enemy.nbLP;
    
    // Si changement détecté, on envoie la nouvelle valeur
    if (cur_h != last_sync_hp_hero || cur_e != last_sync_hp_enemy) {
        last_sync_hp_hero = cur_h;
        last_sync_hp_enemy = cur_e;
        // Host (P0) = LP_Hero, Client (P1) = LP_Enemy
        RequestGameAction(ACTION_SYNC_LP, { p0_lp: cur_h, p1_lp: cur_e });
    }
}

// Vérifier les points de vie pour déclencher la fin de partie
if (instance_exists(LP_Hero) && instance_exists(LP_Enemy)) {
    var heroLP = LP_Hero.nbLP;
    var enemyLP = LP_Enemy.nbLP;
    
    // Vérifier si quelqu'un a perdu (points de vie <= 0)
    if (heroLP <= 0 || enemyLP <= 0) {
        // Éviter de déclencher plusieurs fois la fin de partie
        if (!variable_instance_exists(id, "gameEnded") || !gameEnded) {
            gameEnded = true;
            
            // Déterminer le gagnant
            var isVictory = false;
            if (heroLP <= 0 && enemyLP <= 0) {
                // Égalité - considérer comme défaite
                isVictory = false;
            } else if (heroLP <= 0) {
                // Le héros a perdu
                isVictory = false;
            } else if (enemyLP <= 0) {
                // L'ennemi a perdu, le héros gagne
                isVictory = true;
            }
            
            // Créer l'écran de fin de partie
            var gameOverScreen = instance_create_layer(0, 0, "UI", oGameOverScreen);
            
            // Déterminer si c'est une victoire ou une défaite
            gameOverScreen.isVictory = isVictory;
            
            // Arrêter le jeu (sauf si Tuto Chap 0)
            if (!variable_global_exists("current_chapter") || global.current_chapter != 0) return;
        }
        
        // Arrêter le traitement du jeu si la partie est terminée (sauf si Tuto Chap 0)
        if (!variable_global_exists("current_chapter") || global.current_chapter != 0) return;
    }
}




// Gestion de la pioche automatique (Joueur)
if (timerAutoDraw > 0 && timerAutoDrawEnabled) {
    timerAutoDraw -= 1/room_speed;
} else if (timerAutoDrawEnabled) {
    timerAutoDrawEnabled = false;
    
    // Vérifier qu'on est toujours en phase de pioche et au tour du joueur
    if (phase[phase_current] == "Pick" && is_local_turn) {
        show_debug_message("### Executing Auto-Draw");
        // Logique de pioche (similaire à oCardParent Mouse_4)
        if (variable_instance_exists(id, "local_player_index")) {
            var payload = {
                player_index: local_player_index,
                trigger_next_phase: true
            };
            RequestGameAction(ACTION_DRAW, payload);
        }
    }
}

// --- GESTION DU TUTORIEL (CHAPITRE 0) ---
if (variable_global_exists("current_chapter") && global.current_chapter == 0) {
    if (Tutorial_Chapter0_Update()) return;
    if (Tutorial_Turn3_Update()) return;
    if (Tutorial_Turn5_Update()) return;
    if (Tutorial_Turn7_Update()) return;
    if (Tutorial_Turn9_Update()) return;

    // 2. Déclenchement Tour 1 (Début Main Phase 1)
    if (nbTurn == 1 && phase[phase_current] == "Summon") {
        Tutorial_Chapter0_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 3. Déclenchement Tour 3 (Début Pick Phase - Tour du Joueur)
    if (nbTurn == 3 && phase[phase_current] == "Pick") {
        Tutorial_Turn3_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 4. Déclenchement Tour 5 (Début Pick Phase - Tour du Joueur)
    if (nbTurn == 5 && phase[phase_current] == "Pick") {
        Tutorial_Turn5_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 5. Déclenchement Tour 7 (Début Pick Phase - Tour du Joueur)
    if (nbTurn == 7 && phase[phase_current] == "Pick") {
        Tutorial_Turn7_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 6. Déclenchement Tour 9 (Début Pick Phase - Tour du Joueur)
    if (nbTurn == 9 && phase[phase_current] == "Pick") {
        Tutorial_Turn9_Init();
        if (instance_exists(oTutorielManager)) return;
    }
}

// Arrêter si la partie est terminée (après avoir laissé le Tuto se mettre à jour)
if (variable_instance_exists(id, "gameEnded") && gameEnded) return;

if(timerPick > 0 && timerEnabledPick) {
	timerPick -= 1/room_speed;
}
else if(timerEnabledPick) {
	// Piocher pour le héros seulement s'il a moins de 5 cartes
	if(ds_list_size(handHero.cards) < 5) {
		deckHero.pick();
	}
	
	// Piocher pour l'ennemi seulement s'il a moins de 5 cartes
	if(ds_list_size(handEnemy.cards) < 5) {
		IA.pick();
	}
	
	// Continuer la pioche tant que l'un des joueurs n'a pas 5 cartes
	if(ds_list_size(handHero.cards) < 5 || ds_list_size(handEnemy.cards) < 5) {
		timerPick = 0.5;
	} else {
		timerEnabledPick = false;
		game.nextPhase();
		nextStep.image_index = 0;
	}
}


if(timerIA > 0 && timerEnabledIA) {
	timerIA -= 1/room_speed;
}
else if(timerEnabledIA) {
	
	timerEnabledIA = false;
	switch (phase[phase_current])
	{
		case "Pick": IA.pick();
		break;
		case "Summon": IA.summon();
		break;
		case "Attack": IA.attack();
		break;
	}
}

// === GESTION DES EFFETS CONTINUS ===
// Traiter tous les effets continus des cartes sur le terrain
with (oCardParent) {
    if (zone == "Field" && variable_struct_exists(self, "effects")) {
        for (var i = 0; i < array_length(effects); i++) {
            var effect = effects[i];
            if (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_CONTINUOUS) {
                // Vérifier les conditions du trigger continu
                if (checkTriggerConditions(self, effect)) {
                    // Exécuter l'effet continu
                    executeEffect(self, effect, {});
                }
            }
        }
    }
}
