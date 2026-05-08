
var gw = display_get_gui_width();
var gh = display_get_gui_height();

var panel_spr = asset_get_index("sCadreQuete");
var panel_scale = 1;
var panel_w = width;
var panel_h = height;

if (panel_spr != -1) {
    var spr_w = sprite_get_width(panel_spr);
    var spr_h = sprite_get_height(panel_spr);
    panel_scale = min((gw * 0.98) / spr_w, (gh * 0.86) / spr_h);
    panel_scale = clamp(panel_scale, 0.5, 1.0);
    panel_w = spr_w * panel_scale;
    panel_h = spr_h * panel_scale;
    width = panel_w;
    height = panel_h;
}

x = (gw - panel_w) * 0.5;
y = (gh - panel_h) * 0.5;

// Fond sombre global
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

if (panel_spr != -1) {
    var ox = sprite_get_xoffset(panel_spr);
    var oy = sprite_get_yoffset(panel_spr);
    draw_sprite_ext(panel_spr, 0, x + (ox * panel_scale), y + (oy * panel_scale), panel_scale, panel_scale, 0, c_white, 1);
} else {
    draw_set_color(color_panel);
    draw_rectangle(x, y, x + width, y + height, false);
    draw_set_color(c_white);
    draw_rectangle(x, y, x + width, y + height, true);
}

var close_w = 200 * panel_scale;
var close_h = 50 * panel_scale;
var close_x = x + (panel_w * 0.5) - (close_w * 0.5);
var close_y = y + panel_h + (14 * panel_scale);

var mx_btn = device_mouse_x_to_gui(0);
var my_btn = device_mouse_y_to_gui(0);
var close_hover = point_in_rectangle(mx_btn, my_btn, close_x, close_y, close_x + close_w, close_y + close_h);

var close_spr = asset_get_index("sButton");
if (close_spr != -1) {
    var close_subimg = 0;
    if (close_hover && sprite_get_number(close_spr) > 1) close_subimg = 1;
    draw_sprite_stretched(close_spr, close_subimg, close_x, close_y, close_w, close_h);
} else {
    draw_set_color(c_red);
    draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, false);
}

var f_close = -1;
if (variable_global_exists("get_runtime_font")) f_close = global.get_runtime_font("title", round(18 * panel_scale));
if (f_close == -1) {
    if (font_exists(fontTitle)) f_close = fontTitle;
    else if (font_exists(fontText)) f_close = fontText;
    else if (font_exists(fontUI)) f_close = fontUI;
}
if (f_close != -1) draw_set_font(f_close);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text(close_x + close_w * 0.5 + 2, close_y + close_h * 0.5 + 2, "Fermer");
draw_set_color(make_color_rgb(230, 200, 120));
draw_text(close_x + close_w * 0.5, close_y + close_h * 0.5, "Fermer");

global.quest_panel_close_rect = { x1: close_x, y1: close_y, x2: close_x + close_w, y2: close_y + close_h };

// === CONTENU ===

if (!instance_exists(oQuestManager)) {
    draw_text(x + width/2, y + 100, "Erreur: oQuestManager introuvable.");
    exit;
}

var qm = oQuestManager;
var slots = ["A", "B", "C"];

// Afficher prochaine reset
var now = date_current_datetime();
var next = qm.next_reset_time;
if (next > 0) {
    var diff = date_second_span(now, next);
    var hours = floor(diff / 3600);
    var mins = floor((diff % 3600) / 60);
    draw_set_halign(fa_right);
    draw_text(x + panel_w - (40 * panel_scale), y + (24 * panel_scale), "Reset dans: " + string(hours) + "h " + string(mins) + "m");
}

// Map pour les boutons (reset à chaque frame pour la détection de clic)
global.quest_panel_buttons = [];

var card_margin_x = 120 * panel_scale;
var card_gap_x = 70 * panel_scale;
var card_top = y + (120 * panel_scale);
var card_bottom = y + panel_h - (90 * panel_scale);
var card_h = max(10, card_bottom - card_top);
var card_w = max(10, (panel_w - (card_margin_x * 2) - (card_gap_x * 2)) / 3);

var quest_layout = [
    { title_x: 151, title_y: 37, desc_x1: 26, desc_y1: 62, desc_x2: 280, desc_y2: 83, reward_x: 137, reward_y: 348, bar_x1: 57, bar_y1: 398, bar_x2: 257, bar_y2: 410, btn_x1: 40, btn_y1: 423, btn_x2: 266, btn_y2: 439 },
    { title_x: 151, title_y: 37, desc_x1: 26, desc_y1: 62, desc_x2: 280, desc_y2: 83, reward_x: 137, reward_y: 348, bar_x1: 48, bar_y1: 398, bar_x2: 256, bar_y2: 410, btn_x1: 40, btn_y1: 423, btn_x2: 266, btn_y2: 439 },
    { title_x: 153, title_y: 38, desc_x1: 26, desc_y1: 62, desc_x2: 280, desc_y2: 83, reward_x: 136, reward_y: 358, bar_x1: 46, bar_y1: 398, bar_x2: 248, bar_y2: 410, btn_x1: 33, btn_y1: 423, btn_x2: 273, btn_y2: 441 }
];

for (var i = 0; i < array_length(slots); i++) {
    var slot = slots[i];
    var q = qm.quest_slots[$ slot];

    if (q == noone) continue;
    
    var l = quest_layout[i];
    
    var card_x = x + card_margin_x + i * (card_w + card_gap_x);
    
    var title_x = card_x + (l.title_x * panel_scale);
    var title_y = card_top + (l.title_y * panel_scale);
    
    var desc_x = card_x + (l.desc_x1 * panel_scale);
    var desc_y = card_top + (l.desc_y1 * panel_scale);
    var desc_w = max(10, ((l.desc_x2 - l.desc_x1) * panel_scale));
    
    var bar_x = card_x + (l.bar_x1 * panel_scale);
    var bar_y = card_top + (l.bar_y1 * panel_scale);
    var bar_w = max(1, ((l.bar_x2 - l.bar_x1) * panel_scale));
    var bar_h = max(1, ((l.bar_y2 - l.bar_y1) * panel_scale));
    
    var btn_cx = card_x + (((l.btn_x1 + l.btn_x2) * 0.5) * panel_scale);
    var btn_cy = card_top + (((l.btn_y1 + l.btn_y2) * 0.5) * panel_scale);
    var btn_w = max(160 * panel_scale, ((l.btn_x2 - l.btn_x1) * panel_scale));
    var btn_h = max(28 * panel_scale, ((l.btn_y2 - l.btn_y1) * panel_scale));
    var btn_x = btn_cx - (btn_w * 0.5);
    var btn_y = btn_cy - (btn_h * 0.5);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_ltgray);
    if (font_exists(fontText)) draw_set_font(fontText);
    draw_text(title_x, title_y, "Quête " + slot);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    var line_sep = 20 * panel_scale;
    draw_text_ext(desc_x, desc_y, q.description, line_sep, desc_w);
    
    var pct = (q.target_amount > 0) ? clamp(q.current_progress / q.target_amount, 0, 1) : 0;
    
    var bar_fill_col = q.claimed ? c_dkgray : make_color_rgb(120, 210, 255);
    
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    draw_set_alpha(q.claimed ? 0.4 : 0.9);
    draw_set_color(bar_fill_col);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w * pct, bar_y + bar_h, false);
    draw_set_alpha(1);
    // Texte
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var prog_text = string(floor(q.current_progress)) + " / " + string(q.target_amount);
    if (q.claimed) prog_text = "Terminée";
    draw_text(bar_x + bar_w/2, bar_y + bar_h/2, prog_text);
    
    // Récompense
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    var reward_x = card_x + (l.reward_x * panel_scale);
    var reward_y = card_top + (l.reward_y * panel_scale);
    draw_text(reward_x, reward_y, string(q.reward_amount) + " Or");
    
    // Boutons Action
    if (q.claimed) {
        // Checkmark
        draw_set_color(c_green);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(card_x + (card_w * 0.5), btn_y + btn_h * 0.5, "✓ Reçu");
    } else if (pct >= 1) {
        // CLAIM BUTTON
        draw_set_color(c_yellow);
        draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(btn_x + btn_w * 0.5, btn_y + btn_h * 0.5, "RÉCLAMER");
        
        array_push(global.quest_panel_buttons, { 
            type: "claim", 
            slot: slot, 
            rect: { x1: btn_x, y1: btn_y, x2: btn_x + btn_w, y2: btn_y + btn_h } 
        });
    } else {
        // REROLL BUTTON (pas Slot A)
        if (slot != "A") {
            var reroll_ok = qm.reroll_available;
            mx_btn = device_mouse_x_to_gui(0);
            my_btn = device_mouse_y_to_gui(0);
            var hover_btn = point_in_rectangle(mx_btn, my_btn, btn_x, btn_y, btn_x + btn_w, btn_y + btn_h);
            
            var spr_btn = asset_get_index("sButton");
            if (spr_btn != -1) {
                var subimg_btn = 0;
                if (reroll_ok && hover_btn && sprite_get_number(spr_btn) > 1) subimg_btn = 1;
                draw_set_alpha(reroll_ok ? 1 : 0.45);
                draw_sprite_stretched(spr_btn, subimg_btn, btn_x, btn_y, btn_w, btn_h);
                draw_set_alpha(1);
            } else {
                draw_set_alpha(reroll_ok ? 1 : 0.45);
                draw_set_color(c_red);
                draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
                draw_set_alpha(1);
            }
            
            var f_btn = -1;
            if (variable_global_exists("get_runtime_font")) f_btn = global.get_runtime_font("title", round(18 * panel_scale));
            if (f_btn == -1) {
                if (font_exists(fontTitle)) f_btn = fontTitle;
                else if (font_exists(fontText)) f_btn = fontText;
                else if (font_exists(fontUI)) f_btn = fontUI;
            }
            if (f_btn != -1) draw_set_font(f_btn);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(reroll_ok ? c_black : c_dkgray);
            draw_text(btn_x + btn_w * 0.5 + 2, btn_y + btn_h * 0.5 + 2, "Relancer");
            draw_set_color(reroll_ok ? make_color_rgb(230, 200, 120) : c_gray);
            draw_text(btn_x + btn_w * 0.5, btn_y + btn_h * 0.5, "Relancer");
            
            if (reroll_ok) {
                array_push(global.quest_panel_buttons, { 
                    type: "reroll", 
                    slot: slot, 
                    rect: { x1: btn_x, y1: btn_y, x2: btn_x + btn_w, y2: btn_y + btn_h } 
                });
            }
        }
    }
    
    draw_set_valign(fa_top); // Reset
}
