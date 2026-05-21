duelFeedbackReset();
duelLogPush("— Duel commencé —", "phase");
// Conserver position/taille si le joueur les a déjà réglées cette session
if (!variable_global_exists("duel_log_panel_w")) {
    applyDefaultLayout();
} else {
    loadLayout();
}
