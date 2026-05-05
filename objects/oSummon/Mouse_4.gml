show_debug_message("### oSummon.create")

// Enregistrer le clic UI pour bloquer la sélection de carte sous-jacente
global.last_ui_click_time = current_time;

if (global.isGraveyardViewerOpen) exit;
// Bloque l'interaction si le sélecteur de sacrifice est ouvert
if (variable_global_exists("isSacrificeSelectorOpen") && global.isSacrificeSelectorOpen) exit;

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) exit;

UIManager.selectedSummonOrSet = "Summon";

// Affiche les indicateurs de placement
UIManager.displayIndicator();

// Empêche la propagation du clic vers les objets en dessous
exit;

