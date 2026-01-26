show_debug_message("### oDeck.create")
show_debug_message(isHeroOwner)


///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// Assurer une graine aléatoire initialisée avant tout mélange
// En mode en ligne, la graine est déjà synchronisée via NET_SHARED_SEED.
var _isOnlineDeck = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
if (!_isOnlineDeck) {
    if (!variable_global_exists("rng_initialized") || !global.rng_initialized) {
        randomize();
        global.rng_initialized = true;
        show_debug_message("### oDeck.Create_0 - RNG initialisé (offline fallback)");
    }
}

deck = ds_list_create(); // Liste des cartes devant etre creees
cards = ds_list_create(); // Liste des cartes presentes physiquement dans le deck
image_alpha = 0; // Cache l'image qui est la seulement pour bien placer le deck sur la map


///////////////////////////////////////////////////////////////////////
// Constructeur
///////////////////////////////////////////////////////////////////////

//----------------------------------
// Selectionne un deck
//----------------------------------

// Verifier si des decks personnalises ont ete selectionnes depuis rContreIa
var use_custom_decks = false;

if (isHeroOwner) {
    show_debug_message("### oDeck.Create_0 - Initializing hero deck");
    
    // Debug des variables globales
    show_debug_message("### oDeck.Create_0 - variable_global_exists(selected_player_deck): " + string(variable_global_exists("selected_player_deck")));
    if (variable_global_exists("selected_player_deck")) {
        show_debug_message("### oDeck.Create_0 - global.selected_player_deck: " + string(global.selected_player_deck));
    }
    
    // Deck du heros
    if (variable_global_exists("selected_player_deck") && global.selected_player_deck != noone) {
        // Verifier que les donnees du deck sont valides
        if (is_struct(global.selected_player_deck) && variable_struct_exists(global.selected_player_deck, "name")) {
            show_debug_message("### oDeck.Create_0 - Loading custom player deck: " + global.selected_player_deck.name);
            use_custom_decks = load_player_deck_from_data(global.selected_player_deck, deck, false);
            if (use_custom_decks) {
                show_debug_message("### oDeck.Create_0 - Custom deck loaded successfully with " + string(ds_list_size(deck)) + " cards");
            } else {
                show_debug_message("### oDeck.Create_0 - Failed to load custom deck, using default");
                // Charger le deck par défaut en cas d'échec
                try {
                    heroDeck(deck, false);
                    show_debug_message("### oDeck.Create_0 - Default heroDeck function executed as fallback, deck size: " + string(ds_list_size(deck)));
                } catch (e) {
                    show_debug_message("### oDeck.Create_0 - Error calling heroDeck function as fallback: " + string(e));
                }
            }
        } else {
            show_debug_message("### oDeck.Create_0 - Error: Invalid player deck data");
        }
    }
    
    if (!use_custom_decks) {
        show_debug_message("### oDeck.Create_0 - WARNING: No custom deck loaded, deck will be empty!");
        show_debug_message("### oDeck.Create_0 - Check global.selected_player_deck value and deck selection logic");
    }
} else {
    // Deck de l'ennemi
    if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
        // --- MODE PVP ---
        show_debug_message("### oDeck.Create_0 - PVP ENEMY DECK LOADING");
        
        // 1. Essayer de charger le deck reçu par réseau (données complètes)
        if (variable_global_exists("remote_lobby_deck_data") && is_struct(global.remote_lobby_deck_data)) {
             show_debug_message("### oDeck - Loading REMOTE DECK DATA (received from network)");
             use_custom_decks = load_player_deck_from_data(global.remote_lobby_deck_data, deck, false);
        }
        // 2. Fallback: Essayer de charger par nom (si le deck existe localement)
        else if (variable_global_exists("remote_lobby_deck_name") && global.remote_lobby_deck_name != "") {
             show_debug_message("### oDeck - Loading REMOTE DECK by NAME: " + global.remote_lobby_deck_name);
             if (variable_global_exists("saved_decks") && is_array(global.saved_decks)) {
                 for (var i = 0; i < array_length(global.saved_decks); i++) {
                     if (global.saved_decks[i].name == global.remote_lobby_deck_name) {
                         use_custom_decks = load_player_deck_from_data(global.saved_decks[i], deck, false);
                         break;
                     }
                 }
             }
        }
    }
    else {
        // --- MODE SOLO / CONTRE IA ---
        if (variable_global_exists("selected_bot_deck_id") && global.selected_bot_deck_id != noone) {
            show_debug_message("### oDeck.Create_0 - Chargement du deck bot personnalise ID: " + string(global.selected_bot_deck_id));
            use_custom_decks = load_bot_deck_from_id(global.selected_bot_deck_id, deck, false);
        }
    }
    
    // Si aucun deck n'a pu être chargé (PVP échec ou IA par défaut)
    if (!use_custom_decks) {
        show_debug_message("### oDeck.Create_0 - Loading default enemy deck (Fallback)");
        heroDeck(deck, false);
    }
}
	
	
//----------------------------------
// Place les cartes sur la map
//----------------------------------

// GESTION DES UIDS EN MULTIJOUEUR
// On force une plage d'UIDs spécifique pour chaque joueur afin d'éviter les collisions
// et de permettre la synchronisation parfaite des cartes (Host=100k+, Client=200k+)
if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
    var local_idx = (variable_global_exists("NET_IS_HOST") && !global.NET_IS_HOST) ? 1 : 0;
    var owner_idx = isHeroOwner ? local_idx : (1 - local_idx);
    
    // Définir le début de la plage pour ce deck (ex: 100001 ou 200001)
    // On laisse une marge de 1 au cas où
    global.nextCardInstanceUID = (owner_idx * 100000) + 1;
    
    show_debug_message("### oDeck - Setting UID Range for " + (isHeroOwner ? "HERO" : "ENEMY") + " Deck. Owner=" + string(owner_idx) + " StartUID=" + string(global.nextCardInstanceUID));
}
	
for(var i=0; i<ds_list_size(deck); i++) {
    var item = ds_list_find_value(deck, i);
	
	var instance = instance_create_layer(x+i/3, y-i/3, layer_get_id("Instances"), item);
	instance.image_index = 1;
	instance.image_angle = image_angle;
	instance.image_xscale = image_xscale;
	instance.image_yscale = image_yscale;
    instance.depth = 150;
	instance.isHeroOwner = isHeroOwner;
	instance.zone = "Deck";  // Initialiser la zone de la carte
	
    ds_list_add(cards, instance);
}

// RESTAURATION DE LA PLAGE LOCALE
// Après avoir créé les cartes du deck (qui peuvent être celles de l'adversaire),
// on remet le compteur global sur la plage du joueur LOCAL + marge de sécurité (5000)
// pour que les créations futures (Tokens, etc.) appartiennent bien au joueur local.
if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
    var local_idx = (variable_global_exists("NET_IS_HOST") && !global.NET_IS_HOST) ? 1 : 0;
    global.nextCardInstanceUID = (local_idx * 100000) + 5000;
    show_debug_message("### oDeck - Resetting Global UID to Local Range: " + string(global.nextCardInstanceUID));
}

// Mélanger l'ordre des cartes dans le deck pour rendre la pioche non déterministe
// SAUF si c'est le Chapitre 0 (Tutoriel), où l'ordre est scripté
var is_tutorial = (variable_global_exists("current_chapter") && global.current_chapter == 0);

if (ds_list_size(cards) > 1 && !is_tutorial) {
    // En PVP, on force une graine spécifique par deck pour éviter les désynchronisations
    // liées à l'ordre de création ou à la consommation d'aléatoire par d'autres objets
    if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
        if (variable_global_exists("NET_SHARED_SEED")) {
            // Déterminer l'index logique du propriétaire de ce deck (0 = Hôte, 1 = Client)
            // local_player_index : 0 si Host, 1 si Client
            // isHeroOwner : true si c'est le deck du joueur local, false sinon
            
            var owner_index = 0;
            var local_index = 0;
            var remote_index = 1;
            if (variable_global_exists("NET_IS_HOST") && !global.NET_IS_HOST) {
                local_index = 1;
                remote_index = 0;
            }
            owner_index = (isHeroOwner ? local_index : remote_index);
            
            // Calculer une graine unique mais déterministe pour ce deck
            // On ajoute un grand nombre pour séparer nettement les séquences
            var deck_seed = global.NET_SHARED_SEED + 10000 + (owner_index * 55555);
            random_set_seed(deck_seed);
            show_debug_message("### oDeck PVP Shuffle - Owner Index: " + string(owner_index) + " | Seed: " + string(deck_seed));
        }
    }

    ds_list_shuffle(cards);
    show_debug_message("### oDeck.Create_0 - Deck mélangé: " + string(ds_list_size(cards)) + " cartes");
} else if (is_tutorial) {
    show_debug_message("### oDeck.Create_0 - Deck NON mélangé (Tutoriel actif)");
}


///////////////////////////////////////////////////////////////////////
// Methodes
///////////////////////////////////////////////////////////////////////

// Tire une carte dans le deck
#region Function pick
pick = function() { show_debug_message("### oDeck.pick");
	
	// Verifier qu'il y a des cartes dans le deck
	if (ds_list_size(cards) <= 0) {
		show_debug_message("### oDeck.pick - Error: No cards left in deck");
		return;
	}
	
	// Recupere la carte du dessus (l'index 0 etant en dessous du deck)
	var cardToPick = ds_list_find_value(cards, ds_list_size(cards)-1);
	
	// Verifier que la carte est valide
	if (cardToPick == noone || !instance_exists(cardToPick)) {
		show_debug_message("### oDeck.pick - Error: Invalid card instance");
		return;
	}
	
	// Retire la carte du deck
	ds_list_delete(cards, ds_list_size(cards)-1);
	
    // Vérifier la capacité de la main du propriétaire
    var handInst = (isHeroOwner ? handHero : handEnemy);
    var cap = (variable_global_exists("MAX_HAND_SIZE") ? global.MAX_HAND_SIZE : 10);
    var handCount = (instance_exists(handInst) ? ds_list_size(handInst.cards) : 0);
    if (handCount >= cap) {
        // Main pleine: animation centrale (grande) de brûlure + envoi direct au cimetière, sans triggers
        var gyInst = (isHeroOwner ? graveyardHero : graveyardEnemy);
        if (instance_exists(gyInst)) {
            // FX de défausse au centre: grand et focalisé
            var fx = instance_create_layer(cardToPick.x, cardToPick.y, "UI", oFX_Discard);
            if (fx != noone) {
                fx.spriteGhost    = cardToPick.sprite_index;
                // Toujours montrer la FACE de la carte (frame 0)
                fx.imageGhost     = 0;
                // Afficher au centre de l'écran
                fx.display_at_center = true;
                // Taille standard demandée
                fx.image_xscale   = 1;
                fx.image_yscale   = 1;
                fx.image_angle    = 0;
                // Durée plus lisible pour la brûlure
                fx.duration_ms    = 1200; // ~1.2s
                // Flamme plus épaisse
                fx.flame_thickness = 12;
                fx.depth_override = -100000;
            }
            // Mouvement logique silencieux
            gyInst.addToGraveyard(cardToPick, true); // suppress_triggers = true
        }
        cardToPick.zone = "Graveyard";
        instance_destroy(cardToPick);
        return; // ne pas déclencher TRIGGER_ON_CARD_DRAW
    }
    
    // Déclenche l'événement de pioche avant l'ajout à la main
    registerTriggerEvent(TRIGGER_ON_CARD_DRAW, cardToPick, { owner_is_hero: isHeroOwner });
    
    // Ajoute la carte dans la main avec rafraîchissement différé et lance l'FX de pioche
    if (instance_exists(handInst)) {
        // Masque temporairement la carte réelle pour éviter un clignotement
        cardToPick.visible = false;
        
        // Ajouter sans rafraîchir immédiatement
        handInst.addCard(cardToPick, true);
        
        // FX de pioche: glisse verticale vers la main depuis la carte empilée
        var fx = instance_create_depth(cardToPick.x, cardToPick.y, -100000, oFX_Draw);
        if (fx != noone) {
            fx.spriteGhost       = cardToPick.sprite_index;
            // Afficher la face pour le joueur, le dos pour l'IA
            fx.imageGhost        = (isHeroOwner ? 0 : 1);
            fx.image_xscale      = cardToPick.image_xscale;
            fx.image_yscale      = cardToPick.image_yscale;
            fx.image_angle       = (isHeroOwner ? 0 : 180);
            fx.duration_ms       = 400;
            fx.target_x          = cardToPick.x; // Mouvement vertical dans la colonne de la carte
            fx.target_y          = handInst.y;
            fx.hand_to_update    = handInst;
            fx.card_to_reveal    = cardToPick;
        } else {
            // Fallback si l'effet n'est pas créé
            cardToPick.visible = true;
            if (variable_instance_exists(handInst, "updateDisplay")) { handInst.updateDisplay(); }
        }
    } else {
        // Fallback si la main n'existe pas
        (isHeroOwner ? handHero : handEnemy).addCard(cardToPick);
    }
}
#endregion

