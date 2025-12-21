// === Zone du cadre GraveyardViewer basée sur sCimetiere centré ===
var sprFond = sCimetiere;
var fondW = sprite_get_width(sprFond);
var fondH = sprite_get_height(sprFond);
var centerX = room_width * 0.5;
var centerY = room_height * 0.5;
var scaledW = fondW;
var scaledH = fondH;
var background_x1 = centerX - scaledW * 0.5;
var background_y1 = centerY - scaledH * 0.5;
var background_x2 = centerX + scaledW * 0.5;
var background_y2 = centerY + scaledH * 0.5;

// Si le clic est en dehors du cadre du GraveyardViewer, ne rien faire
if (!(mouse_x >= background_x1 && mouse_x <= background_x2 &&
      mouse_y >= background_y1 && mouse_y <= background_y2)) {
    exit; // Sortir du script pour bloquer le clic
}

// Bouton fermeture (haut-droite du cadre)
var close_margin = 20;
var close_w = 30;
var close_h = 30;
var btn_x1 = background_x2 - close_margin - close_w;
var btn_y1 = background_y1 + close_margin;
var btn_x2 = btn_x1 + close_w;
var btn_y2 = btn_y1 + close_h;

// Si la souris est dans la zone du bouton
if (mouse_x >= btn_x1 && mouse_x <= btn_x2 && mouse_y >= btn_y1 && mouse_y <= btn_y2) {
    // Supprime ce viewer
    instance_destroy();
    global.isGraveyardViewerOpen = false;
}

// Paramètres identiques au draw pour connaître la disposition
var columns = 4;
var rows = 3;
var spacing = 20;

// Aligné avec Draw: zone intérieure du cadre
var inner_margin = 40;
var start_x = background_x1 + inner_margin;
var start_y = background_y1 + inner_margin;
var content_w = scaledW - 2 * inner_margin;
var content_h = scaledH - 2 * inner_margin;
var cell_w = (content_w - (columns - 1) * spacing) / columns;
var cell_h = (content_h - (rows - 1) * spacing) / rows;

// Vérification de sécurité
if (linkedGraveyard == noone || !instance_exists(linkedGraveyard)) {
    return;
}

var list = linkedGraveyard.cards;
var total = array_length(list);

// Si le cimetière est vide, ne rien faire
if (total == 0) {
    return;
}

var count = min(total - scrollIndex, columns * rows);

// Parcourir les cartes affichées et vérifier si la souris est dessus
for (var i = 0; i < count; i++) {
    var col = i mod columns;
    var row = i div columns;

    var draw_x_top_left = start_x + col * (cell_w + spacing);
    var draw_y_top_left = start_y + row * (cell_h + spacing);

    // Taille réelle de la carte affichée (comme dans Draw)
    var cardData_idx = total - 1 - (i + scrollIndex);
    cardData_idx = clamp(cardData_idx, 0, total - 1);
    var cardData_local = list[cardData_idx];
    var sprLocal = cardData_local.sprite_index;
    if (sprLocal == -1 && variable_struct_exists(cardData_local, "object_index")) {
        sprLocal = object_get_sprite(cardData_local.object_index);
    }
    var cw_src = sprite_get_width(sprLocal);
    var ch_src = sprite_get_height(sprLocal);
    var s_local = (cw_src > 0 && ch_src > 0) ? min(cell_w / cw_src, cell_h / ch_src) * 0.95 : 0.25;
    var cw_draw = cw_src * s_local;
    var ch_draw = ch_src * s_local;

    // Centre de la zone dessinée
    var draw_x = draw_x_top_left + cell_w * 0.5;
    var draw_y = draw_y_top_left + cell_h * 0.5;

    // Zone cliquable centrée sur la carte
    var click_x = draw_x - cw_draw / 2;
    var click_y = draw_y - ch_draw / 2;

    // Vérifier si la souris est sur la carte en utilisant la zone cliquable
                if (mouse_x >= click_x && mouse_x <= click_x + cw_draw &&
                    mouse_y >= click_y && mouse_y <= click_y + ch_draw) {

            var cardData = list[cardData_idx];
            
            // Vérifier que les données de carte existent
            if (cardData != undefined) {
                selectedCard = cardData;
                show_debug_message("Carte sélectionnée: " + cardData.name);

                // Désélectionner toute carte actuellement sélectionnée sur le terrain/ main
                // pour éviter deux previews superposés (viewer + sélection terrain)
                if (instance_exists(selectManager)) {
                    selectManager.unSelectAll();
                } else {
                    var sm = instance_find(oSelectManager, 0);
                    if (sm != noone && instance_exists(sm)) {
                        with (sm) { unSelectAll(); }
                    }
                }
            }

            // Optionnel : stopper la boucle une fois la carte sélectionnée
            break;
        }
    }
    // Si aucune carte n'est survolée, réinitialiser selectedCard
    var grid_w = columns * cell_w + (columns - 1) * spacing;
    var grid_h = rows * cell_h + (rows - 1) * spacing;
    if (selectedCard != noone && (mouse_x < start_x || mouse_x > start_x + grid_w ||
        mouse_y < start_y || mouse_y > start_y + grid_h)) {
        selectedCard = noone;
    }
