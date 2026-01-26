// === oDeckList - Mouse Global Left Button Event ===

// Bloquer toute interaction si le panneau d'options est ouvert
if (instance_exists(oPanelOptions)) {
    return;
}

// Calculer les positions des éléments (même logique que dans Draw_0)
var sprW = sprite_get_width(sDeckBuilder);
var scale_x = (sprW - 100) / sprW;
var scaled_w = sprW * scale_x;
var sprite_x = room_width - scaled_w + 55 - 55;
var button_x = sprite_x + 50;
var button_y = room_height / 3 - 270;
var button_width = 320;
var button_height = 80;

// --- Gestion du bouton Toggle Mode ---
if (variable_global_exists("admin_mode") && global.admin_mode) {
    var mode_btn_y = button_y - 60;
    if (!show_deck_builder && point_in_rectangle(mouse_x, mouse_y, button_x, mode_btn_y, button_x + button_width, mode_btn_y + button_height)) {
        if (list_mode == "player") list_mode = "bot";
        else if (list_mode == "bot") list_mode = "hero";
        else list_mode = "player";
        return; // Stop processing to avoid double clicks
    }
} else {
    // Si pas admin, s'assurer qu'on est en mode joueur
    if (list_mode != "player") list_mode = "player";
}
// -------------------------------------

// Vérifier d'abord si le clic est sur un deck sauvegardé (seulement si le deck builder n'est pas affiché)
var clicked_on_deck = false;
var current_list = [];
if (list_mode == "player") {
    if (variable_global_exists("saved_decks")) current_list = global.saved_decks;
} else if (list_mode == "bot") {
    // Utiliser get_all_bot_decks() pour avoir TOUS les decks (custom + histoire)
    current_list = get_all_bot_decks();
} else if (list_mode == "hero") {
    // Utiliser get_all_hero_decks() pour avoir TOUS les decks héros (custom + histoire)
    current_list = get_all_hero_decks();
}

if (!show_deck_builder && array_length(current_list) > 0) {
    var deck_list_y = button_y + button_height + 20;
    var deck_item_height = 35;
    var deck_item_width = button_width;
    
    // Vérifier chaque deck sauvegardé
    for (var i = 0; i < array_length(current_list); i++) {
        var deck = current_list[i];
        var item_y = deck_list_y + (i * (deck_item_height + 5));
        
        // Vérifier si on dépasse l'écran
        if (item_y + deck_item_height > room_height - 50) {
            break;
        }
        
        // Vérifier si le clic est sur ce deck
        if (point_in_rectangle(mouse_x, mouse_y, button_x, item_y, button_x + deck_item_width, item_y + deck_item_height)) {
            clicked_on_deck = true;
            
            // Ouvrir le deck builder avec le deck sélectionné
            show_deck_builder = true;
            
            // Créer l'instance oDeckBuilder si elle n'existe pas
            if (deck_builder_instance == noone || !instance_exists(deck_builder_instance)) {
                var builder_x = x;
                var builder_y = button_y + button_height + 20;
                deck_builder_instance = instance_create_layer(builder_x, builder_y, "Instances", oDeckBuilder);
                
                // Configurer et charger le deck dans l'éditeur
                if (instance_exists(deck_builder_instance)) {
                    deck_builder_instance.is_bot_deck = (other.list_mode == "bot");
                    deck_builder_instance.is_hero_deck = (other.list_mode == "hero");
                    with (deck_builder_instance) {
                        load_deck_for_editing(deck);
                    }
                }
            }
            
            break; // Sortir de la boucle une fois qu'un deck est cliqué
        }
    }
}

// Si aucun deck n'a été cliqué, vérifier le clic sur le bouton "nouveau deck"
if (!clicked_on_deck && point_in_rectangle(mouse_x, mouse_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
    // Basculer l'affichage du deck builder pour un nouveau deck
    show_deck_builder = !show_deck_builder;
    
    if (show_deck_builder) {
        // Créer l'instance oDeckBuilder si elle n'existe pas
        if (deck_builder_instance == noone || !instance_exists(deck_builder_instance)) {
            // Position du cadre sous le bouton
            var builder_x = x;
            var builder_y = button_y + button_height + 20;
            deck_builder_instance = instance_create_layer(builder_x, builder_y, "Instances", oDeckBuilder);
            if (instance_exists(deck_builder_instance)) {
                deck_builder_instance.is_bot_deck = (list_mode == "bot");
                deck_builder_instance.is_hero_deck = (list_mode == "hero");
            }
        }
    } else {
        // Détruire l'instance oDeckBuilder si elle existe
        if (deck_builder_instance != noone && instance_exists(deck_builder_instance)) {
            instance_destroy(deck_builder_instance);
            deck_builder_instance = noone;
        }
    }
}