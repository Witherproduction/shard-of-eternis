show_debug_message("### oHand.create");

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

cards = ds_list_create();

// Initialisation des managers de terrain
fieldMgrHero = noone;
fieldMgrEnemy = noone;

if (instance_exists(oFieldManagerHero)) fieldMgrHero = instance_find(oFieldManagerHero, 0);
if (instance_exists(oFieldManagerEnemy)) fieldMgrEnemy = instance_find(oFieldManagerEnemy, 0);

show_debug_message("### oHand initialized managers: Hero=" + string(fieldMgrHero) + ", Enemy=" + string(fieldMgrEnemy));

///////////////////////////////////////////////////////////////////////
// Methodes
///////////////////////////////////////////////////////////////////////

#region Function updateDisplay
updateDisplay = function() {
    show_debug_message("### oHand.updateDisplay");
    
    var cardWidth = 122.93;
    var spaceBetweenCards = 20;
    var nbCards = ds_list_size(cards);
    
    if(nbCards <= 5) {
        var contentWidth = nbCards * cardWidth + (nbCards - 1) * spaceBetweenCards;
        var offset = cardWidth / 2 + contentWidth / -2;
    }
    else {
        var posXStart = 613;
        var posXEnd = 1307;
        var contentWidth = posXEnd - posXStart;
        var distanceBetweenCards = contentWidth / (nbCards - 1);
    }
    
    var reveal_now = (variable_instance_exists(self, "reveal_override") && reveal_override);
    for (var i = 0; i < nbCards; i++) {
        var card = ds_list_find_value(cards, i);
        
        // Verifier que la carte est valide
        if (card == noone || !instance_exists(card)) {
            show_debug_message("### oHand.updateDisplay - Error: Invalid card at index " + string(i));
            continue;
        }
        
        card.zone = "Hand";
        card.image_angle = isHeroOwner ? 0 : 180;
        card.image_xscale = 0.275;
        card.image_yscale = 0.275;
        if (isHeroOwner) {
            card.depth = -100 - i;
        } else {
            card.depth = -i;
        }
        if(nbCards <= 5)
            card.x = x + offset + i * cardWidth + i * spaceBetweenCards;
        else {
            card.x = posXStart + distanceBetweenCards * i;
        }
        card.y = y;
        var isAdmin = (variable_global_exists("admin_mode") && global.admin_mode);
        var isOnline = (variable_global_exists("NET_MODE") && global.NET_MODE != "offline");
        var show_face = isHeroOwner || reveal_now || (isAdmin && !isOnline);
        card.image_index = show_face ? 0 : 1;
    }
}
#endregion

#region Function summon
summon = function(card, XYPos, desiredOrientation = "", effectTarget = noone) {
    show_debug_message("### oHand.summon");
	show_debug_message("SummonMode: " + string(UIManager.selectedSummonOrSet));
    show_debug_message("Card type: " + card.type);

    // Résoudre le mode d'invocation même côté IA (UIManager peut être vide)
    var mode_resolved = UIManager.selectedSummonOrSet;
    var isSecret = (!is_undefined(card.genre) && card.genre == "Secret");
    if (is_undefined(mode_resolved) || string(mode_resolved) == "") {
        if (isHeroOwner) {
            // Côté joueur: fallback simple si vide
            if (card.type == "Monster") {
                mode_resolved = (desiredOrientation == "PV") ? "Set" : "Summon";
            } else if (card.type == "Magic") {
                mode_resolved = isSecret ? "Set" : "Summon";
            } else {
                mode_resolved = "Summon";
            }
        } else {
            // Côté IA: déduire le mode d'après le type et desiredOrientation
            if (card.type == "Monster") {
                mode_resolved = (desiredOrientation == "PV") ? "Set" : "Summon";
            } else if (card.type == "Magic") {
                mode_resolved = isSecret ? "Set" : "Summon";
            } else {
                mode_resolved = "Summon";
            }
        }
    }
    show_debug_message("SummonMode (resolved): " + string(mode_resolved));

    // Cible
    var target_x = XYPos[0];
    var target_y = XYPos[1];
    var target_pos = XYPos[2];

    // Vérification du terrain et réservation immédiate du slot pour éviter les empilements
    var fieldMgrSummon = isHeroOwner ? fieldMgrHero : fieldMgrEnemy;
    if (fieldMgrSummon == noone || !instance_exists(fieldMgrSummon)) {
        show_debug_message("### oHand.summon - Erreur: fieldManager introuvable");
        return false;
    }

    // [HEARTHSTONE] Bypass slot check for Spells (Magic cards played without slot)
    var isSpellPlay = (card.type == "Magic" && target_pos == -1);

    // --- FIX: Empêcher l'activation de Secrets en double ---
    var isSecretCheck = (variable_instance_exists(card, "genre") && string_lower(card.genre) == "secret");
    if (isSecretCheck) {
        var secretListCheck = isHeroOwner ? global.activeSecretsHero : global.activeSecretsEnemy;
        if (variable_global_exists("activeSecretsHero") && ds_exists(secretListCheck, ds_type_list)) {
            var sz = ds_list_size(secretListCheck);
            for (var i = 0; i < sz; i++) {
                var existing = ds_list_find_value(secretListCheck, i);
                if (instance_exists(existing) && variable_instance_exists(existing, "name") && existing.name == card.name) {
                    show_debug_message("### oHand.summon - BLOCKED: Secret duplicate found (" + string(card.name) + ")");
                    return false;
                }
            }
        }
    }

    if (!isSpellPlay) {
        var fieldTarget = fieldMgrSummon.getField(card.type);
        if (fieldTarget == noone || !instance_exists(fieldTarget) || !variable_struct_exists(fieldTarget, "cards")) {
            show_debug_message("### oHand.summon - Erreur: champ introuvable pour type=" + string(card.type));
            return false;
        }
        if (target_pos < 0 || target_pos >= array_length(fieldTarget.cards)) {
            show_debug_message("### oHand.summon - Erreur: position cible hors limites: " + string(target_pos));
            return false;
        }
        if (fieldTarget.cards[target_pos] != 0) {
            show_debug_message("### oHand.summon - Slot déjà occupé, annulation de la pose");
            return false;
        }
        // Réserver le slot tout de suite pour bloquer les poses simultanées sur la même case
        card.fieldPosition = target_pos;
        fieldMgrSummon.add(card);
    }

    // Retire la carte de la main du joueur (immédiat pour libérer l'espace visuel)
    var idx = ds_list_find_index(cards, card);
    var removedIndex = -1;
    if (idx != -1) {
        removedIndex = idx;
        ds_list_delete(cards, idx);
    }
    updateDisplay();

    // --- Update Summon Limit (Fix: empêcher invocations multiples) ---
    if (variable_instance_exists(card, "type") && card.type == "Monster" && mode_resolved != "SpecialSummon") {
        var pIdx = isHeroOwner ? 0 : 1;
        if (instance_exists(oGame)) {
            oGame.hasSummonedThisTurn[pIdx] = true;
        }
    }

    card.zone = "Field";
    if (instance_exists(selectManager) && selectManager.selected == card) {
        var shouldKeepSelection = (selectManager.pendingEffect != noone) && (selectManager.pendingEffectCard != noone) && (selectManager.pendingEffectCard == card);
        if (!shouldKeepSelection) {
            selectManager.remove();
        }
    }

    // Cache la carte réelle pendant l'animation
    card.visible = false;

    // Déterminer l'orientation/face du fantôme selon le mode et le camp
    var ghost_angle = 0;
    var ghost_index = card.image_index;
        if (isHeroOwner) {
        if (card.type == "Monster" && mode_resolved == "Set") {
            ghost_angle = 90;
            ghost_index = 1; // face cachée
        }
        else if (card.type == "Monster" && (mode_resolved == "Summon" || mode_resolved == "SpecialSummon")) {
            ghost_angle = 0;
            ghost_index = 0; // face visible
        }
        else if (card.type == "Magic" && mode_resolved == "Set") {
            ghost_angle = 0;
            ghost_index = 1; // face cachée
        }
        else if (card.type == "Magic" && mode_resolved == "Summon") {
            ghost_angle = 0;
            ghost_index = 0; // face visible
        }
    } else {
        if (desiredOrientation == "PV" || (card.type == "Monster" && mode_resolved == "Set")) {
            ghost_angle = 90;
            ghost_index = 1; // face cachée
        } else if (card.type == "Magic" && isSecret && mode_resolved == "Set") {
            // Secret ennemi posé face cachée
            ghost_angle = 0;
            ghost_index = 1; // face cachée
        } else {
            ghost_angle = 0;
            ghost_index = 0; // face visible
        }
    }

    // [HEARTHSTONE] Handle Spell Play (Immediate resolution, no field placement)
    if (isSpellPlay) {
        // --- FIX UI: Cacher les boutons Summon/Set immédiatement ---
        if (variable_instance_exists(self, "UIManager") && instance_exists(UIManager)) {
            UIManager.hideSummonAndSet();
        } else if (instance_exists(oUIManager)) {
            oUIManager.hideSummonAndSet();
        }
        
        // --- SECRET HANDLING (Hearthstone Style) ---
        var isSecret = (variable_instance_exists(card, "genre") && string_lower(card.genre) == "secret");
        if (isSecret) {
             card.visible = false;
             card.zone = "Secret";
             
             // Add to Active Secrets List
             var secretList = isHeroOwner ? global.activeSecretsHero : global.activeSecretsEnemy;
             if (ds_list_find_index(secretList, card) == -1) {
                 ds_list_add(secretList, card);
             }
             
             // Secrets are NOT sent to graveyard yet. They stay in "Secret" zone.
             // Triggers will check this list.
             
             // Trigger ON_SUMMON (for other cards reacting to spell cast)
             var ctxSummon = { summon_mode: mode_resolved, owner_is_hero: isHeroOwner, target: effectTarget };
             registerTriggerEvent(TRIGGER_ON_SUMMON, card, ctxSummon);
             
             // Quest Notification (Secret)
             if (isHeroOwner && instance_exists(oQuestManager)) {
                 oQuestManager.notify_event("play_card", 1, { card: card });
             }

             return true;
        }
        
        // --- FIX EFFECT: Exécuter l'effet principal de la carte Magie ---
        // Les cartes magiques "Sort" doivent exécuter leurs effets immédiatement.
        var executed = false;
        var targetingStarted = false;

        if (variable_instance_exists(card, "effects") && is_array(card.effects)) {
            for (var i = 0; i < array_length(card.effects); i++) {
                var eff = card.effects[i];
                var trig = variable_struct_exists(eff, "trigger") ? eff.trigger : "";
                
                // Exécuter si pas de trigger spécifique (défaut) OU si trigger d'activation standard
                // On exclut les triggers de mort/cimetière/tour
                var isActivationEffect = (trig == "" || trig == "main_phase" || trig == "on_spell_cast" || trig == "on_summon");
                
                if (isActivationEffect) {
                     var res = executeEffect(card, eff, { target: effectTarget, owner_is_hero: isHeroOwner });
                     
                     // Check if targeting started
                     if (instance_exists(oSelectManager) && oSelectManager.targetingEffect) {
                         targetingStarted = true;
                         executed = true; // Handled
                         break;
                     }
                     
                     if (res) executed = true;
                }
            }
        } 
        
        if (!executed && !targetingStarted && variable_instance_exists(card, "effect")) {
             // Cas simple: un seul effet (fallback)
             var res = executeEffect(card, card.effect, { target: effectTarget, owner_is_hero: isHeroOwner });
             if (instance_exists(oSelectManager) && oSelectManager.targetingEffect) {
                 targetingStarted = true;
             }
             if (res) executed = true;
        }
        
        if (targetingStarted) {
            show_debug_message("### oHand.summon: Targeting started for " + string(card.name) + " -> Pausing graveyard logic.");
            card.visible = true; // Keep visible for targeting
            card.zone = "Hand"; // Keep as Hand temporarily
            
            // Re-add to hand list temporarily so it doesn't disappear from UI if updateDisplay called?
            // Actually, if we return true, the card is "played" but waiting.
            // If we want it to stay in hand VISUALLY, we might need to re-add it?
            // "card.visible = true" makes the instance visible.
            // But if it's not in "cards" list, updateDisplay won't position it.
            // So it might sit at its current position (where user dropped it?).
            // For targeting, usually we want to see the card.
            // Let's re-add it to the list so updateDisplay manages it.
            if (removedIndex != -1) {
                 ds_list_insert(cards, removedIndex, card);
            } else {
                 ds_list_add(cards, card);
            }
            updateDisplay();
            
            return true;
        }

        if (!executed) {
             show_debug_message("### oHand.summon: Effect execution failed (Condition not met) -> Cancel Play & Refund");
             
             // Restore Card to Hand
             if (removedIndex != -1) {
                 ds_list_insert(cards, removedIndex, card);
             } else {
                 ds_list_add(cards, card);
             }
             updateDisplay();
             
             card.visible = true;
             card.zone = "Hand";
             
             // Refund Mana
             var cost = variable_instance_exists(card, "mana_cost") ? card.mana_cost : 0;
             if (isHeroOwner) {
                 global.mana_hero += cost;
             } else {
                 global.mana_enemy += cost;
             }
             
             return false;
        }
        
        card.visible = false;
        card.zone = "Graveyard";
        
        // Trigger Effect (Execute Spell) - Pour les réactions d'autres cartes
        var ctxSummon = { summon_mode: mode_resolved, owner_is_hero: isHeroOwner, target: effectTarget };
        registerTriggerEvent(TRIGGER_ON_SUMMON, card, ctxSummon);
        
        // Send to Graveyard via consumeSpellIfNeeded (handles Tempo flows correctly)
        if (script_exists(asset_get_index("consumeSpellIfNeeded"))) {
             consumeSpellIfNeeded(card, undefined);
        } else {
             var grave = isHeroOwner ? global.graveyardHero : global.graveyardEnemy;
             if (grave != noone && instance_exists(grave)) {
                 grave.addToGraveyard(card);
             }
             if (instance_exists(card)) instance_destroy(card);
        }
        
        // Quest Notification (Spell)
        if (isHeroOwner && instance_exists(oQuestManager)) {
             oQuestManager.notify_event("play_card", 1, { card: card });
        }

        return true;
    }

    // Crée l'effet d'invocation (glissade vers le terrain) sur le layer UI
    var start_x_ss = card.x;
    var start_y_ss = card.y;
    if (mode_resolved == "SpecialSummon") {
        start_x_ss = 220;
        start_y_ss = room_height * 0.5;
    }
    var fx = instance_create_layer(start_x_ss, start_y_ss, "UI", FX_Invocation);
    if (fx != noone) {
        fx.spriteGhost         = card.sprite_index;
        fx.imageGhost          = ghost_index;
        fx.image_angle         = ghost_angle;
        fx.image_xscale        = (mode_resolved == "SpecialSummon") ? 0 : card.image_xscale;
        fx.image_yscale        = (mode_resolved == "SpecialSummon") ? 0 : card.image_yscale;
        fx.target_x            = target_x;
        fx.target_y            = target_y;
        fx.field_position      = target_pos;
        fx.duration_ms         = 200;   // 0,2s de déplacement
        fx.post_fx_duration_ms = 1000;   // post-effet (~1,0s)
        fx.card_real           = card;
        fx.owner_is_hero       = isHeroOwner;
        fx.summon_mode         = mode_resolved;
        fx.card_type           = card.type;
        fx.desired_orientation = desiredOrientation;
        fx.effect_target       = effectTarget;
        // Surcharges d'apparence (doré brillant + lignes plus fines + nœuds réduits)
         fx.col_main            = make_color_rgb(255, 215, 0);
         fx.trace_thickness     = 2;
         fx.node_radius         = 4;
        // Démarrage réussi: retourner true immédiatement
        return true;
    } else {
        // Fallback en cas d'échec de création de l'effet: placement instantané
        card.x = target_x;
        card.y = target_y;
        // Le slot a déjà été réservé ci-dessus; réaffectation prudente
        card.fieldPosition = target_pos;
        fieldMgrSummon.add(card);

        // Mise à l'échelle/zone (réduction uniforme sur le terrain)
        card.image_xscale = 0.2475;
        card.image_yscale = 0.2475;
        card.zone = "Field";
        card.depth = ((variable_instance_exists(card, "type") && string(card.type) == "Monster") ? -1 : 0);

        // Orientation/face selon camp et mode
        if (isHeroOwner) {
            if (card.type == "Monster" && mode_resolved == "Set") {
                card.orientation = "PV";
                card.image_angle = 90;
                card.image_index = 1;
                card.isFaceDown = true;
            }
            else if (card.type == "Monster" && (mode_resolved == "Summon" || mode_resolved == "SpecialSummon")) {
                card.orientation = "Attack";
                card.image_angle = 0;
                card.image_index = 0;
                card.isFaceDown = false;
            }
            else if (card.type == "Magic" && mode_resolved == "Set") {
                card.orientation = "Attack";
                card.image_angle = 0;
                card.image_index = 1;
                card.isFaceDown = true;
            }
            else if (card.type == "Magic" && mode_resolved == "Summon") {
                card.orientation = "Attack";
                card.image_angle = 0;
                card.image_index = 0;
                card.isFaceDown = false;
            }
        } else {
            if (desiredOrientation == "PV" || (card.type == "Monster" && mode_resolved == "Set")) {
                card.orientation = "PV";
                card.image_angle = 90;
                card.image_index = 1;
                card.isFaceDown = true;
            } else if (card.type == "Magic" && isSecret && mode_resolved == "Set") {
                // Secret ennemi posé face cachée
                card.orientation = "Attack";
                card.image_angle = 0;
                card.image_index = 1;
                card.isFaceDown = true;
            } else {
                card.orientation = "Attack";
                card.image_angle = 0;
                card.image_index = 0;
                card.isFaceDown = false;
            }
        }

        card.visible = true;

        // Verrou: un monstre invoqué ne peut pas changer de position ce tour
        if (card.type == "Monster") {
            card.orientationChangedThisTurn = true;
            // Émettre l’événement d’invocation de monstre en fallback sans FX
            var ctxSummon = { summon_mode: mode_resolved, owner_is_hero: isHeroOwner, target: effectTarget };
            if (mode_resolved == "Summon" || mode_resolved == "SpecialSummon") {
                registerTriggerEvent(TRIGGER_ON_SUMMON, card, ctxSummon);
                registerTriggerEvent(TRIGGER_ON_MONSTER_SUMMON, card, ctxSummon);
            }
        }
        
        // Quest Notification (Fallback)
        if (isHeroOwner && instance_exists(oQuestManager)) {
             oQuestManager.notify_event("play_card", 1, { card: card });
             if (card.type == "Monster") {
                 oQuestManager.notify_event("summon", 1, { card: card });
             }
        }

        // Fallback réussi: retourner true
        return true;
    }
    // Si on atteint ce point, considérer l'opération comme réussie
    return true;
}
#endregion

#region Function addCard
addCard = function(card, suppress_update) {
    show_debug_message("### oHand.addCard");
    
    if (is_undefined(suppress_update)) suppress_update = false;

    // Verifier que la carte est valide
    if (card == noone || !instance_exists(card)) {
        show_debug_message("### oHand.addCard - Error: Invalid card instance");
        return;
    }
    
    ds_list_add(cards, card);
    if (!suppress_update) {
        updateDisplay();
    }	
}
#endregion

#region Function chooseCardIA
chooseCardIA = function() {
    show_debug_message("### oHand.chooseCardIA");
    
    ds_list_shuffle(cards);
    
    for(var i = 0; i < ds_list_size(cards); i++) {
        var item = ds_list_find_value(cards, i);
        if(item.type == "Monster")
            return item;
    }
    return noone;
}
#endregion

