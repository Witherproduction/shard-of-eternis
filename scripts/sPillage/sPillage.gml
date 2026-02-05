function sPillage(card, effect, context) {
    if (card == noone || !instance_exists(card) || !is_struct(effect)) return false;
    var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    if (variable_struct_exists(context, "owner_is_hero")) ownerIsHero = context.owner_is_hero;
    var op = "steal";
    if (variable_struct_exists(effect, "operation")) op = string_lower(effect.operation); else if (variable_struct_exists(effect, "mode")) op = string_lower(effect.mode);
    if (op == "exchange") {
        var takerHandEx = ownerIsHero ? handHero : handEnemy;
        var victimHandEx = ownerIsHero ? handEnemy : handHero;
        if (!instance_exists(takerHandEx) || !instance_exists(victimHandEx)) return false;
        var nA = ds_list_size(takerHandEx.cards);
        var nB = ds_list_size(victimHandEx.cards);
        if (nA <= 0 || nB <= 0) return false;
        var idxA = irandom(nA - 1);
        var idxB = irandom(nB - 1);
        var cardA = ds_list_find_value(takerHandEx.cards, idxA);
        var cardB = ds_list_find_value(victimHandEx.cards, idxB);
        if (cardA == noone || cardB == noone || !instance_exists(cardA) || !instance_exists(cardB)) return false;
        ds_list_delete(takerHandEx.cards, idxA);
        ds_list_delete(victimHandEx.cards, idxB);
        if (variable_instance_exists(takerHandEx, "updateDisplay")) { takerHandEx.updateDisplay(); }
        if (variable_instance_exists(victimHandEx, "updateDisplay")) { victimHandEx.updateDisplay(); }
        registerTriggerEvent(TRIGGER_LEAVE_HAND, cardA, { owner_is_hero: ownerIsHero });
        registerTriggerEvent(TRIGGER_LEAVE_HAND, cardB, { owner_is_hero: !ownerIsHero });
        if (variable_instance_exists(cardA, "isHeroOwner")) cardA.isHeroOwner = !ownerIsHero;
        if (variable_instance_exists(cardA, "image_angle")) cardA.image_angle = (!ownerIsHero) ? 0 : 180;
        victimHandEx.addCard(cardA);
        registerTriggerEvent(TRIGGER_ENTER_HAND, cardA, { owner_is_hero: !ownerIsHero });
        if (variable_instance_exists(cardA, "zone")) cardA.zone = "Hand";
        if (variable_instance_exists(cardB, "isHeroOwner")) cardB.isHeroOwner = ownerIsHero;
        if (variable_instance_exists(cardB, "image_angle")) cardB.image_angle = ownerIsHero ? 0 : 180;
        takerHandEx.addCard(cardB);
        registerTriggerEvent(TRIGGER_ENTER_HAND, cardB, { owner_is_hero: ownerIsHero });
        if (variable_instance_exists(cardB, "zone")) cardB.zone = "Hand";
        return true;
    }
    var destination = "Hand";
    if (variable_struct_exists(effect, "destination")) destination = effect.destination;
    var sources = ["Hand"];
    if (variable_struct_exists(effect, "source_zones")) sources = effect.source_zones; else if (variable_struct_exists(effect, "source_zone")) sources = [effect.source_zone];
    var maxTargets = 1;
    if (variable_struct_exists(effect, "value")) maxTargets = max(1, effect.value); else if (variable_struct_exists(effect, "count")) maxTargets = max(1, effect.count); else if (variable_struct_exists(effect, "max_targets")) maxTargets = max(1, effect.max_targets);
    var randomSelect = true;
    if (variable_struct_exists(effect, "random_select")) randomSelect = effect.random_select;
    var criteria = {};
    if (variable_struct_exists(effect, "criteria")) criteria = effect.criteria; else {
        if (variable_struct_exists(effect, "filter_type")) criteria.type = effect.filter_type; else if (variable_struct_exists(effect, "type")) criteria.type = effect.type;
        if (variable_struct_exists(effect, "filter_genre")) criteria.genre = effect.filter_genre; else if (variable_struct_exists(effect, "genre")) criteria.genre = effect.genre;
        if (variable_struct_exists(effect, "filter_archetype")) criteria.archetype = effect.filter_archetype; else if (variable_struct_exists(effect, "archetype")) criteria.archetype = effect.archetype;
        if (variable_struct_exists(effect, "filter_name")) criteria.name = effect.filter_name; else if (variable_struct_exists(effect, "name")) criteria.name = effect.name;
        if (variable_struct_exists(effect, "object_name")) criteria.object_name = effect.object_name;
    }
    var victimIsHero = !ownerIsHero;
    var allMatchData = [];
    for (var s = 0; s < array_length(sources); s++) {
        var src = sources[s];
        var matches = _findAllInSource(victimIsHero, src, criteria);
        for (var m = 0; m < array_length(matches); m++) { array_push(allMatchData, { card: matches[m].card, source: src, data: matches[m] }); }
    }
    if (array_length(allMatchData) <= 0) return false;
    if (string_lower(destination) == "hand") {
        var handInst = ownerIsHero ? handHero : handEnemy;
        var cap = (variable_global_exists("MAX_HAND_SIZE") ? global.MAX_HAND_SIZE : 10);
        var current = (instance_exists(handInst) ? ds_list_size(handInst.cards) : 0);
        var freeSlots = max(0, cap - current);
        maxTargets = min(maxTargets, freeSlots);
        if (maxTargets <= 0) return false;
    }
    var selected = [];
    if (randomSelect) {
        var avail = array_create(array_length(allMatchData));
        for (var i = 0; i < array_length(allMatchData); i++) { avail[i] = allMatchData[i]; }
        var nsel = min(maxTargets, array_length(avail));
        for (var k = 0; k < nsel; k++) { var r = irandom(array_length(avail) - 1); array_push(selected, avail[r]); array_delete(avail, r, 1); }
    } else {
        var nsel2 = min(maxTargets, array_length(allMatchData));
        for (var k2 = 0; k2 < nsel2; k2++) { array_push(selected, allMatchData[k2]); }
    }
    var takerHand = ownerIsHero ? handHero : handEnemy;
    var takerDeck = ownerIsHero ? deckHero : deckEnemy;
    var takerGY = ownerIsHero ? graveyardHero : graveyardEnemy;
    var victimHand = victimIsHero ? handHero : handEnemy;
    var victimDeck = victimIsHero ? deckHero : deckEnemy;
    var victimGY = victimIsHero ? graveyardHero : graveyardEnemy;
    var victimFieldMgr = victimIsHero ? fieldManagerHero : fieldManagerEnemy;
    for (var j = 0; j < array_length(selected); j++) {
        var entry = selected[j];
        var srcCard = entry.card;
        var srcZone = string(entry.source);
        if (op == "steal") {
            if (srcZone == "Hand" && instance_exists(victimHand) && variable_struct_exists(entry.data, "index")) {
                ds_list_delete(victimHand.cards, entry.data.index);
                if (variable_instance_exists(victimHand, "updateDisplay")) { victimHand.updateDisplay(); }
                registerTriggerEvent(TRIGGER_LEAVE_HAND, srcCard, { owner_is_hero: victimIsHero });
            } else if (srcZone == "Deck" && instance_exists(victimDeck) && variable_struct_exists(entry.data, "index")) {
                ds_list_delete(victimDeck.cards, entry.data.index);
            } else if (srcZone == "Graveyard" && instance_exists(victimGY) && variable_struct_exists(entry.data, "index")) {
                array_delete(victimGY.cards, entry.data.index, 1);
                registerTriggerEvent(TRIGGER_LEAVE_GRAVEYARD, srcCard, { owner_is_hero: victimIsHero });
            } else if (srcZone == "Field" && instance_exists(victimFieldMgr) && variable_struct_exists(entry.data, "pos") && variable_struct_exists(entry.data, "zone_type")) {
                registerTriggerEvent(TRIGGER_LEAVE_FIELD, srcCard, { owner_is_hero: victimIsHero });
                var f = victimFieldMgr.getField(entry.data.zone_type);
                if (f != noone) { f.cards[entry.data.pos] = 0; }
            }
            if (string_lower(destination) == "hand" && instance_exists(takerHand)) {
                if (variable_instance_exists(srcCard, "isHeroOwner")) srcCard.isHeroOwner = ownerIsHero;
                if (variable_instance_exists(srcCard, "image_angle")) srcCard.image_angle = ownerIsHero ? 0 : 180;
                takerHand.addCard(srcCard);
                registerTriggerEvent(TRIGGER_ENTER_HAND, srcCard, { owner_is_hero: ownerIsHero });
                if (variable_instance_exists(srcCard, "zone")) srcCard.zone = "Hand";
            } else if (string_lower(destination) == "deck" && instance_exists(takerDeck)) {
                ds_list_add(takerDeck.cards, srcCard);
                if (variable_instance_exists(srcCard, "zone")) srcCard.zone = "Deck";
            } else if (string_lower(destination) == "graveyard" && instance_exists(takerGY)) {
                takerGY.addToGraveyard(srcCard);
                if (variable_instance_exists(srcCard, "zone")) srcCard.zone = "Graveyard";
                if (instance_exists(srcCard)) instance_destroy(srcCard);
            }
        } else if (op == "copy") {
            var dstCard = noone;
            if (instance_exists(srcCard) && variable_instance_exists(srcCard, "object_index")) {
                var objIdx = srcCard.object_index;
                if (string_lower(destination) == "hand" && instance_exists(takerHand)) {
                    dstCard = instance_create_layer(takerHand.x, takerHand.y, layer_get_id("Instances"), objIdx);
                    if (dstCard != noone) {
                        if (variable_instance_exists(srcCard, "name")) dstCard.name = srcCard.name;
                        if (variable_instance_exists(srcCard, "type")) dstCard.type = srcCard.type;
                        if (variable_instance_exists(srcCard, "archetype")) dstCard.archetype = srcCard.archetype;
                        if (variable_instance_exists(srcCard, "genre")) dstCard.genre = srcCard.genre;
                        if (variable_instance_exists(srcCard, "attack")) dstCard.attack = srcCard.attack;
                        if (variable_instance_exists(srcCard, "PV")) dstCard.PV = srcCard.PV;
                        if (variable_instance_exists(srcCard, "mana_cost")) dstCard.mana_cost = srcCard.mana_cost;
                        if (variable_instance_exists(srcCard, "description")) dstCard.description = srcCard.description;
                        dstCard.isHeroOwner = ownerIsHero;
                        dstCard.image_angle = ownerIsHero ? 0 : 180;
                        takerHand.addCard(dstCard);
                        registerTriggerEvent(TRIGGER_ENTER_HAND, dstCard, { owner_is_hero: ownerIsHero });
                        if (variable_instance_exists(dstCard, "zone")) dstCard.zone = "Hand";
                    }
                } else if (string_lower(destination) == "deck" && instance_exists(takerDeck)) {
                    dstCard = instance_create_layer(takerDeck.x, takerDeck.y, layer_get_id("Instances"), objIdx);
                    if (dstCard != noone) {
                        if (variable_instance_exists(srcCard, "name")) dstCard.name = srcCard.name;
                        if (variable_instance_exists(srcCard, "type")) dstCard.type = srcCard.type;
                        if (variable_instance_exists(srcCard, "archetype")) dstCard.archetype = srcCard.archetype;
                        if (variable_instance_exists(srcCard, "genre")) dstCard.genre = srcCard.genre;
                        if (variable_instance_exists(srcCard, "attack")) dstCard.attack = srcCard.attack;
                        if (variable_instance_exists(srcCard, "PV")) dstCard.PV = srcCard.PV;
                        if (variable_instance_exists(srcCard, "mana_cost")) dstCard.mana_cost = srcCard.mana_cost;
                        if (variable_instance_exists(srcCard, "description")) dstCard.description = srcCard.description;
                        dstCard.isHeroOwner = ownerIsHero;
                        dstCard.image_index = 1;
                        dstCard.image_angle = (instance_exists(takerDeck) ? takerDeck.image_angle : 0);
                        dstCard.image_xscale = (instance_exists(takerDeck) ? takerDeck.image_xscale : 1);
                        dstCard.image_yscale = (instance_exists(takerDeck) ? takerDeck.image_yscale : 1);
                        var idxd = ds_list_size(takerDeck.cards);
                        dstCard.x = takerDeck.x + (idxd / 3);
                        dstCard.y = takerDeck.y - (idxd / 3);
                        dstCard.depth = -idxd;
                        if (variable_instance_exists(dstCard, "isFaceDown")) dstCard.isFaceDown = true;
                        ds_list_add(takerDeck.cards, dstCard);
                        if (variable_instance_exists(dstCard, "zone")) dstCard.zone = "Deck";
                    }
                } else if (string_lower(destination) == "graveyard" && instance_exists(takerGY)) {
                    dstCard = instance_create_layer(takerGY.x, takerGY.y, layer_get_id("Instances"), objIdx);
                    if (dstCard != noone) {
                        if (variable_instance_exists(srcCard, "name")) dstCard.name = srcCard.name;
                        if (variable_instance_exists(srcCard, "type")) dstCard.type = srcCard.type;
                        if (variable_instance_exists(srcCard, "archetype")) dstCard.archetype = srcCard.archetype;
                        if (variable_instance_exists(srcCard, "genre")) dstCard.genre = srcCard.genre;
                        if (variable_instance_exists(srcCard, "attack")) dstCard.attack = srcCard.attack;
                        if (variable_instance_exists(srcCard, "PV")) dstCard.PV = srcCard.PV;
                        if (variable_instance_exists(srcCard, "mana_cost")) dstCard.mana_cost = srcCard.mana_cost;
                        if (variable_instance_exists(srcCard, "description")) dstCard.description = srcCard.description;
                        dstCard.isHeroOwner = ownerIsHero;
                        takerGY.addToGraveyard(dstCard);
                        if (variable_instance_exists(dstCard, "zone")) dstCard.zone = "Graveyard";
                        if (instance_exists(dstCard)) instance_destroy(dstCard);
                    }
                }
            }
        }
    }
    return true;
}

