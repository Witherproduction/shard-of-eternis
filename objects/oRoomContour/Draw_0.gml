/// oRoomContour Draw - sContour largement plus grand que la room (origine centrée)
var W = room_width;
var H = room_height;

// Dimensions du sprite de contour
var spr = sContour;
var baseW = sprite_get_width(spr);
var baseH = sprite_get_height(spr);

// Origine centrée : dessiner au centre de la room
var drawX = W * 0.5;
var drawY = H * 0.5;

var coverScale = max(W / baseW, H / baseH);
var thin_factor_x = 1.04;
var thin_factor_y = 1.12;
var sx = coverScale * thin_factor_x;
var sy = coverScale * thin_factor_y;

draw_sprite_ext(spr, 0, drawX, drawY, sx, sy, 0, c_white, 1);

if (room == rAcceuil) {
    if (!variable_instance_exists(id, "portal_spr")) {
        var s1 = asset_get_index("sPortailHeros");
        var s2 = asset_get_index("sPortailRoche");
        var s3 = asset_get_index("sPortailTerre");
        var opts = [];
        if (s1 != -1) array_push(opts, s1);
        if (s2 != -1) array_push(opts, s2);
        if (s3 != -1) array_push(opts, s3);
        portal_spr = (array_length(opts) > 0) ? opts[irandom(array_length(opts) - 1)] : -1;
    }

    if (portal_spr != -1) {
        var portal_target_h = H * 0.62;
        var portal_scale = portal_target_h / max(1, sprite_get_height(portal_spr));
        portal_scale = clamp(portal_scale, 0.15, 1.2);

        var portal_frames = max(1, sprite_get_number(portal_spr));
        var portal_frame = 0;
        if (portal_frames > 1) {
            portal_frame = (current_time div 80) mod portal_frames;
        }

        var portal_y = H * 0.52;
        var portal_dx = W * 0.28;
        var portal_xl = (W * 0.5) - portal_dx;
        var portal_xr = (W * 0.5) + portal_dx;

        draw_sprite_ext(portal_spr, portal_frame, portal_xl, portal_y, portal_scale, portal_scale, 0, c_white, 1);
        draw_sprite_ext(portal_spr, portal_frame, portal_xr, portal_y, portal_scale, portal_scale, 0, c_white, 1);
    }
}
