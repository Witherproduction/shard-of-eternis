// S'assurer que les propriétés de carte existent
if (!variable_instance_exists(id, "type")) type = "";
if (!variable_instance_exists(id, "attack")) attack = 0;
if (!variable_instance_exists(id, "PV")) PV = 0;
if (!variable_instance_exists(id, "mana_cost")) mana_cost = 0;
if (!variable_instance_exists(id, "name")) name = "";
if (!variable_instance_exists(id, "description")) description = "";
if (!variable_instance_exists(id, "tags")) tags = []; // Tableau de chaînes pour les filtres et quêtes
if (!variable_instance_exists(id, "booster")) booster = "";

// Champs additionnels pour l'affichage dynamique
if (!variable_instance_exists(id, "genre")) genre = "";
if (!variable_instance_exists(id, "race")) race = "";

// Coût/ATK/PV alternatifs si utilisés ailleurs
if (!variable_instance_exists(id, "atk")) atk = attack; // miroir
if (!variable_instance_exists(id, "cost")) cost = mana_cost; // miroir
// Limite par défaut
if (!variable_instance_exists(id, "limited")) limited = 3;

// --- HEARTHSTONE SYSTEM MIGRATION (Phase 1) ---
if (!variable_instance_exists(id, "max_hp")) max_hp = PV; // Default to PV
if (!variable_instance_exists(id, "current_hp")) current_hp = max_hp;
if (!variable_instance_exists(id, "has_taunt")) has_taunt = false;
if (!variable_instance_exists(id, "has_charge")) has_charge = false; 
// ----------------------------------------------

// --- BUFF SYSTEM INITIALIZATION ---
if (!variable_instance_exists(id, "original_attack")) original_attack = attack; // Stats d'origine (immuables pour comparaison couleur)
if (!variable_instance_exists(id, "original_PV")) original_PV = PV;           // Stats d'origine (immuables pour comparaison couleur)
if (!variable_instance_exists(id, "effective_attack")) effective_attack = attack;
if (!variable_instance_exists(id, "effective_defense")) effective_defense = PV;
if (!variable_instance_exists(id, "buff_contribs")) buff_contribs = [];
if (!variable_instance_exists(id, "temp_attack")) temp_attack = 0;
if (!variable_instance_exists(id, "temp_defense")) temp_defense = 0;
// ----------------------------------

// Variables de sélection
isSelected = false;
isHovered = false;
isTargetableForFloraison = false;
isComboActive = false; // Indicateur visuel pour Combo/Condition remplie
comboCheckTimer = 0;   // Timer pour ne pas vérifier à chaque frame
comboAnimTimer = 0;    // Timer pour l'animation visuelle
ambidextrousAnimTimer = 0; // Timer pour l'effet visuel Ambidextrie

if (!variable_global_exists("nextCardInstanceUID")) global.nextCardInstanceUID = 1;
if (!variable_instance_exists(id, "instance_uid")) {
    instance_uid = global.nextCardInstanceUID;
    global.nextCardInstanceUID += 1;
}

// --- VISUAL EFFECTS ---
if (!variable_instance_exists(id, "poison_bubbles")) poison_bubbles = [];
if (!variable_instance_exists(id, "poison_spawn_timer")) poison_spawn_timer = 0;
