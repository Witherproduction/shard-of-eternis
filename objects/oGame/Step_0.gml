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
    
    // Vérifier qu'on est toujours en phase de Start et au tour du joueur
    if (phase[phase_current] == "Start" && is_local_turn) {
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
    if (nbTurn == 1 && phase[phase_current] == "Main") {
        Tutorial_Chapter0_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 3. Déclenchement Tour 3 (Début Start Phase - Tour du Joueur)
    if (nbTurn == 3 && phase[phase_current] == "Start") {
        Tutorial_Turn3_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 4. Déclenchement Tour 5 (Début Start Phase - Tour du Joueur)
    if (nbTurn == 5 && phase[phase_current] == "Start") {
        Tutorial_Turn5_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 5. Déclenchement Tour 7 (Début Start Phase - Tour du Joueur)
    if (nbTurn == 7 && phase[phase_current] == "Start") {
        Tutorial_Turn7_Init();
        if (instance_exists(oTutorielManager)) return;
    }

    // 6. Déclenchement Tour 9 (Début Start Phase - Tour du Joueur)
    if (nbTurn == 9 && phase[phase_current] == "Start") {
        Tutorial_Turn9_Init();
        if (instance_exists(oTutorielManager)) return;
    }
}

// Arrêter si la partie est terminée (après avoir laissé le Tuto se mettre à jour)
if (variable_instance_exists(id, "gameEnded") && gameEnded) return;

if ((!variable_instance_exists(id, "story_pause_after_enemy_draw") || !story_pause_after_enemy_draw) && !instance_exists(oStoryToast)) {
    if (is_callable(chap1_bot_events_on_progress)) {
        var pause_story_anytime = chap1_bot_events_on_progress(id);
        if (pause_story_anytime) {
            story_pause_after_enemy_draw = true;
            exit;
        }
    }
}

if (variable_instance_exists(id, "story_pause_after_enemy_draw") && story_pause_after_enemy_draw) {
    if (instance_exists(oStoryToast)) {
        exit;
    }
    {
        if (variable_instance_exists(id, "story_pending_summon_asset") && story_pending_summon_asset != "") {
            var summonCount = (variable_instance_exists(id, "story_pending_summon_count") ? story_pending_summon_count : 1);
            if (summonCount < 1) summonCount = 1;
            var mana_cost = (variable_instance_exists(id, "story_pending_summon_cost") ? story_pending_summon_cost : 0);
            var forceCost = (variable_instance_exists(id, "story_pending_summon_force_cost") && story_pending_summon_force_cost);
            for (var i = 0; i < summonCount; i++) {
                var slot = getLeftmostFreeMonsterSlot(false);
                if (slot == noone) break;
                var payload = {
                    card_asset_name: story_pending_summon_asset,
                    xy: [slot.x, slot.y, slot.pos],
                    summon_mode: "SpecialSummon"
                };
                if (mana_cost > 0 || forceCost) payload.mana_cost_override = mana_cost;
                RequestGameAction(ACTION_SUMMON, payload);
            }
            story_pending_summon_asset = "";
            if (variable_instance_exists(id, "story_pending_summon_cost")) story_pending_summon_cost = 0;
            if (variable_instance_exists(id, "story_pending_summon_count")) story_pending_summon_count = 0;
            if (variable_instance_exists(id, "story_pending_summon_force_cost")) story_pending_summon_force_cost = false;
        }
        
        if (variable_instance_exists(id, "story_pending_add_to_hand_asset") && story_pending_add_to_hand_asset != "") {
            var handInst = handEnemy;
            if (instance_exists(handInst)) {
                var cap = (variable_global_exists("MAX_HAND_SIZE") ? global.MAX_HAND_SIZE : 10);
                var handCount = ds_list_size(handInst.cards);
                if (handCount < cap) {
                    var objIdxHand = asset_get_index(story_pending_add_to_hand_asset);
                    if (objIdxHand != -1) {
                        var newCard = instance_create_layer(handInst.x, handInst.y, layer_get_id("Instances"), objIdxHand);
                        if (newCard != noone) {
                            newCard.isHeroOwner = false;
                            newCard.image_angle = 180;
                            newCard.zone = "Hand";
                            handInst.addCard(newCard);
                            registerTriggerEvent(TRIGGER_ENTER_HAND, newCard, { owner_is_hero: false });
                        }
                    }
                } else {
                    var gy = graveyardEnemy;
                    var objIdxBurn = asset_get_index(story_pending_add_to_hand_asset);
                    if (instance_exists(gy) && objIdxBurn != -1) {
                        var burnCard = instance_create_layer(gy.x, gy.y, layer_get_id("Instances"), objIdxBurn);
                        if (burnCard != noone) {
                            burnCard.isHeroOwner = false;
                            gy.addToGraveyard(burnCard, true);
                            burnCard.zone = "Graveyard";
                            instance_destroy(burnCard);
                        }
                    }
                }
            }
            story_pending_add_to_hand_asset = "";
        }
    }
    story_pause_after_enemy_draw = false;
    if (player_current == 1 && phase[phase_current] == "Start") nextPhase();
    exit;
}

if(timerMulligan > 0 && timerEnabledMulligan) {
	timerMulligan -= 1/room_speed;
}
else if(timerEnabledMulligan) {
	// Piocher pour le héros seulement s'il a moins de 4 cartes (HS style mulligan)
	if(ds_list_size(handHero.cards) < 4) {
		deckHero.pick();
	}
	
	// Piocher pour l'ennemi seulement s'il a moins de 4 cartes
	if(ds_list_size(handEnemy.cards) < 4) {
		IA.pick();
	}
	
	// Continuer la pioche tant que l'un des joueurs n'a pas 4 cartes
	if(ds_list_size(handHero.cards) < 4 || ds_list_size(handEnemy.cards) < 4) {
		timerMulligan = 0.5;
	} else {
		timerEnabledMulligan = false;
        
        // Transitionner vers le Tour 1 (Phase Start)
        nextPhase();
        
        // Activer la pioche automatique pour la 5ème carte
        timerAutoDraw = 0.5;
        timerAutoDrawEnabled = true;
		nextStep.image_index = 0;
	}
}

if (!(timerEnabledIA && instance_exists(oStoryToast))) {
    if(timerIA > 0 && timerEnabledIA) {
    	timerIA -= 1/room_speed;
    }
    else if(timerEnabledIA) {
	
    	timerEnabledIA = false;

        // SECURITY CHECK: IA timer should only execute if it's Enemy turn
        if (player[player_current] != "Enemy") {
            if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) show_debug_message("### oGame: Blocked IA timer execution during Hero turn");
            exit;
        }

    	switch (phase[phase_current])
    	{
    		case "Start": 
                IA.pick(); 
                var pause_story = false;
                if (is_callable(chap1_bot_events_on_enemy_draw)) {
                    pause_story = chap1_bot_events_on_enemy_draw(id);
                }
                if (pause_story) {
                    story_pause_after_enemy_draw = true;
                    exit;
                }
                if (instance_exists(oGame)) oGame.nextPhase();
                break;
                
    		case "Main": 
                // IA logic simple: Invoque puis attaque puis fin de tour
                // [HEARTHSTONE] Asynchronous Turn Logic
                IA.startTurnLogic();
                
                // Note: IA.startTurnLogic() initiates the Summoning phase.
                // oIA Step event handles the transition Summon -> Attack -> NextPhase.
                break;
                
            // Legacy phases removed
    	}
    }
}

// === GESTION DES EFFETS CONTINUS ===
// Traiter tous les effets continus des cartes sur le terrain
with (oCardParent) {
    if (zone == "Field" && variable_struct_exists(self, "effects")) {
        for (var i = 0; i < array_length(effects); i++) {
            var effect = effects[i];
            if (variable_struct_exists(effect, "trigger") && (effect.trigger == TRIGGER_CONTINUOUS || effect.trigger == TRIGGER_PASSIVE)) {
                // Vérifier les conditions du trigger continu
                if (checkTriggerConditions(self, effect)) {
                    // Exécuter l'effet continu
                    executeEffect(self, effect, {});
                }
            }
        }
    }
}
