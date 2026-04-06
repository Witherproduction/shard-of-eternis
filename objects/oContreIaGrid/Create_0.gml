// === oContreIaGrid - Create Event ===
// Initialisation des variables pour la sélection des bots

// Configuration du tableau
grid_cols = 6;
grid_rows = 5;
total_cells = grid_cols * grid_rows; // 30 emplacements

// Variables de sélection
selected_bot = -1; // -1 = aucune sélection, 0 = aléatoire, 1-29 = bot spécifique
available_bots = []; // Liste des bots disponibles

// === SYSTÈME DE DONNÉES DES BOTS ===
// Structure: bot_data[bot_id] = {nom, description, deck_name, deck_id, difficulty}

bot_data = [];

// Initialiser les données pour chaque bot
for (var i = 0; i < total_cells; i++) {
    bot_data[i] = {};
}

// Bot 0 (Aléatoire)
bot_data[0] = {
    name: "Sélection Aléatoire",
    description: "Un adversaire sera choisi au hasard parmi tous les bots disponibles.",
    deck_name: "Deck Aléatoire",
    deck_id: -1,
    difficulty: "Variable"
};

// === Récupération dynamique des données depuis TOUS les chapitres ===
var all_available_decks = get_all_bot_decks(); // Utilise la fonction agrégée du StoryDeckManager

for (var i = 0; i < array_length(all_available_decks); i++) {
    var deck = all_available_decks[i];
    var bot_id = deck.id; // L'ID du deck détermine la position dans la grille
    
    // Mapping manuel des nouveaux IDs string vers les anciens slots numériques
    if (is_string(bot_id)) {
        if (bot_id == "Invasion_Gueule_Roche") bot_id = 1;
        else if (bot_id == "Essaim_Abyssien") bot_id = 2;
        else if (bot_id == "Bandit_Grand_Chemin") bot_id = 3;
        else if (bot_id == "Matriarche_Peau_Roc") bot_id = 4;
        else if (bot_id == "Recolteur_Recolte_Sournoise") bot_id = 5;
        else if (bot_id == "Armee_des_Skarls") bot_id = 6;
        else if (bot_id == "Terreur_de_la_foret") bot_id = 7;
    }
    
    // Vérification du type de bot_id pour éviter le crash (ex: "tuto_deck_bot" est une string)
    if (is_real(bot_id) && bot_id < total_cells) {
        bot_data[bot_id] = {
            name: deck.name,
            description: variable_struct_exists(deck, "description") ? deck.description : "Pas de description disponible.",
            deck_name: variable_struct_exists(deck, "deck_name") ? deck.deck_name : deck.name,
            deck_id: deck.id,
            difficulty: variable_struct_exists(deck, "difficulty") ? deck.difficulty : "Inconnue",
            portrait: variable_struct_exists(deck, "portrait") ? deck.portrait : undefined
        };
    }
}

// Mettre à jour la liste des bots disponibles en fonction de la progression
available_bots = [];

// Vérifier les bots
for (var i = 1; i < total_cells; i++) {
    if (variable_struct_exists(bot_data[i], "name")) {
        // Vérifier si le bot est débloqué via le gestionnaire de progression
        // Vérifie l'ID numérique (i) OU l'ID string réel (deck_id)
        if (is_bot_unlocked(i) || is_bot_unlocked(bot_data[i].deck_id)) {
            array_push(available_bots, i);
        }
    }
}

/* 
// Bot 5 - Contrôle (Désactivé)
if (array_length(bot_data) > 5 && !variable_struct_exists(bot_data[5], "name")) {
    bot_data[5] = {
        name: "Maître du Contrôle",
        description: "Bot expert en contrôle du terrain et manipulation des cartes adverses.",
        deck_name: "Deck Contrôle",
        deck_id: 5,
        difficulty: "Difficile"
    };
}

// Bots 6-29 - Génériques (Désactivés)
for (var i = 6; i < total_cells; i++) {
    // Code supprimé pour le moment
}
*/

// Variables pour le calcul des positions (reprises du Draw event)
grid_height = room_height * 0.6;
cell_height = grid_height / grid_rows;
cell_width = cell_height;
cell_margin = 5;

total_width = (grid_cols * cell_width) + ((grid_cols - 1) * cell_margin);
total_height = (grid_rows * cell_height) + ((grid_rows - 1) * cell_margin);

frame_width = 400;
available_width = room_width - (2 * frame_width);
grid_x = frame_width + (available_width - total_width) / 2;
grid_y = (room_height - total_height) / 2;

// === FONCTIONS POUR LA GESTION DES DECKS ===

// Fonction pour récupérer le deck d'un bot
function get_bot_deck(bot_id) {
    if (bot_id < 0 || bot_id >= array_length(bot_data)) {
        return noone;
    }
    
    var bot_info = bot_data[bot_id];
    var deck_id = bot_info.deck_id;
    
    // Si c'est le bot aléatoire, retourner un deck aléatoire
    if (bot_id == 0) {
        return get_random_bot_deck();
    }
    
    // Retourner le deck spécifique du bot
    return create_bot_deck(deck_id, bot_info.name);
}

// Fonction pour créer un deck préconstruit pour un bot (utilise le script sBotDecks)
function create_bot_deck(deck_id, bot_name) {
    // Utiliser le script dédié pour récupérer les cartes
    return create_bot_deck_from_script(deck_id, bot_name);
}

// Fonction pour obtenir un deck aléatoire
function get_random_bot_deck() {
    var random_bot_id = irandom_range(1, total_cells - 1);
    return get_bot_deck(random_bot_id);
}

// Fonction utilitaire pour retrouver l'ID du bot à partir de l'ID du deck
function get_bot_id_from_deck(deck_id) {
    for (var i = 0; i < array_length(bot_data); i++) {
        if (bot_data[i].deck_id == deck_id) {
            return i;
        }
    }
    return 1; // Par défaut, retourner le bot 1
}
