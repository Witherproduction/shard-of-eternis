/// === sSearchUtils ===
/// Fonctions de recherche de cartes unifiées avec priorité.

/// @function _cardMatchesCriteria(card, criteria) -> bool
/// @description Vérifie si une carte (instance ou struct) correspond aux critères.
function _cardMatchesCriteria(card, criteria) {
    var card_data = is_struct(card) ? card : (instance_exists(card) ? card : noone);
    if (card_data == noone) return false;

    var isTerrain = false;
    if (is_struct(card_data)) {
        if (variable_struct_exists(card_data, "isTerrain") && card_data.isTerrain) isTerrain = true;
    } else if (instance_exists(card_data)) {
        if (variable_instance_exists(card_data, "isTerrain") && card_data.isTerrain) isTerrain = true;
    }

    if (variable_struct_exists(criteria, "name")) {
        var name_to_check = is_struct(card_data) ? (variable_struct_exists(card_data, "name") ? card_data.name : "") : (variable_instance_exists(card_data, "name") ? card_data.name : "");
        if (name_to_check != criteria.name) return false;
    }
    if (variable_struct_exists(criteria, "name_contains")) {
        var ncheck = is_struct(card_data) ? (variable_struct_exists(card_data, "name") ? card_data.name : "") : (variable_instance_exists(card_data, "name") ? card_data.name : "");
        var nc_l = string_lower(ncheck);
        var want_l = string_lower(criteria.name_contains);
        if (want_l == "" || string_pos(want_l, nc_l) <= 0) return false;
    }
    if (variable_struct_exists(criteria, "archetype")) {
        var archetype_to_check = is_struct(card_data) ? (variable_struct_exists(card_data, "archetype") ? card_data.archetype : "") : (variable_instance_exists(card_data, "archetype") ? card_data.archetype : "");
        if (archetype_to_check != criteria.archetype) return false;
    }
    if (variable_struct_exists(criteria, "object_name")) {
        var object_index_to_check = is_struct(card_data) ? (variable_struct_exists(card_data, "object_index") ? card_data.object_index : noone) : (instance_exists(card_data) ? card_data.object_index : noone);
        if (object_index_to_check == noone || object_get_name(object_index_to_check) != criteria.object_name) return false;
    }
    if (variable_struct_exists(criteria, "is_magic")) {
        var wantMagic = criteria.is_magic;
        if (wantMagic) {
            var obj_idx = is_struct(card_data) ? (variable_struct_exists(card_data, "object_index") ? card_data.object_index : noone) : (instance_exists(card_data) ? card_data.object_index : noone);
            var isMagicAncestor = (obj_idx != noone) && object_is_ancestor(obj_idx, oCardMagic);
            var type_to_check2 = is_struct(card_data)
                ? (variable_struct_exists(card_data, "cardType") ? card_data.cardType : (variable_struct_exists(card_data, "type") ? card_data.type : ""))
                : (variable_instance_exists(card_data, "type") ? card_data.type : "");
            var isMagicType = (string_lower(string(type_to_check2)) == "magic");
            if (!(isMagicAncestor || isMagicType)) return false;
        }
    }
    
    if (variable_struct_exists(criteria, "is_terrain")) {
        var wantTerrain = criteria.is_terrain;
        if (wantTerrain && !isTerrain) return false;
        if (!wantTerrain && isTerrain) return false;
    }

    if (variable_struct_exists(criteria, "type")) {
        var type_to_check = is_struct(card_data)
            ? (variable_struct_exists(card_data, "cardType") ? card_data.cardType : (variable_struct_exists(card_data, "type") ? card_data.type : ""))
            : (variable_instance_exists(card_data, "type") ? card_data.type : "");
        var wantTypeLower = string_lower(string(criteria.type));
        var gotTypeLower = string_lower(string(type_to_check));
        if (wantTypeLower == "monster" && isTerrain && !(variable_struct_exists(criteria, "is_terrain") && criteria.is_terrain)) return false;
        if (gotTypeLower != wantTypeLower) return false;
    }
    if (variable_struct_exists(criteria, "genre")) {
        var genre_to_check = is_struct(card_data)
            ? (variable_struct_exists(card_data, "genre") ? card_data.genre : "")
            : (variable_instance_exists(card_data, "genre") ? card_data.genre : "");
        if (string_lower(genre_to_check) != string_lower(criteria.genre)) return false;
    }
    if (variable_struct_exists(criteria, "race")) {
        var race_to_check = is_struct(card_data)
            ? (variable_struct_exists(card_data, "race") ? card_data.race : "")
            : (variable_instance_exists(card_data, "race") ? card_data.race : "");
        if (string_lower(race_to_check) != string_lower(criteria.race)) return false;
    }

    // Nouveau critère: star_eq (niveau exact)
    if (variable_struct_exists(criteria, "star_eq")) {
        var star_to_check = is_struct(card_data)
            ? (variable_struct_exists(card_data, "mana_cost") ? card_data.mana_cost : -1)
            : (variable_instance_exists(card_data, "mana_cost") ? card_data.mana_cost : -1);
        if (star_to_check != criteria.star_eq) return false;
    }

    // Critère: star_lte (niveau <= X)
    if (variable_struct_exists(criteria, "star_lte")) {
        var star_to_check = is_struct(card_data)
            ? (variable_struct_exists(card_data, "mana_cost") ? card_data.mana_cost : -1)
            : (variable_instance_exists(card_data, "mana_cost") ? card_data.mana_cost : -1);
        if (star_to_check == -1 || star_to_check > criteria.star_lte) return false;
    }

    // Critère: exclude_camouflaged (exclure si camouflé)
    if (variable_struct_exists(criteria, "exclude_camouflaged") && criteria.exclude_camouflaged) {
        var isCamou = false;
        if (is_struct(card_data)) {
            if (variable_struct_exists(card_data, "isCamouflage") && card_data.isCamouflage) isCamou = true;
        } else if (instance_exists(card_data)) {
            if (variable_instance_exists(card_data, "isCamouflage") && card_data.isCamouflage) isCamou = true;
        }
        if (isCamou) return false;
    }
    
    if (variable_struct_exists(criteria, "is_injured")) {
        var wantInjured = criteria.is_injured;
        var injured = false;
        
        var has_current_hp = is_struct(card_data) ? variable_struct_exists(card_data, "current_hp") : variable_instance_exists(card_data, "current_hp");
        var has_max_hp = is_struct(card_data) ? variable_struct_exists(card_data, "max_hp") : variable_instance_exists(card_data, "max_hp");
        if (has_current_hp && has_max_hp) {
            var chp = is_struct(card_data) ? card_data.current_hp : card_data.current_hp;
            var mhp = is_struct(card_data) ? card_data.max_hp : card_data.max_hp;
            injured = (chp < mhp);
        } else {
            var has_pv = is_struct(card_data) ? variable_struct_exists(card_data, "PV") : variable_instance_exists(card_data, "PV");
            var has_def = is_struct(card_data) ? variable_struct_exists(card_data, "original_defense") : variable_instance_exists(card_data, "original_defense");
            if (has_pv && has_def) {
                var pv = is_struct(card_data) ? card_data.PV : card_data.PV;
                var def0 = is_struct(card_data) ? card_data.original_defense : card_data.original_defense;
                injured = (pv < def0);
            }
        }
        
        if (wantInjured && !injured) return false;
        if (!wantInjured && injured) return false;
    }

// Ajouter d'autres vérifications de critères ici (type, attribut, etc.)
return true;
}

/// @function _findInDeck(ownerIsHero, criteria) -> { card, index }
function _findInDeck(ownerIsHero, criteria) {
    var deck = ownerIsHero ? deckHero : deckEnemy;
    if (instance_exists(deck) && ds_list_size(deck.cards) > 0) {
        for (var i = 0; i < ds_list_size(deck.cards); i++) {
            var card = ds_list_find_value(deck.cards, i);
            if (instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                return { card: card, index: i };
            }
        }
    }
    return noone;
}

/// @function _findAllInSource(ownerIsHero, source, criteria) -> array
/// @description Trouve toutes les cartes correspondant aux critères dans une source donnée.
function _findAllInSource(ownerIsHero, source, criteria) {
    var matches = [];
    
    switch (source) {
        case "Deck":
            var deck = ownerIsHero ? deckHero : deckEnemy;
            if (instance_exists(deck) && ds_list_size(deck.cards) > 0) {
                for (var i = 0; i < ds_list_size(deck.cards); i++) {
                    var card = ds_list_find_value(deck.cards, i);
                    if (instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                        array_push(matches, { card: card, index: i });
                    }
                }
            }
            break;
            
        case "Graveyard":
            var graveyard = ownerIsHero ? graveyardHero : graveyardEnemy;
            if (instance_exists(graveyard) && variable_instance_exists(graveyard, "cards")) {
                var garr = graveyard.cards;
                for (var i = 0; i < array_length(garr); i++) {
                    var gdata = garr[i];
                    if (gdata != noone && _cardMatchesCriteria(gdata, criteria)) {
                        array_push(matches, { card: gdata, index: i });
                    }
                }
            }
            break;
            
        case "Hand":
            var hand = ownerIsHero ? handHero : handEnemy;
            if (instance_exists(hand) && ds_list_size(hand.cards) > 0) {
                for (var i = 0; i < ds_list_size(hand.cards); i++) {
                    var card = ds_list_find_value(hand.cards, i);
                    if (instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                        array_push(matches, { card: card, index: i });
                    }
                }
            }
            break;
            
        case "Field":
            var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
            if (instance_exists(fieldMgr)) {
                var monsterField = fieldMgr.getField("Monster");
                for (var i = 0; i < array_length(monsterField.cards); i++) {
                    var card = monsterField.cards[i];
                    if (card != 0 && instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                        array_push(matches, { card: card, pos: i, zone_type: "Monster" });
                    }
                }
                
                var magicField = fieldMgr.getField("MagicTrap");
                for (var i = 0; i < array_length(magicField.cards); i++) {
                    var card = magicField.cards[i];
                    if (card != 0 && instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                        array_push(matches, { card: card, pos: i, zone_type: "MagicTrap" });
                    }
                }
            }
            break;
    }
    
    return matches;
}

/// @function _transferSelectedCards(ownerIsHero, selectedData, destination, shuffleAfter, initiatorCard, effect) -> bool
/// @description Transfère les cartes sélectionnées vers leur destination.
function _transferSelectedCards(ownerIsHero, selectedData, destination, shuffleAfter, initiatorCard, effect) {
    var handInst = ownerIsHero ? handHero : handEnemy;
    var deckInst = ownerIsHero ? deckHero : deckEnemy;
    var gyInst = ownerIsHero ? graveyardHero : graveyardEnemy;
    
    // Trier les indices par ordre décroissant pour éviter les problèmes lors de la suppression
    var indicesToRemove = [];
    for (var i = 0; i < array_length(selectedData); i++) {
        var data = selectedData[i];
        if (variable_struct_exists(data.data, "index")) {
            array_push(indicesToRemove, { source: data.source, index: data.data.index });
        }
    }
    
    // Traiter chaque carte sélectionnée
    for (var i = 0; i < array_length(selectedData); i++) {
        var data = selectedData[i];
        var card = data.card;
        var source = data.source;
        
        // Retirer de la source
        switch (source) {
            case "Deck":
                if (instance_exists(deckInst) && variable_struct_exists(data.data, "index")) {
                    ds_list_delete(deckInst.cards, data.data.index);
                }
                break;
                
            case "Graveyard":
                if (instance_exists(gyInst) && variable_struct_exists(data.data, "index")) {
                    array_delete(gyInst.cards, data.data.index, 1);
                    registerTriggerEvent(TRIGGER_LEAVE_GRAVEYARD, card, { owner_is_hero: ownerIsHero });
                }
                break;
                
            case "Hand":
                if (instance_exists(handInst) && variable_struct_exists(data.data, "index")) {
                    ds_list_delete(handInst.cards, data.data.index);
                }
                break;
                
            case "Field":
                var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
                if (instance_exists(fieldMgr) && variable_struct_exists(data.data, "pos") && variable_struct_exists(data.data, "zone_type")) {
                    registerTriggerEvent(TRIGGER_LEAVE_FIELD, card, { owner_is_hero: ownerIsHero });
                    var field = fieldMgr.getField(data.data.zone_type);
                    field.cards[data.data.pos] = 0;
                }
                break;
        }
        
        // Ajouter à la destination
        switch (string_lower(destination)) {
            case "hand":
                if (instance_exists(handInst)) {
                    if (is_struct(card) && source == "Graveyard" && variable_struct_exists(card, "object_index")) {
                        var objIndex = card.object_index;
                        var newInst = instance_create_layer(handInst.x, handInst.y, layer_get_id("Instances"), objIndex);
                        if (newInst != noone) {
                            if (variable_struct_exists(card, "name")) newInst.name = card.name;
                            if (variable_struct_exists(card, "cardType")) newInst.type = card.cardType;
                            if (variable_struct_exists(card, "archetype")) newInst.archetype = card.archetype;
                            if (variable_struct_exists(card, "genre")) newInst.genre = card.genre;
                            if (variable_struct_exists(card, "attack")) newInst.attack = card.attack;
                            if (variable_struct_exists(card, "PV")) newInst.PV = card.PV;
                            if (variable_struct_exists(card, "mana_cost")) newInst.mana_cost = card.mana_cost;
                            if (variable_struct_exists(card, "description")) newInst.description = card.description;
                            newInst.isHeroOwner = ownerIsHero;
                            newInst.image_angle = ownerIsHero ? 0 : 180;
                            card = newInst;
                        }
                    }
                    handInst.addCard(card);
                    // Optionnel: ajuster le coût de la carte récupérée (ex: Exhumation rapide)
                    var costDelta = 0;
                    if (variable_struct_exists(effect, "cost_delta")) {
                        costDelta = real(effect.cost_delta);
                    } else if (variable_struct_exists(effect, "cost_increase")) {
                        costDelta = real(effect.cost_increase);
                    }
                    if (costDelta != 0 && instance_exists(card) && variable_instance_exists(card, "mana_cost")) {
                        card.mana_cost = max(0, card.mana_cost + costDelta);
                        if (variable_instance_exists(card, "cost")) card.cost = card.mana_cost;
                    }
                    var ctx = { owner_is_hero: ownerIsHero };
                    if (source == "Deck") ctx.from_deck = deckInst;
                    else if (source == "Graveyard") ctx.from_graveyard = gyInst;
                    if (instance_exists(initiatorCard)) ctx.initiator_card_id = initiatorCard.id;
                    if (variable_struct_exists(effect, "id")) ctx.source_effect_id = effect.id;
                    registerTriggerEvent(TRIGGER_ENTER_HAND, card, ctx);
                    if (variable_instance_exists(card, "zone")) card.zone = "Hand";
                }
                break;
                
            case "deck":
                if (instance_exists(deckInst)) {
                    if (is_struct(card) && source == "Graveyard" && variable_struct_exists(card, "object_index")) {
                        var objIndex2 = card.object_index;
                        var newInst2 = instance_create_layer(deckInst.x, deckInst.y, layer_get_id("Instances"), objIndex2);
                        if (newInst2 != noone) {
                            if (variable_struct_exists(card, "name")) newInst2.name = card.name;
                            if (variable_struct_exists(card, "cardType")) newInst2.type = card.cardType;
                            if (variable_struct_exists(card, "archetype")) newInst2.archetype = card.archetype;
                            if (variable_struct_exists(card, "genre")) newInst2.genre = card.genre;
                            if (variable_struct_exists(card, "attack")) newInst2.attack = card.attack;
                            if (variable_struct_exists(card, "PV")) newInst2.PV = card.PV;
                            if (variable_struct_exists(card, "mana_cost")) newInst2.mana_cost = card.mana_cost;
                            if (variable_struct_exists(card, "description")) newInst2.description = card.description;
                            newInst2.isHeroOwner = ownerIsHero;
                            var idxd2 = ds_list_size(deckInst.cards);
                            newInst2.image_index = 1;
                            newInst2.image_angle = deckInst.image_angle;
                            newInst2.image_xscale = deckInst.image_xscale;
                            newInst2.image_yscale = deckInst.image_yscale;
                            newInst2.x = deckInst.x + (idxd2 / 3);
                            newInst2.y = deckInst.y - (idxd2 / 3);
                            newInst2.depth = -idxd2;
                            if (variable_instance_exists(newInst2, "isFaceDown")) newInst2.isFaceDown = true;
                            card = newInst2;
                        }
                    }
                    var idxd = ds_list_size(deckInst.cards);
                    // Harmoniser l'apparence pour toute carte ajoutée au deck
                    if (instance_exists(card)) {
                        card.image_index = 1;
                        card.image_angle = deckInst.image_angle;
                        card.image_xscale = deckInst.image_xscale;
                        card.image_yscale = deckInst.image_yscale;
                        card.x = deckInst.x + (idxd / 3);
                        card.y = deckInst.y - (idxd / 3);
                        card.depth = -idxd;
                        if (variable_instance_exists(card, "isFaceDown")) card.isFaceDown = true;
                    }
                    ds_list_add(deckInst.cards, card);
                    if (variable_instance_exists(card, "zone")) card.zone = "Deck";

                    // FX: Aura sur la carte magie qui a déclenché l'effet (si fournie)
                    if (instance_exists(initiatorCard)) {
                        // Préparer les paramètres du slide sur la carte initiatrice
                        initiatorCard._fx_slide_sprite     = (instance_exists(card) ? card.sprite_index : sprite_get_sprite_index("Sprite22"));
                        initiatorCard._fx_slide_image      = 1; // dos de la carte
                        initiatorCard._fx_slide_xscale     = (instance_exists(deckInst) ? deckInst.image_xscale : 1);
                        initiatorCard._fx_slide_yscale     = (instance_exists(deckInst) ? deckInst.image_yscale : 1);
                        initiatorCard._fx_slide_angle      = (instance_exists(deckInst) ? deckInst.image_angle : 0);
                        // Origine du slide: position du cimetière
                        initiatorCard._fx_spawn_x          = (instance_exists(gyInst) ? gyInst.x : room_width * 0.5);
                        initiatorCard._fx_spawn_y          = (instance_exists(gyInst) ? gyInst.y : room_height * 0.5);
                        // Destination du slide: position de pile du deck calculée pour la carte
                        initiatorCard._fx_target_x         = card.x;
                        initiatorCard._fx_target_y         = card.y;
                        // Deck à mélanger
                        initiatorCard._fx_deck_inst        = deckInst;
                        initiatorCard._fx_shuffle_after    = shuffleAfter;
                        initiatorCard._fx_slide_duration_ms= 700;

                        // Chainer l'apparition centrale (aura) et le slide 500ms après la fin de l'aura, en conservant self = initiatorCard
                        global.fx_aura_next_on_complete = method(initiatorCard, function() {
                            var framesDelay2 = max(1, round((500 / 1000.0) * game_get_speed(gamespeed_fps)));
                            call_later(framesDelay2, time_source_units_frames, method(self, function() {
                                // Spawn du ghost à la position du cimetière
                                var fx = instance_create_depth((variable_instance_exists(self, "_fx_spawn_x") ? self._fx_spawn_x : room_width*0.5), (variable_instance_exists(self, "_fx_spawn_y") ? self._fx_spawn_y : room_height*0.5), -100000, oFX_Draw);
                                if (fx != noone) {
                                    fx.spriteGhost  = (variable_instance_exists(self, "_fx_slide_sprite") ? self._fx_slide_sprite : sprite_get_sprite_index("Sprite22"));
                                    fx.imageGhost   = (variable_instance_exists(self, "_fx_slide_image") ? self._fx_slide_image : 1);
                                    fx.image_xscale = (variable_instance_exists(self, "_fx_slide_xscale") ? self._fx_slide_xscale : 1);
                                    fx.image_yscale = (variable_instance_exists(self, "_fx_slide_yscale") ? self._fx_slide_yscale : 1);
                                    fx.image_angle  = (variable_instance_exists(self, "_fx_slide_angle") ? self._fx_slide_angle : 0);
                                    fx.target_x     = (variable_instance_exists(self, "_fx_target_x") ? self._fx_target_x : room_width * 0.5);
                                    fx.target_y     = (variable_instance_exists(self, "_fx_target_y") ? self._fx_target_y : room_height * 0.5);
                                    fx.duration_ms  = (variable_instance_exists(self, "_fx_slide_duration_ms") ? self._fx_slide_duration_ms : 700);
                                    fx.depth_override = -100000;
                                    // Flip avant glissade
                                    fx.flip_before_move = true;
                                    fx.flip_to_back = true;
                                    fx.flip_duration_ms = 300;
                                    // Mélange du deck après animation si demandé
                                    fx.shuffle_after = (variable_instance_exists(self, "_fx_shuffle_after") ? self._fx_shuffle_after : false);
                                    fx.deck_to_shuffle = (variable_instance_exists(self, "_fx_deck_inst") ? self._fx_deck_inst : noone);
                                }
    // Nettoyer les paramètres
    if (variable_instance_exists(self, "_fx_slide_sprite"))      self._fx_slide_sprite = undefined;
    if (variable_instance_exists(self, "_fx_slide_image"))       self._fx_slide_image = undefined;
    if (variable_instance_exists(self, "_fx_slide_xscale"))      self._fx_slide_xscale = undefined;
    if (variable_instance_exists(self, "_fx_slide_yscale"))      self._fx_slide_yscale = undefined;
    if (variable_instance_exists(self, "_fx_slide_angle"))       self._fx_slide_angle = undefined;
    if (variable_instance_exists(self, "_fx_spawn_x"))           self._fx_spawn_x = undefined;
    if (variable_instance_exists(self, "_fx_spawn_y"))           self._fx_spawn_y = undefined;
                                if (variable_instance_exists(self, "_fx_target_x"))          self._fx_target_x = undefined;
                                if (variable_instance_exists(self, "_fx_target_y"))          self._fx_target_y = undefined;
                                if (variable_instance_exists(self, "_fx_deck_inst"))         self._fx_deck_inst = undefined;
                                if (variable_instance_exists(self, "_fx_slide_duration_ms")) self._fx_slide_duration_ms = undefined;
                            }));
                        });
                        requestFXAura(
                            initiatorCard.sprite_index,
                            (variable_instance_exists(initiatorCard, "image_index") ? initiatorCard.image_index : 0),
                            initiatorCard.image_xscale,
                            initiatorCard.image_yscale,
                            initiatorCard.image_angle,
                            600,
                            18,
                            10,
                            1.50,
                            0.80,
                            initiatorCard.x,
                            initiatorCard.y
                        );
                    }
                }
                break;
                
            case "graveyard":
                if (instance_exists(gyInst)) {
                    if (source == "Deck" && instance_exists(card)) {
                        if (variable_global_exists("fx_aura_lock") && global.fx_aura_lock && variable_global_exists("fx_aura_instance") && global.fx_aura_instance != undefined && instance_exists(global.fx_aura_instance)) {
                            var fxInst = global.fx_aura_instance;
                            // Stocker les données nécessaires sur l'instance de l'aura
                            fxInst._discard_card = card;
                            fxInst._discard_gy = gyInst;
                            fxInst._discard_scale = 0.6;
                            fxInst._discard_duration_ms = 1200;
                            fxInst._discard_flame_thickness = 12;
                            // Définir aussi des variables globales de secours
                            global.fx_next_discard_card = card;
                            global.fx_next_discard_gy = gyInst;
                            global.fx_next_discard_scale = 0.6;
                            global.fx_next_discard_duration_ms = 1200;
                            global.fx_next_discard_flame_thickness = 12;
                            // Chaîner proprement une action existante si présente
                            fxInst._prev_action = variable_instance_exists(fxInst, "on_complete_action") ? fxInst.on_complete_action : noone;
                            fxInst.on_complete_action = function() {
                                if (variable_instance_exists(self, "_prev_action") && is_callable(self._prev_action)) { var __p = self._prev_action; self._prev_action = noone; __p(); }
                                var c = (variable_instance_exists(self, "_discard_card") ? self._discard_card : (variable_global_exists("fx_next_discard_card") ? global.fx_next_discard_card : noone));
                                var gy = (variable_instance_exists(self, "_discard_gy") ? self._discard_gy : (variable_global_exists("fx_next_discard_gy") ? global.fx_next_discard_gy : noone));
                                var sc = (variable_instance_exists(self, "_discard_scale") ? self._discard_scale : (variable_global_exists("fx_next_discard_scale") ? global.fx_next_discard_scale : 0.6));
                                var dur= (variable_instance_exists(self, "_discard_duration_ms") ? self._discard_duration_ms : (variable_global_exists("fx_next_discard_duration_ms") ? global.fx_next_discard_duration_ms : 1200));
                                var thk= (variable_instance_exists(self, "_discard_flame_thickness") ? self._discard_flame_thickness : (variable_global_exists("fx_next_discard_flame_thickness") ? global.fx_next_discard_flame_thickness : 12));
                                if (c != noone && instance_exists(c) && gy != noone && instance_exists(gy)) {
                                    var fx2 = instance_create_layer(room_width * 0.5, room_height * 0.5, "UI", oFX_Discard);
                                    if (fx2 != noone) {
                                        fx2.spriteGhost   = c.sprite_index;
                                        fx2.imageGhost    = 0;
                                        fx2.target_x      = gy.x;
                                        fx2.target_y      = gy.y;
                                        fx2.display_at_center = true;
                                        fx2.image_xscale  = sc;
                                        fx2.image_yscale  = sc;
                                        fx2.image_angle   = 0;
                                        fx2.duration_ms   = dur;
                                        fx2.flame_thickness = thk;
                                        fx2.depth_override = -100000;
                                    }
                                    gy.addToGraveyard(c);
                                    if (variable_instance_exists(c, "zone")) c.zone = "Graveyard";
                                    if (instance_exists(c)) instance_destroy(c);
                                }
                                // Nettoyage des globales de secours
                                if (variable_global_exists("fx_next_discard_card")) global.fx_next_discard_card = noone;
                                if (variable_global_exists("fx_next_discard_gy")) global.fx_next_discard_gy = noone;
                            };
                        } else if (variable_global_exists("fx_aura_lock") && global.fx_aura_lock) {
                            // Pas d'instance accessible: fallback via variables globales
                            global.fx_next_discard_card = card;
                            global.fx_next_discard_gy = gyInst;
                            global.fx_next_discard_scale = 0.6;
                            global.fx_next_discard_duration_ms = 1200;
                            global.fx_next_discard_flame_thickness = 12;
                            global.fx_aura_next_on_complete = function() {
                                var c = global.fx_next_discard_card;
                                var gy = global.fx_next_discard_gy;
                                if (c != noone && instance_exists(c) && gy != noone && instance_exists(gy)) {
                                    var fx2 = instance_create_layer(room_width * 0.5, room_height * 0.5, "UI", oFX_Discard);
                                    if (fx2 != noone) {
                                        fx2.spriteGhost   = c.sprite_index;
                                        fx2.imageGhost    = 0;
                                        fx2.target_x      = gy.x;
                                        fx2.target_y      = gy.y;
                                        fx2.display_at_center = true;
                                        fx2.image_xscale  = global.fx_next_discard_scale;
                                        fx2.image_yscale  = global.fx_next_discard_scale;
                                        fx2.image_angle   = 0;
                                        fx2.duration_ms   = global.fx_next_discard_duration_ms;
                                        fx2.flame_thickness = global.fx_next_discard_flame_thickness;
                                        fx2.depth_override = -100000;
                                    }
                                    gy.addToGraveyard(c);
                                    if (variable_instance_exists(c, "zone")) c.zone = "Graveyard";
                                    if (instance_exists(c)) instance_destroy(c);
                                }
                                global.fx_next_discard_card = noone;
                                global.fx_next_discard_gy = noone;
                            };
                        } else {
                            // Pas d'aura active: jouer immédiatement
                            var fx2i = instance_create_layer(room_width * 0.5, room_height * 0.5, "UI", oFX_Discard);
                            if (fx2i != noone) {
                                fx2i.spriteGhost   = card.sprite_index;
                                fx2i.imageGhost    = 0;
                                fx2i.target_x      = gyInst.x;
                                fx2i.target_y      = gyInst.y;
                                fx2i.display_at_center = true;
                                fx2i.image_xscale  = 0.6;
                                fx2i.image_yscale  = 0.6;
                                fx2i.image_angle   = 0;
                                fx2i.duration_ms   = 1200;
                                fx2i.flame_thickness = 12;
                                fx2i.depth_override = -100000;
                            }
                            gyInst.addToGraveyard(card);
                            if (variable_instance_exists(card, "zone")) card.zone = "Graveyard";
                            if (instance_exists(card)) instance_destroy(card);
                        }
                    } else {
                        gyInst.addToGraveyard(card);
                        if (variable_instance_exists(card, "zone")) card.zone = "Graveyard";
                        if (instance_exists(card)) instance_destroy(card);
                    }
                }
                break;
                
            default:
                show_debug_message("### Destination inconnue: " + string(destination));
                return false;
        }
    }
    
    // Mélanger le deck si nécessaire
    if (string_lower(destination) == "deck" && shuffleAfter && instance_exists(deckInst)) {
        if (is_undefined(shuffleDeck)) {
            ds_list_shuffle(deckInst.cards);
        } else {
            shuffleDeck(deckInst);
        }
    }
    
    return true;
}

/// @function applySearchBySpec(card, effect, context) -> bool
/// @description Exécuteur générique de recherche unifiant toutes les zones sources et destinations.
function applySearchBySpec(card, effect, context) {
    if (card == noone || !instance_exists(card)) return false;
    var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    if (variable_struct_exists(context, "owner_is_hero")) ownerIsHero = context.owner_is_hero;
    
    // Paramètres de recherche
    var searchSources = ["Deck"]; // Par défaut: chercher dans le deck
    if (variable_struct_exists(effect, "search_sources")) searchSources = effect.search_sources;
    else if (variable_struct_exists(effect, "source_zone")) searchSources = [effect.source_zone];
    
    var destination = "Hand"; // Par défaut: ajouter à la main
    if (variable_struct_exists(effect, "destination")) destination = effect.destination;
    
    var maxTargets = 1; // Par défaut: une seule carte
    if (variable_struct_exists(effect, "max_targets")) maxTargets = effect.max_targets;
    else if (variable_struct_exists(effect, "value")) maxTargets = effect.value;
    
    var randomSelect = false;
    if (variable_struct_exists(effect, "random_select")) randomSelect = effect.random_select;
    
    var shuffleAfter = false;
    if (variable_struct_exists(effect, "shuffle_deck")) shuffleAfter = effect.shuffle_deck;
    
    // Garde propriétaire: si déclenché à la fin du tour, n'activer que au tour du propriétaire
    if (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_END_TURN) {
        var gm = instance_find(oGame, 0);
        var activeIsHero = true;
        if (gm != noone && variable_instance_exists(gm, "player") && variable_instance_exists(gm, "player_current")) {
            activeIsHero = (gm.player[gm.player_current] == "Hero");
        }
        if ((ownerIsHero && !activeIsHero) || (!ownerIsHero && activeIsHero)) {
            return false;
        }
    }
    
    // Construire les critères de recherche
    var criteria = {};
    if (variable_struct_exists(effect, "search_criteria")) criteria = effect.search_criteria;
    
    // Compatibilité avec l'ancienne API
    if (variable_struct_exists(effect, "search_archetype")) criteria.archetype = effect.search_archetype;
    if (variable_struct_exists(effect, "search_name")) criteria.name = effect.search_name;
    if (variable_struct_exists(effect, "search_type")) criteria.type = effect.search_type;
    if (variable_struct_exists(effect, "search_genre")) criteria.genre = effect.search_genre;
    
    var allMatches = [];
    var allMatchData = [];
    var preferLastGY = (variable_struct_exists(effect, "prefer_last_in_graveyard") && effect.prefer_last_in_graveyard);
    if (preferLastGY && array_length(searchSources) == 1 && searchSources[0] == "Graveyard") {
        var lastMatch = _findInGraveyard(ownerIsHero, criteria);
        if (lastMatch == noone) {
            return false;
        }
        var selectedData = [ { card: lastMatch.card, source: "Graveyard", data: lastMatch } ];
        // Stocker les paramètres sur la carte pour éviter le scope ambigu des closures
        if (instance_exists(card)) {
            card._pending_owner_is_hero = ownerIsHero;
            card._pending_selected_data = selectedData;
            card._pending_destination   = destination;
            card._pending_shuffle_after = shuffleAfter;
            card._pending_effect_struct = effect;
        }
        var framesDelay = max(1, round((500 / 1000.0) * game_get_speed(gamespeed_fps)));
        call_later(framesDelay, time_source_units_frames, method(card, function() {
            if (!instance_exists(self)) { return; }
            var own_local = variable_instance_exists(self, "_pending_owner_is_hero") ? self._pending_owner_is_hero : true;
            var sel_local = variable_instance_exists(self, "_pending_selected_data") ? self._pending_selected_data : [];
            var dst_local = variable_instance_exists(self, "_pending_destination") ? self._pending_destination : "Deck";
            var sh_local  = variable_instance_exists(self, "_pending_shuffle_after") ? self._pending_shuffle_after : false;
            var eff_local = variable_instance_exists(self, "_pending_effect_struct") ? self._pending_effect_struct : {};
            _transferSelectedCards(own_local, sel_local, dst_local, sh_local, self, eff_local);
            // Nettoyer les pendings
            self._pending_owner_is_hero = undefined;
            self._pending_selected_data = undefined;
            self._pending_destination   = undefined;
            self._pending_shuffle_after = undefined;
            self._pending_effect_struct = undefined;
        }));
        return true;
    } else {
        for (var s = 0; s < array_length(searchSources); s++) {
            var source = searchSources[s];
            var matches = _findAllInSource(ownerIsHero, source, criteria);
            for (var m = 0; m < array_length(matches); m++) {
                array_push(allMatches, matches[m].card);
                array_push(allMatchData, { card: matches[m].card, source: source, data: matches[m] });
            }
        }
        if (array_length(allMatches) == 0) {
            show_debug_message("### Aucun résultat pour EFFECT_SEARCH dans les sources: " + string(searchSources));
            return false;
        }
    }
    
    // Respecter la limite de main si destination == Hand
    if (string_lower(destination) == "hand") {
        var cap = (variable_global_exists("MAX_HAND_SIZE") ? global.MAX_HAND_SIZE : 10);
        var handInst = ownerIsHero ? handHero : handEnemy;
        var current = (instance_exists(handInst) ? ds_list_size(handInst.cards) : 0);
        var freeSlots = max(0, cap - current);
        if (freeSlots <= 0) {
            show_debug_message("### applySearchBySpec: main pleine -> recherche annulée");
            return false;
        }
        maxTargets = min(maxTargets, freeSlots);
    }

    // Sélectionner les cartes à transférer
    var numToSelect = min(maxTargets, array_length(allMatches));
    var selectedData = [];
    
    if (randomSelect) {
        // Sélection aléatoire sans remise
        var available = array_create(array_length(allMatchData));
        for (var i = 0; i < array_length(allMatchData); i++) {
            available[i] = allMatchData[i];
        }
        
        for (var sel = 0; sel < numToSelect; sel++) {
            var r = irandom(array_length(available) - 1);
            array_push(selectedData, available[r]);
            array_delete(available, r, 1);
        }
    } else {
        // Sélection séquentielle (premier trouvé)
        for (var sel = 0; sel < numToSelect; sel++) {
            array_push(selectedData, allMatchData[sel]);
        }
    }
    
    // Transférer les cartes sélectionnées
    return _transferSelectedCards(ownerIsHero, selectedData, destination, shuffleAfter, card, effect);
}

function _findInGraveyard(ownerIsHero, criteria) {
    var graveyard = ownerIsHero ? graveyardHero : graveyardEnemy;
    if (instance_exists(graveyard) && variable_instance_exists(graveyard, "cards")) {
        var garr = graveyard.cards;
        for (var i = array_length(garr) - 1; i >= 0; i--) {
            var gdata = garr[i];
            if (gdata != noone && _cardMatchesCriteria(gdata, criteria)) {
                return { card: gdata, index: i };
            }
        }
    }
    return noone;
}

/// @function _findInHand(ownerIsHero, criteria) -> { card, index }
function _findInHand(ownerIsHero, criteria) {
    var hand = ownerIsHero ? handHero : handEnemy;
    if (instance_exists(hand) && ds_list_size(hand.cards) > 0) {
        for (var i = 0; i < ds_list_size(hand.cards); i++) {
            var card = ds_list_find_value(hand.cards, i);
            if (instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
                return { card: card, index: i };
            }
        }
    }
    return noone;
}

/// @function _findInField(ownerIsHero, criteria) -> { card, pos, zone_type }
function _findInField(ownerIsHero, criteria) {
    var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
    if (!instance_exists(fieldMgr)) return noone;

    var monsterField = fieldMgr.getField("Monster");
    for (var i = 0; i < array_length(monsterField.cards); i++) {
        var card = monsterField.cards[i];
        if (card != 0 && instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
            return { card: card, pos: i, zone_type: "Monster" };
        }
    }

    var magicField = fieldMgr.getField("MagicTrap");
    for (var i = 0; i < array_length(magicField.cards); i++) {
        var card = magicField.cards[i];
        if (card != 0 && instance_exists(card) && _cardMatchesCriteria(card, criteria)) {
            return { card: card, pos: i, zone_type: "MagicTrap" };
        }
    }
    return noone;
}

/// @function findCard(ownerIsHero, criteria, allowedSources) -> { card, source, data }
/// @description Recherche une carte avec priorité Deck > Graveyard > Hand > Field.
function findCard(ownerIsHero, criteria, allowedSources) {
    allowedSources = allowedSources ?? ["Deck", "Graveyard", "Hand", "Field"];
    var sourcesToCheck = ["Deck", "Graveyard", "Hand", "Field"];

    for (var i = 0; i < array_length(sourcesToCheck); i++) {
        var source = sourcesToCheck[i];
        
        var sourceAllowed = false;
        for (var j = 0; j < array_length(allowedSources); j++) {
            if (allowedSources[j] == source) {
                sourceAllowed = true;
                break;
            }
        }
        if (!sourceAllowed) continue;

        var found = noone;
        switch (source) {
            case "Deck":      found = _findInDeck(ownerIsHero, criteria); break;
            case "Graveyard": found = _findInGraveyard(ownerIsHero, criteria); break;
            case "Hand":      found = _findInHand(ownerIsHero, criteria); break;
            case "Field":     found = _findInField(ownerIsHero, criteria); break;
        }

        if (found != noone) {
            return { card: found.card, source: source, data: found };
        }
    }
    return noone;
}
                                if (variable_instance_exists(self, "_fx_shuffle_after"))    self._fx_shuffle_after = undefined;

