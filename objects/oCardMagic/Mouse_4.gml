show_debug_message("### oCardMagic.Click")

// Protection contre les clics traversants (si un bouton UI a été cliqué dans la même frame ou très récemment)
if (variable_global_exists("last_ui_click_time") && (current_time - global.last_ui_click_time) < 200) {
    show_debug_message("### oCardMagic: Clic ignoré car bouton UI cliqué récemment");
    exit;
}

// Vérifier si on est dans une room appropriée
if (room != rDuel && room != rCollection) {
    exit;
}

// Bloquer toute interaction carte si des indicateurs d’emplacement sont actifs (choix de position)
if ((instance_exists(oIndicatorParent)) || (instance_exists(oUIManager) && UIManager.selectedSummonOrSet != "")) {
    return;
}

// Vérifier si la variable globale existe avant de l'utiliser
if (variable_global_exists("isGraveyardViewerOpen") && global.isGraveyardViewerOpen) return;

// Anti-clic traversant: si la souris est sur un bouton UI, ne pas sélectionner la carte
// Utiliser instance_position pour tester le point souris contre les boutons (et non position_meeting)
if ((instance_exists(oSummon) && instance_position(mouse_x, mouse_y, oSummon) != noone)
 || (instance_exists(oAttack) && instance_position(mouse_x, mouse_y, oAttack) != noone)
 || (instance_exists(oEffectButton) && instance_position(mouse_x, mouse_y, oEffectButton) != noone)) {
    return;
}

// Bloquer les clics quand le menu d'action est visible — uniquement en Duel
if (room == rDuel && variable_global_exists("isActionMenuOpen") && global.isActionMenuOpen) {
    var allowDeckPick = false; // Legacy "Pick" phase removed
    var allowUnselectClick = instance_exists(oSelectManager) && selectManager.selected == id;
    // Autoriser viewer-only pour cartes visibles (héros et adversaire)
    var allowHeroViewerClick = instance_exists(oSelectManager) && isHeroOwner && (zone == "Hand" || zone == "Field");
    var allowEnemyViewerClick = instance_exists(oSelectManager) && !isHeroOwner && (
        ((zone == "Field") && !isFaceDown) ||
        ((zone == "Hand") && instance_exists(handEnemy) && variable_instance_exists(handEnemy, "reveal_override") && handEnemy.reveal_override)
    );
    if (!(allowDeckPick || allowUnselectClick || allowHeroViewerClick || allowEnemyViewerClick)) {
        return;
    }
}

// Vérifier si un bouton UI est cliqué et bloquer le traitement de la carte
var uiButtonPresent = false;
if (instance_exists(oSummon) || instance_exists(oAttack) || instance_exists(oEffectButton)) {
    with(oSummon) {
        var w = sprite_get_width(sprite_index) * image_xscale;
        var h = sprite_get_height(sprite_index) * image_yscale;
        var ox = sprite_get_xoffset(sprite_index) * image_xscale;
        var oy = sprite_get_yoffset(sprite_index) * image_yscale;
        var left = x - ox;
        var top = y - oy;
        var right = left + w;
        var bottom = top + h;
        if (point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom)) {
            uiButtonPresent = true;
            break;
        }
    }
    // oSet check removed
    // oPositionButton check removed
    with(oAttack) {
        var w = sprite_get_width(sprite_index) * image_xscale;
        var h = sprite_get_height(sprite_index) * image_yscale;
        var ox = sprite_get_xoffset(sprite_index) * image_xscale;
        var oy = sprite_get_yoffset(sprite_index) * image_yscale;
        var left = x - ox;
        var top = y - oy;
        var right = left + w;
        var bottom = top + h;
        if (point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom)) {
            uiButtonPresent = true;
            break;
        }
    }
    with(oEffectButton) {
        var w = sprite_get_width(sprite_index) * image_xscale;
        var h = sprite_get_height(sprite_index) * image_yscale;
        var ox = sprite_get_xoffset(sprite_index) * image_xscale;
        var oy = sprite_get_yoffset(sprite_index) * image_yscale;
        var left = x - ox;
        var top = y - oy;
        var right = left + w;
        var bottom = top + h;
        if (point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom)) {
            uiButtonPresent = true;
            break;
        }
    }
}

if (uiButtonPresent) {
    return;
}

//----------------------------------
// Affichage dans rCollection
//----------------------------------

// Dans rCollection, hériter de la logique de sélection du parent
if (room == rCollection) {
    event_inherited();
    return;
}

// Phase Summon : Le changement d'orientation se fait maintenant via le bouton de position
// (Ancien système de clic direct supprimé pour éviter les changements non voulus)

// Phase Attack : gérer sélection et attaque ciblée
// Vérifier que l'objet game existe avant de l'utiliser
var isMyTurn = false;
if (instance_exists(game)) {
    if (variable_instance_exists(game, "local_player_index")) {
        isMyTurn = (game.player_current == game.local_player_index);
    } else {
        isMyTurn = (game.player_current == 0);
    }
}

if (isMyTurn && (game.phase[game.phase_current] == "Attack" || game.phase[game.phase_current] == "Main")) {

    // Si aucune carte sélectionnée, on sélectionne celle-ci (si c'est un monstre du héros)
    if (selectManager.selected == noone && isHeroOwner && zone == "Field" && type == "Monster") {
        selectManager.trySelect(id);
        return;
    }
    
    // Si une carte est déjà sélectionnée
    if (selectManager.selected != noone) {
        var selectedCard = selectManager.selected;
        
        // Si on clique sur un monstre ennemi sur le terrain
        if (!isHeroOwner && type == "Monster" && zone == "Field") {
            show_debug_message("### Cible sélectionnée pour l'attaque: " + name);
            var payload = {};
            payload.attacker = selectedCard;
            payload.target = id;
            if (instance_exists(selectedCard) && variable_instance_exists(selectedCard, "instance_uid")) {
                payload.attacker_uid = selectedCard.instance_uid;
            }
            if (variable_instance_exists(id, "instance_uid")) {
                payload.target_uid = instance_uid;
            }
            RequestGameAction(ACTION_ATTACK, payload);
            return;
        }
        
        // Si on clique sur son propre monstre => changer sélection (désélectionner la précédente, sélectionner la nouvelle)
        if (isHeroOwner && type == "Monster" && zone == "Field") {
            selectManager.trySelect(id);
            return;
        }
    }
}


// Sinon, comportement par défaut (sélection, désélection, activation magie/piège, etc.)
event_inherited();
