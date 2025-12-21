// FX_Invocation - Draw
// Phase 1: dessine le fantôme
// Phase 2: dessine le contour "circuit imprimé" autour de la carte posée

var old_alpha = draw_get_alpha();
var old_blend = gpu_get_blendmode();

var _has_portal    = (variable_instance_exists(self, "ss_sprite_idx") && ss_sprite_idx != -1);
var _draw_portal   = _has_portal && (variable_instance_exists(self, "ss_portal_t") && variable_instance_exists(self, "ss_portal_total_frames") && ss_portal_t < ss_portal_total_frames);
var _zoom_total    = (variable_instance_exists(self, "ss_zoom_frames") ? ss_zoom_frames : round(0.5 * room_speed));
var _pre_total     = (variable_instance_exists(self, "ss_pre_total_frames") ? ss_pre_total_frames : round(2.0 * room_speed));
var _portal_total  = (variable_instance_exists(self, "ss_portal_total_frames") ? ss_portal_total_frames : _pre_total + round(1.0 * room_speed));

if (_draw_portal) {
    var zoom_p = clamp(ss_portal_t / max(1, _zoom_total), 0, 1);
    var zoom_e = zoom_p * zoom_p * (3 - 2 * zoom_p);
    var sc = (ss_portal_t < _zoom_total) ? (1.25 * zoom_e) : 1.25;
    var fc_ss = sprite_get_number(ss_sprite_idx);
    var pp = clamp(ss_portal_t / max(1, _portal_total), 0, 1);
    var fi_ss = clamp(floor(pp * max(1, fc_ss - 1)), 0, max(0, fc_ss - 1));
    draw_set_alpha(ss_alpha);
    draw_sprite_ext(ss_sprite_idx, fi_ss, ss_x, ss_y, sc, sc, 0, c_white, 1);
}

// Phase fantôme (avant la pose)
if (!finished_move) {
    if (variable_instance_exists(self, "spriteGhost") && spriteGhost != noone) {
        draw_set_alpha(alpha);
        draw_sprite_ext(spriteGhost, imageGhost, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
    }
}
else {
    // Phase circuit: révélation progressive de la carte vers l’extérieur
    var p = clamp(post_fx_t / max(1, post_fx_duration), 0, 1);
    // Progression séquentielle uniforme: A, puis B, puis C, puis nœuds
    var inner_frac = 0.20;
    var ring_frac  = 0.20;
    var diag_frac  = 0.20;
    var nodes_start = inner_frac + ring_frac + diag_frac; // 0.60
    var nodes_frac  = max(0.0001, 1.0 - nodes_start);     // 0.40
    var p_inner = clamp(p / inner_frac, 0, 1);
    var p_ring  = clamp((p - inner_frac) / ring_frac, 0, 1);
    var p_diag  = clamp((p - inner_frac - ring_frac) / diag_frac, 0, 1);
    var p_nodes = clamp((p - nodes_start) / nodes_frac, 0, 1);
    // Linéaire pour une vitesse constante dans chaque phase
    var e_inner = p_inner;
    var e_ring  = p_ring;
    var e_diag  = p_diag;
    var e_nodes = p_nodes;
    
    // Alpha constant pendant le dessin pour bien voir chaque étape
    var a = 1.0;
    var ring_thickness = max(1, thickness_start + (thickness_end - thickness_start) * e_ring);
    var trace_w = max(1, trace_thickness);
    var node_r = max(1, node_radius * e_nodes);
    
    gpu_set_blendmode(bm_add);
    draw_set_alpha(a);
    // Couleur flash pour pins et nœuds (pas de cercle)
    var is_flash = (post_fx_t > post_fx_duration);
    var flash_p = is_flash ? clamp((post_fx_t - post_fx_duration) / max(1, flash_duration), 0, 1) : 0;
    var flash_str = is_flash ? max(0, 1.0 - (flash_p * flash_p * flash_p)) : 0;
    var col_main = make_color_rgb(0, 180, 255);
    var col_fx = (flash_str > 0) ? merge_color(col_main, c_white, flash_str) : col_main;
    draw_set_color(col_fx);
    var has_elec = (variable_instance_exists(self, "electric_sprite_idx") && electric_sprite_idx != -1);
    if (has_elec) {
        var fc = sprite_get_number(electric_sprite_idx);
        var delay_half = round(0.3 * room_speed);
        var cos_a = dcos(circ_angle);
        var sin_a = dsin(circ_angle);
        var vx_x = cos_a; var vx_y = sin_a;
        var vy_x = -sin_a; var vy_y = cos_a;
        var half_w = circ_w * 0.5;
        var half_h = circ_h * 0.5;
        var half_w_o = half_w + circuit_margin;
        var half_h_o = half_h + circuit_margin;
        var dirs = 10;
        for (var ii = 0; ii < dirs; ii++) {
            var ang = ii * (360 / dirs);
            var cx = dcos(ang);
            var cy = dsin(ang);
            var sx = x + vx_x * (half_w * cx) + vy_x * (half_h * cy);
            var sy = y + vx_y * (half_w * cx) + vy_y * (half_h * cy);
            var ox = x + vx_x * (half_w_o * cx) + vy_x * (half_h_o * cy);
            var oy = y + vx_y * (half_w_o * cx) + vy_y * (half_h_o * cy);
            var dist_o = max(0.0001, point_distance(x, y, ox, oy));
            var ex = ox + (ox - x) / dist_o * trace_out;
            var ey = oy + (oy - y) / dist_o * trace_out;
            var start_delay = (((ii & 1) == 1) ? delay_half : 0);
            if (post_fx_t < start_delay) { continue; }
            var p_loc = clamp((post_fx_t - start_delay) / max(1, post_fx_duration - start_delay), 0, 1);
            var ex_p = sx + (ex - sx) * p_loc;
            var ey_p = sy + (ey - sy) * p_loc;
            var fi = clamp(floor(p_loc * max(1, fc - 1)), 0, max(0, fc - 1));
            var dir_in = point_direction(ex_p, ey_p, x, y);
            var angle_top_to_center = dir_in + 90;
            draw_sprite_ext(electric_sprite_idx, fi, ex_p, ey_p, 0.5, 0.5, angle_top_to_center, c_white, 1);
        }
    } else {
    // Axes orientés et dimensions
    var cos_a = dcos(circ_angle);
    var sin_a = dsin(circ_angle);
    var vx_x = cos_a; var vx_y = sin_a;        // axe horizontal
    var vy_x = -sin_a; var vy_y = cos_a;       // axe vertical
    var half_w = circ_w * 0.5;
    var half_h = circ_h * 0.5;
    var half_w_o = half_w + circuit_margin;
    var half_h_o = half_h + circuit_margin;

    // Coins carte (sans marge)
    var c1x = x + vx_x * half_w + vy_x * half_h; // top-right
    var c1y = y + vx_y * half_w + vy_y * half_h;
    var c2x = x - vx_x * half_w + vy_x * half_h; // top-left
    var c2y = y - vx_y * half_w + vy_y * half_h;
    var c3x = x - vx_x * half_w - vy_x * half_h; // bottom-left
    var c3y = y - vx_y * half_w - vy_y * half_h;
    var c4x = x + vx_x * half_w - vy_x * half_h; // bottom-right
    var c4y = y + vx_y * half_w - vy_y * half_h;

    // Midpoints carte (départ des traces)
    var ct_x = 0.5 * (c1x + c2x); var ct_y = 0.5 * (c1y + c2y);
    var cr_x = 0.5 * (c2x + c3x); var cr_y = 0.5 * (c2y + c3y);
    var cb_x = 0.5 * (c3x + c4x); var cb_y = 0.5 * (c3y + c4y);
    var cl_x = 0.5 * (c4x + c1x); var cl_y = 0.5 * (c4y + c1y);

    // Coins de l’anneau externe (autour de la carte)
    var p1x = x + vx_x * half_w_o + vy_x * half_h_o; // top-right
    var p1y = y + vx_y * half_w_o + vy_y * half_h_o;
    var p2x = x - vx_x * half_w_o + vy_x * half_h_o; // top-left
    var p2y = y - vx_y * half_w_o + vy_y * half_h_o;
    var p3x = x - vx_x * half_w_o - vy_x * half_h_o; // bottom-left
    var p3y = y - vx_y * half_w_o - vy_y * half_h_o;
    var p4x = x + vx_x * half_w_o - vy_x * half_h_o; // bottom-right
    var p4y = y + vx_y * half_w_o - vy_y * half_h_o;

    // Milieux de l’anneau
    var tmx = 0.5 * (p1x + p2x); var tmy = 0.5 * (p1y + p2y);
    var rmx = 0.5 * (p2x + p3x); var rmy = 0.5 * (p2y + p3y);
    var bmx = 0.5 * (p3x + p4x); var bmy = 0.5 * (p3y + p4y);
    var lmx = 0.5 * (p4x + p1x); var lmy = 0.5 * (p4y + p1y);

    // Ancrages externes (extension hors anneau)
    var a_tx = tmx + (tmx - x) / max(0.0001, point_distance(x, y, tmx, tmy)) * trace_out;
    var a_ty = tmy + (tmy - y) / max(0.0001, point_distance(x, y, tmx, tmy)) * trace_out;
    var a_rx = rmx + (rmx - x) / max(0.0001, point_distance(x, y, rmx, rmy)) * trace_out;
    var a_ry = rmy + (rmy - y) / max(0.0001, point_distance(x, y, rmx, rmy)) * trace_out;
    var a_bx = bmx + (bmx - x) / max(0.0001, point_distance(x, y, bmx, bmy)) * trace_out;
    var a_by = bmy + (bmy - y) / max(0.0001, point_distance(x, y, bmx, bmy)) * trace_out;
    var a_lx = lmx + (lmx - x) / max(0.0001, point_distance(x, y, lmx, lmy)) * trace_out;
    var a_ly = lmy + (lmy - y) / max(0.0001, point_distance(x, y, lmx, lmy)) * trace_out;

    var th = max(2, trace_thickness * 2.0);
    var segs = 12;
    var amp = max(2, 12 * (1 - p) + 6);
    var dirs = 12;
    for (var ii = 0; ii < dirs; ii++) {
        var ang = ii * (360 / dirs);
        var cx = dcos(ang);
        var cy = dsin(ang);
        var sx = x + vx_x * (half_w * cx) + vy_x * (half_h * cy);
        var sy = y + vx_y * (half_w * cx) + vy_y * (half_h * cy);
        var ox = x + vx_x * (half_w_o * cx) + vy_x * (half_h_o * cy);
        var oy = y + vx_y * (half_w_o * cx) + vy_y * (half_h_o * cy);
        var dist_o = max(0.0001, point_distance(x, y, ox, oy));
        var ex = ox + (ox - x) / dist_o * trace_out;
        var ey = oy + (oy - y) / dist_o * trace_out;
        var ex_p = sx + (ex - sx) * p;
        var ey_p = sy + (ey - sy) * p;
        var dx = ex_p - sx;
        var dy = ey_p - sy;
        var dist_l = max(1, point_distance(sx, sy, ex_p, ey_p));
        var nx = -dy / dist_l;
        var ny = dx / dist_l;
        var txv_x = -vx_x * half_w_o * dsin(ang) + vy_x * half_h_o * dcos(ang);
        var txv_y = -vx_y * half_w_o * dsin(ang) + vy_y * half_h_o * dcos(ang);
        var tlen = max(1, point_distance(0, 0, txv_x, txv_y));
        var txu = txv_x / tlen;
        var tyu = txv_y / tlen;
        for (var jj = 0; jj < segs; jj++) {
            var t0 = jj / segs; var t1 = (jj + 1) / segs;
            var sx0 = sx + dx * t0; var sy0 = sy + dy * t0;
            var sx1 = sx + dx * t1; var sy1 = sy + dy * t1;
            var j0 = amp * 0.6 * sin(t0 * pi);
            var j1 = amp * 0.6 * sin(t1 * pi);
            var s0 = amp * 0.3 * sin(t0 * pi);
            var s1 = amp * 0.3 * sin(t1 * pi);
            draw_line_width(sx0 + nx * j0 + txu * s0, sy0 + ny * j0 + tyu * s0, sx1 + nx * j1 + txu * s1, sy1 + ny * j1 + tyu * s1, th);
        }
    }
}
}

// Restore state
draw_set_alpha(old_alpha);
gpu_set_blendmode(old_blend);