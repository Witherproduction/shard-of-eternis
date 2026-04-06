text = "";

start_ms = current_time;
fade_in_ms = 250;
hold_ms = 2000;
fade_out_ms = 250;

window_width = 520;
window_height = 90;
margin_top = 60;
corner_radius = 14;
min_width = 420;
max_width = 900;
min_height = 90;
padding_x = 40;
padding_y = 28;
line_sep = 30;
center_on_screen = true;
anchor_to_enemy_field = false;
anchor_to_enemy_lp = false;
anchor_offset_y = 10;
screen_margin = 10;

window_color = make_color_rgb(40, 40, 40);
border_color = make_color_rgb(230, 200, 120);
text_color = c_white;

font = fontTitle;

show_portrait = true;
portrait_sprite = -1;
portrait_size = 96;
portrait_gap = 16;

show_tail = false;
tail_width = 34;
tail_height = 18;
tail_to_enemy = true;

function setText(_text) {
    text = string(_text);
    start_ms = current_time;
}

function setTiming(_hold_ms, _fade_in_ms = 250, _fade_out_ms = 250) {
    hold_ms = max(0, real(_hold_ms));
    fade_in_ms = max(0, real(_fade_in_ms));
    fade_out_ms = max(0, real(_fade_out_ms));
    start_ms = current_time;
}

function setPortrait(_spr, _size = 96) {
    var spr_idx = -1;
    if (is_string(_spr)) spr_idx = asset_get_index(_spr);
    else spr_idx = _spr;
    portrait_sprite = spr_idx;
    portrait_size = max(0, real(_size));
}
