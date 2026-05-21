show_debug_message("### oSelectManager.create");

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

selected = noone;
inspected = noone;              // carte affichée dans le viewer (clic droit), indépendante de selected
targetingEffect = false;        // indique si on est en mode ciblage d'effet
targetingEffectId = noone;      // instance de la carte magique ou oEffectManager qui cible
attackMode = false;             // indique si on est en mode attaque (monstre sélectionné, en attente de cible)
targetingArrow = noone;         // instance de la flèche de ciblage

// Nouvel état: effet différé après placement (magies Artéfact)
pendingEffectCard = noone;      // carte dont l’effet a été demandé avant placement
pendingEffect = noone;          // struct d’effet à exécuter après la pose
pendingEffectIndex = -1;        // index de l'effet pour Command Pattern

// Position du bouton "attaque directe" (à ajuster selon ta scène)
attackDirectX = handEnemy.x;
attackDirectY = handEnemy.y;

attackDirectInstance = noone;
// attackButtonInstance géré maintenant par oUIManager

///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

// Initialise la référence à l'instance du bouton oAttackDirectEnemy
initAttackDirectInstance = function() {
    attackDirectInstance = instance_find(oAttackDirectEnemy, 0);
    if (attackDirectInstance == noone) {
        show_debug_message("### WARNING: Aucun instance de oAttackDirectEnemy trouvée !");
    }
}
initAttackDirectInstance();

// Initialise la référence à l'instance du bouton oAttack
// Les boutons d'attaque sont maintenant gérés par UIManager

// Met à jour le viewer gauche (inspection, pas la sélection gameplay)
updateCardViewer = function(card) {
    if (card == noone || !instance_exists(card)) {
        clearInspection();
        return;
    }
    inspected = card;
    var preview = instance_find(oSelectedCardDisplay, 0);
    if (preview != noone) {
        preview.selected = card;
    } else {
        var newPreview = instance_create_layer(150, 250, "Instances", oSelectedCardDisplay);
        newPreview.selected = card;
        newPreview.depth = -100000;
    }
}

clearInspection = function() {
    inspected = noone;
    var preview = instance_find(oSelectedCardDisplay, 0);
    if (preview != noone) {
        preview.selected = noone;
    }
}

// Retourne la carte oCardParent la plus au premier plan sous la souris
findCardUnderMouse = function() {
    var topCard = noone;
    var topDepth = 999999;
    with (oCardParent) {
        if (!visible) continue;
        if (sprite_index == -1) continue;
        var sw = sprite_get_width(sprite_index) * abs(image_xscale);
        var sh = sprite_get_height(sprite_index) * abs(image_yscale);
        if (sw <= 0 || sh <= 0) continue;
        if (mouse_x < x - sw * 0.5 || mouse_x > x + sw * 0.5) continue;
        if (mouse_y < y - sh * 0.5 || mouse_y > y + sh * 0.5) continue;
        if (depth < topDepth) {
            topDepth = depth;
            topCard = id;
        }
    }
    return topCard;
}

// Carte inspectable au clic droit (viewer)
canInspectCard = function(card) {
    if (card == noone || !instance_exists(card)) return false;
    if (room != rDuel) return false;

    var z = string_lower(string(card.zone));
    var onBoard = (z == "hand" || z == "handselected" || z == "field" || z == "fieldselected");
    var isOwner = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);

    if (isOwner) {
        if (onBoard) return true;
        // Mulligan / Pick : cartes encore marquées Deck sur le deck héros
        if (z == "deck" && instance_exists(game) && variable_instance_exists(game, "phase")
            && game.phase[game.phase_current] == "Pick") {
            return true;
        }
        return false;
    }

    if (z == "field" || z == "fieldselected") {
        return !(variable_instance_exists(card, "isFaceDown") && card.isFaceDown);
    }
    if ((z == "hand" || z == "handselected")
        && instance_exists(handEnemy)
        && variable_instance_exists(handEnemy, "reveal_override")
        && handEnemy.reveal_override) {
        return true;
    }
    return false;
}

tryInspect = function(card) {
    if (!canInspectCard(card)) return false;
    if (inspected == card) {
        clearInspection();
        return true;
    }
    updateCardViewer(card);
    return true;
}

// Gestion centralisée du clic droit (une seule carte par clic)
handleRightClickInspection = function() {
    if (room != rDuel) return;
    if (!mouse_check_button_pressed(mb_right)) return;

    if (instance_exists(oPanelOptions)) return;
    if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) return;
    if (variable_global_exists("isGraveyardViewerOpen") && global.isGraveyardViewerOpen) return;
    if (variable_global_exists("isSacrificeSelectorOpen") && global.isSacrificeSelectorOpen) return;
    if (instance_exists(oIndicatorParent) || (instance_exists(oUIManager) && UIManager.selectedSummonOrSet != "")) return;

    if (variable_global_exists("last_ui_click_time") && (current_time - global.last_ui_click_time) < 200) return;
    if (instance_exists(oSummon) && instance_position(mouse_x, mouse_y, oSummon) != noone) return;
    if (instance_exists(oAttack) && instance_position(mouse_x, mouse_y, oAttack) != noone) return;
    if (instance_exists(oEffectButton) && instance_position(mouse_x, mouse_y, oEffectButton) != noone) return;

    var card = findCardUnderMouse();
    if (card == noone) {
        if (inspected != noone) clearInspection();
        return;
    }
    tryInspect(card);
}

// Définit la carte sélectionnée
set = function(card) {
    show_debug_message("### selectManager.set pour carte: " + string(card));
    show_debug_message("### Type de card: " + string(typeof(card)));
    show_debug_message("### Avant set, selected = " + string(selected));
    selected = card;
    show_debug_message("### Après set, selected = " + string(selected));
    // Vérification que la variable a bien été mise à jour
    if (selected == card) {
        show_debug_message("### La variable selected a été correctement mise à jour");
    } else {
        show_debug_message("### ERREUR: La variable selected n'a pas été mise à jour correctement");
    }
}

// Crée la flèche de ciblage
createTargetingArrow = function(card) {
    show_debug_message("### selectManager.createTargetingArrow");
    if (targetingArrow != noone) {
        instance_destroy(targetingArrow);
    }
    targetingArrow = instance_create_layer(0, 0, "Instances", oTargetingArrow);
    targetingArrow.setSourceCard(card);
}

// Détruit la flèche de ciblage
destroyTargetingArrow = function() {
    show_debug_message("### selectManager.destroyTargetingArrow");
    if (targetingArrow != noone && instance_exists(targetingArrow)) {
        instance_destroy(targetingArrow);
        targetingArrow = noone;
    }
}

// Affiche une flèche d'équipement (OBSOLÈTE: Les Artéfacts sont devenus des sorts Directs)
showEquipLinkArrowFor = function(artifactCard) {
    // Fonction désactivée suite à la suppression du genre Artéfact
    return;
}

// Enlève la sélection
remove = function() {
    show_debug_message("### selectManager.remove");
    selected = noone;
    targetingEffect = false;
    targetingEffectId = noone;
    attackMode = false; // Réinitialise le mode attaque
    destroyTargetingArrow(); // Détruit la flèche de ciblage
    // Nettoyer les marqueurs de ciblage pour Floraison
    if (script_exists(clearTargetingMarkers)) {
        clearTargetingMarkers();
    }
}

// Met à jour la visibilité du bouton d'attaque directe
updateDirectAttackButtonVisibility = function() {
    if (attackDirectInstance == noone) return;

    // Par défaut, caché
    attackDirectInstance.image_alpha = 0;

    // Conditions de base
    if (!attackMode || selected == noone || !instance_exists(selected)) {
        // show_debug_message("### updateDirectAttackButtonVisibility: Conditions de base non remplies");
        return;
    }
    
    var card = selected;

    // Vérifier si c'est le tour du joueur
    var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
    var isLocalTurn = false;
    if (isOnline) {
        if (instance_exists(oGame)) {
            isLocalTurn = oGame.is_local_turn;
        }
    } else {
        isLocalTurn = (game.player_current == 0);
    }
    
    if (!isLocalTurn) return;

    // Vérifie s'il existe un défenseur valide (non camouflé) côté ennemi
    var enemyHasMonsters = false;
    var enemyMonsterField = fieldManagerEnemy.getField("Monster");
    for (var i = 0; i < array_length(enemyMonsterField.cards); i++) {
        var em = enemyMonsterField.cards[i];
        if (em != 0 && instance_exists(em)) {
            var isCamo = (variable_instance_exists(em, "isCamouflage") && em.isCamouflage);
            if (!isCamo) { enemyHasMonsters = true; break; }
        }
    }

    // Percée logic for UI: Allow direct attack if card has isPercee or canAttackDirectAlways
    var allowDirect = !enemyHasMonsters;
    if (variable_instance_exists(card, "isPercee") && card.isPercee) allowDirect = true;
    if (variable_instance_exists(card, "canAttackDirectAlways") && card.canAttackDirectAlways) allowDirect = true;

    if (allowDirect) {
        attackDirectInstance.x = attackDirectX;
        attackDirectInstance.y = attackDirectY;
        attackDirectInstance.image_alpha = 0; // bouton transparent (demande utilisateur)
        show_debug_message("### updateDirectAttackButtonVisibility: Bouton actif mais transparent");
    } else {
        show_debug_message("### updateDirectAttackButtonVisibility: Bouton caché (monstres présents et pas de percée)");
    }
}

// Tente de sélectionner une carte
trySelect = function(card) {
    // Blocage global si le menu d'action est ouvert
    // Autoriser le switch direct vers une autre carte même si le menu est ouvert
    // Sinon, conserver le comportement viewer-only
    if (variable_global_exists("isActionMenuOpen") && global.isActionMenuOpen) {
    if (selected != noone && selected != card && instance_exists(selected) && (selected.zone == "HandSelected" || selected.zone == "FieldSelected")) {
            show_debug_message("### Action menu ouvert: switch direct vers nouvelle carte");
            // Désélectionner proprement l'ancienne carte et masquer les UI
            unSelectAll();
            UIManager.hideSummonAndSet();
            // UIManager.hidePositionButton(); // Removed for HS transition
            UIManager.hideEffectButton();
            if (attackDirectInstance != noone) attackDirectInstance.image_alpha = 0;
            UIManager.hideAttackButton();
            attackMode = false;
            destroyTargetingArrow();
            // Continuer vers la sélection normale pour la nouvelle carte (ne pas retourner)
        } else {
            if (card.isHeroOwner && selected == card && (card.zone == "HandSelected" || card.zone == "FieldSelected")) {
                show_debug_message("### Action menu ouvert: carte déjà sélectionnée -> déléguer à tryUnselect");
                return false;
            }
            show_debug_message("### Action menu ouvert: blocage trySelect (clic droit pour inspecter)");
            return false;
        }
    }
    show_debug_message("### selectManager.trySelect pour carte: " + string(card));
    // Si le sélecteur de sacrifice est ouvert, empêcher tout changement de sélection
    if (variable_global_exists("isSacrificeSelectorOpen") && global.isSacrificeSelectorOpen) {
        show_debug_message("### Sélecteur de sacrifice ouvert: blocage du changement de sélection");
        return false;
    }
    
    // === Gestion ciblage effet magique ===
    if(targetingEffect) {
        show_debug_message("### Mode ciblage d'effet actif");
        if(targetingEffectId != noone) {
            // Vérifie que la carte est bien sur le terrain (Field ou FieldSelected)
            if(card.zone == "Field" || card.zone == "FieldSelected") {
                
                // Vérification Camouflage: Impossible de cibler un monstre ennemi camouflé
                if (!card.isHeroOwner && variable_instance_exists(card, "isCamouflage") && card.isCamouflage) {
                    // Exception si l'effet ignore explicitement le camouflage
                    var ignoreCamo = (variable_instance_exists(targetingEffectId, "ignore_camouflage") && targetingEffectId.ignore_camouflage);
                    if (!ignoreCamo) {
                        show_debug_message("### Cible invalide: Monstre ennemi camouflé (Effet)");
                        return false;
                    }
                }

                // Applique l'effet sur la carte ciblée (quel que soit le propriétaire)
                targetingEffectId.onTargetSelected(card);

                // Désactive le mode ciblage après activation
                targetingEffect = false;
                targetingEffectId = noone;

                // Enlève la sélection courante
                remove();
                show_debug_message("### Carte ciblée avec succès pour effet");
                return true;
            } else {
                show_debug_message("### selectManager.trySelect : cible invalide, doit être sur le terrain");
                return false;
            }
        }
    }
    
    // === Sélection normale ===
    show_debug_message("### Vérification conditions de sélection: isHeroOwner=" + string(card.isHeroOwner) + ", joueur actuel=" + game.player[game.player_current] + ", phase=" + game.phase[game.phase_current]);
    
    var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
    var isLocalTurn = false;
    if (isOnline) {
        if (instance_exists(oGame)) {
            isLocalTurn = oGame.is_local_turn;
        }
    } else {
        isLocalTurn = (game.player_current == 0);
    }
    
    // Autoriser la sélection des cartes du héros pour l'affichage du viewer,
    // même si ce n'est pas son tour (les UI ne s'affichent que quand c'est pertinent).
    if(card.isHeroOwner) {
        
        // === Phase MAIN (Hearthstone Style: Invocation et Attaque combinées) ===
    if(game.phase[game.phase_current] == "Main") {
        
        // --- Gestion Attaque (Carte sur le Terrain) ---
        if(card.zone == "Field") {
            show_debug_message("### Phase Main (Attaque), zone=" + card.zone + ", orientation=" + card.orientation);
            // Toujours autoriser la sélection pour afficher le viewer
            unSelectAll();
            select(card);

            // UI d'attaque uniquement si c'est le tour du joueur local et que la carte est un monstre en Attaque
            // Note: En HS, pas de mode défense, donc orientation toujours "Attack" normalement
            if (isLocalTurn && card.type == "Monster" && card.orientation == "Attack") {
                // Affiche le bouton d'attaque via UIManager (sécurisé côté UIManager)
                UIManager.displayAttackButton(card);

                // Mise à jour de la visibilité du bouton d'attaque directe
                updateDirectAttackButtonVisibility();

                // Créer la flèche de ciblage si le mode attaque est activé
                if(attackMode) {
                    createTargetingArrow(card);
                }
            } else {
                // Tour adverse: cacher les UI d'attaque
                if (attackDirectInstance != noone) attackDirectInstance.image_alpha = 0;
                UIManager.hideAttackButton();
                attackMode = false;
                destroyTargetingArrow();
            }

            show_debug_message("### Sélection effectuée en phase Main (Field) (viewer visible)");
            return true;
        }
        
        // --- Gestion Invocation (Carte en Main) ---
        if(card.zone == "Hand") {
            show_debug_message("### Phase Main (Invocation), zone=" + card.zone);
            unSelectAll();
            select(card);
            
            // UI d'invocation uniquement si c'est le tour du joueur local
            if (isLocalTurn) {
                UIManager.displaySummonSetAction(card);
            } else {
                UIManager.hideSummonAndSet();
            }

            if (attackDirectInstance != noone) {
                attackDirectInstance.image_alpha = 0; // cacher bouton en phase summon
            }
            show_debug_message("### Carte de la main sélectionnée (viewer visible) en phase d'invocation");
            return true;
        }

        // --- Fallback (pour autres types de cartes) ---
    }
    }

    // Cartes ennemies visibles : inspection au clic droit uniquement (pas de sélection gameplay)
    if (!card.isHeroOwner && canInspectCard(card)) {
        show_debug_message("### trySelect: carte ennemie ignorée (clic droit pour inspecter)");
        return false;
    }

    // Autoriser à toutes les phases la sélection des cartes face cachée du héros sur le terrain
    // afin d'afficher le bouton d'effet pour retournement/activation
    if(card.isHeroOwner && card.zone == "Field" && card.isFaceDown) {
        show_debug_message("### Sélection d'une carte face cachée du héros (toutes phases)");
        unSelectAll();
        select(card);
        // UIManager.hideSummonAndSet(); // ne pas cacher le bouton effet juste après
        if (attackDirectInstance != noone) attackDirectInstance.image_alpha = 0;
        show_debug_message("### Carte face cachée sélectionnée (bouton effet disponible)");
        return true;
    }

    show_debug_message("### trySelect: aucune condition remplie, sélection ignorée");
    return false;
}

// Sélectionne une carte
select = function(card) {
    show_debug_message("### selectManager.select pour carte: " + string(card));
    set(card);
    if (!instance_exists(card)) return;
    if(card.zone == "Field") {
        card.zone = "FieldSelected";
        card.image_xscale = 0.3;
        card.image_yscale = 0.3;
        card.y -= 10;
        
        var isOnline_sel = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
        var isLocalTurn_sel = false;
        if (isOnline_sel) {
            if (instance_exists(oGame)) {
                isLocalTurn_sel = oGame.is_local_turn;
            }
        } else {
            isLocalTurn_sel = (game.player[game.player_current] == "Hero");
        }
        
        if(card.type == "Monster" && card.isHeroOwner && game.phase[game.phase_current] == "Main" && isLocalTurn_sel) {
            // UIManager.displayPositionButton(card); // Removed for HS transition
            UIManager.displayEffectButton(card);
        }
        // Afficher le bouton effet pour les cartes face cachée du héros (toutes phases)
        if(card.isHeroOwner && card.isFaceDown) {
            UIManager.displayEffectButton(card);
        }
        // NEW: Afficher le bouton effet pour les cartes visibles du héros sur le terrain
        if(card.isHeroOwner && !card.isFaceDown && isLocalTurn_sel) {
            UIManager.displayEffectButton(card);
        }
        // Indicateur visuel: si carte Artéfact équipée, afficher la flèche vers sa cible (OBSOLÈTE)
        /*
        if (card.type == "Magic" && variable_instance_exists(card, "genre") && string_lower(card.genre) == string_lower("Artéfact")) {
            showEquipLinkArrowFor(card);
        } else {
            // Pas un artéfact: s'assurer qu'on n'affiche pas une flèche d'équipement résiduelle
            destroyTargetingArrow();
        }
        */
        destroyTargetingArrow();
    } else if(card.zone == "Hand") {
        card.zone = "HandSelected";
        card.image_xscale = 0.5;
        card.image_yscale = 0.5;
        card.y -= 80;
    }
}

// Tente de désélectionner une carte
tryUnselect = function(card) {
    show_debug_message("### selectManager.tryUnselect");
    if (!instance_exists(card)) return;
    if (card.zone == "HandSelected" || card.zone == "FieldSelected") {
        unSelect(card);
        UIManager.hideSummonAndSet();
        // UIManager.hidePositionButton(); // Removed for HS transition
        UIManager.hideEffectButton();
        UIManager.hideAttackButton();
        if (attackDirectInstance != noone) attackDirectInstance.image_alpha = 0;
        attackMode = false;
        destroyTargetingArrow();
    }
}

// Désélectionne une carte
unSelect = function(card) {
    show_debug_message("### selectManager.unSelect");
    remove();
    if (!instance_exists(card)) return;
        if(card.zone == "FieldSelected") {
        card.zone = "Field";
        card.image_xscale = 0.2475;
        card.image_yscale = 0.2475;
        // UIManager.hidePositionButton(); // Removed for HS transition
        UIManager.hideEffectButton();
        card.y += 10;
    } else if(card.zone == "HandSelected") {
        card.zone = "Hand";
        card.image_xscale = 0.275;
        card.image_yscale = 0.275;
        card.y += 80;
    }
}

// Désélectionne toutes les cartes
unSelectAll = function() {
    show_debug_message("### selectManager.unSelectAll");
    var nbCards = instance_number(oCardParent);
    for(var i = 0; i < nbCards; i++) {
        var c = instance_find(oCardParent, i);
        if (c.zone == "HandSelected" || c.zone == "FieldSelected") {
            unSelect(c);
        }
    }
    selected = noone; // Nettoyer la référence selected
    UIManager.hideSummonAndSet();
    UIManager.hideAttackButton();
    if (attackDirectInstance != noone) attackDirectInstance.image_alpha = 0;
    attackMode = false;
    destroyTargetingArrow();
    // Nettoyer les marqueurs de ciblage pour Floraison
    if (script_exists(clearTargetingMarkers)) {
        clearTargetingMarkers();
    }
}

// Active le mode ciblage d’effet
startTargeting = function(effectInstance) {
    show_debug_message("### selectManager.startTargeting");
    // Important: nettoyer d’abord, puis activer le mode ciblage
    unSelectAll();
    targetingEffect = true;
    targetingEffectId = effectInstance;
    
    // Ajout de la flèche de ciblage pour les effets
    var src = noone;
    
    if (is_struct(effectInstance)) {
        if (variable_struct_exists(effectInstance, "source_card")) {
            src = effectInstance.source_card;
        }
    } else if (instance_exists(effectInstance)) {
        if (variable_instance_exists(effectInstance, "source_card")) {
            src = effectInstance.source_card;
        }
    }
    
    if (src != noone && instance_exists(src)) {
        createTargetingArrow(src);
    }
}

clearInspection();
