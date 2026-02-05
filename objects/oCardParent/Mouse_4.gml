show_debug_message("### oCardParent.Click - room: " + string(room))

// Protection contre les clics traversants (si un bouton UI a été cliqué dans la même frame ou très récemment)
if (variable_global_exists("last_ui_click_time") && (current_time - global.last_ui_click_time) < 200) {
    show_debug_message("### oCardParent: Clic ignoré car bouton UI cliqué récemment");
    return;
}

// Bloque immédiatement tout clic si le panneau d'options est présent
if (instance_exists(oPanelOptions)) return;

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) return;

///////////////////////////////////////////////////////////////////////
// Controls
///////////////////////////////////////////////////////////////////////

// Vérifier si on est dans une room appropriée
if (room != rDuel && room != rCollection) {
    exit;
}

// Bloquer toute interaction carte si des indicateurs d’emplacement sont actifs (choix de position) — uniquement en Duel
if (room == rDuel) {
    if ((instance_exists(oIndicatorParent)) || (instance_exists(oUIManager) && UIManager.selectedSummonOrSet != "")) {
        return;
    }
}

// Si le GraveyardViewer est ouvert, bloquer les clics — uniquement en Duel
// Vérifier si la variable globale existe avant de l'utiliser
if (room == rDuel && variable_global_exists("isGraveyardViewerOpen") && global.isGraveyardViewerOpen) return;

// Bloquer les clics quand le menu d'action est visible — uniquement en Duel
if (room == rDuel && variable_global_exists("isActionMenuOpen") && global.isActionMenuOpen) {
    var allowDeckPick = false; // Legacy "Pick" phase removed
    var allowUnselectClick = instance_exists(oSelectManager) && selectManager.selected == id;
    // Autoriser un clic de carte héros pour afficher le viewer, même avec le menu ouvert
    var allowViewerClick = instance_exists(oSelectManager) && isHeroOwner && (zone == "Hand" || zone == "Field");
    // Autoriser un clic viewer-only sur carte adverse face visible (terrain)
    var allowEnemyViewerClick = instance_exists(oSelectManager) && !isHeroOwner && (
        ((zone == "Field") && !isFaceDown) ||
        ((zone == "Hand") && instance_exists(handEnemy) && variable_instance_exists(handEnemy, "reveal_override") && handEnemy.reveal_override)
    );
    if (!(allowDeckPick || allowUnselectClick || allowViewerClick || allowEnemyViewerClick)) {
        return;
    }
}

// Vérifier si un bouton UI est présent et bloque les clics — uniquement en Duel
if (room == rDuel && (instance_exists(oSummon) || instance_exists(oAttack) || instance_exists(oEffectButton))) {
    // Vérifier si le clic est directement sur un bouton UI
    var uiButtonClicked = false;
    
    with(oSummon) {
        if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
            uiButtonClicked = true;
            break;
        }
    }
    
    if (!uiButtonClicked) {
        with(oAttack) {
            if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
                uiButtonClicked = true;
                break;
            }
        }
    }

    if (!uiButtonClicked) {
        with(oEffectButton) {
            if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
                uiButtonClicked = true;
                break;
            }
        }
    }
    
    // Si un bouton UI a été cliqué, ne pas sélectionner la carte
    if (uiButtonClicked) {
        exit;
    }
}

// Bloquer uniquement pendant la distribution en phase Pick — Duel
if (room == rDuel && instance_exists(game) && game.timerEnabledMulligan && game.phase[game.phase_current] == "Pick")
    return;

///////////////////////////////////////////////////////////////////////
// Constructeur
///////////////////////////////////////////////////////////////////////

//----------------------------------
// Tire une carte dans le deck
//----------------------------------

// Vérifier que l'objet game existe avant de l'utiliser
var isMyTurn = false;
if (instance_exists(game)) {
    if (variable_instance_exists(game, "local_player_index")) {
        isMyTurn = (game.player_current == game.local_player_index);
    } else {
        // Mode solo : le joueur est toujours l'index 0 ("Hero")
        isMyTurn = (game.player_current == 0);
    }
}

// Manual draw logic removed for HS transition
// if(isHeroOwner && instance_exists(game) && isMyTurn && game.phase[game.phase_current] == "Pick" && zone == "Deck") { ... }

//----------------------------------
// Sélection / Désélection
//----------------------------------

// Vérifier que selectManager existe (uniquement dans rDuel)
if (instance_exists(oSelectManager)) {
    // On essaye de désactiver la carte que si on ne vient pas tout juste de l'activer
    var selection_result = selectManager.trySelect(id);
    show_debug_message("### Résultat de la sélection: " + string(selection_result));
    
    if(!selection_result) { // Sélectionne une carte si on clique dessus
        show_debug_message("### Tentative de désélection de carte: " + string(id));
        selectManager.tryUnselect(id); // Désélectionne une carte si on clique à nouveau dessus
    }
}

//----------------------------------
// Attaque / Cast
//----------------------------------

// Vérifier si une carte sélectionnée clique sur une cible ennemie (uniquement dans rDuel)
if (instance_exists(oSelectManager) && selectManager.selected != noone) {
    // Si on clique sur une carte ennemie, déclencher l'attaque SEULEMENT si le mode attaque est activé
    if (!isHeroOwner && type == "Monster" && zone == "Field") {
        if (selectManager.attackMode) {
            // Vérification Camouflage : Impossible d'attaquer directement un monstre camouflé
            if (variable_instance_exists(id, "isCamouflage") && isCamouflage) {
                show_debug_message("### Cible invalide: Monstre camouflé");
                return;
            }
            
            show_debug_message("### Cible sélectionnée pour l'attaque: " + name);
            var payload = {};
            payload.attacker = selectManager.selected;
            payload.target = id;
            if (instance_exists(selectManager.selected) && variable_instance_exists(selectManager.selected, "instance_uid")) {
                payload.attacker_uid = selectManager.selected.instance_uid;
            }
            if (variable_instance_exists(id, "instance_uid")) {
                payload.target_uid = instance_uid;
            }
            RequestGameAction(ACTION_ATTACK, payload);
            return;
        } else {
            show_debug_message("### Monstre ennemi cliqué mais pas en mode attaque - utilisez le bouton Attack d'abord");
            return;
        }
    }
}

//----------------------------------
// Logique de sélection pour rCollection
//----------------------------------

// Logique de sélection de carte dans la collection
if (room == rCollection) {
    // Désélectionner toutes les autres cartes
    with (oCardParent) {
        isSelected = false;
    }
    
    // Sélectionner cette carte
    isSelected = true;
    
    // Utiliser le système de sélection original avec oCollectionSelectManager
    if (instance_exists(oCollectionSelectManager)) {
        with (oCollectionSelectManager) {
            selectCard(other.id);
        }
    }
}

