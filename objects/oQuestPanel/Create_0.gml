
// === CONFIG ===
var panel_spr = asset_get_index("sCadreQuete");
width = 800;
height = 600;
if (panel_spr != -1) {
    width = sprite_get_width(panel_spr);
    height = sprite_get_height(panel_spr);
}
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

if (instance_exists(oLayoutDebugger)) {
    instance_destroy(oLayoutDebugger);
}
global.show_green_frames = false;
global.debug_selected_field = "";
