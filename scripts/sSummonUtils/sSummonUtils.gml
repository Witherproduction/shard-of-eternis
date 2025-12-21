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

/// @function specialSummonNamed(card, effect, context)
/// @description Invoque spécialement par nom/objet depuis main/deck/cimetière au slot libre le plus à gauche
/// @returns {bool}
function specialSummonNamed(card, effect, context) {
    var ownerIsHero = variable_struct_exists(card, "isHeroOwner") ? card.isHeroOwner : true;
    var slot = getLeftmostFreeMonsterSlot(ownerIsHero);
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
    cardToSummon.zone = "Field";
    cardToSummon.depth = 0;
    cardToSummon.visible = false;

    var ghost_idx = 0;
    var ghost_angle = ownerIsHero ? 0 : 180;
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