// === oLobbyUI - Draw Event ===

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(960, 100, "Lobby Multijoueur");

// Affichage des IP uniquement en mode admin
if (variable_global_exists("admin_mode") && global.admin_mode) {
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_text(50, 50, "ADMIN - IP Publique : " + public_ip);
    draw_text(50, 70, "ADMIN - IP Locale  : " + local_ip_display);
    draw_set_halign(fa_center);
}

// Bouton Retour (UI dédié) avec sprite sButton
var back_btn_w = 220;
var back_btn_h = 60;
var back_btn_x = 200;
var back_btn_y = 1000;
var back_left = back_btn_x - back_btn_w / 2;
var back_top = back_btn_y - back_btn_h / 2;

draw_sprite_stretched(sButton, 0, back_left, back_top, back_btn_w, back_btn_h);
draw_set_color(c_black);
draw_text(back_btn_x + 2, back_btn_y + 2, "Retour");
draw_set_color(make_color_rgb(230, 200, 120));
draw_text(back_btn_x, back_btn_y, "Retour");

// === Panneau de Decks (comme dans la Collection) ===
// Position et sprite sDeckBuilder
var sprite_x = room_width - sprite_get_width(sDeckBuilder) + 55;
var sprite_y = -10;
var sprW = sprite_get_width(sDeckBuilder);
var scale_y = (room_height + 10) / sprite_get_height(sDeckBuilder);
var scale_x = (sprW - 100) / sprW;
var scaled_w = sprW * scale_x;
sprite_x = room_width - scaled_w + 55 - 55;

draw_sprite_ext(sDeckBuilder, 0, sprite_x, sprite_y, scale_x, scale_y, 0, c_white, 1);

// Géométrie identique à oDeckList, sans bouton "nouveau deck"
var list_button_x = sprite_x + 50;
var list_button_y = room_height / 3 - 270;
var baseW_btn = sprite_get_width(sButton);
var baseH_btn = sprite_get_height(sButton);
var list_button_width = round(baseW_btn * 0.8);
var list_button_height = round(baseH_btn * 0.8);

var deck_list_y = list_button_y + list_button_height + 20;
var deck_item_height = 35;
var deck_item_width = list_button_width;

// Affichage des decks sauvegardés (même style que Collection)
if (variable_global_exists("saved_decks") && array_length(global.saved_decks) > 0) {
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(list_button_x + list_button_width/2, deck_list_y - 10, "Decks sauvegardés:");
    
    for (var i = 0; i < array_length(global.saved_decks); i++) {
        var deck = global.saved_decks[i];
        var item_y = deck_list_y + (i * (deck_item_height + 5));
        
        if (item_y + deck_item_height > room_height - 50) {
            break;
        }
        
        // Couleur de fond : bleuté si sélectionné, sinon gris clair
        var bg_color = c_ltgray;
        if (i == selected_deck_idx) {
            bg_color = make_color_rgb(80, 100, 160);
        }
        
        draw_set_color(bg_color);
        draw_rectangle(list_button_x, item_y, list_button_x + deck_item_width, item_y + deck_item_height, false);
        draw_set_color(c_black);
        draw_rectangle(list_button_x, item_y, list_button_x + deck_item_width, item_y + deck_item_height, true);
        
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(list_button_x + 5, item_y + 3, deck.name);
        
        draw_set_color(c_gray);
        if (variable_struct_exists(deck, "card_count")) {
            draw_text(list_button_x + 5, item_y + 18, string(deck.card_count) + " cartes");
        }
    }
}

// === Draw Status ===
draw_set_halign(fa_left);
var status_x = 50;
var status_y = 650;

// Local Status
var local_deck_name = (selected_deck_idx != -1) ? global.saved_decks[selected_deck_idx].name : "Aucun";
draw_text(status_x, status_y, "Vous: " + local_deck_name);
draw_set_color(local_ready ? c_lime : c_red);
draw_text(status_x, status_y + 30, local_ready ? "PRÊT" : "NON PRÊT (Sélectionnez un deck)");

// Remote Status
draw_set_color(c_white);
var remote_name = (global.remote_lobby_deck_name != "") ? global.remote_lobby_deck_name : "Inconnu";
draw_text(status_x, status_y + 80, "Adversaire: " + remote_name);
draw_set_color(global.remote_lobby_ready ? c_lime : c_red);
draw_text(status_x, status_y + 110, global.remote_lobby_ready ? "PRÊT" : "EN ATTENTE");

draw_set_color(c_white);
draw_set_halign(fa_center);


// Draw IP Input (cadre avec sprite sButton)
var ip_left = input_ip_x - input_width / 2;
var ip_top = input_ip_y - input_height / 2;
var ip_right = input_ip_x + input_width / 2;
var ip_bottom = input_ip_y + input_height / 2;

draw_set_halign(fa_right);
draw_text(ip_left - 10, input_ip_y, "Adresse IP :");

// Surbrillance si sélectionné
if (is_typing_ip) {
    draw_sprite_stretched_ext(sButton, 0, ip_left, ip_top, input_width, input_height, c_ltgray, 1);
    draw_set_color(c_yellow);
    draw_rectangle(ip_left, ip_top, ip_right, ip_bottom, true);
} else {
    draw_sprite_stretched(sButton, 0, ip_left, ip_top, input_width, input_height);
}

draw_set_halign(fa_center);
draw_set_color(is_typing_ip ? c_yellow : c_white);
var display_ip = ip_input + (is_typing_ip && (current_time % 1000 < 500) ? "|" : "");
draw_text(input_ip_x, input_ip_y, display_ip);

// Draw Port Input (cadre avec sprite sButton)
var port_left = input_port_x - input_width / 2;
var port_top = input_port_y - input_height / 2;
var port_right = input_port_x + input_width / 2;
var port_bottom = input_port_y + input_height / 2;

draw_set_halign(fa_right);
draw_text(port_left - 10, input_port_y, "Port :");

// Surbrillance si sélectionné
if (is_typing_port) {
    draw_sprite_stretched_ext(sButton, 0, port_left, port_top, input_width, input_height, c_ltgray, 1);
    draw_set_color(c_yellow);
    draw_rectangle(port_left, port_top, port_right, port_bottom, true);
} else {
    draw_sprite_stretched(sButton, 0, port_left, port_top, input_width, input_height);
}

draw_set_halign(fa_center);
draw_set_color(is_typing_port ? c_yellow : c_white);
var display_port = port_input + (is_typing_port && (current_time % 1000 < 500) ? "|" : "");
draw_text(input_port_x, input_port_y, display_port);

draw_set_halign(fa_center);

var host_left = button_host_x - button_width / 2;
var host_top = button_host_y - button_height / 2;
var host_right = button_host_x + button_width / 2;
var host_bottom = button_host_y + button_height / 2;

var join_left = button_join_x - button_width / 2;
var join_top = button_join_y - button_height / 2;
var join_right = button_join_x + button_width / 2;
var join_bottom = button_join_y + button_height / 2;

draw_sprite_stretched(sButton, 0, host_left, host_top, button_width, button_height);
draw_set_color(c_black);
draw_text(button_host_x + 2, button_host_y + 2, "Héberger");
draw_set_color(make_color_rgb(230, 200, 120));
draw_text(button_host_x, button_host_y, "Héberger");

draw_sprite_stretched(sButton, 0, join_left, join_top, button_width, button_height);
draw_set_color(c_black);
draw_text(button_join_x + 2, button_join_y + 2, "Rejoindre");
draw_set_color(make_color_rgb(230, 200, 120));
draw_text(button_join_x, button_join_y, "Rejoindre");

if (variable_global_exists("NET_IS_HOST") && global.NET_IS_HOST && variable_global_exists("NET_HANDSHAKE_DONE") && global.NET_HANDSHAKE_DONE) {
    // Condition pour démarrer: Local Ready + Remote Ready
    var can_start = (local_ready && global.remote_lobby_ready);
    
    var start_left = button_start_x - button_width / 2;
    var start_top = button_start_y - button_height / 2;
    var start_right = button_start_x + button_width / 2;
    var start_bottom = button_start_y + button_height / 2;
    
    // Aura bleuté si prêt
    if (can_start) {
        gpu_set_blendmode(bm_add);
        var glow_alpha = 0.5 + 0.3 * sin(current_time / 200); // Pulsation
        draw_sprite_stretched_ext(sButton, 0, start_left - 5, start_top - 5, button_width + 10, button_height + 10, c_aqua, glow_alpha);
        gpu_set_blendmode(bm_normal);
    }

    draw_sprite_stretched(sButton, 0, start_left, start_top, button_width, button_height);
    
    var main_col = can_start ? make_color_rgb(230, 200, 120) : c_gray;
    draw_set_color(c_black);
    draw_text(button_start_x + 2, button_start_y + 2, "JOUER");
    draw_set_color(main_col);
    draw_text(button_start_x, button_start_y, "JOUER");
}

draw_set_color(c_yellow);
draw_text(960, 660, status_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
