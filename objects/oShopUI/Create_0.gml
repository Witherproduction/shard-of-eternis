button_width = 400;
button_height = 100;
x = 960;
y = 540;
cost = 100;
pack_size = 5;
last_pack_names = [];
pack_timer = 0;
p_upgrade_rare = 0.20;
p_upgrade_epic = 0.08;
p_upgrade_legendary = 0.02;
confirm_open = false;
reveal_active = false;
reveal_cards = [];
reveal_index = 0;
reveal_anim_t = 0;
reveal_t = 0;
reveal_stage = 0; // 0: slide-in, 1: flip, 2: hold
reveal_face = 1;  // 1: back, 0: front
portal_scale = 0;
portal_state = 0; // 0 idle, 1 grow, 6 shrink
reveal_sequence = false;
reveal_ready = false;
reveal_wait_frames = round(room_speed * 1.3);
portal_done = false;
loading_active = false;
loading_timer = 0;
loading_angle = 0;
loading_idx = 0;
loading_elapsed = 0;
loading_min_frames = round(room_speed * 0.7);
buy_quantity = 1;
buy_qty_edit_mode = false;
buy_qty_input = "";
qty_font_name = "Consolas";
qty_font_bold = false;
qty_font_sizes = [];
qty_font_fonts = [];
get_qty_font = function(_size) {
    _size = clamp(round(_size), 8, 64);
    var n = array_length(qty_font_sizes);
    for (var i = 0; i < n; i++) {
        if (qty_font_sizes[i] == _size) return qty_font_fonts[i];
    }
    var f = font_add(qty_font_name, _size, qty_font_bold, false, 32, 255);
    if (f == -1 && os_type == os_windows) {
        var candidates = ["C:\\Windows\\Fonts\\consola.ttf", "C:\\Windows\\Fonts\\arial.ttf", "C:\\Windows\\Fonts\\tahoma.ttf"];
        for (var c = 0; c < array_length(candidates); c++) {
            var p = candidates[c];
            if (file_exists(p)) {
                f = font_add(p, _size, qty_font_bold, false, 32, 255);
                if (f != -1) break;
            }
        }
    }
    if (f != -1) {
        array_push(qty_font_sizes, _size);
        array_push(qty_font_fonts, f);
        return f;
    }
    if (variable_global_exists("get_runtime_font")) return global.get_runtime_font("text", _size);
    if (font_exists(fontText)) return fontText;
    if (font_exists(fontTitle)) return fontTitle;
    if (font_exists(fontUI)) return fontUI;
    return -1;
};
