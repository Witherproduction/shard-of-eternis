
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Centrer le panel si la fenêtre change
x = gw / 2 - width / 2;
y = gh / 2 - height / 2;

// Fond sombre global
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

// Fond du Panel
draw_set_color(color_panel);
draw_rectangle(x, y, x + width, y + height, false);
// Bordure
draw_set_color(c_white);
draw_rectangle(x, y, x + width, y + height, true);

// Titre
draw_set_halign(fa_center);
draw_set_valign(fa_top);
// draw_set_font(fnt_text_fr); // Font not found
draw_set_color(c_white);
draw_text(x + width / 2, y + 20, "QUÊTES QUOTIDIENNES");

// Bouton Fermer (X)
var close_x = x + width - 40;
var close_y = y + 10;
var close_w = 30;
var close_h = 30;
draw_set_color(c_red);
draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, false);
draw_set_color(c_white);
draw_text(close_x + close_w/2, close_y + 5, "X");

// Register hitbox (simple global vars or just check in step)
global.quest_panel_close_rect = { x1: close_x, y1: close_y, x2: close_x + close_w, y2: close_y + close_h };

// === CONTENU ===

if (!instance_exists(oQuestManager)) {
    draw_text(x + width/2, y + 100, "Erreur: oQuestManager introuvable.");
    exit;
}

var qm = oQuestManager;
var slots = ["A", "B", "C"];
var row_h = 140; // Increased from 120
var start_y = y + 100; // Increased from 80

// Afficher info Reroll
var reroll_text = qm.reroll_available ? "Reroll disponible: 1/1" : "Reroll utilisé aujourd'hui";
draw_set_halign(fa_left);
draw_set_font(fontCardText); // Set font explicitly
draw_text(x + 20, y + 60, reroll_text);

// Afficher prochaine reset
var now = date_current_datetime();
var next = qm.next_reset_time;
if (next > 0) {
    var diff = date_second_span(now, next);
    var hours = floor(diff / 3600);
    var mins = floor((diff % 3600) / 60);
    draw_set_halign(fa_right);
    draw_text(x + width - 20, y + 60, "Reset dans: " + string(hours) + "h " + string(mins) + "m");
}

// Map pour les boutons (reset à chaque frame pour la détection de clic)
global.quest_panel_buttons = [];

for (var i = 0; i < array_length(slots); i++) {
    var slot = slots[i];
    var q = qm.quest_slots[$ slot];
    var row_y = start_y + i * (row_h + 10);
    var row_x = x + 20;
    var row_w = width - 40;
    
    // Fond de ligne
    draw_set_color(make_color_rgb(60, 60, 70));
    draw_rectangle(row_x, row_y, row_x + row_w, row_y + row_h, false);
    draw_set_color(c_gray);
    draw_rectangle(row_x, row_y, row_x + row_w, row_y + row_h, true);
    
    if (q == noone) continue;
    
    // Type Label (A, B, C)
    draw_set_color(c_ltgray);
    draw_set_halign(fa_left);
    draw_set_font(fontCardText); // Ensure font is set
    draw_text(row_x + 10, row_y + 10, "Quête " + slot);
    
    // Description
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    // draw_set_font(fnt_text_large);
    draw_text(row_x + 10, row_y + 40, q.description);
    // draw_set_font(fnt_text_fr);
    
    // Progress Bar
    var bar_w = 300;
    var bar_h = 20;
    var bar_x = row_x + 10;
    var bar_y = row_y + 90; // Increased from 80
    
    var pct = (q.target_amount > 0) ? clamp(q.current_progress / q.target_amount, 0, 1) : 0;
    
    // Fond barre
    draw_set_color(c_black);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    // Remplissage
    draw_set_color(q.claimed ? c_dkgray : (pct >= 1 ? c_lime : c_orange));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w * pct, bar_y + bar_h, false);
    // Texte
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var prog_text = string(floor(q.current_progress)) + " / " + string(q.target_amount);
    if (q.claimed) prog_text = "Terminée";
    draw_text(bar_x + bar_w/2, bar_y + bar_h/2, prog_text);
    
    // Récompense
    draw_set_halign(fa_right);
    draw_set_valign(fa_top); // Reset valign
    draw_set_color(c_yellow);
    draw_text(row_x + row_w - 20, row_y + 20, string(q.reward_amount) + " Or");
    
    // Boutons Action
    var btn_w = 100;
    var btn_h = 30;
    var btn_x = row_x + row_w - 120;
    var btn_y = row_y + 80; // Adjusted from 70
    
    if (q.claimed) {
        // Checkmark
        draw_set_color(c_green);
        draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "✓ Reçu");
    } else if (pct >= 1) {
        // CLAIM BUTTON
        draw_set_color(c_yellow);
        draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
        draw_set_color(c_black);
        draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "RÉCLAMER");
        
        array_push(global.quest_panel_buttons, { 
            type: "claim", 
            slot: slot, 
            rect: { x1: btn_x, y1: btn_y, x2: btn_x + btn_w, y2: btn_y + btn_h } 
        });
    } else {
        // REROLL BUTTON (Si dispo et pas Slot A)
        if (slot != "A" && qm.reroll_available) {
            draw_set_color(c_red);
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
            draw_set_color(c_white);
            draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "Reroll");
            
            array_push(global.quest_panel_buttons, { 
                type: "reroll", 
                slot: slot, 
                rect: { x1: btn_x, y1: btn_y, x2: btn_x + btn_w, y2: btn_y + btn_h } 
            });
        }
    }
    
    draw_set_valign(fa_top); // Reset
}
