show_debug_message("### oGame.create")

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// Charger et appliquer les options utilisateur au lancement du jeu
if (!variable_global_exists("options_loaded") || !global.options_loaded) {
    // Note: L'initialisation se fait désormais dans oGlobalManager (rAcceuil)
    // Ce bloc est gardé en secours si on lance le jeu directement depuis rDuel
    progression_init();
    
    // Charger les decks de bots personnalisés
    load_bot_decks_from_file();
load_hero_decks_from_file();

    // Volume
    ini_open("options.ini");
    var _ini_vol = ini_read_real("audio", "volume_percent", 100);
    ini_close();
    global.volume_percent = clamp(_ini_vol, 0, 100);
    audio_master_gain(global.volume_percent / 100);

    // Plein écran / Fenêtré / Sans bordure
    ini_open("options.ini");
    var _fs_default = window_get_fullscreen() ? 1 : 0;
    var _display_mode = ini_read_real("display", "fullscreen", _fs_default);
    
    // Résolution
    var _current_w = window_get_width();
    var _current_h = window_get_height();
    var _default_res = string(_current_w) + "x" + string(_current_h);
    var _res_str = ini_read_string("display", "resolution", _default_res);
    ini_close();

    _display_mode = clamp(_display_mode, 0, 2);

    if (_display_mode == 1) {
        // Plein écran
        window_set_fullscreen(true);
        window_set_showborder(true);
    } else if (_display_mode == 2) {
        // Sans bordure
        window_set_fullscreen(false);
        window_set_showborder(false);
        window_set_rectangle(0, 0, display_get_width(), display_get_height());
    } else {
        // Fenêtré (Mode 0)
        window_set_fullscreen(false);
        window_set_showborder(true);
        
        var _xpos = string_pos("x", _res_str);
        if (_xpos > 0) {
            var _new_w = real(string_copy(_res_str, 1, _xpos - 1));
            var _new_h = real(string_copy(_res_str, _xpos + 1, string_length(_res_str) - _xpos));
            window_set_size(_new_w, _new_h);
            window_center();
        }
    }

    global.options_loaded = true;
    show_debug_message("### Options chargées par oGame (fallback)");
}

// Initialiser le générateur pseudo-aléatoire une seule fois par session
// En ligne, la graine est définie via NET_SHARED_SEED avant l'entrée dans rDuel.
var _isOnlineGame = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
if (!_isOnlineGame) {
    if (!variable_global_exists("rng_initialized") || !global.rng_initialized) {
        randomize();
        global.rng_initialized = true;
        show_debug_message("### RNG initialisé avec randomize() pour cette session (offline)");
    }
}

timerMulligan = 0.5;
timerEnabledMulligan = true;
timerAutoDraw = 0;
timerAutoDrawEnabled = false;
global.isGraveyardViewerOpen = false;

// === Animation globals ===
if (!variable_global_exists("ANIM_ROTATE_SPEED")) global.ANIM_ROTATE_SPEED = 6;      // deg/step
if (!variable_global_exists("ANIM_FLIP_SPEED")) global.ANIM_FLIP_SPEED = 0.03;        // scale/step
if (!variable_global_exists("ANIM_ROTATE_PRE_DELAY_FRAMES")) global.ANIM_ROTATE_PRE_DELAY_FRAMES = 6; // frames

// Activer l’animation de combat via FX_Combat
if (!variable_global_exists("USE_COMBAT_FX")) global.USE_COMBAT_FX = true;

// Niveau de difficulté IA: 0=Normal, 1=Difficile
if (!variable_global_exists("IA_DIFFICULTY")) global.IA_DIFFICULTY = 0;

// Ajouter un flag global pour contrôler la verbosité des logs (par défaut désactivé)
if (!variable_global_exists("VERBOSE_LOGS")) global.VERBOSE_LOGS = false;

// Limite de taille de main (IA et Héros)
if (!variable_global_exists("MAX_HAND_SIZE")) global.MAX_HAND_SIZE = 10;

// --- HEARTHSTONE SYSTEM MIGRATION (Phase 1) ---
// Mana system globals
// FIX: Always reset mana at start of duel to avoid persistence bugs
global.mana_hero = 0;
global.mana_max_hero = 0;
global.mana_enemy = 0;
global.mana_max_enemy = 0;

// Secrets system globals
// FIX: Clear existing lists or create new ones
if (variable_global_exists("activeSecretsHero") && ds_exists(global.activeSecretsHero, ds_type_list)) {
    ds_list_clear(global.activeSecretsHero);
} else {
    global.activeSecretsHero = ds_list_create();
}

if (variable_global_exists("activeSecretsEnemy") && ds_exists(global.activeSecretsEnemy, ds_type_list)) {
    ds_list_clear(global.activeSecretsEnemy);
} else {
    global.activeSecretsEnemy = ds_list_create();
}
// ----------------------------------------------

// Variable pour sauvegarder la room précédente avant d'entrer dans rDuel
if (!variable_global_exists("previous_room_before_duel")) {
    global.previous_room_before_duel = rMode; // Valeur par défaut
}

// Initialiser les variables globales des cimetières
// Ces variables seront assignées aux instances réelles dans la room rDuel
global.graveyardHero = noone;
global.graveyardEnemy = noone;

// Fonction pour initialiser les cimetières (appelée après création de la room)
initializeGraveyards = function() {
    // Trouver les cimetières par leurs coordonnées exactes (comme dans oDamageManager)
    with (oGraveyard) {
        if (abs(x - 1514.7029) < 1 && abs(y - 688.0) < 1) {
            global.graveyardHero = id;
            isHeroOwner = true;
        } else if (abs(x - 452.9149) < 1 && abs(y - 282.0) < 1) {
            global.graveyardEnemy = id;
            isHeroOwner = false;
        }
    }
    
    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
        show_debug_message("### Cimetières initialisés - Hero: " + string(global.graveyardHero) + ", Enemy: " + string(global.graveyardEnemy));
    }
}

// Fonction pour définir le fond d'écran du duel en fonction du bot
setDuelBackground = function() {
    if (variable_global_exists("selected_bot_deck_id")) {
        // Par défaut, tout le monde utilise sTerrain1
        var bg_sprite = asset_get_index("sTerrain1");
        
        // Configuration: Groupes de bots avec des fonds spécifiques
        // Format: { sprite: "NomSprite", bots: [id1, id2, id3...] }
        var bg_groups = [
            {
                sprite: "sTerrain2",
                bots: [1, 2, 3, "Invasion_Gueule_Roche", "Essaim_Abyssien", "Bandit_Grand_Chemin"] // Bot 1, 2 et 3 (Chapitre 1) utilisent sTerrain2
            }
            // Ajoutez d'autres groupes ici pour d'autres exceptions
        ];
        
        // Recherche si le bot actuel fait partie d'une exception
        for (var i = 0; i < array_length(bg_groups); i++) {
            var group = bg_groups[i];
            var bot_list = group.bots;
            
            // Vérifie si l'ID du bot est dans la liste de ce groupe
            for (var j = 0; j < array_length(bot_list); j++) {
                if (bot_list[j] == global.selected_bot_deck_id) {
                    bg_sprite = asset_get_index(group.sprite);
                    break;
                }
            }
        }
        
        if (bg_sprite != -1) {
            var lay_id = layer_get_id("Background");
            if (lay_id != -1) {
                var back_id = layer_background_get_id(lay_id);
                if (back_id != -1) {
                    layer_background_sprite(back_id, bg_sprite);
                    layer_background_stretch(back_id, true);
                    
                    if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
                        show_debug_message("### Background défini pour bot " + string(global.selected_bot_deck_id) + ": " + sprite_get_name(bg_sprite));
                    }
                }
            }
        }
    }
}

// Appliquer le fond d'écran au démarrage
setDuelBackground();

phase = ["Start", "Main", "End"];
player = ["Hero", "Enemy"];
phase_current = 2; // Start at End so nextPhase() cycles to Start
global.current_phase = phase[phase_current];
player_current = 1; // Start at Enemy so nextPhase() cycles to Hero (Player 0)
nbTurn = 0; // Will increment to 1 on first Start
timerIA = 0;
timerEnabledIA = false;

local_player_index = 0;
remote_player_index = 1;

// Vérification du mode Bot/Histoire pour forcer le mode hors-ligne
var isBotDuel = (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone);

if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline" && !isBotDuel) {
    if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST) {
        local_player_index = 0;
        remote_player_index = 1;
    } else {
        local_player_index = 1;
        remote_player_index = 0;
    }
    
    // 50/50 pour décider qui commence
    // On utilise le seed partagé pour que les deux joueurs aient le même résultat
    if (variable_global_exists("NET_SHARED_SEED")) {
        player_current = (global.NET_SHARED_SEED % 2);
        random_set_seed(global.NET_SHARED_SEED);
        
        if (variable_global_exists("VERBOSE_LOGS") && global.VERBOSE_LOGS) {
            show_debug_message("### Multiplayer 50/50: Seed=" + string(global.NET_SHARED_SEED) + " Starting Player=" + string(player_current));
        }
        
        coin_toss_active = true;
        coin_toss_angle = 0;
        coin_toss_speed = 40;
        coin_toss_timer = 0;
        coin_toss_phase = 0;
        coin_toss_scale_x = 1;
        
        is_local_turn = (player_current == local_player_index);
        coin_toss_is_heads = is_local_turn;
    } else {
        coin_toss_active = false;
    }
}
is_local_turn = (player_current == local_player_index);


// Limites par joueur
hasSummonedThisTurn = [false, false];

// Assurer la présence de la base de données des cartes (singleton)
if (!instance_exists(oDataBase)) {
    instance_create_layer(864, 32, "Instances", oDataBase);
    show_debug_message("### oGame: oDataBase créé automatiquement");
}

///////////////////////////////////////////////////////////////////////
// Méthodes


#region Function nextPhase
nextPhase = function() {
    show_debug_message("### oGame.nextPhase: Current=" + phase[phase_current]);

    var prev_phase = phase[phase_current];
    registerTriggerEvent(TRIGGER_END_PHASE, noone, { phase: prev_phase });

    // --- HEARTHSTONE FLOW LOGIC ---
    
    // Cycle: Start -> Main -> (End skipped) -> (Next Player) Start
    // [HEARTHSTONE] Main Phase acts as the final phase (End Turn)
    
    if (phase[phase_current] == "Main" || phase[phase_current] == "End") {
        // Fin du tour actuel
        registerTriggerEvent(TRIGGER_END_TURN, noone, {});
        
        // Quest System Notification: End Turn
        if (player_current == local_player_index && instance_exists(oQuestManager)) {
            oQuestManager.notify_event("end_turn", 1);
        }
        
        // Nettoyage visuel des mains
        if (instance_exists(handHero)) { handHero.reveal_override = false; if (variable_instance_exists(handHero, "updateDisplay")) { handHero.updateDisplay(); } }
        if (instance_exists(handEnemy)) { handEnemy.reveal_override = false; if (variable_instance_exists(handEnemy, "updateDisplay")) { handEnemy.updateDisplay(); } }
        
        // Changement de joueur
        player_current = (player_current + 1) % 2;
        is_local_turn = (player_current == local_player_index);
        
        // Mise à jour visuelle du bouton "Next Phase"
        // Dans HS, le bouton sert juste à dire "Fin de tour"
        if (instance_exists(oNextStep)) oNextStep.image_index = 1; 
        
        nbTurn++;
        
        // Passage à Start du nouveau joueur
        phase_current = 0; // "Start"
    } else {
        // Passage à la phase suivante (Start -> Main)
        phase_current = (phase_current + 1) % 3;
    }

    global.current_phase = phase[phase_current];
    show_debug_message("### New Phase: " + global.current_phase + " (Player " + string(player_current) + ")");

    // --- LOGIQUE DE DÉBUT DE PHASE ---

    if (phase[phase_current] == "Start") {
        // --- MANA & DRAW STEP ---
        
        // 1. Gestion du Mana (Ramp up + Refill)
        if (player_current == 0) { // Hero
            // Augmenter le max si < 10 (Sauf tour 1 du joueur 2 si on veut équilibrer plus tard, mais standard HS: +1 tout le temps)
            // Note: HS commence à 1 mana au T1. 
            // Ici nbTurn s'incrémente à chaque changement de joueur, donc T1 Hero, T2 Enemy, T3 Hero...
            // C'est pas idéal. Généralement T1 = Tour complet.
            // On va simplifier: mana_max += 1 à chaque début de MON tour.
            
            global.mana_max_hero = min(global.mana_max_hero + 1, 10);
            global.mana_hero = global.mana_max_hero;
            show_debug_message("### Mana Hero: " + string(global.mana_hero) + "/" + string(global.mana_max_hero));
            
        } else { // Enemy
            global.mana_max_enemy = min(global.mana_max_enemy + 1, 10);
            global.mana_enemy = global.mana_max_enemy;
            show_debug_message("### Mana Enemy: " + string(global.mana_enemy) + "/" + string(global.mana_max_enemy));
        }

        // 2. Reset des états de combat (Mal d'invocation géré à l'invocation, mais reset des attaques ici)
        hasSummonedThisTurn[player_current] = false;

        with (oCardMonster) {
            var localIdx = (variable_instance_exists(oGame, "local_player_index")) ? oGame.local_player_index : 0;
            var ownerIdx = (isHeroOwner) ? localIdx : (1 - localIdx);
            
            if (ownerIdx == oGame.player_current) {
                // Nouvelle règle: peut attaquer si pas mal d'invocation
                if (variable_instance_exists(id, "attacksUsedThisTurn")) attacksUsedThisTurn = 0;
                
                // Reset de la "Charge" ou autre état temporaire si besoin
                // Dans HS, le mal d'invocation saute au début du tour.
                if (variable_instance_exists(id, "summoningSickness")) summoningSickness = false;
            }
        }

        // 3. Déclencheurs de début de tour
        registerTriggerEvent(TRIGGER_START_TURN, noone, {});

        // 4. Pioche Automatique
        // Sauf si c'est la toute première distribution (gérée par timerMulligan)
        if (!timerEnabledMulligan) {
            // Auto-transition vers Main Phase après pioche
            // On déclenche la pioche, et on demandera la suite
            
             if (is_local_turn) {
                timerAutoDraw = 0.5;
                timerAutoDrawEnabled = true;
                show_debug_message("### Auto-Draw enabled for Turn " + string(nbTurn));
            } else {
                // Pour l'ennemi, l'IA ou le réseau déclenchera la pioche
                // Si IA Offline:
                var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
                if (!isOnline) {
                     // L'IA pioche et passe en Main
                     // On laisse le timerIA gérer ça
                }
            }
        } else {
            // Premier tour distribution: On passe direct en Main manuellement après distribution
            // (La distribution appelle nextPhase quand finie)
        }
        
        // Dans HS, la phase Start est instantanée. On passe en Main direct après la pioche.
        // La pioche se fera via timerAutoDraw qui appelle pick() -> qui PEUT appeler nextPhase() si configuré.
        // Pour l'instant on reste en Start le temps de l'anim pioche.
    }
    
    // --- GESTION IA ---
    var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
    if (!isOnline && player[player_current] == "Enemy") {
        if (phase[phase_current] == "Main") {
            // L'IA joue pendant la Main Phase
            timerIA = 1;
            timerEnabledIA = true;
        } else if (phase[phase_current] == "Start" && !timerEnabledMulligan) {
             // IA doit piocher en Start
             // On force un délai court pour simuler
             timerIA = 0.5;
             timerEnabledIA = true;
        }
    } else if (isOnline) {
        timerEnabledIA = false;
    }
}
#endregion

