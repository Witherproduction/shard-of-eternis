/// @description Vérification périodique du reset
// Vérifier toutes les 60 secondes (60 fps * 60)
check_timer++;
if (check_timer >= 3600) {
    check_timer = 0;
    check_daily_reset();
}
