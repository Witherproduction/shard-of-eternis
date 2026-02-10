// oFX_ProceduralSpike - Draw Event

// 1. Dessiner l'ombre (toujours visible, s'estompe à la fin)
var alpha_mult = 1;
if (phase == 2) alpha_mult = 1 - (timer / phase2_duration);

draw_set_alpha(shadow_alpha * alpha_mult);
draw_set_color(color_shadow);
draw_ellipse(x - shadow_radius, y - shadow_radius * 0.4, x + shadow_radius, y + shadow_radius * 0.4, false);
draw_set_alpha(1);

// 2. Dessiner le pic (Phase 1 seulement)
if (phase == 1) {
    draw_set_color(color_spike);
    var h = spike_height;
    var w = spike_width_base;
    
    // Triangle principal
    draw_triangle(x - w/2, y, x + w/2, y, x, y - h, false);
    
    // Facette éclairée (pour volume)
    draw_set_color(color_highlight);
    draw_triangle(x, y, x + w/2, y, x, y - h, false);
}

// 3. Dessiner les débris (Phase 2)
if (phase == 2) {
    draw_set_color(color_spike);
    for (var i = 0; i < array_length(debris_list); i++) {
        var d = debris_list[i];
        var dx = x + d.dx;
        var dy = y + d.dy;
        
        // Dessiner un petit triangle tournant
        // Calcul simple des sommets rotatés
        var s = d.size;
        var ang = d.rot;
        var len = s;
        
        var x1 = dx + lengthdir_x(len, ang);
        var y1 = dy + lengthdir_y(len, ang);
        var x2 = dx + lengthdir_x(len, ang + 120);
        var y2 = dy + lengthdir_y(len, ang + 120);
        var x3 = dx + lengthdir_x(len, ang + 240);
        var y3 = dy + lengthdir_y(len, ang + 240);
        
        draw_triangle(x1, y1, x2, y2, x3, y3, false);
    }
}