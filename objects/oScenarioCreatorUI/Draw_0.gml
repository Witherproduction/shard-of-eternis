function draw_slot(r, label) {
    var l = r.x - r.w * 0.5;
    var t = r.y - r.h * 0.5;
    var rt = r.x + r.w * 0.5;
    var b = r.y + r.h * 0.5;
    draw_set_color(c_dkgray);
    draw_rectangle(l, t, rt, b, false);
    draw_set_color(c_black);
    draw_rectangle(l, t, rt, b, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(r.x, t - 24, label);
}

var k = min(room_width / 1920, room_height / 1080);
var text_pad = 12 * k;

function draw_accueil_button(x1, y1, x2, y2, label, hover) {
    var w = x2 - x1;
    var h = y2 - y1;
    var subimg = 0;
    if (hover && sprite_get_number(sButton) > 1) subimg = 1;
    draw_sprite_stretched(sButton, subimg, x1, y1, w, h);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var px = max(10, round(16 * k));
    var f = -1;
    if (variable_global_exists("get_runtime_font")) f = global.get_runtime_font("title", px);
    if (f == -1) {
        if (font_exists(fontTitle)) f = fontTitle;
        else if (font_exists(fontText)) f = fontText;
        else if (font_exists(fontUI)) f = fontUI;
    }
    if (f != -1) draw_set_font(f);
    var sc = 1;
    if (f != -1) {
        var base_sz = font_get_size(f);
        if (base_sz > 0) sc = px / base_sz;
    }
    var cx = (x1 + x2) * 0.5;
    var cy = (y1 + y2) * 0.5;
    draw_set_color(c_black);
    draw_text_transformed(cx + 2, cy + 2, label, sc, sc, 0);
    draw_set_color(make_color_rgb(230, 200, 120));
    draw_text_transformed(cx, cy, label, sc, sc, 0);
}

function draw_field(x1, y1, x2, y2, label, value, focused, pad) {
    draw_set_color(make_color_rgb(35, 35, 35));
    draw_roundrect(x1, y1, x2, y2, true);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(x1, y1, x2, y2, false);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(focused ? c_yellow : c_white);
    var cx = x1 + pad;
    var cy = (y1 + y2) * 0.5;
    draw_text(cx, cy, label + ": " + value);
    
    if (focused) {
        var prefix = label + ": ";
        var prefix_w = string_width(prefix);
        var sub_val = string_copy(value, 1, cursor_pos);
        var sub_w = string_width(sub_val);
        var cur_x = cx + prefix_w + sub_w;
        var cur_h = string_height("M");
        draw_line(cur_x, cy - cur_h * 0.4, cur_x, cy + cur_h * 0.4);
    }
}

// Background
var bg_spr = -1;
if (current.bg_name != "") bg_spr = asset_get_index(current.bg_name);
if (bg_spr != -1) draw_sprite_stretched(bg_spr, 0, 0, 0, room_width, room_height);

// Slots
if (sp1_enabled) draw_slot(speaker1, "Speaker 1");
if (sp2_enabled) draw_slot(speaker2, "Speaker 2");
if (sp3_enabled) draw_slot(speaker3, "Speaker 3");
if (textbox_enabled) {
    var s_contour = asset_get_index("sContourTexte");
    if (s_contour != -1) {
        draw_sprite(s_contour, 0, textbox.x, textbox.y);
        // Logical contour
        var r = textbox;
        var l = r.x - r.w * 0.5;
        var t = r.y - r.h * 0.5;
        var rt = r.x + r.w * 0.5;
        var b = r.y + r.h * 0.5;
        draw_set_color(c_black);
        draw_rectangle(l, t, rt, b, true);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(r.x, t - 24, "Cadre texte");
    } else {
        draw_slot(textbox, "Cadre texte");
    }
}
if (obj1_enabled) draw_slot(object1, "Objet 1");
if (obj2_enabled) draw_slot(object2, "Objet 2");

// Portraits / Sprites
var s1 = asset_get_index(current.portrait1_name);
if (sp1_enabled && s1 != -1) {
    var sx = speaker1.x; var sy = speaker1.y;
    var sw = sprite_get_width(s1); var sh = sprite_get_height(s1);
    var scx = speaker1.w / sw; var scy = speaker1.h / sh;
    var sc = min(scx, scy);
    var sign1 = (variable_struct_exists(current, "speaker1_flip") && current.speaker1_flip) ? -1 : 1;
    draw_sprite_ext(s1, 0, sx, sy, sc * sign1, sc, 0, c_white, 1);
}

var s2 = asset_get_index(current.portrait2_name);
if (sp2_enabled && s2 != -1) {
    var sx2 = speaker2.x; var sy2 = speaker2.y;
    var sw2 = sprite_get_width(s2); var sh2 = sprite_get_height(s2);
    var scx2 = speaker2.w / sw2; var scy2 = speaker2.h / sh2;
    var sc2 = min(scx2, scy2);
    var sign2 = (variable_struct_exists(current, "speaker2_flip") && current.speaker2_flip) ? -1 : 1;
    draw_sprite_ext(s2, 0, sx2, sy2, sc2 * sign2, sc2, 0, c_white, 1);
}

var s3 = asset_get_index(current.portrait3_name);
if (sp3_enabled && s3 != -1) {
    var sx3 = speaker3.x; var sy3 = speaker3.y;
    var sw3 = sprite_get_width(s3); var sh3 = sprite_get_height(s3);
    var scx3 = speaker3.w / sw3; var scy3 = speaker3.h / sh3;
    var sc3 = min(scx3, scy3);
    var sign3 = (variable_struct_exists(current, "speaker3_flip") && current.speaker3_flip) ? -1 : 1;
    draw_sprite_ext(s3, 0, sx3, sy3, sc3 * sign3, sc3, 0, c_white, 1);
}

var o1 = asset_get_index(current.obj1_name);
if (obj1_enabled && o1 != -1) {
    var ox1 = object1.x; var oy1 = object1.y;
    var ow1 = sprite_get_width(o1); var oh1 = sprite_get_height(o1);
    var ocx1 = object1.w / ow1; var ocy1 = object1.h / oh1;
    var oc1 = min(ocx1, ocy1);
    var osign1 = (variable_struct_exists(current, "obj1_flip") && current.obj1_flip) ? -1 : 1;
    draw_sprite_ext(o1, 0, ox1, oy1, oc1 * osign1, oc1, 0, c_white, 1);
}

var o2 = asset_get_index(current.obj2_name);
if (obj2_enabled && o2 != -1) {
    var ox2 = object2.x; var oy2 = object2.y;
    var ow2 = sprite_get_width(o2); var oh2 = sprite_get_height(o2);
    var ocx2 = object2.w / ow2; var ocy2 = object2.h / oh2;
    var oc2 = min(ocx2, ocy2);
    var osign2 = (variable_struct_exists(current, "obj2_flip") && current.obj2_flip) ? -1 : 1;
    draw_sprite_ext(o2, 0, ox2, oy2, oc2 * osign2, oc2, 0, c_white, 1);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
var txl = textbox.x - textbox.w * 0.5 + textbox.margin;
var txr = textbox.x + textbox.w * 0.5 - textbox.margin;
var tyt = textbox.y - textbox.h * 0.5 + textbox.margin;
var max_w = txr - txl;
var display_text = string(current.text);
var line_h = string_height("M");
var sep = line_h;

if (textbox_enabled) {
    var len = string_length(display_text);
    var line_start = 1;
    var line_index = 0;
    var caret_x = txl;
    var caret_y = tyt + line_h * 0.5;
    var remaining = cursor_pos;
    if (remaining < 0) remaining = 0;
    if (remaining > len) remaining = len;
    var caret_set = false;

    if (len > 0) {
        while (line_start <= len) {
            var line_end = line_start;
            var last_space = -1;
            var i = line_start;
            while (i <= len) {
                var ch = string_char_at(display_text, i);
                if (ch == " ") last_space = i;
                var seg = string_copy(display_text, line_start, i - line_start + 1);
                if (string_width(seg) > max_w) {
                    if (last_space >= line_start) {
                        line_end = last_space;
                    } else {
                        line_end = i - 1;
                        if (line_end < line_start) line_end = line_start;
                    }
                    break;
                } else {
                    line_end = i;
                }
                i++;
            }

            var line_text = string_copy(display_text, line_start, line_end - line_start + 1);
            var line_y = tyt + line_index * sep;
            draw_text(txl, line_y, line_text);

            if (field_focused == "text" && !caret_set) {
                var line_len = string_length(line_text);
                if (remaining <= 0) {
                    caret_x = txl;
                    caret_y = line_y + line_h * 0.5;
                    caret_set = true;
                } else if (remaining < line_len) {
                    var sub = string_copy(line_text, 1, remaining);
                    caret_x = txl + string_width(sub);
                    caret_y = line_y + line_h * 0.5;
                    caret_set = true;
                } else if (remaining == line_len) {
                    caret_x = txl + string_width(line_text);
                    caret_y = line_y + line_h * 0.5;
                    caret_set = true;
                    remaining = 0;
                } else {
                    remaining -= line_len;
                }
            }

            line_start = line_end + 1;
            line_index++;
        }
    }

    if (field_focused == "text") {
        if (!caret_set) {
            caret_x = txl;
            caret_y = tyt + line_h * 0.5;
        }
        draw_line(caret_x, caret_y - line_h * 0.5, caret_x, caret_y + line_h * 0.5);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var col_x2 = room_width - btn_margin;
var col_x1 = col_x2 - btn_w;
var col_y = btn_margin;

btn_load_x1 = col_x1;
btn_load_y1 = col_y;
btn_load_x2 = col_x2;
btn_load_y2 = btn_load_y1 + btn_h;
col_y = btn_load_y2 + btn_margin;

btn_save_x1 = col_x1;
btn_save_y1 = col_y;
btn_save_x2 = col_x2;
btn_save_y2 = btn_save_y1 + btn_h;
col_y = btn_save_y2 + btn_margin;

btn_delete_x1 = col_x1;
btn_delete_y1 = col_y;
btn_delete_x2 = col_x2;
btn_delete_y2 = btn_delete_y1 + btn_h;
col_y = btn_delete_y2 + btn_margin;

btn_quit_x1 = col_x1;
btn_quit_y1 = col_y;
btn_quit_x2 = col_x2;
btn_quit_y2 = btn_quit_y1 + btn_h;

btn_save_hover = point_in_rectangle(mouse_x, mouse_y, btn_save_x1, btn_save_y1, btn_save_x2, btn_save_y2);
btn_delete_hover = point_in_rectangle(mouse_x, mouse_y, btn_delete_x1, btn_delete_y1, btn_delete_x2, btn_delete_y2);
btn_load_hover = point_in_rectangle(mouse_x, mouse_y, btn_load_x1, btn_load_y1, btn_load_x2, btn_load_y2);
btn_quit_hover = point_in_rectangle(mouse_x, mouse_y, btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2);

draw_accueil_button(btn_save_x1, btn_save_y1, btn_save_x2, btn_save_y2, "Enregistrer", btn_save_hover);
draw_accueil_button(btn_delete_x1, btn_delete_y1, btn_delete_x2, btn_delete_y2, "Supprimer", btn_delete_hover);
draw_accueil_button(btn_load_x1, btn_load_y1, btn_load_x2, btn_load_y2, "Charger", btn_load_hover);
draw_accueil_button(btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2, "Quitter", btn_quit_hover);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var small_h = btn_h * 0.8;
var small_w = btn_w * 0.6;
chap_field_x1 = btn_margin;
chap_field_y1 = btn_margin;
chap_field_x2 = chap_field_x1 + small_w;
chap_field_y2 = chap_field_y1 + small_h;
var cmw = small_h; var cpw = small_h;
btn_chap_minus_x1 = chap_field_x2 + btn_margin * 0.5;
btn_chap_minus_y1 = chap_field_y1;
btn_chap_minus_x2 = btn_chap_minus_x1 + cmw;
btn_chap_minus_y2 = chap_field_y1 + small_h;
btn_chap_plus_x1 = btn_chap_minus_x2 + btn_margin * 0.5;
btn_chap_plus_y1 = chap_field_y1;
btn_chap_plus_x2 = btn_chap_plus_x1 + cpw;
btn_chap_plus_y2 = chap_field_y1 + small_h;

// Placer Acte juste sous Chapitre
act_field_x1 = chap_field_x1;
act_field_y1 = chap_field_y2 + btn_margin;
act_field_x2 = act_field_x1 + small_w;
act_field_y2 = act_field_y1 + small_h;
btn_act_minus_x1 = act_field_x2 + btn_margin * 0.5;
btn_act_minus_y1 = act_field_y1;
btn_act_minus_x2 = btn_act_minus_x1 + cmw;
btn_act_minus_y2 = act_field_y1 + small_h;
btn_act_plus_x1 = btn_act_minus_x2 + btn_margin * 0.5;
btn_act_plus_y1 = act_field_y1;
btn_act_plus_x2 = btn_act_plus_x1 + cpw;
btn_act_plus_y2 = act_field_y1 + small_h;

// Puis Scène sous Acte
scene_field_x1 = chap_field_x1;
scene_field_y1 = act_field_y2 + btn_margin;
scene_field_x2 = scene_field_x1 + small_w;
scene_field_y2 = scene_field_y1 + small_h;
btn_scene_minus_x1 = scene_field_x2 + btn_margin * 0.5;
btn_scene_minus_y1 = scene_field_y1;
btn_scene_minus_x2 = btn_scene_minus_x1 + cmw;
btn_scene_minus_y2 = scene_field_y1 + small_h;
btn_scene_plus_x1 = btn_scene_minus_x2 + btn_margin * 0.5;
btn_scene_plus_y1 = scene_field_y1;
btn_scene_plus_x2 = btn_scene_plus_x1 + cpw;
btn_scene_plus_y2 = scene_field_y1 + small_h;

btn_chap_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_chap_minus_x1, btn_chap_minus_y1, btn_chap_minus_x2, btn_chap_minus_y2);
btn_chap_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_chap_plus_x1, btn_chap_plus_y1, btn_chap_plus_x2, btn_chap_plus_y2);
btn_act_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_act_minus_x1, btn_act_minus_y1, btn_act_minus_x2, btn_act_minus_y2);
btn_act_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_act_plus_x1, btn_act_plus_y1, btn_act_plus_x2, btn_act_plus_y2);

 draw_field(chap_field_x1, chap_field_y1, chap_field_x2, chap_field_y2, "Chapitre", string(global.current_chapter), field_focused == "chapter", text_pad);
 draw_field(act_field_x1, act_field_y1, act_field_x2, act_field_y2, "Acte", string(global.current_act), field_focused == "act", text_pad);
 var totalScenes = array_length(editor_scenes);
 var sceneNum = (scene_idx >= 0) ? scene_idx + 1 : 0;
 var scene_val = string(sceneNum) + "/" + string(totalScenes);
 draw_field(scene_field_x1, scene_field_y1, scene_field_x2, scene_field_y2, "Scène", scene_val, false, text_pad);
var btn_scene_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_scene_minus_x1, btn_scene_minus_y1, btn_scene_minus_x2, btn_scene_minus_y2);
var btn_scene_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_scene_plus_x1, btn_scene_plus_y1, btn_scene_plus_x2, btn_scene_plus_y2);
draw_set_color(btn_scene_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_scene_minus_x1, btn_scene_minus_y1, btn_scene_minus_x2, btn_scene_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_scene_minus_x1, btn_scene_minus_y1, btn_scene_minus_x2, btn_scene_minus_y2, true);
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
draw_text((btn_scene_minus_x1+btn_scene_minus_x2)*0.5, (btn_scene_minus_y1+btn_scene_minus_y2)*0.5, "-");
draw_set_color(btn_scene_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_scene_plus_x1, btn_scene_plus_y1, btn_scene_plus_x2, btn_scene_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_scene_plus_x1, btn_scene_plus_y1, btn_scene_plus_x2, btn_scene_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_scene_plus_x1+btn_scene_plus_x2)*0.5, (btn_scene_plus_y1+btn_scene_plus_y2)*0.5, "+");

// Duel Bot retiré de la colonne gauche

draw_set_color(btn_chap_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_chap_minus_x1, btn_chap_minus_y1, btn_chap_minus_x2, btn_chap_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_chap_minus_x1, btn_chap_minus_y1, btn_chap_minus_x2, btn_chap_minus_y2, true);
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
draw_text((btn_chap_minus_x1+btn_chap_minus_x2)*0.5, (btn_chap_minus_y1+btn_chap_minus_y2)*0.5, "-");

draw_set_color(btn_chap_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_chap_plus_x1, btn_chap_plus_y1, btn_chap_plus_x2, btn_chap_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_chap_plus_x1, btn_chap_plus_y1, btn_chap_plus_x2, btn_chap_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_chap_plus_x1+btn_chap_plus_x2)*0.5, (btn_chap_plus_y1+btn_chap_plus_y2)*0.5, "+");

line_field_x1 = chap_field_x1;
line_field_y1 = scene_field_y2 + btn_margin;
line_field_x2 = line_field_x1 + small_w;
line_field_y2 = line_field_y1 + small_h;
btn_line_minus_x1 = line_field_x2 + btn_margin * 0.5;
btn_line_minus_y1 = line_field_y1;
btn_line_minus_x2 = btn_line_minus_x1 + cmw;
btn_line_minus_y2 = line_field_y2;
btn_line_plus_x1 = btn_line_minus_x2 + btn_margin * 0.5;
btn_line_plus_y1 = line_field_y1;
btn_line_plus_x2 = btn_line_plus_x1 + cpw;
btn_line_plus_y2 = line_field_y2;
 btn_spkr1_x1 = chap_field_x1;
 btn_spkr1_y1 = line_field_y2 + btn_margin;
 btn_spkr1_x2 = btn_spkr1_x1 + small_w * 0.5 - btn_margin * 0.25;
 btn_spkr1_y2 = btn_spkr1_y1 + small_h;
 btn_spkr2_x1 = btn_spkr1_x2 + btn_margin * 0.5;
 btn_spkr2_y1 = btn_spkr1_y1;
 btn_spkr2_x2 = btn_spkr2_x1 + small_w * 0.5 - btn_margin * 0.25;
 btn_spkr2_y2 = btn_spkr2_y1 + small_h;
 btn_line_add_x1 = chap_field_x1;
btn_line_add_y1 = btn_spkr2_y2 + btn_margin;
var half_w = (small_w - btn_margin) * 0.5;
btn_line_add_x2 = btn_line_add_x1 + half_w;
btn_line_add_y2 = btn_line_add_y1 + small_h;

btn_line_del_x1 = btn_line_add_x2 + btn_margin;
btn_line_del_y1 = btn_line_add_y1;
btn_line_del_x2 = btn_line_del_x1 + half_w;
btn_line_del_y2 = btn_line_add_y2;

timer_field_x1 = chap_field_x1;
timer_field_y1 = btn_line_add_y2 + btn_margin;
 timer_field_x2 = timer_field_x1 + small_w;
 timer_field_y2 = timer_field_y1 + small_h;
 btn_spkr1_y1 = timer_field_y2 + btn_margin;
 btn_spkr1_y2 = btn_spkr1_y1 + small_h;
 btn_spkr2_y1 = btn_spkr1_y1;
 btn_spkr2_y2 = btn_spkr2_y1 + small_h;
 var btn_line_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_line_minus_x1, btn_line_minus_y1, btn_line_minus_x2, btn_line_minus_y2);
 var btn_line_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_line_plus_x1, btn_line_plus_y1, btn_line_plus_x2, btn_line_plus_y2);
 btn_spkr1_hover = point_in_rectangle(mouse_x, mouse_y, btn_spkr1_x1, btn_spkr1_y1, btn_spkr1_x2, btn_spkr1_y2);
 btn_spkr2_hover = point_in_rectangle(mouse_x, mouse_y, btn_spkr2_x1, btn_spkr2_y1, btn_spkr2_x2, btn_spkr2_y2);
btn_line_add_hover = point_in_rectangle(mouse_x, mouse_y, btn_line_add_x1, btn_line_add_y1, btn_line_add_x2, btn_line_add_y2);
btn_line_del_hover = point_in_rectangle(mouse_x, mouse_y, btn_line_del_x1, btn_line_del_y1, btn_line_del_x2, btn_line_del_y2);
var line_count = array_length(timeline);
 if (line_count == 0 && scene_idx >= 0 && is_array(editor_scenes[scene_idx].lines)) {
     line_count = array_length(editor_scenes[scene_idx].lines);
 }
 var line_val = string(max(0, line_idx + 1)) + "/" + string(line_count);
 draw_field(line_field_x1, line_field_y1, line_field_x2, line_field_y2, "Action", line_val, false, text_pad);
 draw_field(timer_field_x1, timer_field_y1, timer_field_x2, timer_field_y2, "Timer (ms)", string((variable_struct_exists(current, "wait_after_ms") ? current.wait_after_ms : 600)), field_focused == "wait_after_ms", text_pad);
draw_set_color(btn_line_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_line_minus_x1, btn_line_minus_y1, btn_line_minus_x2, btn_line_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_line_minus_x1, btn_line_minus_y1, btn_line_minus_x2, btn_line_minus_y2, true);
draw_set_color(c_white);
draw_text((btn_line_minus_x1+btn_line_minus_x2)*0.5, (btn_line_minus_y1+btn_line_minus_y2)*0.5, "-");
draw_set_color(btn_line_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_line_plus_x1, btn_line_plus_y1, btn_line_plus_x2, btn_line_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_line_plus_x1, btn_line_plus_y1, btn_line_plus_x2, btn_line_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_line_plus_x1+btn_line_plus_x2)*0.5, (btn_line_plus_y1+btn_line_plus_y2)*0.5, "+");
draw_set_color(btn_line_add_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_line_add_x1, btn_line_add_y1, btn_line_add_x2, btn_line_add_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_line_add_x1, btn_line_add_y1, btn_line_add_x2, btn_line_add_y2, true);
draw_set_color(c_white);
draw_text((btn_line_add_x1+btn_line_add_x2)*0.5, (btn_line_add_y1+btn_line_add_y2)*0.5, "Ajouter");

draw_set_color(btn_line_del_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_line_del_x1, btn_line_del_y1, btn_line_del_x2, btn_line_del_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_line_del_x1, btn_line_del_y1, btn_line_del_x2, btn_line_del_y2, true);
draw_set_color(c_white);
draw_text((btn_line_del_x1+btn_line_del_x2)*0.5, (btn_line_del_y1+btn_line_del_y2)*0.5, "Suppr");


draw_set_color(btn_act_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_act_minus_x1, btn_act_minus_y1, btn_act_minus_x2, btn_act_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_act_minus_x1, btn_act_minus_y1, btn_act_minus_x2, btn_act_minus_y2, true);
draw_set_color(c_white);
draw_text((btn_act_minus_x1+btn_act_minus_x2)*0.5, (btn_act_minus_y1+btn_act_minus_y2)*0.5, "-");

draw_set_color(btn_act_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_act_plus_x1, btn_act_plus_y1, btn_act_plus_x2, btn_act_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_act_plus_x1, btn_act_plus_y1, btn_act_plus_x2, btn_act_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_act_plus_x1+btn_act_plus_x2)*0.5, (btn_act_plus_y1+btn_act_plus_y2)*0.5, "+");

var sp1_l = speaker1.x - speaker1.w * 0.5;
var sp1_t = speaker1.y - speaker1.h * 0.5;
var sp1_r = speaker1.x + speaker1.w * 0.5;
var sp1_b = speaker1.y + speaker1.h * 0.5;
var field_h = 48 * k;
var field_pad = 12 * k;
sp1_field_x1 = sp1_l + field_pad;
sp1_field_y1 = sp1_t + field_pad;
sp1_field_x2 = sp1_r - field_pad;
sp1_field_y2 = sp1_t + field_pad + field_h;
sp1_flip_btn_x2 = sp1_field_x2; sp1_flip_btn_x1 = sp1_flip_btn_x2 - 100 * k; sp1_flip_btn_y1 = sp1_field_y2 + field_pad * 0.5; sp1_flip_btn_y2 = sp1_flip_btn_y1 + field_h;
var sp2_l = speaker2.x - speaker2.w * 0.5;
var sp2_t = speaker2.y - speaker2.h * 0.5;
var sp2_r = speaker2.x + speaker2.w * 0.5;
var sp2_b = speaker2.y + speaker2.h * 0.5;
sp2_field_x1 = sp2_l + field_pad;
sp2_field_y1 = sp2_t + field_pad;
sp2_field_x2 = sp2_r - field_pad;
sp2_field_y2 = sp2_t + field_pad + field_h;
sp2_flip_btn_x2 = sp2_field_x2; sp2_flip_btn_x1 = sp2_flip_btn_x2 - 100 * k; sp2_flip_btn_y1 = sp2_field_y2 + field_pad * 0.5; sp2_flip_btn_y2 = sp2_flip_btn_y1 + field_h;
var sp3_l = speaker3.x - speaker3.w * 0.5;
var sp3_t = speaker3.y - speaker3.h * 0.5;
var sp3_r = speaker3.x + speaker3.w * 0.5;
var sp3_b = speaker3.y + speaker3.h * 0.5;
sp3_field_x1 = sp3_l + field_pad;
sp3_field_y1 = sp3_t + field_pad;
sp3_field_x2 = sp3_r - field_pad;
sp3_field_y2 = sp3_t + field_pad + field_h;
sp3_flip_btn_x2 = sp3_field_x2; sp3_flip_btn_x1 = sp3_flip_btn_x2 - 100 * k; sp3_flip_btn_y1 = sp3_field_y2 + field_pad * 0.5; sp3_flip_btn_y2 = sp3_flip_btn_y1 + field_h;
var ob1_l = object1.x - object1.w * 0.5;
var ob1_t = object1.y - object1.h * 0.5;
var ob1_r = object1.x + object1.w * 0.5;
obj1_field_x1 = ob1_l + field_pad;
obj1_field_y1 = ob1_t + field_pad;
obj1_field_x2 = ob1_r - field_pad;
obj1_field_y2 = ob1_t + field_pad + field_h;
obj1_flip_btn_x2 = obj1_field_x2; obj1_flip_btn_x1 = obj1_flip_btn_x2 - 100 * k; obj1_flip_btn_y1 = obj1_field_y2 + field_pad * 0.5; obj1_flip_btn_y2 = obj1_flip_btn_y1 + field_h;
var ob2_l = object2.x - object2.w * 0.5;
var ob2_t = object2.y - object2.h * 0.5;
var ob2_r = object2.x + object2.w * 0.5;
obj2_field_x1 = ob2_l + field_pad;
obj2_field_y1 = ob2_t + field_pad;
obj2_field_x2 = ob2_r - field_pad;
obj2_field_y2 = ob2_t + field_pad + field_h;
obj2_flip_btn_x2 = obj2_field_x2; obj2_flip_btn_x1 = obj2_flip_btn_x2 - 100 * k; obj2_flip_btn_y1 = obj2_field_y2 + field_pad * 0.5; obj2_flip_btn_y2 = obj2_flip_btn_y1 + field_h;
sp1_flip_hover = point_in_rectangle(mouse_x, mouse_y, sp1_flip_btn_x1, sp1_flip_btn_y1, sp1_flip_btn_x2, sp1_flip_btn_y2);
sp2_flip_hover = point_in_rectangle(mouse_x, mouse_y, sp2_flip_btn_x1, sp2_flip_btn_y1, sp2_flip_btn_x2, sp2_flip_btn_y2);

var bl_x = btn_margin;
var bl_y = room_height - btn_margin - btn_h;

btn_anchor_x1 = bl_x;
btn_anchor_y1 = bl_y - btn_h - btn_margin;
btn_anchor_x2 = btn_anchor_x1 + btn_w;
btn_anchor_y2 = btn_anchor_y1 + btn_h;

btn_anchor_hover = point_in_rectangle(mouse_x, mouse_y, btn_anchor_x1, btn_anchor_y1, btn_anchor_x2, btn_anchor_y2);

var anchor_label = anchor_locked ? "Ancré" : "Ancrer";
draw_accueil_button(btn_anchor_x1, btn_anchor_y1, btn_anchor_x2, btn_anchor_y2, anchor_label, btn_anchor_hover);

btn_create_duel_x1 = bl_x;
btn_create_duel_y1 = bl_y;
btn_create_duel_x2 = bl_x + btn_w;
btn_create_duel_y2 = bl_y + btn_h;

btn_create_duel_hover = point_in_rectangle(mouse_x, mouse_y, btn_create_duel_x1, btn_create_duel_y1, btn_create_duel_x2, btn_create_duel_y2);

var duel_exists = false;
if (variable_struct_exists(current, "duel_bot_id")) {
    var bid = current.duel_bot_id;
    if (is_real(bid)) duel_exists = (bid > 0);
    else if (is_string(bid)) duel_exists = (bid != "" && bid != "0");
    else duel_exists = (bid != 0 && bid != noone);
}
var duel_count = duel_exists ? 1 : 0;
draw_accueil_button(btn_create_duel_x1, btn_create_duel_y1, btn_create_duel_x2, btn_create_duel_y2, "Créer Duel (" + string(duel_count) + ")", btn_create_duel_hover);

obj1_flip_hover = point_in_rectangle(mouse_x, mouse_y, obj1_flip_btn_x1, obj1_flip_btn_y1, obj1_flip_btn_x2, obj1_flip_btn_y2);
obj2_flip_hover = point_in_rectangle(mouse_x, mouse_y, obj2_flip_btn_x1, obj2_flip_btn_y1, obj2_flip_btn_x2, obj2_flip_btn_y2);
var tb_l = textbox.x - textbox.w * 0.5;
var tb_t = textbox.y - textbox.h * 0.5;
var tb_r = textbox.x + textbox.w * 0.5;
var tb_b = textbox.y + textbox.h * 0.5;
text_field_x1 = tb_l + textbox.margin;
text_field_y1 = tb_t + textbox.margin;
text_field_x2 = tb_r - textbox.margin;
text_field_y2 = tb_b - textbox.margin;

var bg_field_w = btn_w;
var bg_field_h = btn_h;
bg_field_x2 = col_x2;
bg_field_x1 = bg_field_x2 - bg_field_w;
bg_field_y1 = btn_quit_y2 + btn_margin;
bg_field_y2 = bg_field_y1 + bg_field_h;
 // Placer les champs Son sous les contrôles +/- du haut
 bg_sound_field_x2 = bg_field_x1 - btn_margin;
 bg_sound_field_x1 = bg_sound_field_x2 - bg_field_w;
 bg_sound_field_y1 = sounds_field_y2 + btn_margin;
 bg_sound_field_y2 = bg_sound_field_y1 + field_h;
 bg_sound2_field_x2 = bg_sound_field_x2;
 bg_sound2_field_x1 = bg_sound_field_x1;
 bg_sound2_field_y1 = bg_sound_field_y2 + btn_margin * 0.5;
 bg_sound2_field_y2 = bg_sound2_field_y1 + field_h;
var top_btn_y1 = btn_margin;
var top_btn_y2 = top_btn_y1 + btn_h;
var top_center = room_width * 0.5;
var top_gap = btn_margin * 0.5;
sounds_field_x1 = top_center - btn_w - top_gap;
sounds_field_y1 = top_btn_y1;
sounds_field_x2 = sounds_field_x1 + btn_w;
sounds_field_y2 = top_btn_y2;
btn_sounds_minus_x1 = sounds_field_x2 + top_gap;
btn_sounds_minus_y1 = top_btn_y1;
 btn_sounds_minus_x2 = btn_sounds_minus_x1 + small_h;
 btn_sounds_minus_y2 = top_btn_y1 + small_h;
btn_sounds_plus_x1 = btn_sounds_minus_x2 + top_gap;
btn_sounds_plus_y1 = top_btn_y1;
 btn_sounds_plus_x2 = btn_sounds_plus_x1 + small_h;
 btn_sounds_plus_y2 = top_btn_y1 + small_h;

var sounds_val = string(sounds_count);
draw_field(sounds_field_x1, sounds_field_y1, sounds_field_x2, sounds_field_y2, "Sons", sounds_val, false, text_pad);
var btn_sounds_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_sounds_minus_x1, btn_sounds_minus_y1, btn_sounds_minus_x2, btn_sounds_minus_y2);
var btn_sounds_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_sounds_plus_x1, btn_sounds_plus_y1, btn_sounds_plus_x2, btn_sounds_plus_y2);
draw_set_color(btn_sounds_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_sounds_minus_x1, btn_sounds_minus_y1, btn_sounds_minus_x2, btn_sounds_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_sounds_minus_x1, btn_sounds_minus_y1, btn_sounds_minus_x2, btn_sounds_minus_y2, true);
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
draw_text((btn_sounds_minus_x1+btn_sounds_minus_x2)*0.5, (btn_sounds_minus_y1+btn_sounds_minus_y2)*0.5, "-");
draw_set_color(btn_sounds_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_sounds_plus_x1, btn_sounds_plus_y1, btn_sounds_plus_x2, btn_sounds_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_sounds_plus_x1, btn_sounds_plus_y1, btn_sounds_plus_x2, btn_sounds_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_sounds_plus_x1+btn_sounds_plus_x2)*0.5, (btn_sounds_plus_y1+btn_sounds_plus_y2)*0.5, "+");

// Champ Son/Fond à droite: affichage conditionnel selon sounds_count

if (sp1_enabled) {
    draw_field(sp1_field_x1, sp1_field_y1, sp1_field_x2, sp1_field_y2, "Sprite", current.portrait1_name, field_focused == "portrait1", text_pad);
    draw_set_color(sp1_flip_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp1_flip_btn_x1, sp1_flip_btn_y1, sp1_flip_btn_x2, sp1_flip_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp1_flip_btn_x1, sp1_flip_btn_y1, sp1_flip_btn_x2, sp1_flip_btn_y2, true);
    draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
    draw_text((sp1_flip_btn_x1+sp1_flip_btn_x2)*0.5, (sp1_flip_btn_y1+sp1_flip_btn_y2)*0.5, current.speaker1_flip ? "↔ Gauche" : "↔ Droite");
}
if (sp2_enabled) {
    draw_field(sp2_field_x1, sp2_field_y1, sp2_field_x2, sp2_field_y2, "Sprite", current.portrait2_name, field_focused == "portrait2", text_pad);
    draw_set_color(sp2_flip_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp2_flip_btn_x1, sp2_flip_btn_y1, sp2_flip_btn_x2, sp2_flip_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp2_flip_btn_x1, sp2_flip_btn_y1, sp2_flip_btn_x2, sp2_flip_btn_y2, true);
    draw_set_color(c_white);
    draw_text((sp2_flip_btn_x1+sp2_flip_btn_x2)*0.5, (sp2_flip_btn_y1+sp2_flip_btn_y2)*0.5, current.speaker2_flip ? "↔ Gauche" : "↔ Droite");
}
if (sp3_enabled) {
    draw_field(sp3_field_x1, sp3_field_y1, sp3_field_x2, sp3_field_y2, "Sprite", current.portrait3_name, field_focused == "portrait3", text_pad);
    var sp3_flip_hover_local = point_in_rectangle(mouse_x, mouse_y, sp3_flip_btn_x1, sp3_flip_btn_y1, sp3_flip_btn_x2, sp3_flip_btn_y2);
    draw_set_color(sp3_flip_hover_local ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp3_flip_btn_x1, sp3_flip_btn_y1, sp3_flip_btn_x2, sp3_flip_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp3_flip_btn_x1, sp3_flip_btn_y1, sp3_flip_btn_x2, sp3_flip_btn_y2, true);
    draw_set_color(c_white);
    draw_text((sp3_flip_btn_x1+sp3_flip_btn_x2)*0.5, (sp3_flip_btn_y1+sp3_flip_btn_y2)*0.5, current.speaker3_flip ? "↔ Gauche" : "↔ Droite");
}
if (obj1_enabled) {
    draw_field(obj1_field_x1, obj1_field_y1, obj1_field_x2, obj1_field_y2, "Objet", current.obj1_name, field_focused == "obj1", text_pad);
    draw_set_color(obj1_flip_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(obj1_flip_btn_x1, obj1_flip_btn_y1, obj1_flip_btn_x2, obj1_flip_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(obj1_flip_btn_x1, obj1_flip_btn_y1, obj1_flip_btn_x2, obj1_flip_btn_y2, true);
    draw_set_color(c_white);
    draw_text((obj1_flip_btn_x1+obj1_flip_btn_x2)*0.5, (obj1_flip_btn_y1+obj1_flip_btn_y2)*0.5, current.obj1_flip ? "↔ Gauche" : "↔ Droite");
}
if (obj2_enabled) {
    draw_field(obj2_field_x1, obj2_field_y1, obj2_field_x2, obj2_field_y2, "Objet", current.obj2_name, field_focused == "obj2", text_pad);
    draw_set_color(obj2_flip_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(obj2_flip_btn_x1, obj2_flip_btn_y1, obj2_flip_btn_x2, obj2_flip_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(obj2_flip_btn_x1, obj2_flip_btn_y1, obj2_flip_btn_x2, obj2_flip_btn_y2, true);
    draw_set_color(c_white);
    draw_text((obj2_flip_btn_x1+obj2_flip_btn_x2)*0.5, (obj2_flip_btn_y1+obj2_flip_btn_y2)*0.5, current.obj2_flip ? "↔ Gauche" : "↔ Droite");
}
draw_field(bg_field_x1, bg_field_y1, bg_field_x2, bg_field_y2, "Fond", current.bg_name, field_focused == "bg", text_pad);
if (sounds_count >= 1) draw_field(bg_sound_field_x1, bg_sound_field_y1, bg_sound_field_x2, bg_sound_field_y2, "Son", current.bg_sound, field_focused == "bg_sound", text_pad);
if (sounds_count >= 2) draw_field(bg_sound2_field_x1, bg_sound2_field_y1, bg_sound2_field_x2, bg_sound2_field_y2, "Son 2", current.bg_sound2, field_focused == "bg_sound2", text_pad);

var eff_btn_w = 120 * k;
var eff_btn_h = field_h;

sp1_eff_btn_x2 = sp1_field_x2;
sp1_eff_btn_x1 = sp1_eff_btn_x2 - eff_btn_w;
sp1_eff_btn_y1 = sp1_field_y1;
sp1_eff_btn_y2 = sp1_field_y1 + eff_btn_h;

sp2_eff_btn_x2 = sp2_field_x2;
sp2_eff_btn_x1 = sp2_eff_btn_x2 - eff_btn_w;
sp2_eff_btn_y1 = sp2_field_y1;
sp2_eff_btn_y2 = sp2_field_y1 + eff_btn_h;

sp3_eff_btn_x2 = sp3_field_x2;
sp3_eff_btn_x1 = sp3_eff_btn_x2 - eff_btn_w;
sp3_eff_btn_y1 = sp3_field_y1;
sp3_eff_btn_y2 = sp3_field_y1 + eff_btn_h;

obj1_eff_btn_x2 = obj1_field_x2;
obj1_eff_btn_x1 = obj1_eff_btn_x2 - eff_btn_w;
obj1_eff_btn_y1 = obj1_field_y1;
obj1_eff_btn_y2 = obj1_field_y1 + eff_btn_h;

obj2_eff_btn_x2 = obj2_field_x2;
obj2_eff_btn_x1 = obj2_eff_btn_x2 - eff_btn_w;
obj2_eff_btn_y1 = obj2_field_y1;
obj2_eff_btn_y2 = obj2_field_y1 + eff_btn_h;

text_eff_btn_x2 = bg_field_x2;
text_eff_btn_x1 = text_eff_btn_x2 - eff_btn_w;
text_eff_btn_y1 = bg_field_y1;
text_eff_btn_y2 = bg_field_y1 + eff_btn_h;

var sp1_eff_hover = sp1_enabled && point_in_rectangle(mouse_x, mouse_y, sp1_eff_btn_x1, sp1_eff_btn_y1, sp1_eff_btn_x2, sp1_eff_btn_y2);
var sp2_eff_hover = sp2_enabled && point_in_rectangle(mouse_x, mouse_y, sp2_eff_btn_x1, sp2_eff_btn_y1, sp2_eff_btn_x2, sp2_eff_btn_y2);
var sp3_eff_hover = sp3_enabled && point_in_rectangle(mouse_x, mouse_y, sp3_eff_btn_x1, sp3_eff_btn_y1, sp3_eff_btn_x2, sp3_eff_btn_y2);
var obj1_eff_hover = obj1_enabled && point_in_rectangle(mouse_x, mouse_y, obj1_eff_btn_x1, obj1_eff_btn_y1, obj1_eff_btn_x2, obj1_eff_btn_y2);
var obj2_eff_hover = obj2_enabled && point_in_rectangle(mouse_x, mouse_y, obj2_eff_btn_x1, obj2_eff_btn_y1, obj2_eff_btn_x2, obj2_eff_btn_y2);
var text_eff_hover = textbox_enabled && point_in_rectangle(mouse_x, mouse_y, text_eff_btn_x1, text_eff_btn_y1, text_eff_btn_x2, text_eff_btn_y2);
var sp1_flip_hover = point_in_rectangle(mouse_x, mouse_y, sp1_flip_btn_x1, sp1_flip_btn_y1, sp1_flip_btn_x2, sp1_flip_btn_y2);
var sp2_flip_hover = point_in_rectangle(mouse_x, mouse_y, sp2_flip_btn_x1, sp2_flip_btn_y1, sp2_flip_btn_x2, sp2_flip_btn_y2);
var obj1_flip_hover = point_in_rectangle(mouse_x, mouse_y, obj1_flip_btn_x1, obj1_flip_btn_y1, obj1_flip_btn_x2, obj1_flip_btn_y2);
var obj2_flip_hover = point_in_rectangle(mouse_x, mouse_y, obj2_flip_btn_x1, obj2_flip_btn_y1, obj2_flip_btn_x2, obj2_flip_btn_y2);

if (sp1_enabled) {
    draw_set_color(sp1_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp1_eff_btn_x1, sp1_eff_btn_y1, sp1_eff_btn_x2, sp1_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp1_eff_btn_x1, sp1_eff_btn_y1, sp1_eff_btn_x2, sp1_eff_btn_y2, true);
    draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
    draw_text((sp1_eff_btn_x1+sp1_eff_btn_x2)*0.5, (sp1_eff_btn_y1+sp1_eff_btn_y2)*0.5, selected_effect_portrait1);
}

if (sp2_enabled) {
    draw_set_color(sp2_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp2_eff_btn_x1, sp2_eff_btn_y1, sp2_eff_btn_x2, sp2_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp2_eff_btn_x1, sp2_eff_btn_y1, sp2_eff_btn_x2, sp2_eff_btn_y2, true);
    draw_set_color(c_white);
    draw_text((sp2_eff_btn_x1+sp2_eff_btn_x2)*0.5, (sp2_eff_btn_y1+sp2_eff_btn_y2)*0.5, selected_effect_portrait2);
}

if (sp3_enabled) {
    draw_set_color(sp3_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(sp3_eff_btn_x1, sp3_eff_btn_y1, sp3_eff_btn_x2, sp3_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(sp3_eff_btn_x1, sp3_eff_btn_y1, sp3_eff_btn_x2, sp3_eff_btn_y2, true);
    draw_set_color(c_white);
    draw_text((sp3_eff_btn_x1+sp3_eff_btn_x2)*0.5, (sp3_eff_btn_y1+sp3_eff_btn_y2)*0.5, selected_effect_portrait3);
}

if (obj1_enabled) {
    draw_set_color(obj1_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(obj1_eff_btn_x1, obj1_eff_btn_y1, obj1_eff_btn_x2, obj1_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(obj1_eff_btn_x1, obj1_eff_btn_y1, obj1_eff_btn_x2, obj1_eff_btn_y2, true);
    draw_set_color(c_white);
    draw_text((obj1_eff_btn_x1+obj1_eff_btn_x2)*0.5, (obj1_eff_btn_y1+obj1_eff_btn_y2)*0.5, selected_effect_obj1);
}

if (obj2_enabled) {
    draw_set_color(obj2_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(obj2_eff_btn_x1, obj2_eff_btn_y1, obj2_eff_btn_x2, obj2_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(obj2_eff_btn_x1, obj2_eff_btn_y1, obj2_eff_btn_x2, obj2_eff_btn_y2, true);
    draw_set_color(c_white);
    draw_text((obj2_eff_btn_x1+obj2_eff_btn_x2)*0.5, (obj2_eff_btn_y1+obj2_eff_btn_y2)*0.5, selected_effect_obj2);
}

if (textbox_enabled) {
    draw_set_color(text_eff_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
    draw_roundrect(text_eff_btn_x1, text_eff_btn_y1, text_eff_btn_x2, text_eff_btn_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(text_eff_btn_x1, text_eff_btn_y1, text_eff_btn_x2, text_eff_btn_y2, true);
    draw_set_color(c_white);
    draw_text((text_eff_btn_x1+text_eff_btn_x2)*0.5, (text_eff_btn_y1+text_eff_btn_y2)*0.5, selected_effect_text);
}

if (dropdown_open_for != "") {
    var ddw = 240 * k;
    dd_item_h = 36 * k;
    if (dropdown_open_for == "portrait1") { dd_x1 = sp1_eff_btn_x1; dd_y1 = sp1_eff_btn_y2; }
    else if (dropdown_open_for == "portrait2") { dd_x1 = sp2_eff_btn_x1; dd_y1 = sp2_eff_btn_y2; }
    else if (dropdown_open_for == "portrait3") { dd_x1 = sp3_eff_btn_x1; dd_y1 = sp3_eff_btn_y2; }
    else if (dropdown_open_for == "obj1") { dd_x1 = obj1_eff_btn_x1; dd_y1 = obj1_eff_btn_y2; }
    else if (dropdown_open_for == "obj2") { dd_x1 = obj2_eff_btn_x1; dd_y1 = obj2_eff_btn_y2; }
    else if (dropdown_open_for == "text") { dd_x1 = text_eff_btn_x1; dd_y1 = text_eff_btn_y2; }
    dd_x2 = dd_x1 + ddw;
    dd_y2 = dd_y1 + dd_item_h * array_length(effect_options);
    draw_set_color(make_color_rgb(35,35,35));
    draw_roundrect(dd_x1, dd_y1, dd_x2, dd_y2, true);
    draw_set_color(make_color_rgb(220,200,120));
    draw_roundrect(dd_x1, dd_y1, dd_x2, dd_y2, false);
    var i = 0;
    while (i < array_length(effect_options)) {
        var iy1 = dd_y1 + i * dd_item_h;
        var iy2 = iy1 + dd_item_h;
        draw_set_color(c_white);
        draw_set_halign(fa_left); draw_set_valign(fa_middle);
        draw_text(dd_x1 + 12 * k, (iy1 + iy2) * 0.5, effect_options[i]);
        i += 1;
    }
}

var hs = resize_handle_size;
var sp1_hr_x1 = sp1_r - hs;
var sp1_hr_y1 = sp1_b - hs;
var sp1_hr_x2 = sp1_r;
var sp1_hr_y2 = sp1_b;
var sp2_hr_x1 = sp2_r - hs;
var sp2_hr_y1 = sp2_b - hs;
var sp2_hr_x2 = sp2_r;
var sp2_hr_y2 = sp2_b;
var sp3_hr_x1 = sp3_r - hs;
var sp3_hr_y1 = sp3_b - hs;
var sp3_hr_x2 = sp3_r;
var sp3_hr_y2 = sp3_b;
var ob1_hr_x1 = obj1_field_x2 - (obj1_field_x2 - obj1_field_x1);
var ob1_r2 = object1.x + object1.w * 0.5;
var ob1_b2 = object1.y + object1.h * 0.5;
ob1_hr_x1 = ob1_r2 - hs;
var ob1_hr_y1 = ob1_b2 - hs;
var ob1_hr_x2 = ob1_r2;
var ob1_hr_y2 = ob1_b2;
var ob2_r2 = object2.x + object2.w * 0.5;
var ob2_b2 = object2.y + object2.h * 0.5;
var ob2_hr_x1 = ob2_r2 - hs;
var ob2_hr_y1 = ob2_b2 - hs;
var ob2_hr_x2 = ob2_r2;
var ob2_hr_y2 = ob2_b2;

var sp1_hr_hover = point_in_rectangle(mouse_x, mouse_y, sp1_hr_x1, sp1_hr_y1, sp1_hr_x2, sp1_hr_y2);
var sp2_hr_hover = point_in_rectangle(mouse_x, mouse_y, sp2_hr_x1, sp2_hr_y1, sp2_hr_x2, sp2_hr_y2);
var sp3_hr_hover = point_in_rectangle(mouse_x, mouse_y, sp3_hr_x1, sp3_hr_y1, sp3_hr_x2, sp3_hr_y2);
var ob1_hr_hover = point_in_rectangle(mouse_x, mouse_y, ob1_hr_x1, ob1_hr_y1, ob1_hr_x2, ob1_hr_y2);
var ob2_hr_hover = point_in_rectangle(mouse_x, mouse_y, ob2_hr_x1, ob2_hr_y1, ob2_hr_x2, ob2_hr_y2);

if (sp1_enabled) {
    draw_set_color(sp1_hr_hover ? c_yellow : c_white);
    draw_rectangle(sp1_hr_x1, sp1_hr_y1, sp1_hr_x2, sp1_hr_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_rectangle(sp1_hr_x1, sp1_hr_y1, sp1_hr_x2, sp1_hr_y2, true);
}

if (sp2_enabled) {
    draw_set_color(sp2_hr_hover ? c_yellow : c_white);
    draw_rectangle(sp2_hr_x1, sp2_hr_y1, sp2_hr_x2, sp2_hr_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_rectangle(sp2_hr_x1, sp2_hr_y1, sp2_hr_x2, sp2_hr_y2, true);
}
if (sp3_enabled) {
    draw_set_color(sp3_hr_hover ? c_yellow : c_white);
    draw_rectangle(sp3_hr_x1, sp3_hr_y1, sp3_hr_x2, sp3_hr_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_rectangle(sp3_hr_x1, sp3_hr_y1, sp3_hr_x2, sp3_hr_y2, true);
}

if (obj1_enabled) {
    draw_set_color(ob1_hr_hover ? c_yellow : c_white);
    draw_rectangle(ob1_hr_x1, ob1_hr_y1, ob1_hr_x2, ob1_hr_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_rectangle(ob1_hr_x1, ob1_hr_y1, ob1_hr_x2, ob1_hr_y2, true);
}

if (obj2_enabled) {
    draw_set_color(ob2_hr_hover ? c_yellow : c_white);
    draw_rectangle(ob2_hr_x1, ob2_hr_y1, ob2_hr_x2, ob2_hr_y2, false);
    draw_set_color(make_color_rgb(220,200,120));
    draw_rectangle(ob2_hr_x1, ob2_hr_y1, ob2_hr_x2, ob2_hr_y2, true);
}

 speakers_field_x1 = act_field_x1;
 speakers_field_y1 = timer_field_y2 + btn_margin;
 speakers_field_x2 = speakers_field_x1 + small_w;
 speakers_field_y2 = speakers_field_y1 + small_h;
 btn_speakers_minus_x1 = speakers_field_x2 + btn_margin * 0.5;
 btn_speakers_minus_y1 = speakers_field_y1;
 btn_speakers_minus_x2 = btn_speakers_minus_x1 + cmw;
 btn_speakers_minus_y2 = speakers_field_y1 + small_h;
 btn_speakers_plus_x1 = btn_speakers_minus_x2 + btn_margin * 0.5;
 btn_speakers_plus_y1 = speakers_field_y1;
 btn_speakers_plus_x2 = btn_speakers_plus_x1 + cpw;
 btn_speakers_plus_y2 = speakers_field_y1 + small_h;
 var btn_speakers_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_speakers_minus_x1, btn_speakers_minus_y1, btn_speakers_minus_x2, btn_speakers_minus_y2);
 var btn_speakers_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_speakers_plus_x1, btn_speakers_plus_y1, btn_speakers_plus_x2, btn_speakers_plus_y2);
 draw_field(speakers_field_x1, speakers_field_y1, speakers_field_x2, speakers_field_y2, "Personnages", string(speakers_count), false, text_pad);
 draw_set_color(btn_speakers_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
 draw_roundrect(btn_speakers_minus_x1, btn_speakers_minus_y1, btn_speakers_minus_x2, btn_speakers_minus_y2, false);
 draw_set_color(make_color_rgb(220,200,120));
 draw_roundrect(btn_speakers_minus_x1, btn_speakers_minus_y1, btn_speakers_minus_x2, btn_speakers_minus_y2, true);
 draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
 draw_text((btn_speakers_minus_x1+btn_speakers_minus_x2)*0.5, (btn_speakers_minus_y1+btn_speakers_minus_y2)*0.5, "-");
 draw_set_color(btn_speakers_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
 draw_roundrect(btn_speakers_plus_x1, btn_speakers_plus_y1, btn_speakers_plus_x2, btn_speakers_plus_y2, false);
 draw_set_color(make_color_rgb(220,200,120));
 draw_roundrect(btn_speakers_plus_x1, btn_speakers_plus_y1, btn_speakers_plus_x2, btn_speakers_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_speakers_plus_x1+btn_speakers_plus_x2)*0.5, (btn_speakers_plus_y1+btn_speakers_plus_y2)*0.5, "+");
objects_field_x1 = speakers_field_x1;
objects_field_y1 = speakers_field_y2 + btn_margin;
objects_field_x2 = objects_field_x1 + small_w;
objects_field_y2 = objects_field_y1 + small_h;
btn_objects_minus_x1 = objects_field_x2 + btn_margin * 0.5;
btn_objects_minus_y1 = objects_field_y1;
btn_objects_minus_x2 = btn_objects_minus_x1 + cmw;
btn_objects_minus_y2 = objects_field_y1 + small_h;
btn_objects_plus_x1 = btn_objects_minus_x2 + btn_margin * 0.5;
btn_objects_plus_y1 = objects_field_y1;
btn_objects_plus_x2 = btn_objects_plus_x1 + cpw;
btn_objects_plus_y2 = objects_field_y1 + small_h;
var btn_objects_minus_hover = point_in_rectangle(mouse_x, mouse_y, btn_objects_minus_x1, btn_objects_minus_y1, btn_objects_minus_x2, btn_objects_minus_y2);
var btn_objects_plus_hover = point_in_rectangle(mouse_x, mouse_y, btn_objects_plus_x1, btn_objects_plus_y1, btn_objects_plus_x2, btn_objects_plus_y2);
draw_field(objects_field_x1, objects_field_y1, objects_field_x2, objects_field_y2, "Objets", string(objects_count), false, text_pad);
draw_set_color(btn_objects_minus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_objects_minus_x1, btn_objects_minus_y1, btn_objects_minus_x2, btn_objects_minus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_objects_minus_x1, btn_objects_minus_y1, btn_objects_minus_x2, btn_objects_minus_y2, true);
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white);
draw_text((btn_objects_minus_x1+btn_objects_minus_x2)*0.5, (btn_objects_minus_y1+btn_objects_minus_y2)*0.5, "-");
draw_set_color(btn_objects_plus_hover ? make_color_rgb(60,45,25) : make_color_rgb(40,40,40));
draw_roundrect(btn_objects_plus_x1, btn_objects_plus_y1, btn_objects_plus_x2, btn_objects_plus_y2, false);
draw_set_color(make_color_rgb(220,200,120));
draw_roundrect(btn_objects_plus_x1, btn_objects_plus_y1, btn_objects_plus_x2, btn_objects_plus_y2, true);
draw_set_color(c_white);
draw_text((btn_objects_plus_x1+btn_objects_plus_x2)*0.5, (btn_objects_plus_y1+btn_objects_plus_y2)*0.5, "+");

// --- DUEL WINDOW DRAWING ---
if (variable_instance_exists(id, "show_duel_window") && show_duel_window) {
    var k = min(room_width / 1920, room_height / 1080);
    
    // Dim background
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Window Background
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_roundrect(duel_window_x, duel_window_y, duel_window_x + duel_window_w, duel_window_y + duel_window_h, false);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(duel_window_x, duel_window_y, duel_window_x + duel_window_w, duel_window_y + duel_window_h, true);
    
    // Title
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed(duel_window_x + duel_window_w / 2, duel_window_y + 20 * k, "Configuration du Duel", 1.5, 1.5, 0);
    
    // Close Button (Top Right)
    var close_size = 40 * k;
    draw_set_color(c_red);
    draw_rectangle(duel_window_x + duel_window_w - close_size, duel_window_y, duel_window_x + duel_window_w, duel_window_y + close_size, false);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(duel_window_x + duel_window_w - close_size / 2, duel_window_y + close_size / 2, "X");

    // Decks Lists (Player and Bot)
    var list_y_start = duel_window_y + 80 * k;
    var item_h = 40 * k;
    
    // Player Decks
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(duel_window_x + 40 * k, list_y_start - 30 * k, "Decks Joueur");
    if (variable_instance_exists(id, "player_deck_options")) {
         for (var i = 0; i < array_length(player_deck_options); i++) {
             var item_y = list_y_start + i * item_h;
             var is_selected = (current.duel_player_deck == player_deck_options[i]);
             if (!is_selected && is_string(current.duel_player_deck) && variable_struct_exists(player_deck_options[i], "id")) {
                 is_selected = (current.duel_player_deck == player_deck_options[i].id);
             }
             draw_set_color(is_selected ? c_green : c_dkgray);
             draw_rectangle(duel_window_x + 20 * k, item_y, duel_window_x + duel_window_w/2 - 20 * k, item_y + item_h - 5, false);
             draw_set_color(c_white);
             var deck_name = variable_struct_exists(player_deck_options[i], "name") ? player_deck_options[i].name : "Deck inconnu";
             draw_text(duel_window_x + 30 * k, item_y + 5, deck_name);
         }
    }

    // Bot Decks
    draw_text(duel_window_x + duel_window_w/2 + 40 * k, list_y_start - 30 * k, "Decks Bot");
    if (variable_instance_exists(id, "bot_deck_options")) {
         for (var i = 0; i < array_length(bot_deck_options); i++) {
             var item_y = list_y_start + i * item_h;
             var is_selected = (string(current.duel_bot_id) == string(bot_deck_options[i].id));
             draw_set_color(is_selected ? c_green : c_dkgray);
             draw_rectangle(duel_window_x + duel_window_w/2 + 20 * k, item_y, duel_window_x + duel_window_w - 20 * k, item_y + item_h - 5, false);
             draw_set_color(c_white);
             draw_text(duel_window_x + duel_window_w/2 + 30 * k, item_y + 5, bot_deck_options[i].name);
         }
    }

    // Confirm Button
    var btn_w_local = 200 * k;
    var btn_h_local = 50 * k;
    var btn_y_local = duel_window_y + duel_window_h - 70 * k;
    var btn_save_x = duel_window_x + duel_window_w / 2 - btn_w_local / 2;
    var btn_text = duel_exists ? "Modifier" : "Créer";
    var btn_hover = point_in_rectangle(mouse_x, mouse_y, btn_save_x, btn_y_local, btn_save_x + btn_w_local, btn_y_local + btn_h_local);
    draw_accueil_button(btn_save_x, btn_y_local, btn_save_x + btn_w_local, btn_y_local + btn_h_local, btn_text, btn_hover);
    
    // Delete Duel Button
    if (duel_exists) {
        var btn_del_x = duel_window_x + 30 * k;
        var btn_del_hover = point_in_rectangle(mouse_x, mouse_y, btn_del_x, btn_y_local, btn_del_x + btn_w_local, btn_y_local + btn_h_local);
        draw_accueil_button(btn_del_x, btn_y_local, btn_del_x + btn_w_local, btn_y_local + btn_h_local, "Supprimer", btn_del_hover);
    }
}
