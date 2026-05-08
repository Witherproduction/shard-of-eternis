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
    timerAutoDraw -= 1 / game_get_speed(gamespeed_fps);
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
            var preferBack = (variable_instance_exists(id, "story_pending_summon_prefer_back") && story_pending_summon_prefer_back);
            var preferFront = (variable_instance_exists(id, "story_pending_summon_prefer_front") && story_pending_summon_prefer_front);
            var triggerAsSummon = (variable_instance_exists(id, "story_pending_summon_trigger_as_summon") && story_pending_summon_trigger_as_summon);
            for (var i = 0; i < summonCount; i++) {
                var slot = noone;
                if (preferBack || preferFront) {
                    var fm = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
                    if (fm != noone && instance_exists(fm)) {
                        var monsterField = fm.getField("Monster");
                        if (monsterField != noone && instance_exists(monsterField)) {
                            var pos = -1;
                            if (preferBack) {
                                for (var k = 4; k < min(array_length(monsterField.cards), 8); k++) {
                                    if (monsterField.cards[k] == 0) { pos = k; break; }
                                }
                                if (pos == -1) {
                                    for (var k2 = 0; k2 < min(array_length(monsterField.cards), 4); k2++) {
                                        if (monsterField.cards[k2] == 0) { pos = k2; break; }
                                    }
                                }
                            } else { // preferFront
                                for (var kf = 0; kf < min(array_length(monsterField.cards), 4); kf++) {
                                    if (monsterField.cards[kf] == 0) { pos = kf; break; }
                                }
                                if (pos == -1) {
                                    for (var kf2 = 4; kf2 < min(array_length(monsterField.cards), 8); kf2++) {
                                        if (monsterField.cards[kf2] == 0) { pos = kf2; break; }
                                    }
                                }
                            }
                            if (pos != -1) {
                                var XY = fm.getPosLocation("Monster", pos);
                                slot = { x: XY[0], y: XY[1], pos: pos };
                            }
                        }
                    }
                } else {
                    slot = getLeftmostFreeMonsterSlot(false);
                }
                if (slot == noone) break;
                var payload = {
                    card_asset_name: story_pending_summon_asset,
                    xy: [slot.x, slot.y, slot.pos],
                    summon_mode: "SpecialSummon"
                };
                if (triggerAsSummon) payload.trigger_as_summon = true;
                if (mana_cost > 0 || forceCost) payload.mana_cost_override = mana_cost;
                RequestGameAction(ACTION_SUMMON, payload);
            }
            story_pending_summon_asset = "";
            if (variable_instance_exists(id, "story_pending_summon_cost")) story_pending_summon_cost = 0;
            if (variable_instance_exists(id, "story_pending_summon_count")) story_pending_summon_count = 0;
            if (variable_instance_exists(id, "story_pending_summon_force_cost")) story_pending_summon_force_cost = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_back")) story_pending_summon_prefer_back = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_front")) story_pending_summon_prefer_front = false;
            if (variable_instance_exists(id, "story_pending_summon_trigger_as_summon")) story_pending_summon_trigger_as_summon = false;
        }
        
        if (variable_instance_exists(id, "story_pending_summon_asset2") && story_pending_summon_asset2 != "") {
            var summonCount2 = (variable_instance_exists(id, "story_pending_summon_count2") ? story_pending_summon_count2 : 1);
            if (summonCount2 < 1) summonCount2 = 1;
            var mana_cost2 = (variable_instance_exists(id, "story_pending_summon_cost2") ? story_pending_summon_cost2 : 0);
            var forceCost2 = (variable_instance_exists(id, "story_pending_summon_force_cost2") && story_pending_summon_force_cost2);
            var preferBack2 = (variable_instance_exists(id, "story_pending_summon_prefer_back2") && story_pending_summon_prefer_back2);
            var preferFront2 = (variable_instance_exists(id, "story_pending_summon_prefer_front2") && story_pending_summon_prefer_front2);
            for (var j = 0; j < summonCount2; j++) {
                var slot2 = noone;
                if (preferBack2 || preferFront2) {
                    var fm2 = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
                    if (fm2 != noone && instance_exists(fm2)) {
                        var monsterField2 = fm2.getField("Monster");
                        if (monsterField2 != noone && instance_exists(monsterField2)) {
                            var pos2 = -1;
                            if (preferBack2) {
                                for (var kb = 4; kb < min(array_length(monsterField2.cards), 8); kb++) {
                                    if (monsterField2.cards[kb] == 0) { pos2 = kb; break; }
                                }
                                if (pos2 == -1) {
                                    for (var kb2 = 0; kb2 < min(array_length(monsterField2.cards), 4); kb2++) {
                                        if (monsterField2.cards[kb2] == 0) { pos2 = kb2; break; }
                                    }
                                }
                            } else { // preferFront2
                                for (var kf = 0; kf < min(array_length(monsterField2.cards), 4); kf++) {
                                    if (monsterField2.cards[kf] == 0) { pos2 = kf; break; }
                                }
                                if (pos2 == -1) {
                                    for (var kf2 = 4; kf2 < min(array_length(monsterField2.cards), 8); kf2++) {
                                        if (monsterField2.cards[kf2] == 0) { pos2 = kf2; break; }
                                    }
                                }
                            }
                            if (pos2 != -1) {
                                var XY2 = fm2.getPosLocation("Monster", pos2);
                                slot2 = { x: XY2[0], y: XY2[1], pos: pos2 };
                            }
                        }
                    }
                } else {
                    slot2 = getLeftmostFreeMonsterSlot(false);
                }
                if (slot2 == noone) break;
                var payload2 = {
                    card_asset_name: story_pending_summon_asset2,
                    xy: [slot2.x, slot2.y, slot2.pos],
                    summon_mode: "SpecialSummon"
                };
                if (mana_cost2 > 0 || forceCost2) payload2.mana_cost_override = mana_cost2;
                RequestGameAction(ACTION_SUMMON, payload2);
            }
            story_pending_summon_asset2 = "";
            if (variable_instance_exists(id, "story_pending_summon_cost2")) story_pending_summon_cost2 = 0;
            if (variable_instance_exists(id, "story_pending_summon_count2")) story_pending_summon_count2 = 0;
            if (variable_instance_exists(id, "story_pending_summon_force_cost2")) story_pending_summon_force_cost2 = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_back2")) story_pending_summon_prefer_back2 = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_front2")) story_pending_summon_prefer_front2 = false;
        }
        
        if (variable_instance_exists(id, "story_pending_summon_asset3") && story_pending_summon_asset3 != "") {
            var summonCount3 = (variable_instance_exists(id, "story_pending_summon_count3") ? story_pending_summon_count3 : 1);
            if (summonCount3 < 1) summonCount3 = 1;
            var mana_cost3 = (variable_instance_exists(id, "story_pending_summon_cost3") ? story_pending_summon_cost3 : 0);
            var forceCost3 = (variable_instance_exists(id, "story_pending_summon_force_cost3") && story_pending_summon_force_cost3);
            var preferBack3 = (variable_instance_exists(id, "story_pending_summon_prefer_back3") && story_pending_summon_prefer_back3);
            var preferFront3 = (variable_instance_exists(id, "story_pending_summon_prefer_front3") && story_pending_summon_prefer_front3);
            for (var m = 0; m < summonCount3; m++) {
                var slot3 = noone;
                if (preferBack3 || preferFront3) {
                    var fm3 = instance_exists(fieldManagerEnemy) ? fieldManagerEnemy : instance_find(oFieldManagerEnemy, 0);
                    if (fm3 != noone && instance_exists(fm3)) {
                        var monsterField3 = fm3.getField("Monster");
                        if (monsterField3 != noone && instance_exists(monsterField3)) {
                            var pos3 = -1;
                            if (preferBack3) {
                                for (var kb3 = 4; kb3 < min(array_length(monsterField3.cards), 8); kb3++) {
                                    if (monsterField3.cards[kb3] == 0) { pos3 = kb3; break; }
                                }
                                if (pos3 == -1) {
                                    for (var kb32 = 0; kb32 < min(array_length(monsterField3.cards), 4); kb32++) {
                                        if (monsterField3.cards[kb32] == 0) { pos3 = kb32; break; }
                                    }
                                }
                            } else { // preferFront3
                                for (var kf3 = 0; kf3 < min(array_length(monsterField3.cards), 4); kf3++) {
                                    if (monsterField3.cards[kf3] == 0) { pos3 = kf3; break; }
                                }
                                if (pos3 == -1) {
                                    for (var kf32 = 4; kf32 < min(array_length(monsterField3.cards), 8); kf32++) {
                                        if (monsterField3.cards[kf32] == 0) { pos3 = kf32; break; }
                                    }
                                }
                            }
                            if (pos3 != -1) {
                                var XY3 = fm3.getPosLocation("Monster", pos3);
                                slot3 = { x: XY3[0], y: XY3[1], pos: pos3 };
                            }
                        }
                    }
                } else {
                    slot3 = getLeftmostFreeMonsterSlot(false);
                }
                if (slot3 == noone) break;
                var payload3 = {
                    card_asset_name: story_pending_summon_asset3,
                    xy: [slot3.x, slot3.y, slot3.pos],
                    summon_mode: "SpecialSummon"
                };
                if (mana_cost3 > 0 || forceCost3) payload3.mana_cost_override = mana_cost3;
                RequestGameAction(ACTION_SUMMON, payload3);
            }
            story_pending_summon_asset3 = "";
            if (variable_instance_exists(id, "story_pending_summon_cost3")) story_pending_summon_cost3 = 0;
            if (variable_instance_exists(id, "story_pending_summon_count3")) story_pending_summon_count3 = 0;
            if (variable_instance_exists(id, "story_pending_summon_force_cost3")) story_pending_summon_force_cost3 = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_back3")) story_pending_summon_prefer_back3 = false;
            if (variable_instance_exists(id, "story_pending_summon_prefer_front3")) story_pending_summon_prefer_front3 = false;
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
        
        if (variable_instance_exists(id, "story_pending_add_to_hand_asset2") && story_pending_add_to_hand_asset2 != "") {
            var handInst2 = handEnemy;
            if (instance_exists(handInst2)) {
                var cap2 = (variable_global_exists("MAX_HAND_SIZE") ? global.MAX_HAND_SIZE : 10);
                var handCount2 = ds_list_size(handInst2.cards);
                if (handCount2 < cap2) {
                    var objIdxHand2 = asset_get_index(story_pending_add_to_hand_asset2);
                    if (objIdxHand2 != -1) {
                        var newCard2 = instance_create_layer(handInst2.x, handInst2.y, layer_get_id("Instances"), objIdxHand2);
                        if (newCard2 != noone) {
                            newCard2.isHeroOwner = false;
                            newCard2.image_angle = 180;
                            newCard2.zone = "Hand";
                            handInst2.addCard(newCard2);
                            registerTriggerEvent(TRIGGER_ENTER_HAND, newCard2, { owner_is_hero: false });
                        }
                    }
                } else {
                    var gy2 = graveyardEnemy;
                    var objIdxBurn2 = asset_get_index(story_pending_add_to_hand_asset2);
                    if (instance_exists(gy2) && objIdxBurn2 != -1) {
                        var burnCard2 = instance_create_layer(gy2.x, gy2.y, layer_get_id("Instances"), objIdxBurn2);
                        if (burnCard2 != noone) {
                            burnCard2.isHeroOwner = false;
                            gy2.addToGraveyard(burnCard2, true);
                            burnCard2.zone = "Graveyard";
                            instance_destroy(burnCard2);
                        }
                    }
                }
            }
            story_pending_add_to_hand_asset2 = "";
        }
    }
    story_pause_after_enemy_draw = false;
    if (player_current == 1 && phase[phase_current] == "Start") nextPhase();
    exit;
}

if(timerMulligan > 0 && timerEnabledMulligan) {
	timerMulligan -= 1 / game_get_speed(gamespeed_fps);
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
    	timerIA -= 1 / game_get_speed(gamespeed_fps);
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
                if (variable_instance_exists(id, "story_pending_cast_spell_asset") && story_pending_cast_spell_asset != "") {
                    var objSpell = asset_get_index(story_pending_cast_spell_asset);
                    if (objSpell != -1) {
                        var hE = handEnemy;
                        if (instance_exists(hE)) {
                            var spellInst = instance_create_layer(hE.x, hE.y, layer_get_id("Instances"), objSpell);
                            if (spellInst != noone) {
                                spellInst.isHeroOwner = false;
                                spellInst.image_angle = 180;
                                spellInst.zone = "Hand";
                                hE.addCard(spellInst);
                                registerTriggerEvent(TRIGGER_ENTER_HAND, spellInst, { owner_is_hero: false });
                                
                                var payloadSpell = {
                                    card: spellInst,
                                    xy: [0, 0, -1],
                                    summon_mode: "Summon"
                                };
                                var castCost = (variable_instance_exists(id, "story_pending_cast_spell_cost") ? story_pending_cast_spell_cost : 0);
                                var castForce = (variable_instance_exists(id, "story_pending_cast_spell_force_cost") && story_pending_cast_spell_force_cost);
                                if (castCost > 0 || castForce) payloadSpell.mana_cost_override = castCost;
                                RequestGameAction(ACTION_SUMMON, payloadSpell);
                            }
                        }
                    }
                    story_pending_cast_spell_asset = "";
                    if (variable_instance_exists(id, "story_pending_cast_spell_cost")) story_pending_cast_spell_cost = 0;
                    if (variable_instance_exists(id, "story_pending_cast_spell_force_cost")) story_pending_cast_spell_force_cost = false;
                }
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
                if (checkTriggerConditions(self, effect, {})) {
                    // Exécuter l'effet continu
                    executeEffect(self, effect, {});
                }
            }
        }
    }
}
