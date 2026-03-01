
// === CONFIG ===
width = 800;
height = 600;
x = display_get_gui_width() / 2 - width / 2;
y = display_get_gui_height() / 2 - height / 2;

// Buttons geometry
close_btn_rect = { x: width - 40, y: 10, w: 30, h: 30 };
reroll_btn_rects = {}; // Map of slot -> rect
claim_btn_rects = {};  // Map of slot -> rect

// Assets (simulated if missing)
color_bg = c_dkgray;
color_panel = make_color_rgb(40, 40, 50);
color_accent = make_color_rgb(200, 180, 100); // Gold-ish

// Refresh data
quests = {};
if (instance_exists(oQuestManager)) {
    quests = oQuestManager.quest_slots;
}

hover_slot = "";
hover_action = ""; // "claim", "reroll", "close"
