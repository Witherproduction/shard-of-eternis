/// @function region_get_zones_ForetDesVoleur()
/// @description Retourne la configuration des zones de révélation pour la Forêt des Voleurs
function region_poly_scale(_pts, _s) {
    var n = array_length(_pts);
    if (n <= 0) return _pts;
    var cx = 0;
    var cy = 0;
    for (var i = 0; i < n; i++) {
        cx += _pts[i].x;
        cy += _pts[i].y;
    }
    cx /= n;
    cy /= n;
    var out = array_create(n);
    for (var i = 0; i < n; i++) {
        var px = _pts[i].x;
        var py = _pts[i].y;
        out[i] = { x: cx + (px - cx) * _s, y: cy + (py - cy) * _s };
    }
    return out;
}

function region_poly_scale_shift(_pts, _s, _shift_x_pct, _shift_y_pct) {
    var out = region_poly_scale(_pts, _s);
    var n = array_length(out);
    if (n <= 0) return out;
    var minx = out[0].x, maxx = out[0].x;
    var miny = out[0].y, maxy = out[0].y;
    for (var i = 1; i < n; i++) {
        var px = out[i].x;
        var py = out[i].y;
        if (px < minx) minx = px;
        if (px > maxx) maxx = px;
        if (py < miny) miny = py;
        if (py > maxy) maxy = py;
    }
    var dx = (maxx - minx) * _shift_x_pct;
    var dy = (maxy - miny) * _shift_y_pct;
    for (var i = 0; i < n; i++) {
        out[i].x += dx;
        out[i].y += dy;
    }
    return out;
}

function region_get_zones_ForetDesVoleur() {
    return [
        {
            // Zone Acte 1 (Fin Chapitre 0)
            condition_check: function() { return is_act_complete(0, 1); },
            points: [ 
                 {x:11, y:-116}, 
                 {x:55, y:-148}, 
                 {x:100, y:-210}, 
                 {x:89, y:-284}, 
                 {x:77, y:-353}, 
                 {x:9, y:-361}, 
                 {x:-111, y:-337}, 
                 {x:-148, y:-307}, 
                 {x:-184, y:-259}, 
                 {x:-175, y:-213}, 
                 {x:-156, y:-153}, 
                 {x:-119, y:-109}, 
                 {x:-49, y:-111}, 
                 {x:-23, y:-102}, 
                 {x:11, y:-114} 
             ]
        },
        {
            // Zone Acte 2 (Fin Chapitre 1 Acte 1)
            condition_check: function() { return is_act_complete(1, 1); },
            points: region_poly_scale_shift([ 
                 {x:12, y:-119}, 
                 {x:52, y:-140}, 
                 {x:93, y:-125}, 
                 {x:169, y:-86}, 
                 {x:163, y:-27}, 
                 {x:186, y:-18}, 
                 {x:212, y:2}, 
                 {x:210, y:37}, 
                 {x:206, y:99}, 
                 {x:138, y:106}, 
                 {x:83, y:79}, 
                 {x:28, y:55}, 
                 {x:-14, y:45}, 
                 {x:-51, y:26}, 
                 {x:-87, y:13}, 
                 {x:-99, y:-3}, 
                 {x:-97, y:-54}, 
                 {x:-102, y:-99}, 
                 {x:-9, y:-107}, 
                 {x:11, y:-117} 
             ], 1.15, -0.05, 0)
        },
        {
            // Zone Acte 3 (Fin Chapitre 1 Acte 2)
            condition_check: function() { return is_act_complete(1, 2); },
            points: [ 
                 {x:-417, y:45}, 
                 {x:-280, y:27}, 
                 {x:-131, y:18}, 
                 {x:-58, y:208}, 
                 {x:-50, y:291}, 
                 {x:-221, y:321}, 
                 {x:-418, y:361}, 
                 {x:-476, y:260}, 
                 {x:-417, y:45} 
             ]
        },
        {
            // Zone Acte 4 (Fin Chapitre 1 Acte 3)
            condition_check: function() { return is_act_complete(1, 3); },
            points: [ 
                 {x:-156, y:29}, 
                 {x:-104, y:286}, 
                 {x:210, y:289}, 
                 {x:138, y:67}, 
                 {x:-47, y:19}, 
                 {x:-156, y:29} 
             ]
        },
        {
            // Zone Fin Acte 4 (Fin Chapitre 1 Acte 4)
            condition_check: function() { return is_act_complete(1, 4); },
            points: [ 
                 {x:10, y:-134}, 
                 {x:234, y:68}, 
                 {x:464, y:73}, 
                 {x:446, y:-320}, 
                 {x:25, y:-416}, 
                 {x:10, y:-134} 
             ]
        }
    ];
}
