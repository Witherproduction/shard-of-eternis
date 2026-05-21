if (room != rDuel) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var gw = display_get_gui_width();
var gh = display_get_gui_height();
if (gw <= 0) gw = 1920;
if (gh <= 0) gh = 1080;

var overPanel = (mx >= panel_x && mx <= panel_x + panel_w && my >= panel_y && my <= panel_y + panel_h);
var overHeader = (mx >= panel_x && mx <= panel_x + panel_w && my >= panel_y && my <= panel_y + header_click_h);
var overToggle = (mx >= panel_x + padding && mx <= panel_x + padding + toggle_zone_w && overHeader);
var filterHit = (!panel_collapsed) ? hitTestFilterChip(mx, my) : "";
var overFilter = (filterHit != "");
var grip_x1 = panel_x + panel_w - grip_size;
var grip_y1 = panel_y + panel_h - grip_size;
var overGrip = (!panel_collapsed && mx >= grip_x1 && mx <= panel_x + panel_w && my >= grip_y1 && my <= panel_y + panel_h);

// --- Début interaction ---
if (mouse_check_button_pressed(mb_left)) {
    if (overGrip) {
        resizing = true;
        dragging = false;
    } else if (overFilter) {
        setLogFilter(filterHit);
        saveLayout();
    } else if (overHeader && !overToggle) {
        dragging = true;
        resizing = false;
        drag_off_x = mx - panel_x;
        drag_off_y = my - panel_y;
        header_press_x = mx;
        header_press_y = my;
    } else if (overToggle) {
        panel_collapsed = !panel_collapsed;
        if (panel_collapsed) {
            panel_h = collapsed_h;
        } else {
            syncPanelHeight();
        }
        saveLayout();
    }
}

// --- Déplacement ---
if (dragging && mouse_check_button(mb_left)) {
    panel_x = mx - drag_off_x;
    panel_y = my - drag_off_y;
    clampPanelToGui();
}

// --- Redimensionnement (coin bas-droit) ---
if (resizing && mouse_check_button(mb_left) && !panel_collapsed) {
    panel_w = max(panel_min_w, mx - panel_x);
    panel_h = max(panel_min_h, my - panel_y);
    panel_w = min(panel_w, panel_max_w);
    panel_h = min(panel_h, panel_max_h);
    syncVisibleLinesFromHeight();
}

// --- Fin interaction ---
if (mouse_check_button_released(mb_left)) {
    if (dragging) {
        var dist = point_distance(header_press_x, header_press_y, mx, my);
        if (dist < 5 && overToggle) {
            panel_collapsed = !panel_collapsed;
            if (panel_collapsed) panel_h = collapsed_h;
            else syncPanelHeight();
        }
    }
    if (dragging || resizing) {
        saveLayout();
    }
    dragging = false;
    resizing = false;
}

// --- Scroll ---
if (!panel_collapsed && overPanel && !dragging && !resizing && !overFilter) {
    if (mouse_wheel_up()) {
        global.duel_log_scroll = max(0, global.duel_log_scroll - 1);
    }
    if (mouse_wheel_down()) {
        var maxScroll = max(0, countLogDisplayLines() - visible_line_count);
        global.duel_log_scroll = min(maxScroll, global.duel_log_scroll + 1);
    }
}
