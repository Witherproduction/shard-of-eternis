// === Script d’Invocation Spéciale (sSummonUtils) ===
// Regroupe la recherche du slot libre et l’invocation nommée

/// @function getLeftmostFreeMonsterSlot(ownerIsHero)
/// @description Retourne le slot libre le plus à gauche et ses coordonnées
/// @returns {struct|noone} - { fieldMgr, pos, x, y } ou noone
function getLeftmostFreeMonsterSlot(ownerIsHero) {
    var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
    var monsterField = fieldMgr.getField("Monster");
    var pos = -1;
    for (var i = 0; i < array_length(monsterField.cards); i++) {
        if (monsterField.cards[i] == 0) { pos = i; break; }
    }
    if (pos == -1) return noone;
    var XY = fieldMgr.getPosLocation("Monster", pos);
    return { fieldMgr: fieldMgr, pos: pos, x: XY[0], y: XY[1] };
}

/// @function getRelativeSummonSlot(ownerIsHero, sourceCard, criteria)
/// @description Trouve un slot basé sur la position de l'invocateur et des critères relatifs (Tank/Support)
function getRelativeSummonSlot(ownerIsHero, sourceCard, criteria) {
    if (sourceCard == noone || !instance_exists(sourceCard)) return noone;
    
    // Certains rôles ne nécessitent pas de position source (random, front, back absolus)
    var role = "";
    if (variable_struct_exists(criteria, "relative_role")) {
        role = string_lower(criteria.relative_role);
    } else if (variable_struct_exists(criteria, "role")) {
        role = string_lower(criteria.role);
    }
    
    var rowCrit = variable_struct_exists(criteria, "row") ? string_lower(criteria.row) : "";
    var requiresSourcePos = true;
    
    if (role == "random") requiresSourcePos = false;
    // Front/Back sont absolus s'ils ne dépendent pas de la source (mais ici front/back sont souvent utilisés en relatif, gardons la logique stricte sauf pour random pour l'instant)
    // Pour "front" et "back" définis dans le switch role, ils utilisent srcCol pour la priorité, donc ils ont besoin de fieldPosition.
    // Seul "random" est purement agnostique de la source.
    
    if (requiresSourcePos) {
        if (!variable_instance_exists(sourceCard, "fieldPosition")) return noone;
        var srcPos = sourceCard.fieldPosition;
        if (srcPos == -1) return noone; // Pas sur le terrain
    } else {
        // Dummy values pour éviter crash, non utilisées par random
        var srcPos = -1;
    }
    
    var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
    var monsterField = fieldMgr.getField("Monster");
    
    var srcRow = (srcPos != -1 && srcPos < 4) ? 0 : 1; // 0=Front, 1=Back
    var srcCol = (srcPos != -1) ? srcPos % 4 : 0;
    
    var targetRow = -1;
    var targetCols = [];
    
    // Logique "Smart" basée sur le rôle
    if (role != "") {
        
        if (role == "tank") {
            // Yvan le Costaud
            if (srcRow == 1) { 
                // Si Invocateur est Back -> Tank va Front (Même colonne)
                targetRow = 0;
                array_push(targetCols, srcCol);
            } else { 
                // Si Invocateur est Front -> Tank va à côté (Même ligne)
                targetRow = 0;
                // Priorité aux adjacents
                if (srcCol > 0) array_push(targetCols, srcCol - 1);
                if (srcCol < 3) array_push(targetCols, srcCol + 1);
            }
        } else if (role == "support") {
            // Catherine Fumerol
            if (srcRow == 0) {
                // Si Invocateur est Front -> Support va Back (Même colonne, derrière)
                targetRow = 1;
                array_push(targetCols, srcCol);
            } else {
                // Si Invocateur est Back -> Support va à côté (Même ligne)
                targetRow = 1;
                if (srcCol > 0) array_push(targetCols, srcCol - 1);
                if (srcCol < 3) array_push(targetCols, srcCol + 1);
            }
        } else if (role == "adjacent") {
            // Même ligne, colonnes adjacentes
            targetRow = srcRow;
            if (srcCol > 0) array_push(targetCols, srcCol - 1);
            if (srcCol < 3) array_push(targetCols, srcCol + 1);
        } else if (role == "front") {
            // Ligne Front (0)
            targetRow = 0;
            // Priorité: Même colonne > Adjacents > Autres
            array_push(targetCols, srcCol);
            if (srcCol > 0) array_push(targetCols, srcCol - 1);
            if (srcCol < 3) array_push(targetCols, srcCol + 1);
            for(var i=0; i<4; i++) {
                if (i != srcCol && i != srcCol-1 && i != srcCol+1) array_push(targetCols, i);
            }
        } else if (role == "back") {
            // Ligne Back (1)
            targetRow = 1;
            // Priorité: Même colonne > Adjacents > Autres
            array_push(targetCols, srcCol);
            if (srcCol > 0) array_push(targetCols, srcCol - 1);
            if (srcCol < 3) array_push(targetCols, srcCol + 1);
            for(var i=0; i<4; i++) {
                if (i != srcCol && i != srcCol-1 && i != srcCol+1) array_push(targetCols, i);
            }
        } else if (role == "random") {
            // Choix aléatoire parmi tous les slots libres
            var freeSlots = [];
            for(var i=0; i<8; i++) {
                if (monsterField.cards[i] == 0) array_push(freeSlots, i);
            }
            if (array_length(freeSlots) > 0) {
                var chosenPos = freeSlots[irandom(array_length(freeSlots) - 1)];
                var XY = fieldMgr.getPosLocation("Monster", chosenPos);
                return { fieldMgr: fieldMgr, pos: chosenPos, x: XY[0], y: XY[1] };
            }
            return noone;
        }
    } 
    // Logique manuelle explicite (fallback)
    else {
        // Row
        if (variable_struct_exists(criteria, "row")) {
            var r = string_lower(criteria.row);
            if (r == "front") targetRow = 0;
            else if (r == "back") targetRow = 1;
            else if (r == "same") targetRow = srcRow;
            else if (r == "opposite") targetRow = 1 - srcRow;
        }
        
        // Column
        if (variable_struct_exists(criteria, "column")) {
            var c = string_lower(criteria.column);
            if (c == "same") array_push(targetCols, srcCol);
            else if (c == "left" && srcCol > 0) array_push(targetCols, srcCol - 1);
            else if (c == "right" && srcCol < 3) array_push(targetCols, srcCol + 1);
            else if (c == "adjacent") {
                if (srcCol > 0) array_push(targetCols, srcCol - 1);
                if (srcCol < 3) array_push(targetCols, srcCol + 1);
            }
        }
    }
    
    if (targetRow == -1 || array_length(targetCols) == 0) return noone;
    
    // Chercher le premier slot valide et libre parmi les candidats
    for (var i = 0; i < array_length(targetCols); i++) {
        var tCol = targetCols[i];
        var tPos = targetRow * 4 + tCol;
        
        // Vérifier si libre
        if (tPos >= 0 && tPos < 8 && monsterField.cards[tPos] == 0) {
            var XY = fieldMgr.getPosLocation("Monster", tPos);
            return { fieldMgr: fieldMgr, pos: tPos, x: XY[0], y: XY[1] };
        }
    }
    
    return noone;
}

/// @function specialSummonNamed(card, effect, context)
/// @description Invoque spécialement par nom/objet depuis main/deck/cimetière au slot libre le plus à gauche
/// @returns {bool}
function specialSummonNamed(card, effect, context) {
    var ownerIsHero = variable_struct_exists(card, "isHeroOwner") ? card.isHeroOwner : true;
    
    // Détermination du slot (Standard ou Relatif)
    var slot = noone;
    if (variable_struct_exists(effect, "placement_criteria")) {
        slot = getRelativeSummonSlot(ownerIsHero, card, effect.placement_criteria);
        if (slot == noone) {
            show_debug_message("### specialSummonNamed: Aucun slot valide pour placement relatif");
            return false; // Échec strict si critères demandés mais slot indisponible
        }
    } else {
        slot = getLeftmostFreeMonsterSlot(ownerIsHero);
    }

    if (slot == noone) { show_debug_message("### Effet: Aucun slot libre"); return false; }

    var targetName = variable_struct_exists(effect, "target_name") ? effect.target_name : "";
    var targetObjectName = variable_struct_exists(effect, "target_object") ? effect.target_object : "";
    var objectName = variable_struct_exists(effect, "object_name") ? effect.object_name : "";

    // Debug global supprimé: conserver uniquement les logs liés aux artéfacts

    // Déterminer les sources autorisées (par défaut: Deck > Graveyard > Hand)
    var allowedSources = ["Deck", "Graveyard", "Hand"];
    if (variable_struct_exists(effect, "allowed_sources")) {
        allowedSources = effect.allowed_sources;
    } else if (variable_struct_exists(effect, "from_deck_only") && effect.from_deck_only) {
        allowedSources = ["Deck"];
    }

    // Construire les critères puis chercher via la priorité globale
    var criteria = {};
    if (variable_struct_exists(effect, "criteria")) criteria = effect.criteria;
    if (targetName != "") criteria.name = targetName;
    if (targetObjectName != "") criteria.object_name = targetObjectName;
    if (objectName != "") criteria.object_name = objectName;

    var found = findCard(ownerIsHero, criteria, allowedSources);
    var fieldMgr = slot.fieldMgr;
    var pos = slot.pos;
    var X = slot.x;
    var Y = slot.y;
    var cardToSummon = noone;
    if (found == noone) {
        var objIndex = noone;
        if (objectName != "") {
            var idxO = asset_get_index(objectName);
            if (idxO != -1) objIndex = idxO;
        } else if (targetObjectName != "") {
            var idxT = asset_get_index(targetObjectName);
            if (idxT != -1) objIndex = idxT;
        } else if (targetName != "") {
            var cardsByName = dbGetCardsByName(targetName);
            if (is_array(cardsByName) && array_length(cardsByName) > 0) {
                var cdata = cardsByName[0];
                if (variable_struct_exists(cdata, "objectId")) {
                    var idxDb = asset_get_index(cdata.objectId);
                    if (idxDb != -1) objIndex = idxDb;
                }
            }
            if (objIndex == noone) {
                var idxNm = asset_get_index(targetName);
                if (idxNm != -1) objIndex = idxNm;
            }
        }
        if (objIndex == noone) {
            return false;
        }
        cardToSummon = instance_create_layer(X, Y, layer_get_id("Instances"), objIndex);
        if (cardToSummon != noone) { cardToSummon.isHeroOwner = ownerIsHero; }
    }

    // Si la carte a déjà été créée par fallback ci-dessus, sa pose sur le terrain sera gérée ci-après

    // Selon la source trouvée, retirer et invoquer
    if (found != noone && found.source == "Hand") {
        UIManager.selectedSummonOrSet = "SpecialSummon";
        var summoned = (ownerIsHero ? handHero : handEnemy).summon(found.card, [X, Y, pos]);
        UIManager.selectedSummonOrSet = "";
        cardToSummon = found.card;
    } else if (found != noone && found.source == "Deck") {
        var deck = ownerIsHero ? deckHero : deckEnemy;
        var didx = (found.data != noone && variable_struct_exists(found.data, "index")) ? found.data.index : ds_list_find_index(deck.cards, found.card);
        if (didx != -1) ds_list_delete(deck.cards, didx);
        cardToSummon = found.card;
    } else if (found != noone && found.source == "Graveyard") {
        var graveyard = ownerIsHero ? graveyardHero : graveyardEnemy;
        var objIndex = noone;
        var gdataSummon = found.card;
        if (is_struct(gdataSummon) && variable_struct_exists(gdataSummon, "object_index")) {
            objIndex = gdataSummon.object_index;
            show_debug_message("### specialSummonNamed: graveyard objIndex from struct=" + string(objIndex));
        } else if (!is_struct(gdataSummon) && instance_exists(gdataSummon)) {
            objIndex = gdataSummon.object_index;
            show_debug_message("### specialSummonNamed: graveyard instance object_index=" + string(objIndex));
        } else if (targetObjectName != "") {
            objIndex = asset_get_index(targetObjectName);
            show_debug_message("### specialSummonNamed: graveyard fallback asset targetObject->index=" + string(objIndex));
        } else if (targetName != "") {
            objIndex = asset_get_index(targetName);
        }
        if (objIndex != noone) {
            cardToSummon = instance_create_layer(X, Y, layer_get_id("Instances"), objIndex);
            if (cardToSummon != noone) { cardToSummon.isHeroOwner = ownerIsHero; }
        }
        var gidx = (found.data != noone && variable_struct_exists(found.data, "index")) ? found.data.index : -1;
        if (gidx != -1) { array_delete(graveyard.cards, gidx, 1); }
    }

    if (cardToSummon == noone) return false;

    cardToSummon.fieldPosition = pos;
    fieldMgr.add(cardToSummon);
    
    // --- HEARTHSTONE SUMMONING SICKNESS ---
    if (instance_exists(cardToSummon) && variable_instance_exists(cardToSummon, "type") && cardToSummon.type == "Monster") {
        var hasCharge = variable_instance_exists(cardToSummon, "has_charge") && cardToSummon.has_charge;
        if (hasCharge) {
            cardToSummon.attacksUsedThisTurn = 0;
        } else {
            cardToSummon.attacksUsedThisTurn = 99; 
        }
    }
    // --------------------------------------

    cardToSummon.zone = "Field";
    cardToSummon.depth = 0;
    cardToSummon.visible = false;

    var ghost_idx = 0;
    var ghost_angle = 0;
    var start_x_ss = 220;
    var start_y_ss = room_height * 0.5;
    var fx = instance_create_layer(start_x_ss, start_y_ss, "UI", FX_Invocation);
    if (fx != noone) {
        fx.spriteGhost         = cardToSummon.sprite_index;
        fx.imageGhost          = ghost_idx;
        fx.image_angle         = ghost_angle;
        fx.image_xscale        = 0;
        fx.image_yscale        = 0;
        fx.target_x            = X;
        fx.target_y            = Y;
        fx.field_position      = pos;
        fx.duration_ms         = 1200;
        fx.post_fx_duration_ms = 1000;
        fx.card_real           = cardToSummon;
        fx.owner_is_hero       = ownerIsHero;
        fx.summon_mode         = "SpecialSummon";
        fx.card_type           = (variable_instance_exists(cardToSummon, "type") ? cardToSummon.type : "Monster");
        fx.desired_orientation = "Attack";
        fx.col_main            = make_color_rgb(255, 215, 0);
        fx.trace_thickness     = 2;
        fx.node_radius         = 4;
        if (is_struct(context)) { context.summoned = cardToSummon; }
        return true;
    }
    return false;
}
