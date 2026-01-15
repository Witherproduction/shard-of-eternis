show_debug_message("### oGame.create")

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// Charger et appliquer les options utilisateur au lancement du jeu
if (!variable_global_exists("options_loaded") || !global.options_loaded) {
    // Note: L'initialisation se fait désormais dans oGlobalManager (rAcceuil)
    // Ce bloc est gardé en secours si on lance le jeu directement depuis rDuel
    progression_init();

    // Volume
    ini_open("options.ini");
    var _ini_vol = ini_read_real("audio", "volume_percent", 100);
    ini_close();
    global.volume_percent = clamp(_ini_vol, 0, 100);
    audio_master_gain(global.volume_percent / 100);

    // Plein écran
    ini_open("options.ini");
    var _fs_default = window_get_fullscreen() ? 1 : 0;
    var _ini_fs = ini_read_real("display", "fullscreen", _fs_default);
    ini_close();
    var _fs_enabled = (_ini_fs >= 0.5);
    window_set_fullscreen(_fs_enabled);

    // Résolution (appliquée uniquement en mode fenêtré)
    ini_open("options.ini");
    var _current_w = window_get_width();
    var _current_h = window_get_height();
    var _default_res = string(_current_w) + "x" + string(_current_h);
    var _res_str = ini_read_string("display", "resolution", _default_res);
    ini_close();

    if (!_fs_enabled) {
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
if (!variable_global_exists("rng_initialized") || !global.rng_initialized) {
    randomize();
    global.rng_initialized = true;
    show_debug_message("### RNG initialisé avec randomize() pour cette session");
}

timerPick = 0.5;
timerEnabledPick = true;
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
                bots: [1] // Bot 1 utilise sTerrain2
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

phase = ["Pick", "Summon", "Attack"];
player = ["Hero", "Enemy"];
phase_current = 0;
global.current_phase = phase[phase_current];
player_current = 0;
nbTurn = 1;
timerIA = 0;
timerEnabledIA = false;

local_player_index = 0;
remote_player_index = 1;
if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
    if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST) {
        local_player_index = 0;
        remote_player_index = 1;
    } else {
        local_player_index = 1;
        remote_player_index = 0;
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
    show_debug_message("### oGame.nextPhase")

    var prev_phase = phase[phase_current];
    registerTriggerEvent(TRIGGER_END_PHASE, noone, { phase: prev_phase });

    if (phase[phase_current] == "Attack") {
        // Fin du tour: déclenche les effets de fin
        registerTriggerEvent(TRIGGER_END_TURN, noone, {});
        if (instance_exists(handHero)) { handHero.reveal_override = false; if (variable_instance_exists(handHero, "updateDisplay")) { handHero.updateDisplay(); } }
        if (instance_exists(handEnemy)) { handEnemy.reveal_override = false; if (variable_instance_exists(handEnemy, "updateDisplay")) { handEnemy.updateDisplay(); } }
        player_current = (player_current + 1) % 2;
        is_local_turn = (player_current == local_player_index);
        nextStep.image_index = 1;
        nbTurn++;
    }

    phase_current = (phase_current + 1) % 3;
    global.current_phase = phase[phase_current];
    if (phase[phase_current] == "Attack") {
        registerTriggerEvent(TRIGGER_BATTLE_PHASE, noone, {});
    }

    // Réinitialisation des états au début du tour
  if (phase[phase_current] == "Pick") {
    hasSummonedThisTurn[player_current] = false;

    // Réinitialise orientation pour tous les monstres du joueur actif
 with (oCardMonster) {
    if ((isHeroOwner && oGame.player[oGame.player_current] == "Hero") ||
        (!isHeroOwner && oGame.player[oGame.player_current] == "Enemy")) {
        orientationChangedThisTurn = false;
        if (variable_instance_exists(id, "attacksUsedThisTurn")) attacksUsedThisTurn = 0;
    }
}

    // Début du tour: déclenche les effets de début
    registerTriggerEvent(TRIGGER_START_TURN, noone, {});

}
    var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
    if (!isOnline && player[player_current] == "Enemy") {
        timerIA = 1;
        timerEnabledIA = true;
    } else if (isOnline) {
        timerEnabledIA = false;
    }
}
#endregion
