var bg = asset_get_index(current.bg_name);
if (bg != -1) {
    draw_sprite_stretched(bg, 0, 0, 0, room_width, room_height);
} else {
    draw_clear_alpha(c_black, 1);
}

update_nav_buttons();

var s1 = asset_get_index(current.portrait1_name);
if (s1 != -1) {
    var sw = sprite_get_width(s1); var sh = sprite_get_height(s1);
    var scx = speaker1.w / sw; var scy = speaker1.h / sh; var sc = min(scx, scy);
    var dur1 = fx_duration_ms;
    if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé" || current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé" || current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé" || current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") { dur1 *= fx_inverse_multiplier; }
    var t1 = clamp((current_time - fx_sp1_start_ms) / dur1, 0, 1);
    var dx1 = 0; var dy1 = 0; var sc1 = 1; var ang1 = 0; var a1 = 1; var glow1 = false;
    if (current.portrait1_effect == "Fondu") { a1 = t1; }
    else if (current.portrait1_effect == "FonduInverse" || current.portrait1_effect == "Fondu inversé") { a1 = 1 - t1; }
    else if (current.portrait1_effect == "DeplacementAB") { dx1 = (prev_speaker1_x - speaker1.x) * (1 - t1); dy1 = (prev_speaker1_y - speaker1.y) * (1 - t1); }
    else if (current.portrait1_effect == "SlideGauche" || current.portrait1_effect == "Slide gauche") { dx1 = -room_width * 0.3 * (1 - t1); }
    else if (current.portrait1_effect == "SlideDroite" || current.portrait1_effect == "Slide droite") { dx1 = room_width * 0.3 * (1 - t1); }
    else if (current.portrait1_effect == "SlideHaut"   || current.portrait1_effect == "Slide haut") { dy1 = -room_height * 0.2 * (1 - t1); }
    else if (current.portrait1_effect == "SlideBas"    || current.portrait1_effect == "Slide bas") { dy1 = room_height * 0.2 * (1 - t1); }
    else if (current.portrait1_effect == "SlideGaucheInverse" || current.portrait1_effect == "Slide gauche inversé") { dx1 = -(room_width + speaker1.w) * t1; }
    else if (current.portrait1_effect == "SlideDroiteInverse" || current.portrait1_effect == "Slide droite inversé") { dx1 = (room_width + speaker1.w) * t1; }
    else if (current.portrait1_effect == "SlideHautInverse" || current.portrait1_effect == "Slide haut inversé") { dy1 = -(room_height + speaker1.h) * t1; }
    else if (current.portrait1_effect == "SlideBasInverse" || current.portrait1_effect == "Slide bas inversé") { dy1 = (room_height + speaker1.h) * t1; }
    else if (current.portrait1_effect == "Pop") { sc1 = 0.8 + 0.2 * t1; }
    else if (current.portrait1_effect == "Pulse") { sc1 = 1 + 0.06 * sin(t1 * pi); }
    else if (current.portrait1_effect == "Glow") { glow1 = true; }
    else if (current.portrait1_effect == "RotationIn") { ang1 = -15 * (1 - t1); a1 = t1; }
    var sign1 = (variable_struct_exists(current, "speaker1_flip") && current.speaker1_flip) ? -1 : 1;
    draw_sprite_ext(s1, 0, speaker1.x + dx1, speaker1.y + dy1, sc * sc1 * sign1, sc * sc1, ang1, c_white, a1);
    if (glow1) { draw_sprite_ext(s1, 0, speaker1.x + dx1, speaker1.y + dy1, sc * sc1 * 1.02, sc * sc1 * 1.02, ang1, make_color_rgb(255,220,120), 0.35); }
}

var s2 = asset_get_index(current.portrait2_name);
if (s2 != -1) {
    var sw2 = sprite_get_width(s2); var sh2 = sprite_get_height(s2);
    var scx2 = speaker2.w / sw2; var scy2 = speaker2.h / sh2; var sc2 = min(scx2, scy2);
    var dur2 = fx_duration_ms;
    if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé" || current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé" || current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé" || current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") { dur2 *= fx_inverse_multiplier; }
    var t2 = clamp((current_time - fx_sp2_start_ms) / dur2, 0, 1);
    var dx2 = 0; var dy2 = 0; var scp2 = 1; var ang2 = 0; var a2 = 1; var glow2 = false;
    if (current.portrait2_effect == "Fondu") { a2 = t2; }
    else if (current.portrait2_effect == "FonduInverse" || current.portrait2_effect == "Fondu inversé") { a2 = 1 - t2; }
    else if (current.portrait2_effect == "DeplacementAB") { dx2 = (prev_speaker2_x - speaker2.x) * (1 - t2); dy2 = (prev_speaker2_y - speaker2.y) * (1 - t2); }
    else if (current.portrait2_effect == "SlideGauche" || current.portrait2_effect == "Slide gauche") { dx2 = -room_width * 0.3 * (1 - t2); }
    else if (current.portrait2_effect == "SlideDroite" || current.portrait2_effect == "Slide droite") { dx2 = room_width * 0.3 * (1 - t2); }
    else if (current.portrait2_effect == "SlideHaut"   || current.portrait2_effect == "Slide haut") { dy2 = -room_height * 0.2 * (1 - t2); }
    else if (current.portrait2_effect == "SlideBas"    || current.portrait2_effect == "Slide bas") { dy2 = room_height * 0.2 * (1 - t2); }
    else if (current.portrait2_effect == "SlideGaucheInverse" || current.portrait2_effect == "Slide gauche inversé") { dx2 = -(room_width + speaker2.w) * t2; }
    else if (current.portrait2_effect == "SlideDroiteInverse" || current.portrait2_effect == "Slide droite inversé") { dx2 = (room_width + speaker2.w) * t2; }
    else if (current.portrait2_effect == "SlideHautInverse" || current.portrait2_effect == "Slide haut inversé") { dy2 = -(room_height + speaker2.h) * t2; }
    else if (current.portrait2_effect == "SlideBasInverse" || current.portrait2_effect == "Slide bas inversé") { dy2 = (room_height + speaker2.h) * t2; }
    else if (current.portrait2_effect == "Pop") { scp2 = 0.8 + 0.2 * t2; }
    else if (current.portrait2_effect == "Pulse") { scp2 = 1 + 0.06 * sin(t2 * pi); }
    else if (current.portrait2_effect == "Glow") { glow2 = true; }
    else if (current.portrait2_effect == "RotationIn") { ang2 = -15 * (1 - t2); a2 = t2; }
    var sign2 = (variable_struct_exists(current, "speaker2_flip") && current.speaker2_flip) ? -1 : 1;
    draw_sprite_ext(s2, 0, speaker2.x + dx2, speaker2.y + dy2, sc2 * scp2 * sign2, sc2 * scp2, ang2, c_white, a2);
    if (glow2) { draw_sprite_ext(s2, 0, speaker2.x + dx2, speaker2.y + dy2, sc2 * scp2 * 1.02, sc2 * scp2 * 1.02, ang2, make_color_rgb(255,220,120), 0.35); }
}

var s3 = asset_get_index(current.portrait3_name);
if (s3 != -1) {
    var sw3 = sprite_get_width(s3); var sh3 = sprite_get_height(s3);
    var scx3 = speaker3.w / sw3; var scy3 = speaker3.h / sh3; var sc3 = min(scx3, scy3);
    var dur3p = fx_duration_ms;
    var e3 = string_lower(current.portrait3_effect);
    if (e3 == "slidegaucheinverse" || e3 == "slide gauche inversé" || e3 == "slide gauche inverse" || e3 == "slidedroiteinverse" || e3 == "slide droite inversé" || e3 == "slide droite inverse" || e3 == "slidehautinverse" || e3 == "slide haut inversé" || e3 == "slide haut inverse" || e3 == "slidebasinverse" || e3 == "slide bas inversé" || e3 == "slide bas inverse") { dur3p *= fx_inverse_multiplier; }
    var t3p = clamp((current_time - fx_sp3_start_ms) / dur3p, 0, 1);
    var dx3p = 0; var dy3p = 0; var scp3 = 1; var ang3p = 0; var a3p = 1; var glow3p = false;
    if (e3 == "fondu") { a3p = t3p; }
    else if (e3 == "fonduinverse" || e3 == "fondu inversé" || e3 == "fondu inverse") { a3p = 1 - t3p; }
    else if (e3 == "deplacementab" || e3 == "déplacementab" || e3 == "deplacement ab" || e3 == "déplacement ab") { dx3p = (prev_speaker3_x - speaker3.x) * (1 - t3p); dy3p = (prev_speaker3_y - speaker3.y) * (1 - t3p); }
    else if (e3 == "slidegauche" || e3 == "slide gauche") { dx3p = -room_width * 0.3 * (1 - t3p); }
    else if (e3 == "slidedroite" || e3 == "slide droite") { dx3p = room_width * 0.3 * (1 - t3p); }
    else if (e3 == "slidehaut"   || e3 == "slide haut") { dy3p = -room_height * 0.2 * (1 - t3p); }
    else if (e3 == "slidebas"    || e3 == "slide bas") { dy3p = room_height * 0.2 * (1 - t3p); }
    else if (e3 == "slidegaucheinverse" || e3 == "slide gauche inversé" || e3 == "slide gauche inverse") { dx3p = -(room_width + speaker3.w) * t3p; }
    else if (e3 == "slidedroiteinverse" || e3 == "slide droite inversé" || e3 == "slide droite inverse") { dx3p = (room_width + speaker3.w) * t3p; }
    else if (e3 == "slidehautinverse" || e3 == "slide haut inversé" || e3 == "slide haut inverse") { dy3p = -(room_height + speaker3.h) * t3p; }
    else if (e3 == "slidebasinverse" || e3 == "slide bas inversé" || e3 == "slide bas inverse") { dy3p = (room_height + speaker3.h) * t3p; }
    else if (e3 == "pop") { scp3 = 0.8 + 0.2 * t3p; }
    else if (e3 == "pulse") { scp3 = 1 + 0.06 * sin(t3p * pi); }
    else if (e3 == "glow") { glow3p = true; }
    else if (e3 == "rotationin" || e3 == "rotation in") { ang3p = -15 * (1 - t3p); a3p = t3p; }
    var sign3 = (variable_struct_exists(current, "speaker3_flip") && current.speaker3_flip) ? -1 : 1;
    draw_sprite_ext(s3, 0, speaker3.x + dx3p, speaker3.y + dy3p, sc3 * scp3 * sign3, sc3 * scp3, ang3p, c_white, a3p);
    if (glow3p) { draw_sprite_ext(s3, 0, speaker3.x + dx3p, speaker3.y + dy3p, sc3 * scp3 * 1.02, sc3 * scp3 * 1.02, ang3p, make_color_rgb(255,220,120), 0.35); }
}

var o1 = asset_get_index(current.obj1_name);
if (o1 != -1) {
    var ow1 = sprite_get_width(o1); var oh1 = sprite_get_height(o1);
    var ocx1 = object1.w / ow1; var ocy1 = object1.h / oh1; var oc1 = min(ocx1, ocy1);
    var dur3 = fx_duration_ms;
    if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé" || current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé" || current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé" || current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") { dur3 *= fx_inverse_multiplier; }
    var t3 = clamp((current_time - fx_obj1_start_ms) / dur3, 0, 1);
    var dx3 = 0; var dy3 = 0; var sco1 = 1; var ang3 = 0; var a3 = 1; var glow3 = false;
    if (current.obj1_effect == "Fondu") { a3 = t3; }
    else if (current.obj1_effect == "DeplacementAB") { dx3 = (prev_object1_x - object1.x) * (1 - t3); dy3 = (prev_object1_y - object1.y) * (1 - t3); }
    else if (current.obj1_effect == "SlideGauche" || current.obj1_effect == "Slide gauche") { dx3 = -room_width * 0.3 * (1 - t3); }
    else if (current.obj1_effect == "SlideDroite" || current.obj1_effect == "Slide droite") { dx3 = room_width * 0.3 * (1 - t3); }
    else if (current.obj1_effect == "SlideHaut"   || current.obj1_effect == "Slide haut") { dy3 = -room_height * 0.2 * (1 - t3); }
    else if (current.obj1_effect == "SlideBas"    || current.obj1_effect == "Slide bas") { dy3 = room_height * 0.2 * (1 - t3); }
    else if (current.obj1_effect == "SlideGaucheInverse" || current.obj1_effect == "Slide gauche inversé") { dx3 = -(room_width + object1.w) * t3; }
    else if (current.obj1_effect == "SlideDroiteInverse" || current.obj1_effect == "Slide droite inversé") { dx3 = (room_width + object1.w) * t3; }
    else if (current.obj1_effect == "SlideHautInverse" || current.obj1_effect == "Slide haut inversé") { dy3 = -(room_height + object1.h) * t3; }
    else if (current.obj1_effect == "SlideBasInverse" || current.obj1_effect == "Slide bas inversé") { dy3 = (room_height + object1.h) * t3; }
    else if (current.obj1_effect == "Pop") { sco1 = 0.85 + 0.15 * t3; }
    else if (current.obj1_effect == "FonduInverse" || current.obj1_effect == "Fondu inversé") { a3 = 1 - t3; }
    else if (current.obj1_effect == "Pulse") { sco1 = 1 + 0.06 * sin(t3 * pi); }
    else if (current.obj1_effect == "Glow") { glow3 = true; }
    else if (current.obj1_effect == "RotationIn") { ang3 = -15 * (1 - t3); a3 = t3; }
    var sign3 = (variable_struct_exists(current, "obj1_flip") && current.obj1_flip) ? -1 : 1;
    draw_sprite_ext(o1, 0, object1.x + dx3, object1.y + dy3, oc1 * sco1 * sign3, oc1 * sco1, ang3, c_white, a3);
    if (glow3) { draw_sprite_ext(o1, 0, object1.x + dx3, object1.y + dy3, oc1 * sco1 * 1.02, oc1 * sco1 * 1.02, ang3, make_color_rgb(255,220,120), 0.35); }
}

var o2 = asset_get_index(current.obj2_name);
if (o2 != -1) {
    var ow2 = sprite_get_width(o2); var oh2 = sprite_get_height(o2);
    var ocx2 = object2.w / ow2; var ocy2 = object2.h / oh2; var oc2 = min(ocx2, ocy2);
    var dur4 = fx_duration_ms;
    if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé" || current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé" || current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé" || current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") { dur4 *= fx_inverse_multiplier; }
    var t4 = clamp((current_time - fx_obj2_start_ms) / dur4, 0, 1);
    var dx4 = 0; var dy4 = 0; var sco2 = 1; var ang4 = 0; var a4 = 1; var glow4 = false;
    if (current.obj2_effect == "Fondu") { a4 = t4; }
    else if (current.obj2_effect == "DeplacementAB") { dx4 = (prev_object2_x - object2.x) * (1 - t4); dy4 = (prev_object2_y - object2.y) * (1 - t4); }
    else if (current.obj2_effect == "SlideGauche" || current.obj2_effect == "Slide gauche") { dx4 = -room_width * 0.3 * (1 - t4); }
    else if (current.obj2_effect == "SlideDroite" || current.obj2_effect == "Slide droite") { dx4 = room_width * 0.3 * (1 - t4); }
    else if (current.obj2_effect == "SlideHaut"   || current.obj2_effect == "Slide haut") { dy4 = -room_height * 0.2 * (1 - t4); }
    else if (current.obj2_effect == "SlideBas"    || current.obj2_effect == "Slide bas") { dy4 = room_height * 0.2 * (1 - t4); }
    else if (current.obj2_effect == "SlideGaucheInverse" || current.obj2_effect == "Slide gauche inversé") { dx4 = -(room_width + object2.w) * t4; }
    else if (current.obj2_effect == "SlideDroiteInverse" || current.obj2_effect == "Slide droite inversé") { dx4 = (room_width + object2.w) * t4; }
    else if (current.obj2_effect == "SlideHautInverse" || current.obj2_effect == "Slide haut inversé") { dy4 = -(room_height + object2.h) * t4; }
    else if (current.obj2_effect == "SlideBasInverse" || current.obj2_effect == "Slide bas inversé") { dy4 = (room_height + object2.h) * t4; }
    else if (current.obj2_effect == "Pop") { sco2 = 0.85 + 0.15 * t4; }
    else if (current.obj2_effect == "FonduInverse" || current.obj2_effect == "Fondu inversé") { a4 = 1 - t4; }
    else if (current.obj2_effect == "Pulse") { sco2 = 1 + 0.06 * sin(t4 * pi); }
    else if (current.obj2_effect == "Glow") { glow4 = true; }
    else if (current.obj2_effect == "RotationIn") { ang4 = -15 * (1 - t4); a4 = t4; }
    var sign4 = (variable_struct_exists(current, "obj2_flip") && current.obj2_flip) ? -1 : 1;
    draw_sprite_ext(o2, 0, object2.x + dx4, object2.y + dy4, oc2 * sco2 * sign4, oc2 * sco2, ang4, c_white, a4);
    if (glow4) { draw_sprite_ext(o2, 0, object2.x + dx4, object2.y + dy4, oc2 * sco2 * 1.02, oc2 * sco2 * 1.02, ang4, make_color_rgb(255,220,120), 0.35); }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (font_exists(fontText)) draw_set_font(fontText);
draw_set_color(c_white);
var txl = textbox.x - textbox.w * 0.5 + textbox.margin;
var txr = textbox.x + textbox.w * 0.5 - textbox.margin;
var tyt = textbox.y - textbox.h * 0.5 + textbox.margin;
var tyb = textbox.y + textbox.h * 0.5 - textbox.margin;
var tx = txl;
var ty = tyt;
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_roundrect(textbox.x - textbox.w * 0.5, textbox.y - textbox.h * 0.5, textbox.x + textbox.w * 0.5, textbox.y + textbox.h * 0.5, false);
draw_set_alpha(1);

var s_contour = asset_get_index("sContourTexte");
if (s_contour != -1) {
    draw_sprite(s_contour, 0, textbox.x, textbox.y);
}

draw_set_color(c_white);
var durt = fx_duration_ms;
if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé" || current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé" || current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé" || current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") { durt *= fx_inverse_multiplier; }
var tt = clamp((current_time - fx_text_start_ms) / durt, 0, 1);
var dxt = 0; var dyt = 0; var base_text_scale = 1; var sct = base_text_scale; var angt = 0; var at = 1;
if (current.text_effect == "Fondu") { at = tt; }
else if (current.text_effect == "FonduInverse" || current.text_effect == "Fondu inversé") { at = 1 - tt; }
else if (current.text_effect == "SlideGauche") { dxt = -textbox.w * 0.6 * (1 - tt); }
else if (current.text_effect == "SlideDroite") { dxt = textbox.w * 0.6 * (1 - tt); }
else if (current.text_effect == "SlideHaut") { dyt = -textbox.h * 0.4 * (1 - tt); }
    else if (current.text_effect == "SlideBas") { dyt = textbox.h * 0.4 * (1 - tt); }
    else if (current.text_effect == "SlideGaucheInverse" || current.text_effect == "Slide gauche inversé") { dxt = -(room_width + textbox.w) * tt; }
    else if (current.text_effect == "SlideDroiteInverse" || current.text_effect == "Slide droite inversé") { dxt = (room_width + textbox.w) * tt; }
    else if (current.text_effect == "SlideHautInverse" || current.text_effect == "Slide haut inversé") { dyt = -(room_height + textbox.h) * tt; }
    else if (current.text_effect == "SlideBasInverse" || current.text_effect == "Slide bas inversé") { dyt = (room_height + textbox.h) * tt; }
else if (current.text_effect == "Pop") { sct = base_text_scale * (0.9 + 0.1 * tt); }
else if (current.text_effect == "Pulse") { sct = base_text_scale * (1 + 0.04 * sin(tt * pi)); }
else if (current.text_effect == "RotationIn") { angt = -10 * (1 - tt); at = tt; }
draw_set_alpha(at);
var txs = string(current.text);
var len = string_length(txs);
var cps = max(1, text_reveal_cps);
var elapsed_ms = current_time - fx_text_start_ms;
var shown = clamp(floor(elapsed_ms * cps / 1000), 0, len);
var tx_show = string_copy(txs, 1, shown);
var base_h = string_height("Ag");
var wrap_w = max(1, round((txr - txl) / max(0.001, sct)));
draw_text_ext_transformed(tx + dxt, ty + dyt, tx_show, base_h, wrap_w, sct, sct, angt);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fontUI);

var draw_menu_button = function(x1, y1, x2, y2, label, hover) {
    var w = x2 - x1;
    var h = y2 - y1;
    if (sprite_exists(sButton)) {
        var subimg = 0;
        if (hover && sprite_get_number(sButton) > 1) subimg = 1;
        draw_sprite_stretched(sButton, subimg, x1, y1, w, h);
    } else {
        draw_set_color(hover ? c_ltgray : c_gray);
        draw_rectangle(x1, y1, x2, y2, false);
        draw_set_color(c_white);
        draw_rectangle(x1, y1, x2, y2, true);
    }
    
    var cx = (x1 + x2) * 0.5;
    var cy = (y1 + y2) * 0.5;
    var max_w = max(1, w - 16);
    var max_h = max(1, h - 10);
    var col_main = make_color_rgb(230, 200, 120);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (variable_global_exists("get_runtime_font")) {
        var sz = 20;
        var f = global.get_runtime_font("title", sz);
        while (sz > 10 && f != -1) {
            draw_set_font(f);
            if (string_width(label) <= max_w && string_height("Ag") <= max_h) break;
            sz -= 1;
            f = global.get_runtime_font("title", sz);
        }
        if (f != -1) draw_set_font(f);
        draw_set_color(c_black);
        draw_text(cx + 2, cy + 2, label);
        draw_set_color(col_main);
        draw_text(cx, cy, label);
    } else {
        var f2 = -1;
        if (font_exists(fontTitle)) f2 = fontTitle;
        else if (font_exists(fontText)) f2 = fontText;
        else if (font_exists(fontUI)) f2 = fontUI;
        if (f2 != -1) draw_set_font(f2);
        var sw = string_width(label);
        var sh = string_height("Ag");
        var sc = 1;
        if (sw > 0) sc = min(sc, max_w / sw);
        if (sh > 0) sc = min(sc, max_h / sh);
        sc = min(1, sc);
        draw_set_color(c_black);
        draw_text_transformed(cx + 2, cy + 2, label, sc, sc, 0);
        draw_set_color(col_main);
        draw_text_transformed(cx, cy, label, sc, sc, 0);
    }
};

// Bouton Précédent
var hover_prev = point_in_rectangle(mouse_x, mouse_y, btn_prev_x1, btn_prev_y1, btn_prev_x2, btn_prev_y2);
draw_menu_button(btn_prev_x1, btn_prev_y1, btn_prev_x2, btn_prev_y2, "Précédent", hover_prev);

// Bouton Retour
var hover_quit = point_in_rectangle(mouse_x, mouse_y, btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2);
draw_menu_button(btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2, "Retour", hover_quit);

// Bouton Suivant
var hover_next = point_in_rectangle(mouse_x, mouse_y, btn_next_x1, btn_next_y1, btn_next_x2, btn_next_y2);
draw_menu_button(btn_next_x1, btn_next_y1, btn_next_x2, btn_next_y2, "Suivant", hover_next);

// Bouton Skip
var hover_skip = point_in_rectangle(mouse_x, mouse_y, btn_skip_x1, btn_skip_y1, btn_skip_x2, btn_skip_y2);
draw_menu_button(btn_skip_x1, btn_skip_y1, btn_skip_x2, btn_skip_y2, "Skip", hover_skip);

// Bouton Auto
var hover_auto = point_in_rectangle(mouse_x, mouse_y, btn_auto_x1, btn_auto_y1, btn_auto_x2, btn_auto_y2);
draw_menu_button(btn_auto_x1, btn_auto_y1, btn_auto_x2, btn_auto_y2, "Auto", hover_auto);

if (auto_mode) {
    var thick = 3;
    var col_blue = make_color_rgb(50, 150, 255);
    var col_white = c_white;
    var cycle_len = 8;
    var len_blue = 5;
    var len_white = 3;
    var flow_speed = 0.03; 
    
    var w = btn_auto_x2 - btn_auto_x1;
    var h = btn_auto_y2 - btn_auto_y1;
    var perim = 2 * (w + h);
    var offset = (current_time * flow_speed) % perim;

    for (var i = 0; i < perim; i += cycle_len) {
        var d_start = (i + offset) % perim;
        
        // --- Draw Blue part ---
        var curr_d = d_start;
        var rem_len = len_blue;
        draw_set_color(col_blue);
        
        while (rem_len > 0) {
            var side_idx = 0;
            var next_corner = 0;
            if (curr_d < w) { next_corner = w; side_idx = 0; }
            else if (curr_d < w + h) { next_corner = w + h; side_idx = 1; }
            else if (curr_d < 2*w + h) { next_corner = 2*w + h; side_idx = 2; }
            else { next_corner = perim; side_idx = 3; }
            
            var dist_to_corner = next_corner - curr_d;
            var draw_len = min(rem_len, dist_to_corner);
            
            var x_s, y_s, x_e, y_e;
            if (side_idx == 0) { x_s = btn_auto_x1 + curr_d; y_s = btn_auto_y1; }
            else if (side_idx == 1) { x_s = btn_auto_x2; y_s = btn_auto_y1 + (curr_d - w); }
            else if (side_idx == 2) { x_s = btn_auto_x2 - (curr_d - (w+h)); y_s = btn_auto_y2; }
            else { x_s = btn_auto_x1; y_s = btn_auto_y2 - (curr_d - (2*w+h)); }
            
            var end_d = curr_d + draw_len;
            if (side_idx == 0) { x_e = btn_auto_x1 + end_d; y_e = btn_auto_y1; }
            else if (side_idx == 1) { x_e = btn_auto_x2; y_e = btn_auto_y1 + (end_d - w); }
            else if (side_idx == 2) { x_e = btn_auto_x2 - (end_d - (w+h)); y_e = btn_auto_y2; }
            else { x_e = btn_auto_x1; y_e = btn_auto_y2 - (end_d - (2*w+h)); }
            
            draw_line_width(x_s, y_s, x_e, y_e, thick);
            
            curr_d = (curr_d + draw_len) % perim;
            rem_len -= draw_len;
        }
        
        // --- Draw White part ---
        curr_d = (d_start + len_blue) % perim;
        rem_len = len_white;
        draw_set_color(col_white);
        
        while (rem_len > 0) {
            var side_idx = 0;
            var next_corner = 0;
            if (curr_d < w) { next_corner = w; side_idx = 0; }
            else if (curr_d < w + h) { next_corner = w + h; side_idx = 1; }
            else if (curr_d < 2*w + h) { next_corner = 2*w + h; side_idx = 2; }
            else { next_corner = perim; side_idx = 3; }
            
            var dist_to_corner = next_corner - curr_d;
            var draw_len = min(rem_len, dist_to_corner);
            
            var x_s, y_s, x_e, y_e;
            if (side_idx == 0) { x_s = btn_auto_x1 + curr_d; y_s = btn_auto_y1; }
            else if (side_idx == 1) { x_s = btn_auto_x2; y_s = btn_auto_y1 + (curr_d - w); }
            else if (side_idx == 2) { x_s = btn_auto_x2 - (curr_d - (w+h)); y_s = btn_auto_y2; }
            else { x_s = btn_auto_x1; y_s = btn_auto_y2 - (curr_d - (2*w+h)); }
            
            var end_d = curr_d + draw_len;
            if (side_idx == 0) { x_e = btn_auto_x1 + end_d; y_e = btn_auto_y1; }
            else if (side_idx == 1) { x_e = btn_auto_x2; y_e = btn_auto_y1 + (end_d - w); }
            else if (side_idx == 2) { x_e = btn_auto_x2 - (end_d - (w+h)); y_e = btn_auto_y2; }
            else { x_e = btn_auto_x1; y_e = btn_auto_y2 - (end_d - (2*w+h)); }
            
            draw_line_width(x_s, y_s, x_e, y_e, thick);
            
            curr_d = (curr_d + draw_len) % perim;
            rem_len -= draw_len;
        }
    }
}

if (variable_instance_exists(id, "end_act_popup_active") && end_act_popup_active) {
    var pw = 700;
    var ph = 280;
    var px1 = (room_width - pw) * 0.5;
    var py1 = (room_height - ph) * 0.5;
    var px2 = px1 + pw;
    var py2 = py1 + ph;
    var btn_w = 260;
    var btn_h = 56;
    var gap_btn = 20;
    var btn1_x1 = px1 + (pw - (btn_w * 2 + gap_btn)) * 0.5;
    var btn1_y1 = py2 - btn_h - 30;
    var btn1_x2 = btn1_x1 + btn_w;
    var btn1_y2 = btn1_y1 + btn_h;
    var btn2_x1 = btn1_x2 + gap_btn;
    var btn2_y1 = btn1_y1;
    var btn2_x2 = btn2_x1 + btn_w;
    var btn2_y2 = btn2_y1 + btn_h;

    // Voile
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    // Panel
    draw_set_color(make_color_rgb(35, 35, 45));
    draw_roundrect(px1, py1, px2, py2, false);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_roundrect(px1, py1, px2, py2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    if (font_exists(fontTitle)) draw_set_font(fontTitle);
    draw_text((px1 + px2) * 0.5, py1 + 50, end_act_popup_title);

    if (font_exists(fontText)) draw_set_font(fontText);
    var body_txt = end_act_popup_has_next
        ? "Veux-tu passer a l'acte suivant\nou retourner au menu Histoire ?"
        : "Il n'y a pas d'acte suivant disponible.\nRetourner au menu Histoire ?";
    draw_text((px1 + px2) * 0.5, py1 + 125, body_txt);

    var hover_next_act = end_act_popup_has_next && point_in_rectangle(mouse_x, mouse_y, btn1_x1, btn1_y1, btn1_x2, btn1_y2);
    var hover_menu = point_in_rectangle(mouse_x, mouse_y, btn2_x1, btn2_y1, btn2_x2, btn2_y2);

    draw_menu_button(btn1_x1, btn1_y1, btn1_x2, btn1_y2, "Acte suivant", hover_next_act);
    if (!end_act_popup_has_next) {
        draw_set_alpha(0.45);
        draw_set_color(c_black);
        draw_roundrect(btn1_x1, btn1_y1, btn1_x2, btn1_y2, false);
        draw_set_alpha(1);
    }
    draw_menu_button(btn2_x1, btn2_y1, btn2_x2, btn2_y2, "Menu Histoire", hover_menu);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
