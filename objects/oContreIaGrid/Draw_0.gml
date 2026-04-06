// === oContreIaGrid - Draw Event ===
// Dessine un tableau avec 30 espaces vides au milieu de l'écran

// Configuration du tableau - 60% de la hauteur de l'écran
var grid_cols = 6;
var grid_rows = 5;
var grid_height = room_height * 0.6; // 60% de la hauteur
var cell_height = grid_height / grid_rows;
var cell_width = cell_height; // Cellules carrées
var cell_margin = 5;

// Calculer la taille totale du tableau
var total_width = (grid_cols * cell_width) + ((grid_cols - 1) * cell_margin);
var total_height = (grid_rows * cell_height) + ((grid_rows - 1) * cell_margin);

// Position centrée entre les deux cadres (400px chacun)
var frame_width = 400;
var available_width = room_width - (2 * frame_width); // Espace entre les cadres
var grid_x = frame_width + (available_width - total_width) / 2;
var grid_y = (room_height - total_height) / 2;

// Couleurs
var cell_color = c_white;
var border_color = c_black;
var bg_color = c_ltgray;

var frame_x1 = grid_x - 20;
var frame_y1 = grid_y - 20;
var frame_w = total_width + 40;
var frame_h = total_height + 40;
var frame_cx = frame_x1 + frame_w / 2;
var frame_cy = frame_y1 + frame_h / 2;
var sx = frame_w / sprite_get_width(sCimetiere);
var sy = frame_h / sprite_get_height(sCimetiere);
draw_sprite_ext(sCimetiere, 0, frame_cx, frame_cy, sx, sy, 0, c_white, 1);

// Dessiner chaque cellule
for (var row = 0; row < grid_rows; row++) {
    for (var col = 0; col < grid_cols; col++) {
        var cell_x = grid_x + (col * (cell_width + cell_margin));
        var cell_y = grid_y + (row * (cell_height + cell_margin));
        
        // Calculer l'index de la cellule (0-29)
        var cell_index = (row * grid_cols) + col;
        
        // Déterminer le nom de l'emplacement
        var cell_name = "";
        if (cell_index == 0) {
            cell_name = "aleatoire";
        } else {
            cell_name = "bot" + string(cell_index);
        }
        
        // Déterminer la couleur de fond selon l'état
        var current_cell_color = cell_color;
        var text_color = c_black;
        
        // Vérifier si ce bot est disponible
        var bot_available = false;
        if (cell_index == 0) {
            bot_available = true;
        } else {
            for (var i = 0; i < array_length(available_bots); i++) {
                if (available_bots[i] == cell_index) {
                    bot_available = true;
                    break;
                }
            }
        }
        
        // Vérifier si cette cellule est sélectionnée
        if (selected_bot == cell_index) {
            current_cell_color = c_lime; // Vert pour la sélection
            text_color = c_black;
        } else if (cell_index == 0) {
            // Bouton aléatoire - toujours disponible
            current_cell_color = c_yellow; // Jaune pour le bouton aléatoire
            text_color = c_black;
        } else {
            if (!bot_available) {
                current_cell_color = c_gray; // Gris pour les bots non disponibles
                text_color = c_dkgray;
            }
        }
        
        if (cell_index == 0) {
            draw_sprite_stretched(sPortraitIntro, 0, cell_x, cell_y, cell_width, cell_height);
        } else {
            draw_sprite_stretched(sPortrait, 0, cell_x, cell_y, cell_width, cell_height);
        }
        
        // Dessiner la bordure de la cellule
        if (selected_bot == cell_index) {
            draw_set_color(border_color);
            draw_rectangle(cell_x, cell_y, cell_x + cell_width, cell_y + cell_height, true);
        }
        
        // Dessiner une bordure plus épaisse si sélectionné
        if (selected_bot == cell_index) {
            draw_set_color(c_green);
            for (var i = 0; i < 3; i++) {
                draw_rectangle(cell_x - i, cell_y - i, cell_x + cell_width + i, cell_y + cell_height + i, true);
            }
        }
        
        if (bot_available && cell_index != 0) {
            var bot_info = bot_data[cell_index];
            if (variable_struct_exists(bot_info, "portrait") && bot_info.portrait != undefined) {
                var spr_idx = -1;
                if (is_string(bot_info.portrait)) {
                    spr_idx = asset_get_index(bot_info.portrait);
                } else {
                    spr_idx = bot_info.portrait;
                }
                
                if (spr_idx != -1) {
                    var draw_w = cell_width;
                    var draw_h = cell_height;
                    var spr_w = sprite_get_width(spr_idx);
                    var spr_h = sprite_get_height(spr_idx);
                    var scale_x = draw_w / spr_w;
                    var scale_y = draw_h / spr_h;
                    var scale = max(scale_x, scale_y); 
                    
                    var ox = sprite_get_xoffset(spr_idx);
                    var oy = sprite_get_yoffset(spr_idx);
                    
                    var draw_px = cell_x + (draw_w - spr_w * scale) / 2;
                    var draw_py = cell_y + (draw_h - spr_h * scale) / 2;
                    
                    draw_px += ox * scale;
                    draw_py += oy * scale;
                    
                    draw_sprite_ext(spr_idx, 0, draw_px, draw_py, scale, scale, 0, c_white, 1);
                }
            }
        }
    }
}

// Remettre les alignements par défaut
draw_set_halign(fa_left);
draw_set_valign(fa_top);
