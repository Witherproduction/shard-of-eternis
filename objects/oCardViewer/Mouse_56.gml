// === oCardViewer - Mouse Left Pressed Event ===

// Bloquer toute interaction si le panneau d'options est ouvert
if (instance_exists(oPanelOptions)) {
    exit;
}

// Room check
if (room != rCollection) {
    exit;
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// --- Gestion du menu déroulant booster ---
{
    var drop_x = dropdown_x;
    var drop_y = dropdown_y;
    var drop_w = dropdown_w;
    var drop_h = dropdown_h;

    var clickInDropdown = (mx >= drop_x && mx <= drop_x + drop_w && my >= drop_y && my <= drop_y + drop_h);

    if (clickInDropdown) {
        dropdown_open = !dropdown_open;
        if (dropdown_open == false) {
            // Fermeture sans changement
        }
        exit; // la zone du dropdown capture le clic
    }

    if (dropdown_open) {
        var item_h = drop_h;
        var list_y1 = drop_y + drop_h + 2;
        var list_y2 = list_y1 + array_length(dropdown_items) * item_h;
        var list_x1 = drop_x;
        var list_x2 = drop_x + drop_w;

        if (mx >= list_x1 && mx <= list_x2 && my >= list_y1 && my <= list_y2) {
            var index = floor((my - list_y1) / item_h);
            index = clamp(index, 0, array_length(dropdown_items) - 1);
            dropdown_selected_index = index;
            dropdown_open = false;

            var selected_text = dropdown_items[index];
            // Assigner directement le texte sélectionné comme filtre
            global.collection_booster_filter = selected_text;

            if (array_length(allCards) > 0) {
                applyBoosterFilterNow();
                // garder le tri courant (ou par défaut alpha)
                if (!variable_global_exists("sort_mode") || global.sort_mode == "none") {
                    global.sort_mode = "alpha";
                    global.sort_descending = false;
                }
                sortCards(global.sort_mode);
            }
            exit; // le clic était dans la liste
        }
    }
}

// --- Pagination: flèches gauche/droite centrées sous la grille ---
{
    var btn_w = 28;
    var btn_h = dropdown_h;
    var grid_center_x = startX + ((cardsPerRow - 1) * cardSpacing) / 2;
    var gui_h = display_get_gui_height();
    var last_row_y = startY + (maxRows - 1) * cardSpacingVertical;
    var page_y = min(last_row_y + cardSpacingVertical - 20, gui_h - btn_h - 20);
    var left_x1 = grid_center_x - 100 - btn_w;
    var left_y1 = page_y;
    var left_x2 = left_x1 + btn_w;
    var left_y2 = left_y1 + btn_h;
    var right_x1 = grid_center_x + 100;
    var right_y1 = page_y;
    var right_x2 = right_x1 + btn_w;
    var right_y2 = right_y1 + btn_h;

    // Clic gauche
    if (mx >= left_x1 && mx <= left_x2 && my >= left_y1 && my <= left_y2) {
        if (currentPage > 1) {
            currentPage -= 1;
            displayFilteredCards();
        }
        exit;
    }
    // Clic droit
    if (mx >= right_x1 && mx <= right_x2 && my >= right_y1 && my <= right_y2) {
        if (currentPage < totalPages) {
            currentPage += 1;
            displayFilteredCards();
        }
        exit;
    }
}

// --- Bouton Invocation ---
{
    var drop_x = dropdown_x;
    var drop_y = dropdown_y;
    var drop_w = dropdown_w;
    var drop_h = dropdown_h;
    var inv_label = "Invocation";
    var inv_pad = 18;
    draw_set_font(fontCardDisplay);
    var inv_w = max(220, string_width(inv_label) + inv_pad * 2);
    var inv_h = drop_h;
    var gui_w = display_get_gui_width();
    var inv_x1 = (gui_w * 0.5) - (inv_w * 0.5);
    var inv_y1 = drop_y;
    if (instance_exists(oRetour1)) {
        var ret = instance_find(oRetour1, 0);
        if (ret != noone && instance_exists(ret)) {
            inv_y1 = ret.y - inv_h * 0.5;
        }
    }
    var inv_x2 = inv_x1 + inv_w;
    var inv_y2 = inv_y1 + inv_h;
    if (mx >= inv_x1 && mx <= inv_x2 && my >= inv_y1 && my <= inv_y2) {
        global.collection_invocation_mode = !global.collection_invocation_mode;
        allCards = dbGetAllCards();
        allCards = filterOutTokens(allCards);
        allCards = global.collection_invocation_mode ? filterInvocationCandidates(allCards) : filterOutLocked(allCards);
        rebuildDropdown();
        global.collection_booster_filter = "Tout";
        applyBoosterFilterNow();
        if (!variable_global_exists("sort_mode") || global.sort_mode == "none") {
            global.sort_mode = "alpha";
            global.sort_descending = false;
        }
        sortCards(global.sort_mode);
        displayFilteredCards();
        exit;
    }
}

// --- Clic sur le bouton "Convoquer" de la carte sélectionnée ---
if (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode) {
    if (instance_exists(oCollectionCardDisplay) && oCollectionCardDisplay.selectedCard != noone && instance_exists(oCollectionCardDisplay.selectedCard)) {
        var display_x = oCollectionCardDisplay.x;
        var display_y = oCollectionCardDisplay.y;
        var display_scale = 0.6;
        var card_width = sprite_get_width(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;
        var card_height = sprite_get_height(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;
        var btn_w = 260;
        var btn_h = 44;
        var btn_x = display_x;
        var btn_y = display_y + card_height * 0.5 + 50;
        var bx1 = btn_x - btn_w * 0.5;
        var by1 = btn_y - btn_h * 0.5;
        var bx2 = btn_x + btn_w * 0.5;
        var by2 = btn_y + btn_h * 0.5;
        var mxw = mouse_x;
        var myw = mouse_y;
        if (mxw >= bx1 && mxw <= bx2 && myw >= by1 && myw <= by2) {
            // Animation Trigger
            if (variable_instance_exists(id, "summonAnimState")) {
                summonAnimState = 1; // Start Zoom In
                summonAnimTimer = summonAnimDurationIn;
                
                // Capture info of the summoned card
                if (instance_exists(oCollectionCardDisplay) && instance_exists(oCollectionCardDisplay.selectedCard)) {
                     var _c = oCollectionCardDisplay.selectedCard;
                     summonAnimCard = {
                        sprite: _c.sprite_index,
                        image: _c.image_index,
                        name: variable_instance_exists(_c, "name") ? _c.name : ""
                     };
                }
            }

            var cost_rar = "commun";
            if (variable_instance_exists(oCollectionCardDisplay.selectedCard, "rarity")) {
                cost_rar = string_lower(string(oCollectionCardDisplay.selectedCard.rarity));
            }
            var cost = 8;
            if (cost_rar == "rare") cost = 20;
            else if (cost_rar == "epique") cost = 80;
            else if (cost_rar == "legendaire") cost = 320;
            var cid_val = "";
            if (variable_instance_exists(oCollectionCardDisplay.selectedCard, "card_id") && string(oCollectionCardDisplay.selectedCard.card_id) != "") {
                cid_val = string(oCollectionCardDisplay.selectedCard.card_id);
            } else if (variable_instance_exists(oCollectionCardDisplay.selectedCard, "name")) {
                var normalize = function(s) {
                    var r = string_lower(string(s));
                    r = string_replace_all(r, "à", "a"); r = string_replace_all(r, "â", "a"); r = string_replace_all(r, "ä", "a");
                    r = string_replace_all(r, "é", "e"); r = string_replace_all(r, "è", "e"); r = string_replace_all(r, "ê", "e"); r = string_replace_all(r, "ë", "e");
                    r = string_replace_all(r, "î", "i"); r = string_replace_all(r, "ï", "i");
                    r = string_replace_all(r, "ô", "o"); r = string_replace_all(r, "ö", "o");
                    r = string_replace_all(r, "ù", "u"); r = string_replace_all(r, "û", "u"); r = string_replace_all(r, "ü", "u");
                    r = string_replace_all(r, "ç", "c");
                    return r;
                };
                var nm = normalize(oCollectionCardDisplay.selectedCard.name);
                var matches = dbGetCardsByName(oCollectionCardDisplay.selectedCard.name);
                for (var mi = 0; mi < array_length(matches); mi++) {
                    var dc = matches[mi];
                    if (variable_struct_exists(dc, "name") && normalize(dc.name) == nm && variable_struct_exists(dc, "id")) {
                        cid_val = string(dc.id);
                        break;
                    }
                }
            }
            if (cid_val != "") {
                var owned = get_card_count(cid_val);
                var maxc = get_max_copies_for_card_id(cid_val);
                var stones = variable_global_exists("arcane_stones") ? max(0, real(global.arcane_stones)) : 0;
                if (owned < maxc && stones >= cost) {
                    if (!spend_arcane_stones(cost)) {
                        exit;
                    }
                    unlock_card(cid_val);
                    audio_play_sound(invocation, 1, false);
                    show_debug_message("[DEBUG] Invocation immediate (NO ANIMATION) for card: " + cid_val);

                    // Refresh UI immediately
                    // Re-fetch all cards to update "owned" counts
                    allCards = dbGetAllCards();
                    // Re-apply filters
                    if (variable_global_exists("collection_invocation_mode") && global.collection_invocation_mode) {
                        allCards = filterInvocationCandidates(allCards);
                    } else {
                        allCards = filterOutLocked(allCards);
                    }
                    applyBoosterFilterNow(); // Refreshes filteredCards
                    sortCards(global.sort_mode);
                }
            }
            exit;
        }
    }
}

// --- Gestion des boutons d'action de carte sélectionnée (+, -, étoile) ---
if (instance_exists(oCollectionCardDisplay) && 
    oCollectionCardDisplay.selectedCard != noone && 
    instance_exists(oCollectionCardDisplay.selectedCard)) {
    // IMPORTANT: les boutons sont dessinés dans l'événement Draw GUI (Draw_64),
    // donc on utilise les coordonnées souris du GUI pour les zones cliquables
    var mx_check = mx;
    var my_check = my;

    var viewer_x = oCollectionCardDisplay.x;
    var viewer_y = oCollectionCardDisplay.y;
    var display_scale = 0.6;
    var card_width = sprite_get_width(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;
    var card_height = sprite_get_height(oCollectionCardDisplay.selectedCard.sprite_index) * display_scale;

    var frames_x = viewer_x - card_width/2 - 60;
    var frames_start_y = viewer_y - card_height/2;
    var spacing = 50;

    // Cadres et interactions
    var plus_x1 = frames_x - 20;
    var plus_y1 = frames_start_y - 20;
    var plus_x2 = frames_x + 20;
    var plus_y2 = frames_start_y + 20;

    var minus_x1 = frames_x - 20;
    var minus_y1 = frames_start_y + spacing - 20;
    var minus_x2 = frames_x + 20;
    var minus_y2 = frames_start_y + spacing + 20;

    var star_x1 = frames_x - 20;
    var star_y1 = frames_start_y + spacing * 2 - 20;
    var star_x2 = frames_x + 20;
    var star_y2 = frames_start_y + spacing * 2 + 20;

    if (mx_check >= plus_x1 && mx_check <= plus_x2 && my_check >= plus_y1 && my_check <= plus_y2) {
        var displayObj = instance_find(oCollectionCardDisplay, 0);
        if (displayObj != noone && instance_exists(displayObj)) {
            var sel = displayObj.selectedCard;
            if (sel != noone && instance_exists(sel)) {
                var cardName = variable_instance_exists(sel, "name") ? sel.name : "";
                if (cardName != "") {
                    if (!instance_exists(oDeckBuilder)) {
                        var builder_x = room_width - 400;
                        var builder_y = 100;
                        instance_create_layer(builder_x, builder_y, "Instances", oDeckBuilder);
                    }
                    with (oDeckBuilder) {
                        if (!is_array(cards_list)) { cards_list = []; }
                        // Résoudre la carte depuis la DB
                        var cardData = noone;
                        var candidates = dbGetCardsByName(cardName);
                        for (var ii = 0; ii < array_length(candidates); ii++) {
                            if (variable_struct_exists(candidates[ii], "name") && candidates[ii].name == cardName) {
                                cardData = candidates[ii];
                                break;
                            }
                        }
                        var oid = (cardData != noone && variable_struct_exists(cardData, "objectId")) ? cardData.objectId : "";
                        var cid = (cardData != noone && variable_struct_exists(cardData, "id")) ? string(cardData.id) : "";
                        var maxCopies = get_max_copies_for_card(cardName, oid);
                        // Compter copies déjà dans le deck
                        var deckCount = 0;
                        for (var di = 0; di < array_length(cards_list); di++) {
                            var entry = cards_list[di];
                            var entry_name = is_struct(entry) && variable_struct_exists(entry, "name") ? entry.name : string(entry);
                            if (entry_name == cardName) deckCount++;
                        }
                        // Quantité possédée
                        var owned = (cid != "") ? get_card_count(cid) : 0;
                        if (owned <= 0) {
                            show_debug_message("### Ajout refusé: carte non possédée (" + cardName + ")");
                        } else if (deckCount >= min(maxCopies, owned)) {
                            show_debug_message("### Ajout refusé: limite atteinte pour " + cardName + " (deck=" + string(deckCount) + ", max=" + string(min(maxCopies, owned)) + ")");
                        } else {
                            array_push(cards_list, cardName);
                            if (!is_undefined(check_and_add_slot)) check_and_add_slot();
                        }
                    }
                }
            }
        }
        exit;
    }
    if (mx_check >= minus_x1 && mx_check <= minus_x2 && my_check >= minus_y1 && my_check <= minus_y2) {
        var displayObj2 = instance_find(oCollectionCardDisplay, 0);
        if (displayObj2 != noone && instance_exists(displayObj2)) {
            var sel2 = displayObj2.selectedCard;
            if (sel2 != noone && instance_exists(sel2)) {
                var cardName2 = variable_instance_exists(sel2, "name") ? sel2.name : "";
                if (cardName2 != "" && instance_exists(oDeckBuilder)) {
                    with (oDeckBuilder) {
                        if (!is_array(cards_list)) { cards_list = []; }
                        for (var i = 0; i < array_length(cards_list); i++) {
                            var entry = cards_list[i];
                            var entry_name = is_struct(entry) && variable_struct_exists(entry, "name") ? entry.name : string(entry);
                            if (entry_name == cardName2) {
                                array_delete(cards_list, i, 1);
                                break;
                            }
                        }
                    }
                }
            }
        }
        exit;
    }
    if (mx_check >= star_x1 && mx_check <= star_x2 && my_check >= star_y1 && my_check <= star_y2) {
        var displayObj3 = instance_find(oCollectionCardDisplay, 0);
        if (displayObj3 != noone && instance_exists(displayObj3)) {
            var sel3 = displayObj3.selectedCard;
            if (sel3 != noone && instance_exists(sel3)) {
                var cardName3 = variable_instance_exists(sel3, "name") ? sel3.name : "";
                if (cardName3 != "") {
                    if (!variable_global_exists("favorite_cards") || !is_array(global.favorite_cards)) {
                        global.favorite_cards = [];
                    }
                    var found = false;
                    for (var f = 0; f < array_length(global.favorite_cards); f++) {
                        if (global.favorite_cards[f] == cardName3) { found = true; break; }
                    }
                    if (found) {
                        for (var r = 0; r < array_length(global.favorite_cards); r++) {
                            if (global.favorite_cards[r] == cardName3) { array_delete(global.favorite_cards, r, 1); break; }
                        }
                    } else {
                        array_push(global.favorite_cards, cardName3);
                    }
                }
            }
        }
        exit;
    }
}
