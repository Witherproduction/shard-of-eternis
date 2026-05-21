/// @description Journal de duel — texte petit, déplaçable, redimensionnable
depth = -11000;
visible = true;

padding = 6;
line_h = 13;
line_gap = 5;
line_step = line_h + line_gap;
header_h = 20;
filter_bar_h = 16;
filter_chip_gap = 2;
filter_scale = 0.38;
log_filter = "all";
filter_ids = ["all", "hero", "enemy", "effect", "damage"];
filter_labels = ["Tout", "Moi", "Adv.", "Effet", "Dég."];
log_top = header_h + filter_bar_h + 6;
text_scale = 0.46;

panel_w = 220;
panel_h = 90;
panel_x = 14;
panel_y = 700;

panel_collapsed = false;
collapsed_h = 16;
header_click_h = 20;
toggle_zone_w = 14;
arrow_size = 8;
grip_size = 14;

panel_min_w = 150;
panel_min_h = 40;
panel_max_w = 480;
panel_max_h = 320;

visible_line_count = 5;

dragging = false;
resizing = false;
drag_off_x = 0;
drag_off_y = 0;
header_press_x = 0;
header_press_y = 0;
user_custom_layout = false;

applyDefaultLayout = function() {
    panel_w = 220;
    panel_collapsed = false;
    visible_line_count = 5;
    syncPanelHeight();

    panel_x = 14;
    var lp = instance_find(oLP_Hero, 0);
    var viewerBottom = 580;
    if (lp != noone && instance_exists(lp)) {
        panel_y = lp.y - panel_h - 16;
    } else {
        panel_y = 700;
    }
    panel_y = max(viewerBottom, panel_y);

    var gh = display_get_gui_height();
    if (gh <= 0) gh = 1080;
    if (panel_y + panel_h > gh - 6) panel_y = gh - panel_h - 6;
};

syncPanelHeight = function() {
    if (panel_collapsed) {
        panel_h = collapsed_h;
    } else {
        panel_h = log_top + visible_line_count * line_step + padding;
        panel_h = clamp(panel_h, panel_min_h, panel_max_h);
    }
};

syncVisibleLinesFromHeight = function() {
    if (panel_collapsed) return;
    var inner = panel_h - log_top - padding;
    visible_line_count = max(1, floor(inner / line_step));
};

getFilterChipWidth = function() {
    var n = array_length(filter_ids);
    if (n <= 0) return 40;
    return max(28, (panel_w - padding * 2 - filter_chip_gap * (n - 1)) / n);
};

getFilterChipRect = function(_index) {
    var chipW = getFilterChipWidth();
    var fx = panel_x + padding + _index * (chipW + filter_chip_gap);
    var fy = panel_y + header_h + 1;
    return [fx, fy, fx + chipW, fy + filter_bar_h - 2];
};

hitTestFilterChip = function(_mx, _my) {
    if (panel_collapsed) return "";
    for (var fi = 0; fi < array_length(filter_ids); fi++) {
        var r = getFilterChipRect(fi);
        if (_mx >= r[0] && _mx <= r[2] && _my >= r[1] && _my <= r[3]) {
            return filter_ids[fi];
        }
    }
    return "";
};

setLogFilter = function(_filterId) {
    log_filter = _filterId;
    if (!variable_global_exists("duel_log_scroll")) global.duel_log_scroll = 0;
    else global.duel_log_scroll = 0;
};

logEntryPassesFilter = function(_entry) {
    if (script_exists(asset_get_index("duelLogEntryPassesFilter"))) {
        return duelLogEntryPassesFilter(_entry, log_filter);
    }
    return true;
};

// Flèche replier/déplier (sans caractères Unicode)
drawGuiFoldArrow = function(_x, _y, _sz, _collapsed, _col) {
    draw_set_color(_col);
    if (_collapsed) {
        var x1 = _x;
        var y1 = _y + _sz * 0.2;
        var x2 = _x;
        var y2 = _y + _sz * 0.8;
        var x3 = _x + _sz * 0.75;
        var y3 = _y + _sz * 0.5;
        draw_triangle(x1, y1, x2, y2, x3, y3, false);
    } else {
        var x1 = _x;
        var y1 = _y;
        var x2 = _x + _sz;
        var y2 = _y;
        var x3 = _x + _sz * 0.5;
        var y3 = _y + _sz * 0.7;
        draw_triangle(x1, y1, x2, y2, x3, y3, false);
    }
};

// Petite flèche « résumé » (pointe vers la droite)
drawGuiSummaryArrow = function(_x, _y, _sz, _col) {
    draw_set_color(_col);
    draw_triangle(_x, _y + _sz * 0.15, _x, _y + _sz * 0.85, _x + _sz * 0.7, _y + _sz * 0.5, false);
};

getLogTextMaxWidth = function() {
    return max(40, (panel_w - padding * 2) / text_scale);
};

/// Découpe un mot trop long caractère par caractère
_wrapLongWord = function(_word, _maxW, _lines) {
    var chunk = "";
    for (var ci = 1; ci <= string_length(_word); ci++) {
        var ch = string_char_at(_word, ci);
        var test = chunk + ch;
        if (string_width(test) > _maxW && chunk != "") {
            array_push(_lines, chunk);
            chunk = ch;
        } else {
            chunk = test;
        }
    }
    if (chunk != "") array_push(_lines, chunk);
    return "";
};

wrapTextToLines = function(_text, _maxW) {
    var lines = [];
    var txt = string(_text);
    if (txt == "") {
        array_push(lines, "");
        return lines;
    }
    if (string_width(txt) <= _maxW) {
        array_push(lines, txt);
        return lines;
    }
    var words = string_split(txt, " ");
    var cur = "";
    for (var wi = 0; wi < array_length(words); wi++) {
        var word = words[wi];
        if (word == "") continue;
        if (string_width(word) > _maxW) {
            if (cur != "") {
                array_push(lines, cur);
                cur = "";
            }
            cur = _wrapLongWord(word, _maxW, lines);
            continue;
        }
        var test = (cur == "") ? word : (cur + " " + word);
        if (string_width(test) <= _maxW) {
            cur = test;
        } else {
            if (cur != "") array_push(lines, cur);
            cur = word;
        }
    }
    if (cur != "") array_push(lines, cur);
    if (array_length(lines) == 0) array_push(lines, txt);
    return lines;
};

_ensureLogPanelFont = function() {
    var fnt = font_exists(fontUI) ? fontUI : (font_exists(fontText) ? fontText : -1);
    if (fnt != -1) draw_set_font(fnt);
};

countLogDisplayLines = function() {
    if (!variable_global_exists("duel_log")) return 0;
    _ensureLogPanelFont();
    var maxW = getLogTextMaxWidth();
    var total = 0;
    var logArr = global.duel_log;
    for (var i = 0; i < array_length(logArr); i++) {
        var entry = logArr[i];
        if (!is_struct(entry) || !variable_struct_exists(entry, "text")) continue;
        if (!logEntryPassesFilter(entry)) continue;
        var prefix = variable_struct_exists(entry, "turn") ? ("[T" + string(entry.turn) + "] ") : "";
        var wrapped = wrapTextToLines(prefix + entry.text, maxW);
        total += max(1, array_length(wrapped));
    }
    return total;
};

buildLogDisplayLines = function() {
    var result = [];
    if (!variable_global_exists("duel_log")) return result;
    _ensureLogPanelFont();
    var maxW = getLogTextMaxWidth();
    var logArr = global.duel_log;
    for (var i = 0; i < array_length(logArr); i++) {
        var entry = logArr[i];
        if (!is_struct(entry) || !variable_struct_exists(entry, "text")) continue;
        if (!logEntryPassesFilter(entry)) continue;
        var kind = variable_struct_exists(entry, "kind") ? entry.kind : "";
        var turnN = variable_struct_exists(entry, "turn") ? entry.turn : 0;
        var prefix = (turnN > 0) ? ("[T" + string(turnN) + "] ") : "";
        var wrapped = wrapTextToLines(prefix + entry.text, maxW);
        for (var wi = 0; wi < array_length(wrapped); wi++) {
            array_push(result, { text: wrapped[wi], kind: kind });
        }
    }
    return result;
};

// Poignée : 3 traits diagonaux parallèles
drawGuiResizeGrip = function(_px, _py, _pw, _ph, _col) {
    draw_set_color(_col);
    var xR = _px + _pw - 2;
    var yB = _py + _ph - 2;
    var span = grip_size - 4;
    for (var gi = 0; gi < 3; gi++) {
        var d = gi * 4;
        var lx = xR - span + d;
        var ty = yB - span + d;
        draw_line(lx, yB, xR, ty);
    }
};

clampPanelToGui = function() {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    if (gw <= 0) gw = 1920;
    if (gh <= 0) gh = 1080;
    panel_w = clamp(panel_w, panel_min_w, panel_max_w);
    panel_h = clamp(panel_h, panel_collapsed ? collapsed_h : panel_min_h, panel_max_h);
    panel_x = clamp(panel_x, 0, gw - panel_w);
    panel_y = clamp(panel_y, 0, gh - panel_h);
};

saveLayout = function() {
    global.duel_log_panel_x = panel_x;
    global.duel_log_panel_y = panel_y;
    global.duel_log_panel_w = panel_w;
    global.duel_log_panel_h = panel_h;
    global.duel_log_panel_collapsed = panel_collapsed;
    global.duel_log_panel_lines = visible_line_count;
    global.duel_log_panel_filter = log_filter;
    user_custom_layout = true;
};

loadLayout = function() {
    if (!variable_global_exists("duel_log_panel_w")) return false;
    panel_x = global.duel_log_panel_x;
    panel_y = global.duel_log_panel_y;
    panel_w = global.duel_log_panel_w;
    panel_h = global.duel_log_panel_h;
    panel_collapsed = global.duel_log_panel_collapsed;
    if (variable_global_exists("duel_log_panel_lines")) {
        visible_line_count = max(1, global.duel_log_panel_lines);
    }
    if (variable_global_exists("duel_log_panel_filter")) {
        log_filter = global.duel_log_panel_filter;
    }
    if (!panel_collapsed) syncVisibleLinesFromHeight();
    clampPanelToGui();
    user_custom_layout = true;
    return true;
};

if (!loadLayout()) {
    applyDefaultLayout();
}

if (!variable_global_exists("duel_feedback_ready")) {
    duelFeedbackInit();
}
duelFeedbackEnsureUI();
